drop database if exists dbUAS;
create database dbUAS;
  use dbUAS;

SET max_sp_recursion_depth=255;

  create table tblData(
    pasien varchar(3),
    demam varchar(6),
    sakitkepala varchar(6),
    nyeri varchar(6),
    lemas varchar(6),
    kelelahan varchar(6),
    hidungtersumbat varchar(6),
    bersin varchar(6),
    sakittenggorokan varchar(6),
    sulitbernafas varchar(6),
    diagnosa varchar(5)
  );

  create table tblBackup(
    pasien varchar(3),
    demam varchar(6),
    sakitkepala varchar(6),
    nyeri varchar(6),
    lemas varchar(6),
    kelelahan varchar(6),
    hidungtersumbat varchar(6),
    bersin varchar(6),
    sakittenggorokan varchar(6),
    sulitbernafas varchar(6),
    diagnosa varchar(5)
  );

  delimiter $$
  create trigger tgAutoInsert after insert on tblData
    for each row
    begin
    insert into tblBackup
      values(new.pasien,new.demam,new.sakitkepala,new.nyeri,new.lemas,new.kelelahan,new.hidungtersumbat,new.bersin,new.sakittenggorokan,new.sulitbernafas,new.diagnosa);
    end
    $$
  delimiter ;
/*P1 diagnosa demam seharusnya*/
  insert into tblData values
    ('P1','tidak','ringan','tidak','tidak','tidak','ringan','parah','parah','ringan','demam'),
    ('P2','parah','parah','parah','parah','parah','tidak','tidak','parah','parah','flu'),
    ('P3','parah','parah','ringan','parah','parah','parah','tidak','parah','parah','flu'),
    ('P4','tidak','tidak','tidak','ringan','tidak','parah','tidak','ringan','ringan','demam'),
    ('P5','parah','parah','ringan','parah','parah','parah','tidak','parah','parah','flu'),
    ('P6','tidak','tidak','tidak','ringan','tidak','parah','parah','parah','tidak','demam'),
    ('P7','parah','parah','parah','parah','parah','tidak','tidak','tidak','parah','flu'),
    ('P8','tidak','tidak','tidak','tidak','tidak','parah','parah','tidak','ringan','demam'),
    ('P9','tidak','ringan','ringan','tidak','tidak','parah','parah','parah','parah','demam'),
    ('P10','parah','parah','parah','ringan','ringan','tidak','parah','tidak','parah','flu'),
    ('P11','tidak','tidak','tidak','ringan','tidak','parah','ringan','parah','tidak','demam'),
    ('P12','parah','ringan','parah','ringan','parah','tidak','parah','tidak','ringan','flu'),
    ('P13','tidak','tidak','ringan','ringan','tidak','parah','parah','parah','tidak','demam'),
    ('P14','parah','parah','parah','parah','ringan','tidak','parah','parah','parah','flu'),
    ('P15','ringan','tidak','tidak','ringan','tidak','parah','tidak','parah','ringan','demam'),
    ('P16','tidak','tidak','tidak','tidak','tidak','parah','parah','parah','parah','demam'),
    ('P17','parah','ringan','parah','ringan','ringan','tidak','tidak','tidak','parah','flu');

    create table tblParameter(
      parameter varchar(20)
    );

    insert into tblParameter values
      ('demam'),
      ('sakitkepala'),
      ('nyeri'),
      ('lemas'),
      ('kelelahan'),
      ('hidungtersumbat'),
      ('bersin'),
      ('sakittenggorokan'),
      ('sulitbernafas');

      create table tblHitung(
        atribut varchar(20),
        informasi varchar(20),
        jumlahdata int,
        ddemam int,
        dflu int,
        entropy decimal(8,4),
        gain decimal(8,4)
      );

    select * from tblData;

    --Stored Function Entropy
    delimiter ##
    create function sfEntropy(pjumlahdata int,pdemam int,pflu int)
    returns decimal(8,4)
    begin
    declare vEntropy decimal(8,4);

    set vEntropy=(-(pdemam/pjumlahdata)*log2(pdemam/pjumlahdata))+
    (-(pflu/pjumlahdata)*log2(pflu/pjumlahdata));

    return(vEntropy);
    end ##
    delimiter ;

    --Stored Procedure Iterasi 1
    delimiter $$
    create procedure spC45()
    begin
    declare i int;
    declare j int;
    declare vParameter varchar(20);
    declare vInformasi varchar(6);
    declare nParameter int;
    declare vGainMax varchar(20);
    declare vCabang varchar(255);

    declare cParameter cursor for select * from tblParameter;

    select count(*) from tblParameter into nParameter;
    set i=0;
    set j=0;

