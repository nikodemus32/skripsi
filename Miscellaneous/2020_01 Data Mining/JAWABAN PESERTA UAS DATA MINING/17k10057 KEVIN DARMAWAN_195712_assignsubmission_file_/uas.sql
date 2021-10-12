drop database if exists dbUAS;
create database dbUAS;
use dbUAS;

create table tblPasien
(
pasien varchar(3),
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

insert into tblPasien values
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
('P17','Parah','Ringan','Parah','Ringan','RIngan','Tidak','Tidak','Tidak','Parah','Flu');

select pasien as '[1]',
demam as '[2]',
sakitkepala as '[3]',
nyeri as '[4]',
lemas as '[5]',
kelelahan as '[6]',
hidungtersumbat as '[7]',
bersin as '[8]',
sakittenggorokan as '[9]',
sulitbernafas as '[10]',
diagnosa as Diagnosa
from tblPasien;

create table tblHitung
(
atribut varchar(255),
informasi varchar(20),
jumdata int,
diagdemam int,
diagflu int,
entropy decimal(8,4),
gain double
);

select COUNT(*) into @jumdata
from tblPasien;

select COUNT(*) into @diagdemam
from tblPasien
where diagnosa = 'Demam';

select COUNT(*) into @diagflu
from tblPasien
where diagnosa = 'Flu';

select (-(@diagdemam/@jumdata)*log2(@diagdemam/@jumdata))
+
(-(@diagflu/@jumdata)*log2(@diagflu/@jumdata)) 
into @entropy;

select @jumdata AS 'JUMLAH DATA',
@diagdemam AS 'DIAGNOSA DEMAM',
@diagflu AS 'DIAGNOSA FLU',
ROUND(@entropy, 4) AS ENTROPY;

insert into tblHitung(atribut,jumdata,diagdemam,diagflu,entropy) values
('TOTAL DATA', @jumdata, @diagdemam, @diagflu, @entropy);

select atribut as ATRIBUT,jumdata as 'JUMLAH DATA',diagdemam as 'DIAGNOSA DEMAM',
diagflu as 'DIAGNOSA FLU', entropy as 'ENTROPY'
from tblHitung;

/*Proses Demam */
insert into tblHitung(informasi, jumdata,diagdemam,diagflu)
	select A.demam as DEMAM, count(*) as 'JUMLAH DATA',
		(
		select count(*)
		from tblPasien as B
		where B.diagnosa = 'Demam' AND B.demam = A.demam
		) AS 'Demam',
	
		(
		select count(*)
		from tblPasien as C
		where C.diagnosa = 'flu' AND C.demam = A.demam
		) AS 'Flu'
	from tblPasien as A
	group by A.demam;
	
update tblHitung set atribut = 'DEMAM' where atribut is null;

/*Proses Sakit Kepala*/
insert into tblHitung(informasi, jumdata,diagdemam,diagflu)
	select A.sakitkepala as 'SAKIT KEPALA', count(*) as 'JUMLAH DATA',
		(
		select count(*)
		from tblPasien as B
		where B.diagnosa = 'Demam' AND B.sakitkepala = A.sakitkepala
		) AS 'Demam',
	
		(
		select count(*)
		from tblPasien as C
		where C.diagnosa = 'flu' AND C.sakitkepala = A.sakitkepala
		) AS 'Flu'
	from tblPasien as A
	group by A.sakitkepala;
	
update tblHitung set atribut = 'SAKIT KEPALA' where atribut is null;

/*Proses Nyeri*/
insert into tblHitung(informasi, jumdata,diagdemam,diagflu)
	select A.nyeri as NYERI, count(*) as 'JUMLAH DATA',
		(
		select count(*)
		from tblPasien as B
		where B.diagnosa = 'Demam' AND B.nyeri = A.nyeri
		) AS 'Demam',
	
		(
		select count(*)
		from tblPasien as C
		where C.diagnosa = 'flu' AND C.nyeri = A.nyeri
		) AS 'Flu'
	from tblPasien as A
	group by A.nyeri;
	
update tblHitung set atribut = 'NYERI' where atribut is null;

/*Proses Lemas*/
insert into tblHitung(informasi, jumdata,diagdemam,diagflu)
	select A.lemas as LEMAS, count(*) as 'JUMLAH DATA',
		(
		select count(*)
		from tblPasien as B
		where B.diagnosa = 'Demam' AND B.lemas = A.lemas
		) AS 'Demam',
	
		(
		select count(*)
		from tblPasien as C
		where C.diagnosa = 'flu' AND C.lemas = A.lemas
		) AS 'Flu'
	from tblPasien as A
	group by A.lemas;
	
update tblHitung set atribut = 'LEMAS' where atribut is null;

/*Proses Kelelahan*/
insert into tblHitung(informasi, jumdata,diagdemam,diagflu)
	select A.kelelahan as KELELAHAN, count(*) as 'JUMLAH DATA',
		(
		select count(*)
		from tblPasien as B
		where B.diagnosa = 'Demam' AND B.kelelahan = A.kelelahan
		) AS 'Demam',
	
		(
		select count(*)
		from tblPasien as C
		where C.diagnosa = 'flu' AND C.kelelahan = A.kelelahan
		) AS 'Flu'
	from tblPasien as A
	group by A.kelelahan;
	
update tblHitung set atribut = 'KELELAHAN' where atribut is null;

/*Proses Hidung Tersumbat*/
insert into tblHitung(informasi, jumdata,diagdemam,diagflu)
	select A.hidungtersumbat as 'HIDUNG TERSUMBAT', count(*) as 'JUMLAH DATA',
		(
		select count(*)
		from tblPasien as B
		where B.diagnosa = 'Demam' AND B.hidungtersumbat = A.hidungtersumbat
		) AS 'Demam',
	
		(
		select count(*)
		from tblPasien as C
		where C.diagnosa = 'flu' AND C.hidungtersumbat = A.hidungtersumbat
		) AS 'Flu'
	from tblPasien as A
	group by A.hidungtersumbat;
	
update tblHitung set atribut = 'HIDUNG TERSUMBAT' where atribut is null;

/*Proses Bersin*/
insert into tblHitung(informasi, jumdata,diagdemam,diagflu)
	select A.bersin as BERSIN, count(*) as 'JUMLAH DATA',
		(
		select count(*)
		from tblPasien as B
		where B.diagnosa = 'Demam' AND B.bersin = A.bersin
		) AS 'Demam',
	
		(
		select count(*)
		from tblPasien as C
		where C.diagnosa = 'flu' AND C.bersin = A.bersin
		) AS 'Flu'
	from tblPasien as A
	group by A.bersin;
	
update tblHitung set atribut = 'BERSIN' where atribut is null;

/*Proses Sakit Tenggorakan*/
insert into tblHitung(informasi, jumdata,diagdemam,diagflu)
	select A.sakittenggorokan as 'SAKIT TENGGOROKAN', count(*) as 'JUMLAH DATA',
		(
		select count(*)
		from tblPasien as B
		where B.diagnosa = 'Demam' AND B.sakittenggorokan = A.sakittenggorokan
		) AS 'Demam',
	
		(
		select count(*)
		from tblPasien as C
		where C.diagnosa = 'flu' AND C.sakittenggorokan = A.sakittenggorokan
		) AS 'Flu'
	from tblPasien as A
	group by A.sakittenggorokan;
	
update tblHitung set atribut = 'SAKIT TENGGOROKAN' where atribut is null;

/*Proses Sulit Bernafas*/
insert into tblHitung(informasi, jumdata,diagdemam,diagflu)
	select A.sulitbernafas as 'SULIT BERNAFAS', count(*) as 'JUMLAH DATA',
		(
		select count(*)
		from tblPasien as B
		where B.diagnosa = 'Demam' AND B.sulitbernafas = A.sulitbernafas
		) AS 'Demam',
	
		(
		select count(*)
		from tblPasien as C
		where C.diagnosa = 'flu' AND C.sulitbernafas = A.sulitbernafas
		) AS 'Flu'
	from tblPasien as A
	group by A.sulitbernafas;
	
update tblHitung set atribut = 'SULIT BERNAFAS' where atribut is null;

/*Cek Tabel Hitung Terupdate*/
select * from tblHitung;

/*Menghitung entropy*/
update tblHitung set entropy = (-(diagdemam/jumdata)*log2(diagdemam/jumdata))
+ 
(-(diagflu/jumdata)*log2(diagflu/jumdata));

update tblHitung set entropy = 0 where entropy is NULL;

select * from tblHitung;

/*Menghitung GAIN*/
drop table if exists tblSementara;
create temporary table tblSementara
(
atribut varchar(20),
gain double
);

INSERT into tblSementara(atribut, gain)
select atribut, @entropy - SUM((jumdata/@jumdata) *  entropy) AS GAIN 
from tblHitung
group by atribut;

select * from tblSementara;

update tblHitung set GAIN =
(
select gain
from tblSementara
where atribut = tblHitung.atribut
);

TRUNCATE table tblHitung;

/*ITERASI KE- 2*/
SELECT COUNT(*) INTO @jumdata 
FROM tblPasien 
WHERE nyeri = 'Ringan';

SELECT COUNT(*) INTO @diagdemam
FROM tblPasien 
WHERE diagnosa = 'Demam' 
AND nyeri = 'Ringan';

SELECT COUNT(*) INTO @diagflu 
FROM tblPasien
WHERE diagnosa = 'Flu' 
AND nyeri = 'Ringan';

SELECT (-(@diagdemam/@jumdata) * log2(@diagdemam/@jumdata)) + (-(@diagflu/@jumdata) * log2(@diagflu/@jumdata)) 
INTO @entropy;

SELECT @jumdata AS 'JUMLAH DATA NYERI RINGAN',
@diagdemam AS 'DIAGNOSA DEMAM',
@diagflu AS 'DIAGNOSA FLU', 
ROUND(@entropy,4) AS 'ENTROPY NYERI RINGAN';

INSERT INTO tblHitung(atribut, jumdata, diagdemam, diagflu, entropy) 
VALUES ('TOTAL DATA NYERI RINGAN', @jumdata, @diagdemam, @diagflu, @entropy);
SELECT * FROM tblHitung;

/*Demam*/
INSERT INTO tblHitung(informasi, jumdata, diagdemam, diagflu)
    SELECT A.demam AS DEMAM, COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*) 
			FROM tblPasien AS B 
			WHERE B.diagnosa = 'Demam' AND B.demam = A.demam 
			AND nyeri = 'Ringan'
        ) AS 'Demam',
        (
            SELECT COUNT(*) 
			FROM tblPasien AS C 
			WHERE C.diagnosa = 'Flu' AND C.demam = A.demam 
			AND nyeri = 'Ringan'
        ) AS 'Flu'
    FROM tblPasien AS A 
	WHERE nyeri = 'Ringan' GROUP BY demam;

