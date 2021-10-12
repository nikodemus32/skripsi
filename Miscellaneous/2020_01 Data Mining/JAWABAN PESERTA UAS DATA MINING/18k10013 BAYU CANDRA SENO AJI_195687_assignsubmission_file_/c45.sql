/*LANGKAH 1: siapkan database dan data2 nya*/
DROP DATABASE IF EXISTS dbC45;
CREATE DATABASE dbC45;
USE dbC45;

CREATE TABLE tblC45
(
nourut INT,
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

INSERT INTO tblC45 VALUES
('P1', 'Tidak', 'Ringan', 'Tidak', 'Tidak', 'Tidak', 'Ringan', 'Parah', 'Parah', 'Ringan', 'Demam'),
('P2', 'Parah', 'Parah', 'Parah', 'Parah', 'Parah', 'Tidak', 'Tidak', 'Parah', 'Parah', 'Flu'),
('P3', 'Parah', 'Parah', 'Ringan', 'Parah', 'Parah', 'Parah', 'Tidak', 'Parah', 'Parah', 'Flu'),
('P4', 'Tidak', 'Tidak', 'Tidak', 'Ringan', 'Tidak', 'Parah', 'Tidak', 'Ringan', 'Ringan', 'Demam'),
('P5', 'Parah', 'Parah', 'Ringan', 'Parah', 'Parah', 'Parah', 'Tidak', 'Parah', 'Parah', 'Flu'),
('P6', 'Tidak', 'Tidak', 'Tidak', 'Ringan', 'Tidak', 'Parah', 'Parah', 'Parah', 'Tidak', 'Demam'),
('P7', 'Parah', 'Parah', 'Parah', 'Parah', 'Parah', 'Tidak', 'Tidak', 'Tidak', 'Parah', 'Flu'),
('P8', 'Tidak', 'Tidak', 'Tidak', 'Tidak', 'Tidak', 'Parah', 'Parah', 'Tidak', 'Ringan', 'Demam'),
('P9', 'Tidak', 'Ringan', 'Ringan', 'Tidak', 'Tidak', 'Parah', 'Parah', 'Parah', 'Parah', 'Demam'),
('P10', 'Parah', 'Parah', 'Parah', 'Ringan', 'Ringan', 'Tidak', 'Parah', 'Tidak', 'Parah', 'Flu'),
('P11', 'Tidak', 'Tidak', 'Tidak', 'Ringan', 'Tidak', 'Parah', 'Ringan', 'Parah', 'Tidak', 'Demam'),
('P12', 'Parah', 'Ringan', 'Parah', 'Ringan', 'Parah', 'Tidak', 'Parah', 'Tidak', 'Ringan', 'Flu'),
('P13', 'Tidak', 'Tidak', 'Ringan', 'Ringan', 'Tidak', 'Parah', 'Parah', 'Parah', 'Tidak', 'Demam'),
('P14', 'Parah', 'Parah', 'Parah', 'Parah', 'Ringan', 'Tidak', 'Parah', 'Parah', 'Parah', 'Flu'),
('P15', 'Ringan', 'Tidak', 'Tidak', 'Ringan', 'Tidak', 'Parah', 'Tidak', 'Parah', 'Ringan', 'Demam'),
('P16', 'Tidak', 'Tidak', 'Tidak', 'Tidak', 'Tidak', 'Parah', 'Parah', 'Parah', 'Parah', 'Demam'),
('P17', 'Parah', 'Ringan', 'Parah', 'Ringan', 'Ringan', 'Tidak', 'Tidak', 'Tidak', 'Parah', 'Flu');

SELECT * FROM tblC45;

/*LANGKAH 2: buat tabel untuk menampung hasil hitungan*/
CREATE TABLE tblHitung
(
atribut VARCHAR(20),
informasi VARCHAR(20),
jumlahdata INT,
demam INT,
flu INT,
entropy DECIMAL(8,4),
gain DECIMAL(8,4)
);

DESC tblHitung;

SELECT COUNT(*) INTO @jumlahdata
FROM tblC45;

SELECT COUNT(*) INTO @demam
FROM tblC45
WHERE diagnosa = 'demam';

SELECT COUNT(*) INTO @flu
FROM tblC45
WHERE diagnosa = 'flu';

SELECT (-(@demam/@jumlahdata) * log2(@demam/@jumlahdata))
+
(-(@flu/@jumlahdata)*log2(@flu/@jumlahdata))
INTO @entropy;

SELECT @jumlahdata AS JUM_DATA,
@demam AS DEMAM,
@flu AS FLU,
ROUND(@entropy, 4) AS ENTROPY;

INSERT INTO tblHitung(atribut, jumlahdata, demam, flu, entropy) VALUES
('TOTAL DATA', @jumlahdata, @demam, @flu, @entropy);

SELECT * FROM tblHitung;

/*LANGKAH 3: melakukan proses untuk setiap atribut*/
/*OUTLOOK*/
INSERT INTO tblHitung(informasi, jumlahdata, demam, flu)
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

/*TEMPERATURE*/
INSERT INTO tblHitung(informasi, jumlahdata, demam, flu)
	SELECT A.sakitkepala AS SAKITKEPALA, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.diagnosa = 'demam' AND B.sakitkepala = A.sakitkepala
	) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.diagnosa = 'demam' AND C.sakitkepala = A.sakitkepala
	) AS 'FLU'
	FROM tblC45 AS A
	GROUP BY A.sakitkepala;

