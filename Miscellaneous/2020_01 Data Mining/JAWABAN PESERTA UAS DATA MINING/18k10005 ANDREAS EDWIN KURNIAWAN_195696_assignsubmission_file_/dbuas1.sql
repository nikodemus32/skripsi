/*UAS Andreas Edwin Kurniawan NIM : 18.K1.0005*/
drop database if exists dbuas1;
create database dbuas1;
use dbuas1;

create table tbluas1
(
    nourut int,
    demam varchar(20),
    sakitkepala varchar(20),
    nyeri varchar(20),
    lemas varchar(20),
    kelelahan varchar(20),
    hidungtersumbat varchar(20),
    bersin varchar(20),
    sakittenggorokan varchar(20),
    sulitbernafas varchar(20),
    diagnosa varchar(20)
);

load data local infile 'dbuas1.csv'
into table tbluas1
fields terminated by ';'
enclosed by ''''
ignore 1 lines;

select * from tbluas1;

create table tblHitung
(
    atribut varchar(20),
    informasi varchar(20),
    jumlahdata int,
    demam varchar(20),
    flu varchar(20),
    entropy decimal(8,4),
    gain decimal(8,4)
);

desc tblHitung;

select count(*) into @jumlahdata from tbluas1;

select count(*) into @demam from tbluas1 where diagnosa = 'demam';

select count(*) into @flu from tbluas1 where diagnosa = 'flu';

select (-(@demam/@jumlahdata) * log2(@demam/@jumlahdata)) + (-(@flu/@jumlahdata) * log2(@flu/@jumlahdata)) into @entropy;

select @jumlahdata as JUM_DATA,
@demam as JAWAB_DEMAM, @flu as JAWAB_FLU, ROUND(@entropy,4) as ENTROPY;

insert into tblHitung(atribut, jumlahdata, demam, flu, entropy) VALUES ('TOTAL DATA', @jumlahdata, @demam, @flu, @entropy);
select * from tblHitung;

insert into tblHitung(informasi, jumlahdata, demam, flu)
    select A.demam as DEMAM, count(*) as JUMLAH_DATA,
        (
            select count(*) from tbluas1 as B where B.diagnosa = 'demam' and B.demam = A.demam
        ) as 'DEMAM',
        (
            select count(*) from tbluas1 as C where C.diagnosa = 'flu' and C.demam = A.demam
        ) as 'flu'
    from tbluas1 as A group by A.demam;

update tblHitung SET atribut = 'DEMAM' where atribut is null;

  insert into tblHitung(informasi, jumlahdata, demam, flu)
      select A.sakitkepala as SAKITKEPALA, count(*) as JUMLAH_DATA,
          (
              select count(*) from tbluas1 as B where B.diagnosa = 'demam' and B.sakitkepala = A.sakitkepala
          ) as 'DEMAM',
          (
              select count(*) from tbluas1 as C where C.diagnosa = 'flu' and C.sakitkepala = A.sakitkepala
          ) as 'FLU'
      from tbluas1 as A group by A.sakitkepala;

  update tblHitung SET atribut = 'SAKITKEPALA' where atribut is null;

  insert into tblHitung(informasi, jumlahdata, demam, flu)
      select A.nyeri as NYERI, count(*) as JUMLAH_DATA,
          (
              select count(*) from tbluas1 as B where B.diagnosa = 'demam' and B.nyeri = A.nyeri
          ) as 'DEMAM',
          (
              select count(*) from tbluas1 as C where C.diagnosa = 'flu' and C.nyeri = A.nyeri
          ) as 'FLU'
      from tbluas1 as A group by A.nyeri;

  update tblHitung SET atribut = 'NYERI' where atribut is null;

    insert into tblHitung(informasi, jumlahdata, demam, flu)
        select A.lemas as LEMAS, count(*) as JUMLAH_DATA,
            (
                select count(*) from tbluas1 as B where B.diagnosa = 'demam' and B.lemas = A.lemas
            ) as 'DEMAM',
            (
                select count(*) from tbluas1 as C where C.diagnosa = 'flu' and C.lemas = A.lemas
            ) as 'FLU'
        from tbluas1 as A group by A.lemas;

    update tblHitung SET atribut = 'LEMAS' where atribut is null;

    insert into tblHitung(informasi, jumlahdata, demam, flu)
        select A.kelelahan as KELELAHAN, count(*) as JUMLAH_DATA,
            (
                select count(*) from tbluas1 as B where B.diagnosa = 'demam' and B.kelelahan = A.kelelahan
            ) as 'DEMAM',
            (
                select count(*) from tbluas1 as C where C.diagnosa = 'flu' and C.kelelahan = A.kelelahan
            ) as 'FLU'
        from tbluas1 as A group by A.kelelahan;

    update tblHitung SET atribut = 'KELELAHAN' where atribut is null;

    insert into tblHitung(informasi, jumlahdata, demam, flu)
        select A.hidungtersumbat as HIDUNGTERSUMBAT, count(*) as JUMLAH_DATA,
            (
                select count(*) from tbluas1 as B where B.diagnosa = 'demam' and B.hidungtersumbat = A.hidungtersumbat
            ) as 'DEMAM',
            (
                select count(*) from tbluas1 as C where C.diagnosa = 'flu' and C.hidungtersumbat = A.hidungtersumbat
            ) as 'FLU'
        from tbluas1 as A group by A.hidungtersumbat;

    update tblHitung SET atribut = 'HIDUNGTERSUMBAT' where atribut is null;

    insert into tblHitung(informasi, jumlahdata, demam, flu)
        select A.bersin as BERSIN, count(*) as JUMLAH_DATA,
            (
                select count(*) from tbluas1 as B where B.diagnosa = 'demam' and B.bersin = A.bersin
            ) as 'DEMAM',
            (
                select count(*) from tbluas1 as C where C.diagnosa = 'flu' and C.bersin = A.bersin
            ) as 'FLU'
        from tbluas1 as A group by A.bersin;

    update tblHitung SET atribut = 'BERSIN' where atribut is null;

    insert into tblHitung(informasi, jumlahdata, demam, flu)
        select A.sakittenggorokan as SAKITTENGGOROKAN, count(*) as JUMLAH_DATA,
            (
                select count(*) from tbluas1 as B where B.diagnosa = 'demam' and B.sakittenggorokan = A.sakittenggorokan
            ) as 'DEMAM',
            (
                select count(*) from tbluas1 as C where C.diagnosa = 'flu' and C.sakittenggorokan = A.sakittenggorokan
            ) as 'FLU'
        from tbluas1 as A group by A.sakittenggorokan;

    update tblHitung SET atribut = 'SAKITTENGGOROKAN' where atribut is null;

    insert into tblHitung(informasi, jumlahdata, demam, flu)
        select A.sulitbernafas as SULITBERNAFAS, count(*) as JUMLAH_DATA,
            (
                select count(*) from tbluas1 as B where B.diagnosa = 'demam' and B.sulitbernafas = A.sulitbernafas
            ) as 'DEMAM',
            (
                select count(*) from tbluas1 as C where C.diagnosa = 'flu' and C.sulitbernafas = A.sulitbernafas
            ) as 'FLU'
        from tbluas1 as A group by A.sulitbernafas;

    update tblHitung SET atribut = 'SULITBERNAFAS' where atribut is null;

      update tblHitung SET atribut = 'SULITBERNAFAS' where atribut is null;

      update tblHitung SET entropy = (-(demam/jumlahdata) * log2(demam/jumlahdata)) + (-(flu/jumlahdata) * log2(flu/jumlahdata)) where demam <> 0 and flu <> 0;

      update tblHitung SET entropy = 0 where entropy IS NULL;

      select * from tblHitung;

      DROP TABLE IF EXISTS tblTampung;
      CREATE TEMPORARY TABLE tblTampung
      (
          atribut varchar(20),
          gain decimal(8,4)
      );

      insert into tblTampung(atribut, gain)
      select atribut, @entropy - SUM((jumlahdata/@jumlahdata) * entropy) as GAIN from tblHitung group by atribut;

      select * from tblTampung;

      update tblHitung SET GAIN =
          (
              select gain
              from tblTampung
              where atribut = tblHitung.atribut
          );

      select * from tblHitung;

     