UPDATE tblHitung 
SET atribut = 'DEMAM' 
WHERE atribut IS NULL;

/*Sakit Kepala*/
INSERT INTO tblHitung(informasi, jumdata, diagdemam, diagflu)
    SELECT A.sakitkepala AS 'SAKIT KEPALA', COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*) 
			FROM tblPasien AS B 
			WHERE B.diagnosa = 'Demam' AND B.sakitkepala = A.sakitkepala 
			AND nyeri = 'Ringan'
        ) AS 'Demam',
        (
            SELECT COUNT(*) 
			FROM tblPasien AS C 
			WHERE C.diagnosa = 'Flu' AND C.sakitkepala = A.sakitkepala 
			AND nyeri = 'Ringan'
        ) AS 'Flu'
    FROM tblPasien AS A 
	WHERE nyeri = 'Ringan' GROUP BY sakitkepala;

UPDATE tblHitung 
SET atribut = 'SAKIT KEPALA' 
WHERE atribut IS NULL;

/*Lemas*/
INSERT INTO tblHitung(informasi, jumdata, diagdemam, diagflu)
    SELECT A.lemas AS LEMAS, COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*) 
			FROM tblPasien AS B 
			WHERE B.diagnosa = 'Demam' AND B.lemas = A.lemas 
			AND nyeri = 'Ringan'
        ) AS 'Demam',
        (
            SELECT COUNT(*) 
			FROM tblPasien AS C 
			WHERE C.diagnosa = 'Flu' AND C.lemas = A.lemas 
			AND nyeri = 'Ringan'
        ) AS 'Flu'
    FROM tblPasien AS A 
	WHERE nyeri = 'Ringan' GROUP BY lemas;