UPDATE tblHitung SET atribut = 'SAKIT KEPALA' WHERE atribut IS NULL;

/*HUMADITY*/
INSERT INTO tblHitung(informasi, jumlahdata, demam, flu)
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

/*WINDY*/
INSERT INTO tblHitung(informasi, jumlahdata, demam, flu)
	SELECT A.lemas AS WINDY, COUNT(*) AS JUMLAH_DATA,
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

/*WINDY*/
INSERT INTO tblHitung(informasi, jumlahdata, demam, flu)
	SELECT A.kelelahan AS KELELAHAN, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.diagnosa = 'demam' AND B.kelelahan = A.kelelahan
	) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.diagnosa = 'flu' AND C.kelelahan = A.kelelahan
	) AS 'FLU'
	FROM tblC45 AS A
	GROUP BY A.kelelahan;

UPDATE tblHitung SET atribut = 'KELELAHAN' WHERE atribut IS NULL;

/*WINDY*/
INSERT INTO tblHitung(informasi, jumlahdata, demam, flu)
	SELECT A.hidungtersumbat AS HIDUNGTERSUMBAT, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.diagnosa = 'demam' AND B.hidungtersumbat = A.hidungtersumbat
	) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.diagnosa = 'flu' AND C.hidungtersumbat = A.hidungtersumbat
	) AS 'FLU'
	FROM tblC45 AS A
	GROUP BY A.hidungtersumbat;

UPDATE tblHitung SET atribut = 'HIDUNGTERSUMBAT' WHERE atribut IS NULL;

/*WINDY*/
INSERT INTO tblHitung(informasi, jumlahdata, demam, flu)
	SELECT A.bersin AS BERSIN, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.diagnosa = 'demam' AND B.bersin = A.bersin
	) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.diagnosa = 'flu' AND C.bersin = A.bersin
	) AS 'FLU'
	FROM tblC45 AS A
	GROUP BY A.bersin;

UPDATE tblHitung SET atribut = 'BERSIN' WHERE atribut IS NULL;

/*WINDY*/
INSERT INTO tblHitung(informasi, jumlahdata, demam, flu)
	SELECT A.sakittenggorokan AS SAKITTENGGOROKAN, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.diagnosa = 'demam' AND B.sakittenggorokan = A.sakittenggorokan
	) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.diagnosa = 'flu' AND C.sakittenggorokan = A.sakittenggorokan
	) AS 'FLU'
	FROM tblC45 AS A
	GROUP BY A.sakittenggorokan;

