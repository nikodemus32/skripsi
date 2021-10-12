DROP DATABASE IF EXISTS dbUAS;
CREATE DATABASE dbUAS;
USE dbUAS;

CREATE TABLE tblData
(
  No Pasien VARCHAR(25),
  Demam VARCHAR(25),
  Sakit Kepala VARCHAR(25),
  Nyeri VARCHAR(25),
  Lemas VARCHAR(25),
  Kelelahan VARCHAR(25),
  Hidung Tersumbat VARCHAR(25),
  Bersin VARCHAR(25),
  Sakit Tenggorokan VARCHAR(25),
  Sulit Bernafas VARCHAR(25),
  Diagnosa VARCHAR(25)
);

LOAD DATA LOCAL INFILE 'C:\Users\Eleazer\Desktop\dbC45.csv'
INTO TABLE tblData
FIELDS TERMINATED BY ','
ENCLOSED BY ''''
IGNORE 1 LINES;

SELECT * FROM tblData;

CREATE TABLE tblHitungan(
  atribut VARCHAR(20),
  informasi VARCHAR(20),
  jumlahdata INT,
  diagnosademam INT,
  diagnosaflu INT,
  entropy DECIMAL(8,4),
  gain DECIMAL(8,4)
);
DESC tblHitungan;

SELECT COUNT(*) INTO @jumlahdata
FROM tblData;

SELECT COUNT(*) INTO @diagnosademam
FROM tblData WHERE diagnosa = 'demam';

SELECT COUNT(*) INTO @diagnosaflu
FROM tblData WHERE diagnosa = 'flu';

SELECT (-(@diagnosademam/@jumlahdata) * log2(@diagnosademam/@jumlahdata)) + (-(@diagnosaflu/@jumlahdata)*log2(@diagnosaflu/@jumlahdata))
INTO @entropy;

SELECT @jumlahdata AS JUM_DATA,
@diagnosademam AS JAWAB_NO,
@diagnosaflu AS JAWAB_YES,
ROUND(@entropy, 4) AS ENTROPY;

INSERT INTO tblHitungan(atribut, jumlahdata, diagnosademam, diagnosaflu, entropy) VALUES
('TOTAL DATA', @jumlahdata, @diagnosademam, @diagnosaflu, @entropy);

SELECT * FROM tblHitungan;
INSERT INTO tblHitungan(informasi, jumlahdata, diagnosademam, diagnosaflu)
	SELECT A.lemas AS LEMAS, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblData AS B
		WHERE B.diagnosa = 'demam' AND B.lemas = A.lemas
    )
    AS 'demam',
		(
		SELECT COUNT(*)
		FROM tblData AS C
		WHERE C.diagnosa = 'flu' AND C.lemas = A.lemas
    )
    AS 'flu'
	FROM tblData AS A
	GROUP BY A.lemas;

UPDATE tblHitungan SET atribut = 'WINDY' WHERE atribut IS NULL;

INSERT INTO tblHitungan(informasi, jumlahdata, diagnosademam, diagnosaflu)
	SELECT A.sakitkepala AS SAKITKEPALA, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblData AS B
		WHERE B.diagnosa = 'demam' AND B.sakitkepala = A.sakitkepala
		) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblData AS C
		WHERE C.diagnosa = 'flu' AND C.sakitkepala = A.sakitkepala
		) AS 'FLU'
	FROM tblData AS A
	GROUP BY A.sakitkepala;

UPDATE tblHitungan SET atribut = 'SAKITKEPALA' WHERE atribut IS NULL;

INSERT INTO tblHitungan(informasi, jumlahdata, diagnosademam, diagnosaflu)
	SELECT A.nyeri AS NYERI, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblData AS B
		WHERE B.diagnosa = 'demam' AND B.nyeri = A.nyeri
    )
    AS 'demam',
		(
		SELECT COUNT(*)
		FROM tblData AS C
		WHERE C.diagnosa = 'flu' AND C.nyeri = A.nyeri
    )
    AS 'flu'
	FROM tblData AS A
	GROUP BY A.nyeri;

UPDATE tblHitungan SET atribut = 'NYERI' WHERE atribut IS NULL;

INSERT INTO tblHitungan(informasi, jumlahdata, diagnosademam, diagnosaflu)
	SELECT A.demam AS DEMAM, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblData AS B
		WHERE B.diagnosa = 'demam' AND B.demam = A.demam
    )
    AS 'demam',
    (
		SELECT COUNT(*)
		FROM tblData AS C
		WHERE C.diagnosa = 'flu' AND C.demam = A.demam
    )
    AS 'flu'
	FROM tblData AS A
	GROUP BY A.demam;

UPDATE tblHitungan SET atribut = 'DEMAM' WHERE atribut IS NULL;
UPDATE tblHitungan SET entropy = (-(diagnosademam/jumlahdata) * log2(diagnosademam/jumlahdata)) + (-(diagnosaflu/jumlahdata) * log2(diagnosaflu/jumlahdata));
UPDATE tblHitungan SET entropy = 0 WHERE entropy IS NULL;
SELECT * FROM tblHitungan;

DROP TABLE IF EXISTS tblSementara;
CREATE TEMPORARY TABLE tblSementara(
  atribut VARCHAR(20),
  gain DECIMAL(4, 8)
);

INSERT INTO tblSementara(atribut, gain)
SELECT atribut, @entropy -
SUM((jumlahdata/@jumlahdata) * entropy) AS GAIN
FROM tblHitungan GROUP BY atribut;
SELECT * FROM tblSementara;

UPDATE tblHitungan SET GAIN =(
	SELECT gain
	FROM tblSementara WHERE atribut = tblHitungan.atribut
	);
SELECT * FROM tblHitungan;