UPDATE tblHitung 
SET atribut = 'LEMAS' 
WHERE atribut IS NULL;

/*Kelelahan*/
INSERT INTO tblHitung(informasi, jumdata, diagdemam, diagflu)
    SELECT A.kelelahan AS KELELAHAN, COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*) 
			FROM tblPasien AS B 
			WHERE B.diagnosa = 'Demam' AND B.kelelahan = A.kelelahan 
			AND nyeri = 'Ringan'
        ) AS 'Demam',
        (
            SELECT COUNT(*) 
			FROM tblPasien AS C 
			WHERE C.diagnosa = 'Flu' AND C.kelelahan = A.kelelahan 
			AND nyeri = 'Ringan'
        ) AS 'Flu'
    FROM tblPasien AS A 
	WHERE nyeri = 'Ringan' GROUP BY kelelahan;

UPDATE tblHitung 
SET atribut = 'KELELAHAN' 
WHERE atribut IS NULL;

/*Hidung Tersumbat*/
INSERT INTO tblHitung(informasi, jumdata, diagdemam, diagflu)
    SELECT A.hidungtersumbat AS 'Hidung Tersumbat', COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*) 
			FROM tblPasien AS B 
			WHERE B.diagnosa = 'Demam' AND B.hidungtersumbat = A.hidungtersumbat 
			AND nyeri = 'Ringan'
        ) AS 'Demam',
        (
            SELECT COUNT(*) 
			FROM tblPasien AS C 
			WHERE C.diagnosa = 'Flu' AND C.hidungtersumbat = A.hidungtersumbat 
			AND nyeri = 'Ringan'
        ) AS 'Flu'
    FROM tblPasien AS A 
	WHERE nyeri = 'Ringan' GROUP BY hidungtersumbat;

