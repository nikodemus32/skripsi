DROP DATABASE IF EXISTS c45uas;
CREATE DATABASE c45uas;
USE c45uas;

CREATE TABLE tblC45
(
nourut VARCHAR(10),
demam VARCHAR(10),
sakitkepala VARCHAR(10),
nyeri VARCHAR(10),
lemas VARCHAR(10),
kelelahan VARCHAR(10),
hidungtersumbat VARCHAR(10),
bersin VARCHAR(10),
sakitternggorokan VARCHAR(10),
sulitbernafas VARCHAR(10),
diagnosa VARCHAR(10)
);


/* LOAD DATA LOCAL INFILE 'c45uas.csv'
INTO TABLE tblC45
FIELDS TERMINATED BY ';'
ENCLOSED BY ''''
IGNORE 1 LINES; */

INSERT into tblC45 VALUES
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

SELECT * FROM tblC45;

/*LANGKAH 2: buat tabel untuk menampung hasil hitungan*/
CREATE TABLE tblHitung
(
atribut VARCHAR(20),
informasi VARCHAR(20),
jumlahdata INT,
playdemam INT,
playflu INT,
entropy DECIMAL(8,4),
gain DECIMAL(8,4)
);

DESC tblHitung;

SELECT COUNT(*) INTO @jumlahdata
FROM tblC45;

SELECT COUNT(*) INTO @playdemam
FROM tblC45
WHERE diagnosa = 'demam';

SELECT COUNT(*) INTO @playflu
FROM tblC45
WHERE diagnosa = 'flu';

SELECT (-(@playdemam/@jumlahdata) * log2(@playdemam/@jumlahdata))
+
(-(@playflu/@jumlahdata)*log2(@playflu/@jumlahdata))
INTO @entropy;

SELECT @jumlahdata AS JUM_DATA,
@playdemam AS JAWAB_DEMAM,
@playflu AS JAWAB_FLU,
ROUND(@entropy, 9) AS ENTROPY;

INSERT INTO tblHitung(atribut, jumlahdata, playdemam, playflu, entropy) VALUES
('TOTAL DATA', @jumlahdata, @playdemam, @playflu, @entropy);

SELECT * FROM tblHitung;

/*LANGKAH 3: melakukan proses untuk setiap atribut*/
/*DEMAM*/
INSERT INTO tblHitung(informasi, jumlahdata, playdemam, playflu)
	SELECT A.demam AS DEMAM, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.diagnosa = 'demam' 
		AND B.demam = A.demam
		) AS 'DEMAM',
	
		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.diagnosa = 'flu' 
		AND C.demam = A.demam
		) AS 'FLU'
	FROM tblC45 AS A
	GROUP BY A.demam;

UPDATE tblHitung SET atribut = 'DEMAM' WHERE atribut IS NULL;

/*SAKIT KEPALA*/
INSERT INTO tblHitung(informasi, jumlahdata, playdemam, playflu)
	SELECT A.sakitkepala AS SAKITKEPALA, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.diagnosa = 'demam' 
		AND B.sakitkepala = A.sakitkepala
		) AS 'DEMAM',
	
		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.diagnosa = 'flu' 
		AND C.sakitkepala = A.sakitkepala
		) AS 'FLU'
	FROM tblC45 AS A
	GROUP BY A.sakitkepala;

UPDATE tblHitung SET atribut = 'SAKITKEPALA' WHERE atribut IS NULL;

/*NYERI*/
INSERT INTO tblHitung(informasi, jumlahdata, playdemam, playflu)
	SELECT A.nyeri AS NYERI, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.diagnosa = 'demam' 
		AND B.nyeri = A.nyeri
		) AS 'DEMAM',
	
		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.diagnosa = 'flu' 
		AND C.nyeri = A.nyeri
		) AS 'FLU'
	FROM tblC45 AS A
	GROUP BY A.nyeri;

UPDATE tblHitung SET atribut = 'NYERI' WHERE atribut IS NULL;