UPDATE tblHitung SET atribut = 'SAKITTENGGOROKAN' WHERE atribut IS NULL;

/*WINDY*/
INSERT INTO tblHitung(informasi, jumlahdata, demam, flu)
	SELECT A.sulitbernafas AS SULITBERNAFAS, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.diagnosa = 'demam' AND B.sulitbernafas = A.sulitbernafas
	) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.diagnosa = 'flu' AND C.sulitbernafas = A.sulitbernafas
	) AS 'FLU'
	FROM tblC45 AS A
	GROUP BY A.sulitbernafas;

UPDATE tblHitung SET atribut = 'SULITBERNAFAS' WHERE atribut IS NULL;

/*LANGKAH 4: menghitung entropy*/
UPDATE tblHitung SET entropy = (-(demam/jumlahdata) * log2(demam/jumlahdata))
+
(-(flu/jumlahdata) * log2(flu/jumlahdata));

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

#iterasi2
SELECT MAX(tblHitung.gain) AS
maximal
FROM tblHitung;

CREATE TABLE tblHitung1
(
atribut VARCHAR(20),
informasi VARCHAR(20),
jumlahdata INT,
demam INT,
flu INT,
entropy DECIMAL(8,4),
gain DECIMAL(8,4)
);

SELECT COUNT(*) INTO @sakittenggorokantidakjumlahdata
FROM tblC45
WHERE sakittenggorokan = 'tidak';

SELECT COUNT(*) INTO @sakittenggorokantidakdemam
FROM tblC45
WHERE sakittenggorokan = 'tidak' AND diagnosa = 'demam';

SELECT COUNT(*) INTO @sakittenggorokantidakflu
FROM tblC45
WHERE sakittenggorokan = 'tidak' AND diagnosa = 'flu';

SELECT (-(@sakittenggorokantidakdemam/@sakittenggorokantidakjumlahdata) * log2(@sakittenggorokantidakdemam/@sakittenggorokantidakjumlahdata))
+
(-(@sakittenggorokantidakflu/@sakittenggorokantidakjumlahdata)*log2(@sakittenggorokantidakflu/@sakittenggorokantidakjumlahdata))
INTO @sakittenggorokantidakentropy;

SELECT @sakittenggorokantidakjumlahdata AS JUM_DATA,
@sakittenggorokantidakdemam AS DEMAM,
@sakittenggorokantidakflu AS FLU,
ROUND(@sakittenggorokantidakentropy, 4) AS ENTROPY;

INSERT INTO tblHitung1(atribut, jumlahdata, demam, flu, entropy) VALUES
('SAKIT TENGGOROKAN', @sakittenggorokantidakjumlahdata, @sakittenggorokantidakdemam, @sakittenggorokantidakflu, @sakittenggorokantidakentropy);

SELECT * FROM tblHitung1;

#outlook
INSERT INTO tblHitung1(informasi, jumlahdata, demam, flu)
	SELECT A.demam AS DEMAM, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.diagnosa = 'demam' AND B.demam = A.demam AND B.sakittenggorokan = 'tidak'
	) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.diagnosa = 'flu' AND C.demam = A.demam AND C.sakittenggorokan = 'tidak'
	) AS 'FLU'
	FROM tblC45 AS A
	WHERE A.sakittenggorokan = 'tidak'
	GROUP BY A.demam;

UPDATE tblHitung1 SET atribut = 'DEMAM' WHERE atribut IS NULL;