UPDATE tblHitung 
SET atribut = 'HIDUNG TERSUMBAT' 
WHERE atribut IS NULL;

/*Bersin*/
INSERT INTO tblHitung(informasi, jumdata, diagdemam, diagflu)
    SELECT A.bersin AS BERSIN, COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*) 
			FROM tblPasien AS B 
			WHERE B.diagnosa = 'Demam' AND B.bersin = A.bersin 
			AND nyeri = 'Ringan'
        ) AS 'Demam',
        (
            SELECT COUNT(*) 
			FROM tblPasien AS C 
			WHERE C.diagnosa = 'Flu' AND C.bersin = A.bersin 
			AND nyeri = 'Ringan'
        ) AS 'Flu'
    FROM tblPasien AS A 
	WHERE nyeri = 'Ringan' GROUP BY bersin;

UPDATE tblHitung 
SET atribut = 'BERSIN' 
WHERE atribut IS NULL;

/*Sakit Tenggorokkan*/
INSERT INTO tblHitung(informasi, jumdata, diagdemam, diagflu)
    SELECT A.sakittenggorokan AS 'Sakit Tenggorokkan', COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*) 
			FROM tblPasien AS B 
			WHERE B.diagnosa = 'Demam' AND B.sakittenggorokan = A.sakittenggorokan 
			AND nyeri = 'Ringan'
        ) AS 'Demam',
        (
            SELECT COUNT(*) 
			FROM tblPasien AS C 
			WHERE C.diagnosa = 'Flu' AND C.sakittenggorokan = A.sakittenggorokan 
			AND nyeri = 'Ringan'
        ) AS 'Flu'
    FROM tblPasien AS A 
	WHERE nyeri = 'Ringan' GROUP BY sakittenggorokan;

