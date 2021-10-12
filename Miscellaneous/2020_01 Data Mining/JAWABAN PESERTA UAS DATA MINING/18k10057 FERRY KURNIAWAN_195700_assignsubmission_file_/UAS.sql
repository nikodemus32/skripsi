drop database if exists dbUAS;
create database dbUAS;
use dbUAS;

create table tbldata (
    CODE varchar (20),
    Demam varchar (20),
    SKepala varchar (20),
    Nyeri varchar (20),
    Lemas varchar (20),
    Kelelahan varchar (20),
    HTersumbat varchar (20),
    Bersin varchar (20),
    STenggorokan varchar (20),
    SuBernafas varchar (20),
    Diagnosa varchar (20)
);

insert into tbldata values
    ("P1", "Tidak", "Ringan", "Tidak", "Tidak", "Tidak", "Ringan", "Parah", "Parah", "Ringan", "Demam"),
    ("P2", "Parah", "Parah", "Parah", "Parah", "Parah", "Tidak", "Tidak", "Parah", "Parah", "Flu"),
    ("P3", "Parah", "Parah", "Ringan", "Parah", "Parah", "Parah", "Tidak", "Parah", "Parah", "Flu"),
    ("P4", "Tidak", "Tidak", "Tidak", "Ringan", "Tidak", "Parah", "Tidak", "Ringan", "Ringan", "Demam"),
    ("P5", "Parah", "Parah", "Ringan", "Parah", "Parah", "Parah", "Tidak", "Parah", "Parah", "Flu"),
    ("P6", "Tidak", "Tidak", "Tidak", "Ringan", "Tidak", "Parah", "Parah", "Parah", "Tidak", "Demam"),
    ("P7", "Parah", "Parah", "Parah", "Parah", "Parah", "Tidak", "Tidak", "Tidak", "Parah", "Flu"),
    ("P8", "Tidak", "Tidak", "Tidak", "Tidak", "Tidak", "Parah", "Parah", "Tidak", "Ringan", "Demam"),
    ("P9", "Tidak", "Ringan", "Ringan", "Tidak", "Tidak", "Parah", "Parah", "Parah", "Parah", "Demam"),
    ("P10", "Parah", "Parah", "Parah", "Ringan", "Ringan", "Tidak", "Parah", "Tidak", "Parah", "Flu"),
    ("P11", "Tidak", "Tidak", "Tidak", "Ringan", "Tidak", "Parah", "Ringan", "Parah", "Tidak", "Demam"),
    ("P12", "Parah", "Ringan", "Parah", "Ringan", "Parah", "Tidak", "Parah", "Tidak", "Ringan", "Flu"),
    ("P13", "Tidak", "Tidak", "Ringan", "Ringan", "Tidak", "Parah", "Parah", "Parah", "Tidak", "Demam"),
    ("P14", "Parah", "Parah", "Parah", "Parah", "Ringan", "Tidak", "Parah", "Parah", "Parah", "Flu"),
    ("P15", "Ringan", "Tidak", "Tidak", "Ringan", "Tidak", "Parah", "Tidak", "Parah", "Ringan", "Demam"),
    ("P16", "Tidak", "Tidak", "Tidak",  "Tidak",  "Tidak", "Parah", "Parah", "Parah", "Parah", "Demam"),
    ("P17", "Parah", "Ringan", "Parah", "Ringan", "Ringan", "Tidak", "Tidak", "Tidak", "Parah", "Flu");

select * from tbldata;

create table tblHitung(
  atribut varchar(20),
  informasi varchar(20),
  jumlahdata int,
  diagD int,
  diagF int,
  entropy decimal(8,2),
  gain double
);

select count(*) into @jumlahdata from tbldata;
select @diagF := count(*)
from tbldata
where Diagnosa ='Flu';

select @diagD := count(*)
from tbldata
where Diagnosa ='Demam';

select @jumlahdata,@diagD,@diagF;

select @entropy := (-1*(@diagD/@jumlahdata)*log2(@diagD/@jumlahdata))+
@entropy := (-1*(@diagF/@jumlahdata)*log2(@diagF/@jumlahdata));
select @entropy as entropy;
insert into tblHitung(atribut,jumlahdata,diagD,diagF,entropy) values
  ('TOTAL DATA',@jumlahdata,@diagD,@diagF,@entropy);

insert into tblHitung(informasi, jumlahdata , diagD, diagF)
select A.Demam, count(*) as Jumlah_data,
  (
    select count(*)
    from tbldata as B
    where B.Diagnosa = 'Demam' and B.Demam = A.Demam
  ) as 'Demam',
  (
    select count(*)
    from tbldata as C
    where C.Diagnosa = 'Flu' and C.Demam = A.Demam
  ) as 'Flu'
from tbldata as A
group by Demam;

update tblHitung set atribut='Demam' where atribut is null;
select * from tblHitung;

insert into tblHitung(informasi, jumlahdata , diagD, diagF)
select A.SKepala, count(*) as Jumlah_data,
  (
    select count(*)
    from tbldata as B
    where B.Diagnosa = 'Demam' and B.SKepala = A.SKepala
  ) as 'Demam',
  (
    select count(*)
    from tbldata as C
    where C.Diagnosa = 'Flu' and C.SKepala = A.SKepala
  ) as 'Flu'
from tbldata as A
group by SKepala;

update tblHitung set atribut='Sakit Kepala' where atribut is null;
select * from tblHitung
where atribut like "%Sakit Kepala" OR atribut like "%TOTAL DATA";