#temperature
INSERT INTO tblHitung1(informasi, jumlahdata, demam, flu)
	SELECT A.sakitkepala AS SAKITKEPALA, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.diagnosa = 'demam' AND B.sakitkepala = A.sakitkepala AND B.sakittenggorokan = 'tidak'
	) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.diagnosa = 'flu' AND C.sakitkepala = A.sakitkepala AND C.sakittenggorokan = 'tidak'
	) AS 'FLU'
	FROM tblC45 AS A
  WHERE A.sakittenggorokan = 'tidak'
	GROUP BY A.sakitkepala;

UPDATE tblHitung1 SET atribut = 'SAKITKEPALA' WHERE atribut IS NULL;

/*WINDY*/
INSERT INTO tblHitung1(informasi, jumlahdata, demam, flu)
	SELECT A.NYERI AS NYERI, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.diagnosa = 'demam' AND B.nyeri = A.nyeri AND B.sakittenggorokan = 'tidak'
	) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.diagnosa = 'flu' AND C.nyeri = A.nyeri AND C.sakittenggorokan = 'tidak'
	) AS 'FLU'
	FROM tblC45 AS A
	WHERE A.sakittenggorokan = 'tidak'
	GROUP BY A.nyeri;

UPDATE tblHitung1 SET atribut = 'NYERI' WHERE atribut IS NULL;

INSERT INTO tblHitung1(informasi, jumlahdata, demam, flu)
	SELECT A.lemas AS LEMAS, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.diagnosa = 'demam' AND B.lemas = A.lemas AND B.sakittenggorokan = 'tidak'
	) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.diagnosa = 'flu' AND C.lemas = A.lemas AND C.sakittenggorokan = 'tidak'
	) AS 'FLU'
	FROM tblC45 AS A
	WHERE A.sakittenggorokan = 'tidak'
	GROUP BY A.lemas;

UPDATE tblHitung1 SET atribut = 'LEMAS' WHERE atribut IS NULL;

INSERT INTO tblHitung1(informasi, jumlahdata, demam, flu)
	SELECT A.kelelahan AS KELELAHAN, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.diagnosa = 'demam' AND B.kelelahan = A.kelelahan AND B.sakittenggorokan = 'tidak'
	) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.diagnosa = 'flu' AND C.kelelahan = A.kelelahan AND C.sakittenggorokan = 'tidak'
	) AS 'FLU'
	FROM tblC45 AS A
	WHERE A.sakittenggorokan = 'tidak'
	GROUP BY A.kelelahan;

UPDATE tblHitung1 SET atribut = 'KELELAHAN' WHERE atribut IS NULL;

INSERT INTO tblHitung1(informasi, jumlahdata, demam, flu)
	SELECT A.hidungtersumbat AS HIDUNGTERSUMBAT, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.diagnosa = 'demam' AND B.hidungtersumbat = A.hidungtersumbat AND B.sakittenggorokan = 'tidak'
	) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.diagnosa = 'flu' AND C.hidungtersumbat = A.hidungtersumbat AND C.sakittenggorokan = 'tidak'
	) AS 'FLU'
	FROM tblC45 AS A
	WHERE A.sakittenggorokan = 'tidak'
	GROUP BY A.hidungtersumbat;

UPDATE tblHitung1 SET atribut = 'HIDUNGTERSUMBAT' WHERE atribut IS NULL;

INSERT INTO tblHitung1(informasi, jumlahdata, demam, flu)
	SELECT A.bersin AS BERSIN, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.diagnosa = 'demam' AND B.bersin = A.bersin AND B.sakittenggorokan = 'tidak'
	) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.diagnosa = 'flu' AND C.bersin = A.bersin AND C.sakittenggorokan = 'tidak'
	) AS 'FLU'
	FROM tblC45 AS A
	WHERE A.sakittenggorokan = 'tidak'
	GROUP BY A.bersin;

UPDATE tblHitung1 SET atribut = 'BERSIN' WHERE atribut IS NULL;