UPDATE tblHitung 
SET atribut = 'SAKIT TENGGOROKKAN' 
WHERE atribut IS NULL;

/*Sulit Bernafas*/
INSERT INTO tblHitung(informasi, jumdata, diagdemam, diagflu)
    SELECT A.sulitbernafas AS 'SULIT BERNAFAS', COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*) 
			FROM tblPasien AS B 
			WHERE B.diagnosa = 'Demam' AND B.sulitbernafas = A.sulitbernafas 
			AND nyeri = 'Ringan'
        ) AS 'Demam',
        (
            SELECT COUNT(*) 
			FROM tblPasien AS C 
			WHERE C.diagnosa = 'Flu' AND C.sulitbernafas = A.sulitbernafas 
			AND nyeri = 'Ringan'
        ) AS 'Flu'
    FROM tblPasien AS A 
	WHERE nyeri = 'Ringan' GROUP BY sulitbernafas;

UPDATE tblHitung 
SET atribut = 'SULIT BERNAFAS' 
WHERE atribut IS NULL;
select * from tblHitung;

/*Entropy*/
UPDATE tblHitung 
SET entropy = (-(diagdemam/jumdata) * log2(diagdemam/jumdata)) + 
(-(diagflu/jumdata) * log2(diagflu/jumdata));

UPDATE tblHitung 
SET entropy = 0 
WHERE entropy IS NULL;

SELECT * FROM tblHitung;

/*GAIN*/
DROP TABLE IF EXISTS tblTampung;
CREATE TEMPORARY TABLE tblTampung
(
    atribut VARCHAR(20),
    gain decimal(8,4)
);

INSERT INTO tblTampung(atribut, gain)
SELECT atribut, @entropy - SUM((jumdata/@jumdata) * entropy) AS GAIN 
FROM tblHitung GROUP BY atribut;

SELECT * FROM tblTampung;

UPDATE tblHitung SET GAIN =
    (
        SELECT gain
        FROM tblTampung
        WHERE atribut = tblHitung.atribut
    );

SELECT * FROM tblHitung;

TRUNCATE table tblHitung;

/*ITERASI KE 3*/
SELECT COUNT(*) INTO @jumdata 
FROM tblPasien
WHERE nyeri = 'Ringan' 
AND sulitbernafas = 'Parah';

SELECT COUNT(*) INTO @diagdemam 
FROM tblPasien 
WHERE diagnosa = 'Demam' 
AND nyeri = 'Ringan'
AND sulitbernafas = 'Parah';

SELECT COUNT(*) INTO @diagflu 
FROM tblPasien 
WHERE diagnosa = 'Flu' 
AND nyeri = 'Ringan'
AND sulitbernafas = 'Parah';

SELECT (-(@diagdemam/@jumdata) * log2(@diagdemam/@jumdata)) + (-(@diagflu/@jumdata) * log2(@diagflu/@jumdata)) 
INTO @entropy;

SELECT @jumdata AS 'JUMLAH DATA NYERI RINGAN, SULIT BERNAFAS PARAH',
@diagdemam AS DEMAM, 
@diagflu AS FLU, 
ROUND(@entropy,4) AS 'ENTROPY NYERI RINGAN, SULIT BERNAFAS PARAH';

INSERT INTO tblHitung(atribut, jumdata, diagdemam, diagflu, entropy) 
VALUES ('TOTAL DATA NYERI RINGAN, SULIT BERNAFAS PARAH', @jumdata, @diagdemam, @diagflu, @entropy);
SELECT * FROM tblHitung;

/*Demam*/
INSERT INTO tblHitung(informasi, jumdata, diagdemam, diagflu)
    SELECT A.demam AS DEMAM, COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*) 
			FROM tblPasien AS B 
			WHERE B.diagnosa = 'Demam' AND B.demam = A.demam 
			AND nyeri = 'Ringan'
			AND sulitbernafas = 'Parah'
        ) AS 'Demam',
        (
            SELECT COUNT(*) 
			FROM tblPasien AS C 
			WHERE C.diagnosa = 'Flu' AND C.demam = A.demam 
			AND nyeri = 'Ringan'
			AND sulitbernafas = 'Parah'
        ) AS 'Flu'
    FROM tblPasien AS A 
	WHERE nyeri = 'Ringan' AND sulitbernafas = 'Parah'
	GROUP BY demam;