select @iterasi as 'ITERASI';

    open cParameter;


    fetch cParameter into vParameter;

    if exists(select parameter from tblParameter where parameter='demam') then

    insert into tblHitung(informasi,jumlahdata,ddemam,dflu)
      select A.demam,count(*),

      (
        select count(*)
        from tblData as B
        where B.diagnosa='demam' and B.demam=A.demam
      ),

      (
        select count(*)
        from tblData as C
        where C.diagnosa='flu' and C.demam=A.demam
      )

      from tblData as A
      group by A.demam;
    update tblHitung set atribut = 'demam' where atribut is NULL;

      end if;

      if exists(select parameter from tblParameter where parameter='sakitkepala') then

      insert into tblHitung(informasi,jumlahdata,ddemam,dflu)
        select A.sakitkepala,count(*),

        (
          select count(*)
          from tblData as B
          where B.diagnosa='demam' and B.sakitkepala=A.sakitkepala
        ),

        (
          select count(*)
          from tblData as C
          where C.diagnosa='flu' and C.sakitkepala=A.sakitkepala
        )

        from tblData as A
        group by A.sakitkepala;
      update tblHitung set atribut = 'sakitkepala' where atribut is NULL;

        end if;

        if exists(select parameter from tblParameter where parameter='nyeri') then

        insert into tblHitung(informasi,jumlahdata,ddemam,dflu)
          select A.nyeri,count(*),

          (
            select count(*)
            from tblData as B
            where B.diagnosa='demam' and B.nyeri=A.nyeri
          ),

          (
            select count(*)
            from tblData as C
            where C.diagnosa='flu' and C.nyeri=A.nyeri
          )

          from tblData as A
          group by A.nyeri;
        update tblHitung set atribut = 'nyeri' where atribut is NULL;

          end if;

          if exists(select parameter from tblParameter where parameter='lemas') then

          insert into tblHitung(informasi,jumlahdata,ddemam,dflu)
            select A.lemas,count(*),

            (
              select count(*)
              from tblData as B
              where B.diagnosa='demam' and B.lemas=A.lemas
            ),

            (
              select count(*)
              from tblData as C
              where C.diagnosa='flu' and C.lemas=A.lemas
            )

            from tblData as A
            group by A.lemas;
          update tblHitung set atribut = 'lemas' where atribut is NULL;

            end if;

            if exists(select parameter from tblParameter where parameter='kelelahan') then

            insert into tblHitung(informasi,jumlahdata,ddemam,dflu)
              select A.kelelahan,count(*),

              (
                select count(*)
                from tblData as B
                where B.diagnosa='demam' and B.kelelahan=A.kelelahan
              ),

              (
                select count(*)
                from tblData as C
                where C.diagnosa='flu' and C.kelelahan=A.kelelahan
              )

              from tblData as A
              group by A.kelelahan;
            update tblHitung set atribut = 'kelelahan' where atribut is NULL;

              end if;

              if exists(select parameter from tblParameter where parameter='hidungtersumbat') then

              insert into tblHitung(informasi,jumlahdata,ddemam,dflu)
                select A.hidungtersumbat,count(*),

                (
                  select count(*)
                  from tblData as B
                  where B.diagnosa='demam' and B.hidungtersumbat=A.hidungtersumbat
                ),

                (
                  select count(*)
                  from tblData as C
                  where C.diagnosa='flu' and C.hidungtersumbat=A.hidungtersumbat
                )

                from tblData as A
                group by A.hidungtersumbat;
              update tblHitung set atribut = 'hidungtersumbat' where atribut is NULL;

                end if;

                if exists(select parameter from tblParameter where parameter='bersin') then

                insert into tblHitung(informasi,jumlahdata,ddemam,dflu)
                  select A.bersin,count(*),

                  (
                    select count(*)
                    from tblData as B
                    where B.diagnosa='demam' and B.bersin=A.bersin
                  ),

                  (
                    select count(*)
                    from tblData as C
                    where C.diagnosa='flu' and C.bersin=A.bersin
                  )

                  from tblData as A
                  group by A.bersin;
                update tblHitung set atribut = 'bersin' where atribut is NULL;

                  end if;

                  if exists(select parameter from tblParameter where parameter='sakittenggorokan') then

                  insert into tblHitung(informasi,jumlahdata,ddemam,dflu)
                    select A.sakittenggorokan,count(*),

                    (
                      select count(*)
                      from tblData as B
                      where B.diagnosa='demam' and B.sakittenggorokan=A.sakittenggorokan
                    ),

                    (
                      select count(*)
                      from tblData as C
                      where C.diagnosa='flu' and C.sakittenggorokan=A.sakittenggorokan
                    )

                    from tblData as A
                    group by A.sakittenggorokan;
                  update tblHitung set atribut = 'sakittenggorokan' where atribut is NULL;

                    end if;

                    if exists(select parameter from tblParameter where parameter='sulitbernafas') then

                    insert into tblHitung(informasi,jumlahdata,ddemam,dflu)
                      select A.sulitbernafas,count(*),

                      (
                        select count(*)
                        from tblData as B
                        where B.diagnosa='demam' and B.sulitbernafas=A.sulitbernafas
                      ),

                      (
                        select count(*)
                        from tblData as C
                        where C.diagnosa='flu' and C.sulitbernafas=A.sulitbernafas
                      )

                      from tblData as A
                      group by A.sulitbernafas;
                    update tblHitung set atribut = 'sulitbernafas' where atribut is NULL;

                      end if;

          /*Entropy*/
          update tblHitung set entropy = sfEntropy(jumlahdata,ddemam,dflu);

            update tblHitung set entropy = 0 where entropy is NULL;

              /*Hitung gain*/
              drop table if exists tblTampung;
              create TEMPORARY TABLE tblTampung(
                atribut varchar(20),
                gain decimal(8,4)
              );

              insert into tblTampung(atribut,gain)
              select atribut,round(@entropy - sum((jumlahdata/@jumlahdata)*entropy),4) as GAIN
              from tblHitung
              group by atribut;

              update tblHitung set gain=
                (
                  select gain
                  from tblTampung
                  where atribut = tblHitung.atribut
                );

                select * from tblHitung;
    close cParameter;

    if exists (select atribut
    from tblHitung
    where gain=(select max(gain) from tblHitung) and ddemam!=0 and dflu !=0) then

    select atribut into @atribut
    from tblHitung
    where gain=(select max(gain) from tblHitung) and ddemam!=0 and dflu !=0;

    select informasi into @informasi
    from tblHitung
    where gain=(select max(gain) from tblHitung) and ddemam!=0 and dflu !=0;

      select concat(@atribut,' ',@informasi) into @cabang;

    select @cabang as 'Nilai gain tertinggi dan yang akan diiterasi:';

    delete from tblParameter where parameter=@atribut;

    /*  select * from tblParameter;*/


      select jumlahdata into @jumlahdata
      from tblHitung
      where gain=(select max(gain) from tblHitung) and ddemam!=0 and dflu !=0;

      select ddemam into  @ddemam
      from tblHitung
      where gain=(select max(gain) from tblHitung) and ddemam!=0 and dflu !=0;

      select dflu into @dflu
      from tblHitung
      where gain=(select max(gain) from tblHitung) and ddemam!=0 and dflu !=0;

      set @entropy := sfEntropy(@jumlahdata,@ddemam,@dflu);

      truncate table tblHitung;

      insert into tblHitung(atribut,jumlahdata,ddemam,dflu,entropy) values
        (@cabang,@jumlahdata,@ddemam,@dflu,@entropy);



      /*call spC45loop();*/


    else select 'Akhir dari iterasi!';
    select atribut into @atribut
    from tblHitung
    where gain=(select max(gain) from tblHitung) limit 1;

    select concat(
      @atribut,' tidak = ',( if( (select dflu from tblHitung where atribut=@atribut and informasi='tidak')=0,"demam","flu") ),'\n',
      @atribut,' ringan = ',( if( (select dflu from tblHitung where atribut=@atribut and informasi='ringan')=0,"demam","flu") ),'\n',
      @atribut,' parah = ',( if( (select dflu from tblHitung where atribut=@atribut and informasi='parah')=0,"demam","flu") )
  ) as 'Kesimpulan';

    end if;
    end
    $$
    delimiter ;

    -------------------SP LOOP---------------------------------------------------------
    delimiter $$
    create procedure spC45loop()
    begin
    declare i int;
    declare j int;
    declare vParameter varchar(20);
    declare vInformasi varchar(6);
    declare nParameter int;
    declare vGainMax varchar(20);
    declare vCabang varchar(255);

    declare cParameter cursor for select * from tblParameter;

    select count(*) from tblParameter into nParameter;
    set i=0;
    set j=0;

    set @iterasi=@iterasi+1;