INSERT INTO tblHitung1(informasi, jumlahdata, demam, flu)
	SELECT A.sulitbernafas AS SULITBERNAFAS, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.diagnosa = 'demam' AND B.sulitbernafas = A.sulitbernafas AND B.sakittenggorokan = 'tidak'
	) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.diagnosa = 'flu' AND C.sulitbernafas = A.sulitbernafas AND C.sakittenggorokan = 'tidak'
	) AS 'FLU'
	FROM tblC45 AS A
	WHERE A.sakittenggorokan = 'tidak'
	GROUP BY A.sulitbernafas;

UPDATE tblHitung1 SET atribut = 'SULITBERNAFAS' WHERE atribut IS NULL;

/*LANGKAH 4: menghitung entropy*/
UPDATE tblHitung1 SET entropy = (-(demam/jumlahdata) * log2(demam/jumlahdata))
+
(-(flu/jumlahdata) * log2(flu/jumlahdata));

UPDATE tblHitung1 SET entropy = 0 WHERE entropy IS NULL;

SELECT * FROM tblHitung1;

/*LANGKAH 5: menghitung nilai gain*/
DROP TABLE IF EXISTS tblTampung1;
CREATE TEMPORARY TABLE tblTampung1
(
atribut VARCHAR(20),
gain DECIMAL (8, 4)
);

INSERT INTO tblTampung1(atribut, gain)
SELECT atribut, @sakittenggorokantidakentropy -
SUM((jumlahdata/@sakittenggorokantidakjumlahdata) * entropy) AS GAIN
FROM tblHitung1
GROUP BY atribut;

SELECT * FROM tblTampung1;

UPDATE tblHitung1 SET GAIN =
	(
	SELECT gain
	FROM tblTampung1
	WHERE atribut = tblHitung1.atribut
	);

SELECT * FROM tblHitung1;

#iterasi3
SELECT MAX(tblHitung1.gain) AS
maximal
FROM tblHitung1;

CREATE TABLE tblHitung2
(
atribut VARCHAR(20),
informasi VARCHAR(20),
jumlahdata INT,
demam INT,
flu INT,
entropy DECIMAL(8,4),
gain DECIMAL(8,4)
);

SELECT COUNT(*) INTO @sulitbernafasringanjumlahdata
FROM tblC45
WHERE sulitbernafas = 'ringan';

SELECT COUNT(*) INTO @sulitbernafasringandemam
FROM tblC45
WHERE sulitbernafas = 'ringan' AND diagnosa = 'demam';

SELECT COUNT(*) INTO @sulitbernafasringanflu
FROM tblC45
WHERE sulitbernafas = 'ringan' AND diagnosa = 'flu';

SELECT (-(@sulitbernafasringandemam/@sulitbernafasringanjumlahdata) * log2(@sulitbernafasringandemam/@sulitbernafasringanjumlahdata))
+
(-(@sulitbernafasringanflu/@sulitbernafasringanjumlahdata)*log2(@sulitbernafasringanflu/@sulitbernafasringanjumlahdata))
INTO @sulitbernafasringanentropy;

SELECT @sulitbernafasringanjumlahdata AS JUM_DATA,
@sulitbernafasringandemam AS DEMAM,
@sulitbernafasringanflu AS FLU,
ROUND(@sulitbernafasringanentropy, 4) AS ENTROPY;

INSERT INTO tblHitung2(atribut, jumlahdata, demam, flu, entropy) VALUES
('SULIT BERNAFAS RINGAN', @sulitbernafasringanjumlahdata, @sulitbernafasringandemam, @sulitbernafasringanflu, @sulitbernafasringanentropy);

SELECT * FROM tblHitung2;

#temperature
INSERT INTO tblHitung2(informasi, jumlahdata, demam, flu)
	SELECT A.demam AS DEMAM, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.diagnosa = 'demam' AND B.demam = A.demam AND B.sulitbernafas = 'ringan'
	) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.diagnosa = 'flu' AND C.demam = A.demam AND C.sulitbernafas = 'ringan'
	) AS 'FLU'
	FROM tblC45 AS A
  WHERE A.sulitbernafas = 'ringan'
	GROUP BY A.demam;

