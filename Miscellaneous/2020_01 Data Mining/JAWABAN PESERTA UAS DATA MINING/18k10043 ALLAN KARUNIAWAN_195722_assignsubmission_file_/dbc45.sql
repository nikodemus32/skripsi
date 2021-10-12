drop database if exists dbC45;
create database dbC45;
use dbC45;

insert into tblC45 values
  ('P1','Tidak','Ringan','Tidak','Tidak','Tidak','Ringan','Parah','Parah','Ringan','Demam'),
  ('P2','Parah','Parah','Parah','Parah','Parah','Tidak','Tidak','Parah','Parah','Flu'),
  ('P3','Parah','Parah','Ringan','Parah','Parah','Parah','Tidak','Parah','Parah','Flu'),
  ('P4','Tidak','Tidak','Tidak','Ringan','Tidak','Parah','Tidak','Ringan','Ringan','Demam'),
  ('P5','Parah','Parah','Ringan','Parah','Parah','Parah','Tidak','Parah','Parah','Flu'),
  ('P6','Tidak','Tidak','Tidak','Ringan','Tidak','Parah','Parah','Parah','Tidak','Demam'),
  ('P7','Parah','Parah','Parah','Parah','Parah','Tidak','Tidak','Tidak','Parah','Flu'),
  ('P8','Tidak','Tidak','Tidak','Tidak','Tidak','Parah','Parah','Tidak','Ringan','Demam'),
  ('P9','Tidak','Ringan','Ringan','Tidak','Tidak','Parah','Parah','Parah','Parah','Demam'),
  ('P10','Parah','Parah','Parah','Ringan','Ringan','Tidak','Parah','Tidak','Parah','Flu'),
  ('P11','Tidak','Tidak','Tidak','Ringan','Tidak','Parah','Ringan','Parah','Tidak','Demam'),
  ('P12','Parah','Ringan','Parah','Ringan','Parah','Tidak','Parah','Tidak','Ringan','Flu'),
  ('P13','Tidak','Tidak','Ringan','Ringan','Tidak','Parah','Parah','Parah','Tidak','Demam'),
  ('P14','Parah','Parah','Parah','Parah','Ringan','Tidak','Parah','Parah','Parah','Flu'),
  ('P15','Ringan','Tidak','Tidak','Ringan','Tidak','Parah','Tidak','Parah','Ringan','Demam'),
  ('P16','Tidak','Tidak','Tidak','Tidak','Tidak','Parah','Parah','Parah','Parah','Demam'),
  ('P17','Parah','Ringan','Parah','Ringan','Ringan','Tidak','Tidak','Tidak','Parah','Flu');
select * from tblC45;


create table tblC45(
  pasien varchar(5),
  demam varchar(10),
  sakitkepala varchar(10),
  nyeri varchar(10),
  lemas varchar(10),
  kelelahan varchar(10),
  hidungtersumbat varchar(10),
  bersin varchar(10),
  sakittenggorokan varchar(10),
  sulitbernafas varchar(10),
);

CREATE TABLE tblPasien
(
atribut VARCHAR(20),
informasi VARCHAR(20),
jumlahdata INT,
diagnosaflu INT,
diagnosademam INT,
entropy DECIMAL(8,4),
gain DECIMAL(8,4)
);

DESC tblPasien;

select count(*) into @jumlahdata from tblC45;
select @diagnosaflu := count(*)
from tblC45
where diagnosa ='tidak';

select @diagnosademam := count(*)
from tblC45
where diagnosa ='parah';

select @diagnosademam := count(*)
from tblC45
where diagnosa ='ringan' > 5;

select @jumlahdata,@diagnosaflu,@diagnosademam;

select @entropy := (-1*(@diagnosaflu/@jumlahdata)*log2(@diagnosaflu/@jumlahdata))+
@entropy := (-1*(@diagnosademam/@jumlahdata)*log2(@diagnosademam/@jumlahdata));
select @entropy;
insert into tblPasien(atribut,jumlahdata,diagnosaflu,diagnosademam,entropy) values
  ('TOTAL DATA',@jumlahdata,@diagnosaflu,@diagnosademam,@entropy);