select @iterasi as 'ITERASI';

    open cParameter;


    fetch cParameter into vParameter;

    if exists(select parameter from tblParameter where parameter='demam') then

    insert into tblHitung(informasi,jumlahdata,ddemam,dflu)
      select A.demam,count(*),

      (
        select count(*)
        from tblData as B
        where B.diagnosa='demam' and B.demam=A.demam
      ),

      (
        select count(*)
        from tblData as C
        where C.diagnosa='flu' and C.demam=A.demam
      )

      from tblData as A
      group by A.demam;
    update tblHitung set atribut = 'demam' where atribut is NULL;

      end if;

      if exists(select parameter from tblParameter where parameter='sakitkepala') then

      insert into tblHitung(informasi,jumlahdata,ddemam,dflu)
        select A.sakitkepala,count(*),

        (
          select count(*)
          from tblData as B
          where B.diagnosa='demam' and B.sakitkepala=A.sakitkepala
        ),

        (
          select count(*)
          from tblData as C
          where C.diagnosa='flu' and C.sakitkepala=A.sakitkepala
        )

        from tblData as A
        group by A.sakitkepala;
      update tblHitung set atribut = 'sakitkepala' where atribut is NULL;

        end if;

        if exists(select parameter from tblParameter where parameter='nyeri') then

        insert into tblHitung(informasi,jumlahdata,ddemam,dflu)
          select A.nyeri,count(*),

          (
            select count(*)
            from tblData as B
            where B.diagnosa='demam' and B.nyeri=A.nyeri
          ),

          (
            select count(*)
            from tblData as C
            where C.diagnosa='flu' and C.nyeri=A.nyeri
          )

          from tblData as A
          group by A.nyeri;
        update tblHitung set atribut = 'nyeri' where atribut is NULL;

          end if;

          if exists(select parameter from tblParameter where parameter='lemas') then

          insert into tblHitung(informasi,jumlahdata,ddemam,dflu)
            select A.lemas,count(*),

            (
              select count(*)
              from tblData as B
              where B.diagnosa='demam' and B.lemas=A.lemas
            ),

            (
              select count(*)
              from tblData as C
              where C.diagnosa='flu' and C.lemas=A.lemas
            )

            from tblData as A
            group by A.lemas;
          update tblHitung set atribut = 'lemas' where atribut is NULL;

            end if;

            if exists(select parameter from tblParameter where parameter='kelelahan') then

            insert into tblHitung(informasi,jumlahdata,ddemam,dflu)
              select A.kelelahan,count(*),

              (
                select count(*)
                from tblData as B
                where B.diagnosa='demam' and B.kelelahan=A.kelelahan
              ),

              (
                select count(*)
                from tblData as C
                where C.diagnosa='flu' and C.kelelahan=A.kelelahan
              )

              from tblData as A
              group by A.kelelahan;
            update tblHitung set atribut = 'kelelahan' where atribut is NULL;

              end if;

              if exists(select parameter from tblParameter where parameter='hidungtersumbat') then

              insert into tblHitung(informasi,jumlahdata,ddemam,dflu)
                select A.hidungtersumbat,count(*),

                (
                  select count(*)
                  from tblData as B
                  where B.diagnosa='demam' and B.hidungtersumbat=A.hidungtersumbat
                ),

                (
                  select count(*)
                  from tblData as C
                  where C.diagnosa='flu' and C.hidungtersumbat=A.hidungtersumbat
                )

                from tblData as A
                group by A.hidungtersumbat;
              update tblHitung set atribut = 'hidungtersumbat' where atribut is NULL;

                end if;

                if exists(select parameter from tblParameter where parameter='bersin') then

                insert into tblHitung(informasi,jumlahdata,ddemam,dflu)
                  select A.bersin,count(*),

                  (
                    select count(*)
                    from tblData as B
                    where B.diagnosa='demam' and B.bersin=A.bersin
                  ),

                  (
                    select count(*)
                    from tblData as C
                    where C.diagnosa='flu' and C.bersin=A.bersin
                  )

                  from tblData as A
                  group by A.bersin;
                update tblHitung set atribut = 'bersin' where atribut is NULL;

                  end if;

                  if exists(select parameter from tblParameter where parameter='sakittenggorokan') then

                  insert into tblHitung(informasi,jumlahdata,ddemam,dflu)
                    select A.sakittenggorokan,count(*),

                    (
                      select count(*)
                      from tblData as B
                      where B.diagnosa='demam' and B.sakittenggorokan=A.sakittenggorokan
                    ),

                    (
                      select count(*)
                      from tblData as C
                      where C.diagnosa='flu' and C.sakittenggorokan=A.sakittenggorokan
                    )

                    from tblData as A
                    group by A.sakittenggorokan;
                  update tblHitung set atribut = 'sakittenggorokan' where atribut is NULL;

                    end if;

                    if exists(select parameter from tblParameter where parameter='sulitbernafas') then

                    insert into tblHitung(informasi,jumlahdata,ddemam,dflu)
                      select A.sulitbernafas,count(*),

                      (
                        select count(*)
                        from tblData as B
                        where B.diagnosa='demam' and B.sulitbernafas=A.sulitbernafas
                      ),

                      (
                        select count(*)
                        from tblData as C
                        where C.diagnosa='flu' and C.sulitbernafas=A.sulitbernafas
                      )

                      from tblData as A
                      group by A.sulitbernafas;
                    update tblHitung set atribut = 'sulitbernafas' where atribut is NULL;

                      end if;

          /*Entropy*/
          update tblHitung set entropy = sfEntropy(jumlahdata,ddemam,dflu);

            update tblHitung set entropy = 0 where entropy is NULL;

              /*Hitung gain*/
              drop table if exists tblTampung;
              create TEMPORARY TABLE tblTampung(
                atribut varchar(20),
                gain decimal(8,4)
              );

              insert into tblTampung(atribut,gain)
              select atribut,round(@entropy - sum((jumlahdata/@jumlahdata)*entropy),4) as GAIN
              from tblHitung
              group by atribut;

              update tblHitung set gain=
                (
                  select gain
                  from tblTampung
                  where atribut = tblHitung.atribut
                );

                select * from tblHitung;
    close cParameter;

    if exists (select atribut
    from tblHitung
    where gain=(select max(gain) from tblHitung) and ddemam!=0 and dflu !=0) then

    select atribut into @atribut
    from tblHitung
    where gain=(select max(gain) from tblHitung) and ddemam!=0 and dflu !=0;

    select informasi into @informasi
    from tblHitung
    where gain=(select max(gain) from tblHitung) and ddemam!=0 and dflu !=0;

      select concat(@cabang,' ',@atribut,' ',@informasi) into @cabang;

    select @cabang as 'Nilai gain tertinggi dan yang akan diiterasi:';

    delete from tblParameter where parameter=@atribut;


      select jumlahdata into @jumlahdata
      from tblHitung
      where gain=(select max(gain) from tblHitung) and ddemam!=0 and dflu !=0;

      select ddemam into  @ddemam
      from tblHitung
      where gain=(select max(gain) from tblHitung) and ddemam!=0 and dflu !=0;

      select dflu into @dflu
      from tblHitung
      where gain=(select max(gain) from tblHitung) and ddemam!=0 and dflu !=0;

      set @entropy := sfEntropy(@jumlahdata,@ddemam,@dflu);

      truncate table tblHitung;

      insert into tblHitung(atribut,jumlahdata,ddemam,dflu,entropy) values
        (@cabang,@jumlahdata,@ddemam,@dflu,@entropy);

        call spC45loop();

      /*call spC45loop();*/


    else select 'Akhir dari iterasi!';
    select atribut into @atribut
    from tblHitung
    where gain=(select max(gain) from tblHitung) limit 1;

    select concat(
      @atribut,' tidak = ',( if( (select dflu from tblHitung where atribut=@atribut and informasi='tidak')=0,"demam","flu") ),'\n',
      @atribut,' ringan = ',( if( (select dflu from tblHitung where atribut=@atribut and informasi='ringan')=0,"demam","flu") ),'\n',
      @atribut,' parah = ',( if( (select dflu from tblHitung where atribut=@atribut and informasi='parah')=0,"demam","flu") )
  ) as 'Kesimpulan';

    end if;

    end
    $$
    delimiter ;
    ------------------------------------------------------------------------------------


    /****************************************Iterasi 1******************************/
    --Data Total

    select 1 into @iterasi;

    select '' into @cabang;

    select count(*) into @jumlahdata
    from tblData;

    select count(*) into  @ddemam
    from tblData
    where diagnosa = 'demam';

    select count(*) into @dflu
    from tblData
    where diagnosa = 'flu';

    set @entropy := sfEntropy(@jumlahdata,@ddemam,@dflu);

    insert into tblHitung(atribut,jumlahdata,ddemam,dflu,entropy) values
      ('Total Data',@jumlahdata,@ddemam,@dflu,@entropy);

      call spC45();
      --call spC45loop();