UPDATE tblHitung2 SET atribut = 'DEMAM' WHERE atribut IS NULL;

/*WINDY*/
INSERT INTO tblHitung2(informasi, jumlahdata, demam, flu)
	SELECT A.sakitkepala AS SAKITKEPALA, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.diagnosa = 'demam' AND B.sakitkepala = A.sakitkepala AND B.sulitbernafas = 'ringan'
	) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.diagnosa = 'flu' AND C.sakitkepala = A.sakitkepala AND C.sulitbernafas = 'ringan'
	) AS 'FLU'
	FROM tblC45 AS A
	WHERE A.sulitbernafas = 'ringan'
	GROUP BY A.sakitkepala;

UPDATE tblHitung2 SET atribut = 'SAKITKEPALA' WHERE atribut IS NULL;

INSERT INTO tblHitung2(informasi, jumlahdata, demam, flu)
	SELECT A.nyeri AS NYERI, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.diagnosa = 'demam' AND B.nyeri = A.nyeri AND B.sulitbernafas = 'ringan'
	) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.diagnosa = 'flu' AND C.nyeri = A.nyeri AND C.sulitbernafas = 'ringan'
	) AS 'FLU'
	FROM tblC45 AS A
	WHERE A.sulitbernafas = 'ringan'
	GROUP BY A.nyeri;

UPDATE tblHitung2 SET atribut = 'NYERI' WHERE atribut IS NULL;

INSERT INTO tblHitung2(informasi, jumlahdata, demam, flu)
	SELECT A.lemas AS LEMAS, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.diagnosa = 'demam' AND B.lemas = A.lemas AND B.sulitbernafas = 'ringan'
	) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.diagnosa = 'flu' AND C.lemas = A.lemas AND C.sulitbernafas = 'ringan'
	) AS 'FLU'
	FROM tblC45 AS A
	WHERE A.sulitbernafas = 'ringan'
	GROUP BY A.lemas;

UPDATE tblHitung2 SET atribut = 'LEMAS' WHERE atribut IS NULL;

INSERT INTO tblHitung2(informasi, jumlahdata, demam, flu)
	SELECT A.kelelahan AS KELELAHAN, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.diagnosa = 'demam' AND B.kelelahan = A.kelelahan AND B.sulitbernafas = 'ringan'
	) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.diagnosa = 'flu' AND C.kelelahan = A.kelelahan AND C.sulitbernafas = 'ringan'
	) AS 'FLU'
	FROM tblC45 AS A
	WHERE A.sulitbernafas = 'ringan'
	GROUP BY A.kelelahan;

UPDATE tblHitung2 SET atribut = 'KELELAHAN' WHERE atribut IS NULL;

INSERT INTO tblHitung2(informasi, jumlahdata, demam, flu)
	SELECT A.hidungtersumbat AS HIDUNGTERSUMBAT, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.diagnosa = 'demam' AND B.hidungtersumbat = A.hidungtersumbat AND B.sulitbernafas = 'ringan'
	) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.diagnosa = 'flu' AND C.hidungtersumbat = A.hidungtersumbat AND C.sulitbernafas = 'ringan'
	) AS 'FLU'
	FROM tblC45 AS A
	WHERE A.sulitbernafas = 'ringan'
	GROUP BY A.hidungtersumbat;

UPDATE tblHitung2 SET atribut = 'HIDUNGTERSUMBAT' WHERE atribut IS NULL;

INSERT INTO tblHitung2(informasi, jumlahdata, demam, flu)
	SELECT A.bersin AS BERSIN, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.diagnosa = 'demam' AND B.bersin = A.bersin AND B.sulitbernafas = 'ringan'
	) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.diagnosa = 'flu' AND C.bersin = A.bersin AND C.sulitbernafas = 'ringan'
	) AS 'FLU'
	FROM tblC45 AS A
	WHERE A.sulitbernafas = 'ringan'
	GROUP BY A.bersin;