insert into tblHitung(informasi, jumlahdata , diagD, diagF)
select A.Nyeri, count(*) as Jumlah_data,
  (
    select count(*)
    from tbldata as B
    where B.Diagnosa = 'Demam' and B.Nyeri = A.Nyeri
  ) as 'Demam',
  (
    select count(*)
    from tbldata as C
    where C.Diagnosa = 'Flu' and C.Nyeri = A.Nyeri
  ) as 'Flu'
from tbldata as A
group by Nyeri;

update tblHitung set atribut='Nyeri' where atribut is null;
select * from tblHitung
where atribut like "%Nyeri%" OR atribut like "%TOTAL DATA%";

insert into tblHitung(informasi, jumlahdata , diagD, diagF)
select A.Lemas, count(*) as Jumlah_data,
  (
    select count(*)
    from tbldata as B
    where B.Diagnosa = 'Demam' and B.Lemas = A.Lemas
  ) as 'Demam',
  (
    select count(*)
    from tbldata as C
    where C.Diagnosa = 'Flu' and C.Lemas = A.Lemas
  ) as 'Flu'
from tbldata as A
group by Lemas;

update tblHitung set atribut='Lemas' where atribut is null;
select * from tblHitung
where atribut like "%Lemas%" OR atribut like "%TOTAL DATA%";

insert into tblHitung(informasi, jumlahdata , diagD, diagF)
select A.Kelelahan, count(*) as Jumlah_data,
  (
    select count(*)
    from tbldata as B
    where B.Diagnosa = 'Demam' and B.Kelelahan = A.Kelelahan
  ) as 'Demam',
  (
    select count(*)
    from tbldata as C
    where C.Diagnosa = 'Flu' and C.Kelelahan = A.Kelelahan
  ) as 'Flu'
from tbldata as A
group by Kelelahan;

update tblHitung set atribut='Kelelahan' where atribut is null;
select * from tblHitung
where atribut like "%Kelelahan%" OR atribut like "%TOTAL DATA%";

insert into tblHitung(informasi, jumlahdata , diagD, diagF)
select A.HTersumbat, count(*) as Jumlah_data,
  (
    select count(*)
    from tbldata as B
    where B.Diagnosa = 'Demam' and B.HTersumbat = A.HTersumbat
  ) as 'Demam',
  (
    select count(*)
    from tbldata as C
    where C.Diagnosa = 'Flu' and C.HTersumbat = A.HTersumbat
  ) as 'Flu'
from tbldata as A
group by HTersumbat;

update tblHitung set atribut='Hidung Tersumbat' where atribut is null;
select * from tblHitung
where atribut like "%Hidung Tersumbat%" OR atribut like "%TOTAL DATA%";

insert into tblHitung(informasi, jumlahdata , diagD, diagF)
select A.Bersin, count(*) as Jumlah_data,
  (
    select count(*)
    from tbldata as B
    where B.Diagnosa = 'Demam' and B.Bersin = A.Bersin
  ) as 'Demam',
  (
    select count(*)
    from tbldata as C
    where C.Diagnosa = 'Flu' and C.Bersin = A.Bersin
  ) as 'Flu'
from tbldata as A
group by Bersin;

update tblHitung set atribut='Bersin' where atribut is null;
select * from tblHitung
where atribut like "%Bersin%" OR atribut like "%TOTAL DATA%";

insert into tblHitung(informasi, jumlahdata , diagD, diagF)
select A.STenggorokan, count(*) as Jumlah_data,
  (
    select count(*)
    from tbldata as B
    where B.Diagnosa = 'Demam' and B.STenggorokan = A.STenggorokan
  ) as 'Demam',
  (
    select count(*)
    from tbldata as C
    where C.Diagnosa = 'Flu' and C.STenggorokan = A.STenggorokan
  ) as 'Flu'
from tbldata as A
group by STenggorokan;

update tblHitung set atribut='Sakit Tenggorokan' where atribut is null;
select * from tblHitung
where atribut like "%Sakit Tenggorokan%" OR atribut like "%TOTAL DATA%";

insert into tblHitung(informasi, jumlahdata , diagD, diagF)
select A.SuBernafas, count(*) as Jumlah_data,
  (
    select count(*)
    from tbldata as B
    where B.Diagnosa = 'Demam' and B.SuBernafas = A.SuBernafas
  ) as 'Demam',
  (
    select count(*)
    from tbldata as C
    where C.Diagnosa = 'Flu' and C.SuBernafas = A.SuBernafas
  ) as 'Flu'
from tbldata as A
group by SuBernafas;

update tblHitung set atribut='Sulit Bernafas' where atribut is null;
select * from tblHitung
where atribut like "%Sulit Bernafas%" OR atribut like "%TOTAL DATA%";

update tblHitung set entropy = (-(diagF/jumlahdata)* log2(diagF/jumlahdata))+
(-(diagD/jumlahdata)*log2(diagD/jumlahdata))
where diagF<>0 and diagD<>0;

update tblHitung set entropy =0 where entropy is null;

drop table if exists tblTampung;
create  table tblTampung(
  atribut varchar(20),
  gain double
);

insert into tblTampung(atribut,gain)
select atribut,
@entropy-sum((jumlahdata/@jumlahdata) * entropy)
from tblHitung
group by atribut;

update tblHitung set gain=(
  select gain
  from tblTampung
  where atribut=tblHitung.atribut
);

select * from tblTampung;
select atribut,gain from tblHitung order by gain desc limit 0,1;

select * from tblHitung
order by gain desc limit 0,3;