-- demam
insert into tblPasien(informasi,jumlahdata,diagnosaflu,diagnosademam)
select A.demam, count(*) as Jumlah_data,
  (
    select count(*)
    from tblC45 as B
    where B.diagnosa = 'tidak' and B.demam=A.demam
  ) as 'tidak',
  (
    select count(*)
    from tblC45 as C
    where C.diagnosa = 'parah' and C.demam=A.demam
  ) as 'parah'
    (
    select count(*)
    from tblC45 as D
    where D.diagnosa = 'ringan' and D.demam=A.demam
  ) as 'parah'
from tblC45 as A
group by demam;



update tblPasien set atribut='demam' where atribut is null;
select * from tblPasien;

-- sakitkepala
insert into tblPasien(informasi,jumlahdata,diagnosaflu,diagnosademam)
select A.sakitkepala, count(*) as Jumlah_data,
  (
    select count(*)
    from tblC45 as B
    where B.diagnosa = 'tidak' and B.sakitkepala=A.sakitkepala
  ) as 'tidak',
  (
    select count(*)
    from tblC45 as C
    where C.diagnosa = 'parah' and C.sakitkepala=A.sakitkepala
  ) as 'parah'
    (
    select count(*)
    from tblC45 as C
    where d.diagnosa = 'ringan' and D sakitkepala=A.sakitkepala
  ) as 'ringan'
from tblC45 as A
group by sakitkepala;



update tblPasien set atribut='sakitkepala' where atribut is null;


-- nyeri
insert into tblPasien(informasi,jumlahdata,diagnosaflu,diagnosademam)
select A.nyeri, count(*) as Jumlah_data,
  (
    select count(*)
    from tblC45 as B
    where B.diagnosa = 'tidak' and B.nyeri=A.nyeri
  ) as 'tidak',
  (
    select count(*)
    from tblC45 as C
    where C.diagnosa = 'parah' and C.nyeri=A.nyeri
  ) as 'parah'
    (
    select count(*)
    from tblC45 as C
    where D.diagnosa = 'ringan' and D.nyeri=A.nyeri
  ) as 'ringan'
from tblC45 as A
group by nyeri;
update tblPasien set atribut='nyeri' where atribut is null;

-- lemas
insert into tblPasien(informasi,jumlahdata,diagnosaflu,diagnosademam)
select A.lemas, count(*) as Jumlah_data,
  (
    select count(*)
    from tblC45 as B
    where B.diagnosa = 'tidak' and B.lemas=A.lemas
  ) as 'tidak',
  (
    select count(*)
    from tblC45 as C
    where C.diagnosa = 'parah' and C.lemas=A.lemas
  ) as 'parah'
    (
    select count(*)
    from tblC45 as C
    where D.diagnosa = 'parah' and D.lemas=A.lemas
  ) as 'ringan'
from tblC45 as A
group by lemas;

update tblPasien set atribut='lemas' where atribut is null;

-- kelelahan
insert into tblPasien(informasi,jumlahdata,diagnosaflu,diagnosademam)
select A.lemas, count(*) as Jumlah_data,
  (
    select count(*)
    from tblC45 as B
    where B.diagnosa = 'tidak' and B.kelelahan=A.kelelahan
  ) as 'tidak',
  (
    select count(*)
    from tblC45 as C
    where C.diagnosa = 'parah' and C.kelelahan=A.kelelahan
  ) as 'parah'
    (
    select count(*)
    from tblC45 as C
    where D.diagnosa = 'parah' and D.kelelahan=A.kelelahan
  ) as 'ringan'
from tblC45 as A
group by kelelahan;

update tblPasien set atribut='kelalahn' where atribut is null;