UPDATE tblHitung2 SET atribut = 'BERSIN' WHERE atribut IS NULL;

/*LANGKAH 4: menghitung entropy*/
UPDATE tblHitung2 SET entropy = (-(demam/jumlahdata) * log2(demam/jumlahdata))
+
(-(flu/jumlahdata) * log2(flu/jumlahdata));

UPDATE tblHitung2 SET entropy = 0 WHERE entropy IS NULL;

SELECT * FROM tblHitung2;

/*LANGKAH 5: menghitung nilai gain*/
DROP TABLE IF EXISTS tblTampung2;
CREATE TEMPORARY TABLE tblTampung2
(
atribut VARCHAR(20),
gain DECIMAL (8, 4)
);

INSERT INTO tblTampung2(atribut, gain)
SELECT atribut, @sulitbernafasringanentropy -
SUM((jumlahdata/@sulitbernafasringanjumlahdata) * entropy) AS GAIN
FROM tblHitung2
GROUP BY atribut;

SELECT * FROM tblTampung2;

UPDATE tblHitung2 SET GAIN =
	(
	SELECT gain
	FROM tblTampung2
	WHERE atribut = tblHitung2.atribut
	);

SELECT * FROM tblHitung2;

#iterasi4
SELECT MAX(tblHitung2.gain) AS
maximal
FROM tblHitung2;

CREATE TABLE tblHitung3
(
atribut VARCHAR(20),
informasi VARCHAR(20),
jumlahdata INT,
demam INT,
flu INT,
entropy DECIMAL(8,4),
gain DECIMAL(8,4)
);

SELECT COUNT(*) INTO @bersinparahjumlahdata
FROM tblC45
WHERE bersin = 'parah';

SELECT COUNT(*) INTO @bersinparahdemam
FROM tblC45
WHERE bersin = 'parah' AND diagnosa = 'demam';

SELECT COUNT(*) INTO @bersinparahflu
FROM tblC45
WHERE bersin = 'parah' AND diagnosa = 'flu';

SELECT (-(@bersinparahdemam/@bersinparahjumlahdata) * log2(@bersinparahdemam/@bersinparahjumlahdata))
+
(-(@bersinparahflu/@bersinparahjumlahdata)*log2(@bersinparahflu/@bersinparahjumlahdata))
INTO @bersinparahentropy;

SELECT @bersinparahjumlahdata AS JUM_DATA,
@bersinparahdemam AS DEMAM,
@bersinparahflu AS FLU,
ROUND(@bersinparahentropy, 4) AS ENTROPY;

INSERT INTO tblHitung3(atribut, jumlahdata, demam, flu, entropy) VALUES
('BERSIN PARAH', @bersinparahjumlahdata, @bersinparahdemam, @bersinparahflu, @bersinparahentropy);

SELECT * FROM tblHitung3;

#temperature
INSERT INTO tblHitung3(informasi, jumlahdata, demam, flu)
	SELECT A.demam AS DEMAM, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.diagnosa = 'demam' AND B.demam = A.demam AND B.bersin = 'parah'
	) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.diagnosa = 'flu' AND C.demam = A.demam AND C.bersin = 'parah'
	) AS 'FLU'
	FROM tblC45 AS A
  WHERE A.bersin = 'parah'
	GROUP BY A.demam;

UPDATE tblHitung3 SET atribut = 'DEMAM' WHERE atribut IS NULL;

/*WINDY*/
INSERT INTO tblHitung3(informasi, jumlahdata, demam, flu)
	SELECT A.sakitkepala AS SAKITKEPALA, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.diagnosa = 'demam' AND B.sakitkepala = A.sakitkepala AND B.bersin = 'parah'
	) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.diagnosa = 'flu' AND C.sakitkepala = A.sakitkepala AND C.bersin = 'parah'
	) AS 'FLU'
	FROM tblC45 AS A
	WHERE A.bersin = 'parah'
	GROUP BY A.sakitkepala;