UPDATE tblHitung 
SET atribut = 'DEMAM' 
WHERE atribut IS NULL;

/*Sakit Kepala*/
INSERT INTO tblHitung(informasi, jumdata, diagdemam, diagflu)
    SELECT A.sakitkepala AS 'SAKIT KEPALA', COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*) 
			FROM tblPasien AS B 
			WHERE B.diagnosa = 'Demam' AND B.sakitkepala = A.sakitkepala 
			AND nyeri = 'Ringan'
			AND sulitbernafas = 'Parah'
        ) AS 'Demam',
        (
            SELECT COUNT(*) 
			FROM tblPasien AS C 
			WHERE C.diagnosa = 'Flu' AND C.sakitkepala = A.sakitkepala 
			AND nyeri = 'Ringan'
			AND sulitbernafas = 'Parah'
        ) AS 'Flu'
    FROM tblPasien AS A 
	WHERE nyeri = 'Ringan' 
	AND sulitbernafas = 'Parah'
	GROUP BY sakitkepala;

UPDATE tblHitung 
SET atribut = 'SAKIT KEPALA' 
WHERE atribut IS NULL;

/*Lemas*/
INSERT INTO tblHitung(informasi, jumdata, diagdemam, diagflu)
    SELECT A.lemas AS LEMAS, COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*) 
			FROM tblPasien AS B 
			WHERE B.diagnosa = 'Demam' AND B.lemas = A.lemas 
			AND nyeri = 'Ringan'
			AND sulitbernafas = 'Parah'
        ) AS 'Demam',
        (
            SELECT COUNT(*) 
			FROM tblPasien AS C 
			WHERE C.diagnosa = 'Flu' AND C.lemas = A.lemas 
			AND nyeri = 'Ringan'
			AND sulitbernafas = 'Parah'
        ) AS 'Flu'
    FROM tblPasien AS A 
	WHERE nyeri = 'Ringan' 
	AND sulitbernafas = 'Parah'
	GROUP BY lemas;

UPDATE tblHitung 
SET atribut = 'LEMAS' 
WHERE atribut IS NULL;

/*Kelelahan*/
INSERT INTO tblHitung(informasi, jumdata, diagdemam, diagflu)
    SELECT A.kelelahan AS KELELAHAN, COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*) 
			FROM tblPasien AS B 
			WHERE B.diagnosa = 'Demam' AND B.kelelahan = A.kelelahan 
			AND nyeri = 'Ringan'
			AND sulitbernafas = 'Parah'
        ) AS 'Demam',
        (
            SELECT COUNT(*) 
			FROM tblPasien AS C 
			WHERE C.diagnosa = 'Flu' AND C.kelelahan = A.kelelahan 
			AND nyeri = 'Ringan'
			AND sulitbernafas = 'Parah'
        ) AS 'Flu'
    FROM tblPasien AS A 
	WHERE nyeri = 'Ringan' 
	AND sulitbernafas = 'Parah'
	GROUP BY kelelahan;

UPDATE tblHitung 
SET atribut = 'KELELAHAN' 
WHERE atribut IS NULL;

/*Hidung Tersumbat*/
INSERT INTO tblHitung(informasi, jumdata, diagdemam, diagflu)
    SELECT A.hidungtersumbat AS 'Hidung Tersumbat', COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*) 
			FROM tblPasien AS B 
			WHERE B.diagnosa = 'Demam' AND B.hidungtersumbat = A.hidungtersumbat 
			AND nyeri = 'Ringan'
			AND sulitbernafas = 'Parah'
        ) AS 'Demam',
        (
            SELECT COUNT(*) 
			FROM tblPasien AS C 
			WHERE C.diagnosa = 'Flu' AND C.hidungtersumbat = A.hidungtersumbat 
			AND nyeri = 'Ringan'
			AND sulitbernafas = 'Parah'
        ) AS 'Flu'
    FROM tblPasien AS A 
	WHERE nyeri = 'Ringan'
	AND sulitbernafas = 'Parah'
	GROUP BY hidungtersumbat;