-- hidungtersumbat
insert into tblPasien(informasi,jumlahdata,diagnosaflu,diagnosademam)
select A.hidungtersumbat, count(*) as Jumlah_data,
  (
    select count(*)
    from tblC45 as B
    where B.diagnosa = 'tidak' and B.hidungtersumbat=A.hidungtersumbat
  ) as 'tidak',
  (
    select count(*)
    from tblC45 as C
    where C.diagnosa = 'parah' and C.hidungtersumbat=A.hidungtersumbat
  ) as 'parah'
    (
    select count(*)
    from tblC45 as C
    where D.diagnosa = 'parah' and D.hidungtersumbat=A.hidungtersumbat
  ) as 'ringan'
from tblC45 as A
group by hidungtersumbat;

update tblPasien set atribut='hidungtersumbat' where atribut is null;

-- bersin
insert into tblPasien(informasi,jumlahdata,diagnosaflu,diagnosademam)
select A.bersin, count(*) as Jumlah_data,
  (
    select count(*)
    from tblC45 as B
    where B.diagnosa = 'tidak' and B.bersin=A.bersin
  ) as 'tidak',
  (
    select count(*)
    from tblC45 as C
    where C.diagnosa = 'parah' and C.bersin=A.bersin
  ) as 'parah'
    (
    select count(*)
    from tblC45 as C
    where D.diagnosa = 'parah' and D.bersin=A.bersin
  ) as 'ringan'
from tblC45 as A
group by bersin;

update tblPasien set atribut='bersin' where atribut is null;

-- sakittenggorokan
insert into tblPasien(informasi,jumlahdata,diagnosaflu,diagnosademam)
select A.lemas, count(*) as Jumlah_data,
  (
    select count(*)
    from tblC45 as B
    where B.diagnosa = 'tidak' and B.sakittenggorokan=A.sakittenggorokan
  ) as 'tidak',
  (
    select count(*)
    from tblC45 as C
    where C.diagnosa = 'parah' and C.sakittenggorokan=A.sakittenggorokan
  ) as 'parah'
    (
    select count(*)
    from tblC45 as C
    where D.diagnosa = 'parah' and D.sakittenggorokan=A.sakittenggorokan
  ) as 'ringan'
from tblC45 as A
group by sakittenggorokan;

update tblPasien set atribut='sakittenggorokan' where atribut is null;

-- lemas
insert into tblPasien(informasi,jumlahdata,diagnosaflu,diagnosademam)
select A.sulitbernafas, count(*) as Jumlah_data,
  (
    select count(*)
    from tblC45 as B
    where B.diagnosa = 'tidak' and B.sulitbernafas=A.sulitbernafas
  ) as 'tidak',
  (
    select count(*)
    from tblC45 as C
    where C.diagnosa = 'parah' and C.sulitbernafas=A.sulitbernafas
  ) as 'parah'
    (
    select count(*)
    from tblC45 as C
    where D.diagnosa = 'parah' and D.sulitbernafas=A.sulitbernafas
  ) as 'ringan'
from tblC45 as A
group by sulitbernafas;

update tblPasien set atribut='sulitbernafas' where atribut is null;


select * from tblPasien;
-- hitung entropy

update tblPasien set entropy = (-(diagnosaflu/jumlahdata)* log2(diagnosaflu/jumlahdata))+
(-(diagnosademam/jumlahdata)*log2(diagnosademam/jumlahdata))
where diagnosaflu<>0 and diagnosademam<>0;

update tblPasien set entropy =0 where entropy is null;

select * from tblPasien;


drop table if exists tblTampung;
create  table tblTampung(
  atribut varchar(20),
  gain double
);


insert into tblTampung(atribut,gain)
select atribut,
@entropy-sum((jumlahdata/@jumlahdata) * entropy)
from tblPasien
group by atribut;

update tblPasien set gain=(
  select gain
  from tblTampung
  where atribut=tblPasien.atribut
);