UPDATE tblHitung3 SET atribut = 'SAKITKEPALA' WHERE atribut IS NULL;

INSERT INTO tblHitung3(informasi, jumlahdata, demam, flu)
	SELECT A.nyeri AS NYERI, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.diagnosa = 'demam' AND B.nyeri = A.nyeri AND B.bersin = 'parah'
	) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.diagnosa = 'flu' AND C.nyeri = A.nyeri AND C.bersin = 'parah'
	) AS 'FLU'
	FROM tblC45 AS A
	WHERE A.bersin = 'parah'
	GROUP BY A.nyeri;

UPDATE tblHitung3 SET atribut = 'NYERI' WHERE atribut IS NULL;

INSERT INTO tblHitung3(informasi, jumlahdata, demam, flu)
	SELECT A.lemas AS LEMAS, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.diagnosa = 'demam' AND B.lemas = A.lemas AND B.bersin = 'parah'
	) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.diagnosa = 'flu' AND C.lemas = A.lemas AND C.bersin = 'parah'
	) AS 'FLU'
	FROM tblC45 AS A
	WHERE A.bersin = 'parah'
	GROUP BY A.lemas;

UPDATE tblHitung3 SET atribut = 'LEMAS' WHERE atribut IS NULL;

INSERT INTO tblHitung3(informasi, jumlahdata, demam, flu)
	SELECT A.kelelahan AS KELELAHAN, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.diagnosa = 'demam' AND B.kelelahan = A.kelelahan AND B.bersin = 'parah'
	) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.diagnosa = 'flu' AND C.kelelahan = A.kelelahan AND C.bersin = 'parah'
	) AS 'FLU'
	FROM tblC45 AS A
	WHERE A.bersin = 'parah'
	GROUP BY A.kelelahan;

UPDATE tblHitung3 SET atribut = 'KELELAHAN' WHERE atribut IS NULL;

INSERT INTO tblHitung3(informasi, jumlahdata, demam, flu)
	SELECT A.hidungtersumbat AS HIDUNGTERSUMBAT, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.diagnosa = 'demam' AND B.hidungtersumbat = A.hidungtersumbat AND B.bersin = 'parah'
	) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.diagnosa = 'flu' AND C.hidungtersumbat = A.hidungtersumbat AND C.bersin = 'parah'
	) AS 'FLU'
	FROM tblC45 AS A
	WHERE A.bersin = 'parah'
	GROUP BY A.hidungtersumbat;

UPDATE tblHitung3 SET atribut = 'HIDUNGTERSUMBAT' WHERE atribut IS NULL;

/*LANGKAH 4: menghitung entropy*/
UPDATE tblHitung3 SET entropy = (-(demam/jumlahdata) * log2(demam/jumlahdata))
+
(-(flu/jumlahdata) * log2(flu/jumlahdata));

UPDATE tblHitung2 SET entropy = 0 WHERE entropy IS NULL;

SELECT * FROM tblHitung3;

/*LANGKAH 5: menghitung nilai gain*/
DROP TABLE IF EXISTS tblTampung3;
CREATE TEMPORARY TABLE tblTampung3
(
atribut VARCHAR(20),
gain DECIMAL (8, 4)
);

INSERT INTO tblTampung3(atribut, gain)
SELECT atribut, @sulitbernafasringanentropy -
SUM((jumlahdata/@sulitbernafasringanjumlahdata) * entropy) AS GAIN
FROM tblHitung3
GROUP BY atribut;

SELECT * FROM tblTampung3;

UPDATE tblHitung3 SET GAIN =
	(
	SELECT gain
	FROM tblTampung3
	WHERE atribut = tblHitung3.atribut
	);

SELECT * FROM tblHitung3;
