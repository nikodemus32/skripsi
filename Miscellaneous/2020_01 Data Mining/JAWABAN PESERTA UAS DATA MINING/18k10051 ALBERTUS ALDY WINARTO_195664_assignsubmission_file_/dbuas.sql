drop database if exists dbuas;
create database dbuas;
use dbuas;

create table tbluas
(
nourut int,
demam varchar(10),
sakitkepala varchar(10),
nyeri varchar(10),
lemas varchar(10),
kelelahan varchar(10),
hidungtersumbat varchar(10),
bersin varchar(10),
sakittenggorokan varchar(10),
sulitbernafas varchar(10),
diagnosa varchar(10)
);

LOAD DATA LOCAL INFILE 'dbuas.csv'
INTO TABLE tbluas
FIELDS TERMINATED BY ';'
ENCLOSED BY ''''
IGNORE 1 LINES;

select * from tbluas;

CREATE TABLE tblHitung
(
atribut varchar(20),
informasi varchar(20),
jumlahdata int,
demam varchar(10),
flu varchar(10),
entropy decimal(8,4),
gain decimal(8,4)
);

DESC tblHitung;

/*iterasi 1*/

select COUNT(*) INTO @jumlahdata
FROM tbluas;

SELECT COUNT(*) INTO @demam
FROM tbluas
WHERE diagnosa = 'demam';

SELECT COUNT(*) INTO @flu
FROM tbluas
WHERE diagnosa = 'flu';

SELECT (-(@demam/@jumlahdata) * log2(@demam/@jumlahdata))
+
(-(@flu/@jumlahdata)*log2(@flu/@jumlahdata))
INTO @entropy;

SELECT @jumlahdata AS JUM_DATA,
@demam AS JAWAB_DEMAM,
@flu AS JAWAB_FLU,
ROUND(@entropy, 4) AS ENTROPY;

INSERT INTO tblHitung(atribut, jumlahdata, demam, flu, entropy) VALUES
('TOTAL DATA', @jumlahdata, @demam, @flu, @entropy);

SELECT * FROM tblHitung;

insert into tblHitung(informasi, jumlahdata, demam, flu)
    select A.demam as DEMAM, count(*) as JUMLAH_DATA,
        (
            select count(*) from tbluas as B where B.diagnosa = 'demam' and B.demam = A.demam
        ) as 'DEMAM',
        (
            select count(*) from tbluas as C where C.diagnosa = 'flu' and C.demam = A.demam
        ) as 'FLU'
    from tbluas as A group by A.demam;

update tblHitung SET atribut = 'DEMAM' where atribut is null;

insert into tblHitung(informasi, jumlahdata, demam, flu)
    select A.sakitkepala as SAKITKEPALA, count(*) as JUMLAH_DATA,
        (
            select count(*) from tbluas as B where B.diagnosa = 'demam' and B.sakitkepala = A.sakitkepala
        ) as 'DEMAM',
        (
            select count(*) from tbluas as C where C.diagnosa = 'flu' and C.sakitkepala = A.sakitkepala
        ) as 'FLU'
    from tbluas as A group by A.sakitkepala;

update tblHitung SET atribut = 'SAKITKEPALA' where atribut is null;

insert into tblHitung(informasi, jumlahdata, demam, flu)
    select A.nyeri as NYERI, count(*) as JUMLAH_DATA,
        (
            select count(*) from tbluas as B where B.diagnosa = 'demam' and B.nyeri = A.nyeri
        ) as 'DEMAM',
        (
            select count(*) from tbluas as C where C.diagnosa = 'flu' and C.nyeri = A.nyeri
        ) as 'FLU'
    from tbluas as A group by A.nyeri;

update tblHitung SET atribut = 'NYERI' where atribut is null;

insert into tblHitung(informasi, jumlahdata, demam, flu)
    select A.lemas as LEMAS, count(*) as JUMLAH_DATA,
        (
            select count(*) from tbluas as B where B.diagnosa = 'demam' and B.lemas = A.lemas
        ) as 'DEMAM',
        (
            select count(*) from tbluas as C where C.diagnosa = 'flu' and C.lemas = A.lemas
        ) as 'FLU'
    from tbluas as A group by A.lemas;

update tblHitung SET atribut = 'LEMAS' where atribut is null;

insert into tblHitung(informasi, jumlahdata, demam, flu)
    select A.kelelahan as KELELAHAN, count(*) as JUMLAH_DATA,
        (
            select count(*) from tbluas as B where B.diagnosa = 'demam' and B.kelelahan = A.kelelahan
        ) as 'DEMAM',
        (
            select count(*) from tbluas as C where C.diagnosa = 'flu' and C.kelelahan = A.kelelahan
        ) as 'FLU'
    from tbluas as A group by A.kelelahan;

update tblHitung SET atribut = 'KELELAHAN' where atribut is null;

insert into tblHitung(informasi, jumlahdata, demam, flu)
    select A.hidungtersumbat as HIDUNGTERSUMBAT, count(*) as JUMLAH_DATA,
        (
            select count(*) from tbluas as B where B.diagnosa = 'demam' and B.hidungtersumbat = A.hidungtersumbat
        ) as 'DEMAM',
        (
            select count(*) from tbluas as C where C.diagnosa = 'flu' and C.hidungtersumbat = A.hidungtersumbat
        ) as 'FLU'
    from tbluas as A group by A.hidungtersumbat;

update tblHitung SET atribut = 'HIDUNGTERSUMBAT' where atribut is null;

insert into tblHitung(informasi, jumlahdata, demam, flu)
    select A.bersin as BERSIN, count(*) as JUMLAH_DATA,
        (
            select count(*) from tbluas as B where B.diagnosa = 'demam' and B.bersin = A.bersin
        ) as 'DEMAM',
        (
            select count(*) from tbluas as C where C.diagnosa = 'flu' and C.bersin = A.bersin
        ) as 'FLU'
    from tbluas as A group by A.bersin;

update tblHitung SET atribut = 'BERSIN' where atribut is null;

insert into tblHitung(informasi, jumlahdata, demam, flu)
    select A.sakittenggorokan as SAKITTENGGOROKAN, count(*) as JUMLAH_DATA,
        (
            select count(*) from tbluas as B where B.diagnosa = 'demam' and B.sakittenggorokan = A.sakittenggorokan
        ) as 'DEMAM',
        (
            select count(*) from tbluas as C where C.diagnosa = 'flu' and C.sakittenggorokan = A.sakittenggorokan
        ) as 'FLU'
    from tbluas as A group by A.sakittenggorokan;

update tblHitung SET atribut = 'SAKITTENGGOROKAN' where atribut is null;

insert into tblHitung(informasi, jumlahdata, demam, flu)
    select A.sulitbernafas as SULITBERNAFAS, count(*) as JUMLAH_DATA,
        (
            select count(*) from tbluas as B where B.diagnosa = 'demam' and B.sulitbernafas = A.sulitbernafas
        ) as 'DEMAM',
        (
            select count(*) from tbluas as C where C.diagnosa = 'flu' and C.sulitbernafas = A.sulitbernafas
        ) as 'FLU'
    from tbluas as A group by A.sulitbernafas;

update tblHitung SET atribut = 'SULITBERNAFAS' where atribut is null;

update tblHitung SET entropy = (-(demam/jumlahdata) * log2(demam/jumlahdata)) + (-(flu/jumlahdata) * log2(flu/jumlahdata)) where demam <> 0 and flu <> 0;

update tblHitung SET entropy = 0 where entropy IS NULL;

select * from tblHitung;

DROP TABLE IF EXISTS tblTampung;
CREATE TEMPORARY TABLE tblTampung
(
atribut VARCHAR(20),
gain DECIMAL(8, 4)
);

INSERT INTO tblTampung(atribut, gain)
SELECT atribut, @entropy - 
SUM((jumlahdata/@jumlahdata) * entropy) AS GAIN
FROM tblHitung
GROUP BY atribut;

SELECT * FROM tblTampung;

UPDATE tblHitung SET GAIN = 
	(
	SELECT gain
	FROM tblTampung
	WHERE atribut = tblHitung.atribut
	);

SELECT * FROM tblHitung;