select * from tblTampung;
select atribut,gain from tblPasien order by gain desc limit 0,1;

create table tbl2(
  atribut varchar(20),
  informasi varchar(20),
  jumlahdata int,
  diagnosaflu int,
  diagnosademam int,
  entropy decimal(8,2),
  gain double
);


select count(*) into @jumlahdata2
from tblC45
where nyeri='tidak';
select @diagnosaflu2 := count(*)
from tblC45
where diagnosa ='parah' and nyeri='tidak';

select @diagnosademam2 := count(*)
from tblC45
where diagnosa ='parah'  and nyeri='tidak';

select @entropy2 := (-1*(@diagnosaflu2/@jumlahdata2)*log2(@diagnosaflu2/@jumlahdata2))+
(-1*(@diagnosademam2/@jumlahdata2)*log2(@diagnosademam2/@jumlahdata2));



insert into tbl2(atribut,jumlahdata,diagnosaflu,diagnosademam,entropy) values
  ('TOTAL DATA',@jumlahdata2,@diagnosaflu2,@diagnosademam2,@entropy2);

-- demam
insert into tbl2(informasi,jumlahdata,diagnosaflu,diagnosademam)
select A.demam, count(*) as Jumlah_data,
  (
    select count(*)
    from tblC45 as B
    where B.diagnosa = 'tidak' and B.demam=A.demam and B.nyeri='ringan'
  ) as 'tidak',
  (
    select count(*)
    from tblC45 as C
    where C.diagnosa = 'parah' and C.demam=A.demam and C.nyeri='ringan'
  ) as 'parah'
from tblC45 as A
where nyeri='parah'
group by demam;



update tbl2 set atribut='demam' where atribut is null;

-- sakitkepala
  insert into tbl2(informasi,jumlahdata,diagnosaflu,diagnosademam)
  select A.sakitkepala, count(*) as Jumlah_data,
    (
      select count(*)
      from tblC45 as B
      where B.diagnosa = 'tidak' and B.sakitkepala=A.sakitkepalaand B.nyeri='ringan'
    ) as 'tidak',
    (
      select count(*)
      from tblC45 as C
      where C.diagnosa = 'parah' and C.sakitkepala=A.sakitkepalaand C.nyeri='ringan'
    ) as 'parah'
  from tblC45 as A
where nyeri='ringan'
  group by sakitkepala;



  update tbl2 set atribut='sakitkepala' where atribut is null;


    -- lemas
    insert into tbl2(informasi,jumlahdata,diagnosaflu,diagnosademam)
    select A.lemas, count(*) as Jumlah_data,
      (
        select count(*)
        from tblC45 as B
        where B.diagnosa = 'tidak' and B.lemas=A.lemas and B.nyeri='ringan'
      ) as 'ringan',
      (
        select count(*)
        from tblC45 as C
        where C.diagnosa = 'parah' and C.lemas=A.lemas and C.nyeri='ringan'
      ) as 'parah'
    from tblC45 as A
    where nyeri='parah'
    group by lemas;

    update tbl2 set atribut='lemas' where atribut is null;

update tbl2 set entropy = (-(diagnosaflu/jumlahdata)* log2(diagnosaflu/jumlahdata))+
      (-(diagnosademam/jumlahdata)*log2(diagnosademam/jumlahdata))
      where diagnosaflu<>0 and diagnosademam<>0;

      update tbl2 set entropy =0 where entropy is null;



        drop table if exists tblTampung2;
        create  table tblTampung2(
          atribut varchar(20),
          gain double
        );


        insert into tblTampung2(atribut,gain)
        select atribut,
        @entropy2-sum((jumlahdata/@jumlahdata2) * entropy)
        from tbl2
        group by atribut;

        update tbl2 set gain=(
          select gain
          from tblTampung2
          where atribut=tbl2.atribut
        );

select * from tblTampung2;
select * from tbl2;

select atribut,gain from tbl2 order by gain desc limit 0,1;