UPDATE tblHitung 
SET atribut = 'HIDUNG TERSUMBAT' 
WHERE atribut IS NULL;

/*Bersin*/
INSERT INTO tblHitung(informasi, jumdata, diagdemam, diagflu)
    SELECT A.bersin AS BERSIN, COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*) 
			FROM tblPasien AS B 
			WHERE B.diagnosa = 'Demam' AND B.bersin = A.bersin 
			AND nyeri = 'Ringan'
			AND sulitbernafas = 'Parah'
        ) AS 'Demam',
        (
            SELECT COUNT(*) 
			FROM tblPasien AS C 
			WHERE C.diagnosa = 'Flu' AND C.bersin = A.bersin 
			AND nyeri = 'Ringan'
			AND sulitbernafas = 'Parah'
        ) AS 'Flu'
    FROM tblPasien AS A 
	WHERE nyeri = 'Ringan' 
	AND sulitbernafas = 'Parah'
	GROUP BY bersin;

UPDATE tblHitung 
SET atribut = 'BERSIN' 
WHERE atribut IS NULL;

/*Sakit Tenggorokkan*/
INSERT INTO tblHitung(informasi, jumdata, diagdemam, diagflu)
    SELECT A.sakittenggorokan AS 'Sakit Tenggorokkan', COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*) 
			FROM tblPasien AS B 
			WHERE B.diagnosa = 'Demam' AND B.sakittenggorokan = A.sakittenggorokan 
			AND nyeri = 'Ringan'
			AND sulitbernafas = 'Parah'
        ) AS 'Demam',
        (
            SELECT COUNT(*) 
			FROM tblPasien AS C 
			WHERE C.diagnosa = 'Flu' AND C.sakittenggorokan = A.sakittenggorokan 
			AND nyeri = 'Ringan'
			AND sulitbernafas = 'Parah'
        ) AS 'Flu'
    FROM tblPasien AS A 
	WHERE nyeri = 'Ringan' 
	AND sulitbernafas = 'Parah'
	GROUP BY sakittenggorokan;

UPDATE tblHitung 
SET atribut = 'SAKIT TENGGOROKKAN' 
WHERE atribut IS NULL;
select * from tblHitung;

/*Entropy Iterasi 3*/
UPDATE tblHitung 
SET entropy = (-(diagdemam/jumdata) * log2(diagdemam/jumdata)) + 
(-(diagflu/jumdata) * log2(diagflu/jumdata));

UPDATE tblHitung 
SET entropy = 0 
WHERE entropy IS NULL;

SELECT * FROM tblHitung;

/*GAIN*/
DROP TABLE IF EXISTS tblTampung;
CREATE TEMPORARY TABLE tblTampung
(
    atribut VARCHAR(20),
    gain decimal(8,4)
);

INSERT INTO tblTampung(atribut, gain)
SELECT atribut, @entropy - SUM((jumdata/@jumdata) * entropy) AS GAIN 
FROM tblHitung GROUP BY atribut;

SELECT * FROM tblTampung;

UPDATE tblHitung SET GAIN =
    (
        SELECT gain
        FROM tblTampung
        WHERE atribut = tblHitung.atribut
    );

SELECT * FROM tblHitung;

/*Tabel Kesimpulan*/
DROP TABLE IF EXISTS tblKesimpulan;
CREATE TEMPORARY TABLE tblKesimpulan
(
    atribut VARCHAR(255),
    kesimpulan VARCHAR(255)
);

INSERT INTO tblKesimpulan values 
('Berdasarkan analisis di atas, Gejala = NYERI RINGAN, SULIT BERNAFAS PARAH, HIDUNG TERSUMBAT PARAH', 'Pasien di nyatakan DEMAM');

SELECT * FROM tblKesimpulan;