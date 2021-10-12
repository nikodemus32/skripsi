/*1*/
DROP DATABASE IF EXISTS dbUAS_18K10058;
CREATE DATABASE dbUAS_18K10058;
USE dbUAS_18K10058;

CREATE TABLE tblC45
(
nopasien VARCHAR(10),
demam VARCHAR(10),
sakitkepala VARCHAR(10),
nyeri VARCHAR(10),
lemas VARCHAR(10),
kelelahan VARCHAR(10),
hidungtersumbat VARCHAR(10),
bersin VARCHAR(10),
sakittenggorokan VARCHAR(10),
sulitbernafas VARCHAR(10),
diagnosa VARCHAR(10)
);

LOAD DATA LOCAL INFILE 'UAS.csv'
INTO TABLE tblC45
FIELDS TERMINATED BY ','
ENCLOSED BY ''''
IGNORE 1 LINES;

SELECT * FROM tblC45;

/*2*/
CREATE TABLE tblHitung
(
atribut VARCHAR(20),
informasi VARCHAR(20),
jumlahdata INT,
diagnosademam INT,
diagnosaflu INT,
entropy DECIMAL(8,4),
gain DECIMAL(8,4)
);
DESC tblHitung;
SELECT COUNT(*) INTO @jumlahdata
FROM tblC45;
SELECT COUNT(*) INTO @diagnosademam
FROM tblC45
WHERE diagnosa = 'demam';
SELECT COUNT(*) INTO @diagnosaflu
FROM tblC45
WHERE diagnosa = 'flu';
SELECT (-(@diagnosademam/@jumlahdata) * log2(@diagnosademam/@jumlahdata))
+
(-(@diagnosaflu/@jumlahdata)*log2(@diagnosaflu/@jumlahdata))
INTO @entropy;

SELECT @jumlahdata AS JUM_DATA,
@diagnosademam AS JAWAB_NO,
@diagnosaflu AS JAWAB_YES,
ROUND(@entropy, 4) AS ENTROPY;

INSERT INTO tblHitung(atribut, jumlahdata, diagnosademam, diagnosaflu, entropy) VALUES
('TOTAL DATA', @jumlahdata, @diagnosademam, @diagnosaflu, @entropy);

SELECT * FROM tblHitung;

/*3*/
/*DEMAM*/
INSERT INTO tblHitung(informasi, jumlahdata, diagnosademam, diagnosaflu)
	SELECT A.demam AS DEMAM, COUNT(*) AS JUMLAH_DATA,
	(
	SELECT COUNT(*)
	FROM tblC45 AS B
	WHERE B.diagnosa = 'demam' AND B.demam = A.demam
	) AS 'DEMAM',

	(
	SELECT COUNT(*)
	FROM tblC45 AS C
	WHERE C.diagnosa = 'flu' AND C.demam = A.demam
	) AS 'FLU'
	FROM tblC45 AS A
	GROUP BY A.demam;

UPDATE tblHitung SET atribut = 'DEMAM' WHERE atribut IS NULL;

/*SAKITKEPALA*/
INSERT INTO tblHitung(informasi, jumlahdata, diagnosademam, diagnosaflu)
	SELECT A.sakitkepala AS SAKITKEPALA, COUNT(*) AS JUMLAH_DATA,
	(
	SELECT COUNT(*)
	FROM tblC45 AS B
	WHERE B.diagnosa = 'demam' AND B.sakitkepala = A.sakitkepala
	) AS 'DEMAM',
	
	(
	SELECT COUNT(*)
	FROM tblC45 AS C
	WHERE C.diagnosa = 'flu' AND C.sakitkepala = A.sakitkepala
	) AS 'FLU'
	FROM tblC45 AS A
	GROUP BY A.sakitkepala;

UPDATE tblHitung SET atribut = 'SAKITKEPALA' WHERE atribut IS NULL;

/*NYERI*/
INSERT INTO tblHitung(informasi, jumlahdata, diagnosademam, diagnosaflu)
	SELECT A.nyeri AS NYERI, COUNT(*) AS JUMLAH_DATA,
	(
	SELECT COUNT(*)
	FROM tblC45 AS B
	WHERE B.diagnosa = 'demam' AND B.nyeri = A.nyeri
	) AS 'DEMAM',
	
	(
	SELECT COUNT(*)
	FROM tblC45 AS C
	WHERE C.diagnosa = 'flu' AND C.nyeri = A.nyeri
	) AS 'FLU'
	FROM tblC45 AS A
	GROUP BY A.nyeri;

UPDATE tblHitung SET atribut = 'NYERI' WHERE atribut IS NULL;

/*LEMAS*/
INSERT INTO tblHitung(informasi, jumlahdata, diagnosademam, diagnosaflu)
	SELECT A.lemas AS LEMAS, COUNT(*) AS JUMLAH_DATA,
	(
	SELECT COUNT(*)
	FROM tblC45 AS B
	WHERE B.diagnosa = 'demam' AND B.lemas = A.lemas
	) AS 'DEMAM',
	(
	SELECT COUNT(*)
	FROM tblC45 AS C
	WHERE C.diagnosa = 'flu' AND C.lemas = A.lemas
	) AS 'FLU'
	FROM tblC45 AS A
	GROUP BY A.lemas;

UPDATE tblHitung SET atribut = 'LEMAS' WHERE atribut IS NULL;

/*4*/
UPDATE tblHitung SET entropy = (-(diagnosademam/jumlahdata) * log2(diagnosademam/jumlahdata))+
(-(diagnosaflu/jumlahdata) * log2(diagnosaflu/jumlahdata));
UPDATE tblHitung SET entropy = 0 WHERE entropy IS NULL;
SELECT * FROM tblHitung;

/*5*/
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
