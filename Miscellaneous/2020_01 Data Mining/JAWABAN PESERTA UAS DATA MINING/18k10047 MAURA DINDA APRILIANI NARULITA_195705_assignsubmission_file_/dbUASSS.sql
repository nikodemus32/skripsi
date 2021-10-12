
DROP DATABASE IF EXISTS dbC45;
CREATE DATABASE dbC45;
USE dbC45;

CREATE TABLE tblC45
(
pasien VARCHAR(10),
Demam VARCHAR(10),
Sakitkepala VARCHAR(10),
Nyeri VARCHAR(10),
Lemas VARCHAR(10),
Kelelahan VARCHAR(10),
HidungTersumbat VARCHAR(10),
Bersin VARCHAR(10),
SakitTenggorokan VARCHAR(10),
SulitBernapas VARCHAR(10)
Diagnosa VARCHAR(10)
);

LOAD DATA LOCAL INFILE 'dbC-45.csv'
INTO TABLE tblC45
FIELDS TERMINATED BY ';'
ENCLOSED BY ''''
IGNORE 1 LINES;

SELECT * FROM tblC45;

CREATE TABLE tblHitung
(
keterangan VARCHAR(10),
atribut VARCHAR(20),
informasi VARCHAR(20),
jumlahdata INT,
demam INT,
flu INT,
entropy DECIMAL(8,4),
gain DECIMAL(8,4)
);

select @jumkasus := count(*) from tblC45;
select @demam := count(*) from tblC45 where Diagnosa = 'Demams';
select @flu := count(*) from tblC45 where Diagnosa ='Flue';
select @entropy :=
(-(@flu/@jumkasus)*log2(@flu@jumkasus))+(-(@demam/@jumkasu
s)*log2(@demam/@jumkasus));
select @jumkasus, @demam, @flu, @entropy;
insert into tblHitung
(keterangan, jumlahkasus, demam, flu, entropy)
values ('Total', @jumkasus, @demam, @flu, @entropy);

insert into tblHitung (atribut, jumlahkasus, demam, flu)
select distinct(A.Demam), count(*) as jumkasus,
(select count(*) from tblC45 as b
where b.Diagnosa = 'Flue' and b.Demam = A.Demam) as
'Flu',
(select count(*) from tblC45 as c
where c.Diagnosa = 'Demams' and c.Demam = A.Demam) as
'Demam'
from tblC45 As A
group by A.Demam;
update tblHitung set keterangan = 'Demam' where keterangan
IS NULL;

insert into tblHitung (atribut, jumlahkasus, demam, flue)
select distinct(A.Sakitkepala), count(*) as jumkasus,
(select count(*) from tblC45 as b
where b.Diagnosa = 'Flue' and b.Sakitkepala = A.Sakitkepala)
as 'Flu',
(select count(*) from tblC45 as c
where c.Diagnosa = 'Demams' and c.Sakitkepala =
A.Sakitkepala) as 'Demam'
from tblC45 As A
group by A.Sakitkepala;
update tblHitung set keterangan = 'Sakitkepala' where
keterangan IS NULL;

insert into tblHitung (atribut, jumlahkasus, demam, flu)
select distinct(A.Nyeri), count(*) as jumkasus,
(select count(*) from tblC45 as b
where b.Diagnosa = 'Flue' and b.Nyeri = A.Nyeri) as
'Flu',
(select count(*) from tblC45 as c
where c.Diagnosa = 'Demams' and c.Nyeri = A.Nyeri) as
'Demam'
from tblC45 As A
group by A.Nyeri;
update tblHitung set keterangan = 'Nyeri' where
keterangan IS NULL;

insert into tblHitung (atribut, jumlahkasus, demam, flu)
select distinct(A.Lemas), count(*) as jumkasus,
(select count(*) from tblC45 as b
where b.Diagnosa = 'Flue' and b.Lemas = A.Lemas) as 'Flu',
(select count(*) from tblC45 as c
where c.Diagnosa = 'Demams' and c.Lemas = A.Lemas) as 'Demam'
from tblC45 As A
group by A.Lemas;
update tblHitung set keterangan = 'Lemas' where keterangan
IS NULL;

insert into tblHitung (atribut, jumlahkasus, demam, flu)
select distinct(A.Kelelahan), count(*) as jumkasus,
(select count(*) from tblC45 as b
where b.Diagnosa = 'Flue' and b.Kelelahan = A.Kelelahan) as 'Flu',
(select count(*) from tblC45 as c
where c.Diagnosa = 'Demams' and c.Kelelahan = A.Kelelahan) as 'Demam'
from tblC45 As A
group by A.Kelelahan;
update tblHitung set keterangan = 'Kelelahan' where keterangan
IS NULL;

insert into tblHitung (atribut, jumlahkasus, demam, flu)
select distinct(A.HidungTersumbat), count(*) as jumkasus,
(select count(*) from tblC45 as b
where b.Diagnosa = 'Flue' and b.HidungTersumbat = A.HidungTersumbat) as 'Flu',
(select count(*) from tblC45 as c
where c.Diagnosa = 'Demams' and c.HidungTersumbat = A.HidungTersumbat) as 'Demam'
from tblC45 As A
group by A.HidungTersumbat;
update tblHitung set keterangan = 'HidungTersumbat' where keterangan
IS NULL;

insert into tblHitung (atribut, jumlahkasus, demam, flu)
select distinct(A.Bersin), count(*) as jumkasus,
(select count(*) from tblC45 as b
where b.Diagnosa = 'Flue' and b.Bersin = A.Bersin) as 'Flu',
(select count(*) from tblC45 as c
where c.Diagnosa = 'Demams' and c.Bersin = A.Bersin) as 'Demam'
from tblC45 As A
group by A.Bersin;
update tblHitung set keterangan = 'Bersin' where keterangan
IS NULL;

insert into tblHitung (atribut, jumlahkasus, demam, flu)
select distinct(A.SakitTenggorokan), count(*) as jumkasus,
(select count(*) from tblC45 as b
where b.Diagnosa = 'Flue' and b.SakitTenggorokan = A.SakitTenggorokan) as 'Flu',
(select count(*) from tblC45 as c
where c.Diagnosa = 'Demams' and c.SakitTenggorokan = A.SakitTenggorokan) as 'Demam'
from tblC45 As A
group by A.SakitTenggorokan;
update tblHitung set keterangan = 'SakitTenggorokan' where keterangan
IS NULL;

insert into tblHitung (atribut, jumlahkasus, demam, flu)
select distinct(A.SulitBernapas), count(*) as jumkasus,
(select count(*) from tblC45 as b
where b.Diagnosa = 'Flue' and b.SulitBernapas = A.SulitBernapas) as 'Flu',
(select count(*) from tblC45 as c
where c.Diagnosa = 'Demams' and c.SulitBernapas = A.SulitBernapas) as 'Demam'
from tblC45 As A
group by A.SulitBernapas;
update tblHitung set keterangan = 'SulitBernapas' where keterangan
IS NULL;

update tblHitung set atribut = ' ' where atribut is NULL;
update tblHitung set entropy =
(-(demam/jumlahkasus)*log2(demam/jumlahkasus))+(- flu/jumlahk
asus)*log2 flu/jumlahkasus));
update tblHitung set entropy = 0 where entropy is null;

DROP TABLE IF EXISTS tblTampung;
CREATE TEMPORARY TABLE tblTampung
(
keterangan varchar(20),
gain double
);
insert into tblTampung (keterangan, gain)
select keterangan, @entropy - sum((jumlahkasus/@jumkasus) *
entropy) as HitungGain
from tblHitung
group by keterangan;
update tblHitung set gain =
(select tblTampung.gain
from tblTampung
where tblTampung.keterangan = tblHitung.keterangan);
select * from tblC45;

select ucase(keterangan) as KETERANGAN,
ucase(atribut) as ATRIBUT,
jumlahkasus as JUMLAH,
demam as DEMAM,
round(entropy, 10) as ENTROPY,
round(gain, 10) as GA
flu as FLU,IN
from tblHitung