/*LEMAS*/
INSERT INTO tblHitung(informasi, jumlahdata, playdemam, playflu)
	SELECT A.lemas AS LEMAS, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.diagnosa = 'demam' 
		AND B.lemas = A.lemas
		) AS 'DEMAM',
	
		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.diagnosa = 'flu' 
		AND C.lemas = A.lemas
		) AS 'FLU'
	FROM tblC45 AS A
	GROUP BY A.lemas;

UPDATE tblHitung SET atribut = 'LEMAS' WHERE atribut IS NULL;

/*KELELAHAN*/
INSERT INTO tblHitung(informasi, jumlahdata, playdemam, playflu)
	SELECT A.kelelahan AS KELELAHAN, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.diagnosa = 'demam' 
		AND B.kelelahan = A.kelelahan
		) AS 'DEMAM',
	
		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.diagnosa = 'flu' 
		AND C.kelelahan = A.kelelahan
		) AS 'FLU'
	FROM tblC45 AS A
	GROUP BY A.kelelahan;

UPDATE tblHitung SET atribut = 'KELELAHAN' WHERE atribut IS NULL;

/*HIDUNG TERSUMBAT*/
INSERT INTO tblHitung(informasi, jumlahdata, playdemam, playflu)
	SELECT A.hidungtersumbat AS HIDUNGTERSUMBAT, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.diagnosa = 'demam' 
		AND B.hidungtersumbat = A.hidungtersumbat
		) AS 'DEMAM',
	
		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.diagnosa = 'flu' 
		AND C.hidungtersumbat = A.hidungtersumbat
		) AS 'FLU'
	FROM tblC45 AS A
	GROUP BY A.hidungtersumbat;

UPDATE tblHitung SET atribut = 'HIDUNGTERSUMBAT' WHERE atribut IS NULL;

/*BERSIN*/
INSERT INTO tblHitung(informasi, jumlahdata, playdemam, playflu)
	SELECT A.bersin AS BERSIN, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.diagnosa = 'demam' 
		AND B.bersin = A.bersin
		) AS 'DEMAM',
	
		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.diagnosa = 'flu' 
		AND C.bersin = A.bersin
		) AS 'FLU'
	FROM tblC45 AS A
	GROUP BY A.bersin;

UPDATE tblHitung SET atribut = 'BERSIN' WHERE atribut IS NULL;

/*SAKIT TENGGOROKAN*/
INSERT INTO tblHitung(informasi, jumlahdata, playdemam, playflu)
	SELECT A.sakitternggorokan AS SAKITTENGGOROKAN, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.diagnosa = 'demam' 
		AND B.sakitternggorokan = A.sakitternggorokan
		) AS 'DEMAM',
	
		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.diagnosa = 'flu' 
		AND C.sakitternggorokan = A.sakitternggorokan
		) AS 'FLU'
	FROM tblC45 AS A
	GROUP BY A.sakitternggorokan;

UPDATE tblHitung SET atribut = 'SAKITTENGGOROKAN' WHERE atribut IS NULL;

/*SULIT BERNAFAS*/
INSERT INTO tblHitung(informasi, jumlahdata, playdemam, playflu)
	SELECT A.sulitbernafas AS SULITBERNAFAS, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.diagnosa = 'demam' 
		AND B.sulitbernafas = A.sulitbernafas
		) AS 'DEMAM',
	
		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.diagnosa = 'flu' 
		AND C.sulitbernafas = A.sulitbernafas
		) AS 'FLU'
	FROM tblC45 AS A
	GROUP BY A.sulitbernafas;

UPDATE tblHitung SET atribut = 'SULITBERNAFAS' WHERE atribut IS NULL;


/*LANGKAH 4: menghitung entropy*/
UPDATE tblHitung SET entropy = (-(playdemam/jumlahdata) * log2(playdemam/jumlahdata))
+
(-(playflu/jumlahdata) * log2(playflu/jumlahdata));

UPDATE tblHitung SET entropy = 0 WHERE entropy IS NULL;

SELECT * FROM tblHitung;

/*LANGKAH 5: menghitung nilai gain*/
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