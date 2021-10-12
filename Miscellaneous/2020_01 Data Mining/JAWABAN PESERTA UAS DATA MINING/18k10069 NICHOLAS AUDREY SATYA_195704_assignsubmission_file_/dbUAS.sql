DROP DATABASE IF EXISTS dbUAS;
CREATE DATABASE dbUAS;
USE dbUAS;

CREATE TABLE tblC45
(
  pasien varchar(10),
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

select * from tblC45;

CREATE TABLE tblHitung
(
iterasi VARCHAR(10),
gejala VARCHAR(10),
tingkat VARCHAR(10),
jumlahdata INT,
diagnosademam INT,
diagnosaflu INT,
entropy DECIMAL(8,4),
gain DECIMAL(8,4)
);

DESC tblHitung;

-- Iterasi 1 --

SELECT COUNT(*) INTO @jumlahdata
FROM tblC45;

SELECT COUNT(*) INTO @diagnosademam
FROM tblC45
WHERE diagnosa = 'Demam';

SELECT COUNT(*) INTO @diagnosaflu
FROM tblC45
WHERE diagnosa = 'Flu';

SELECT (-(@diagnosademam/@jumlahdata) * log2(@diagnosademam/@jumlahdata))
+
(-(@diagnosaflu/@jumlahdata)*log2(@diagnosaflu/@jumlahdata))
INTO @entropy;

SELECT @jumlahdata AS JUM_DATA,
@diagnosademam AS DIAGNOSA_DEMAM,
@diagnosaflu AS DIAGNOSA_FLU,
ROUND(@entropy, 4) AS ENTROPY;

INSERT INTO tblHitung(iterasi, gejala, jumlahdata, diagnosademam, diagnosaflu, entropy) VALUES
('Iterasi 1','TOTAL DATA', @jumlahdata, @diagnosademam, @diagnosaflu, @entropy);

SELECT * FROM tblHitung;

/*DEMAM*/
INSERT INTO tblHitung(tingkat, jumlahdata, diagnosademam, diagnosaflu)
	SELECT A.demam AS DEMAM, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.diagnosa = 'Demam' AND B.demam = A.demam
  ) AS 'Demam',

		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.diagnosa = 'Flu' AND C.demam = A.demam
  ) AS 'Flu'
	FROM tblC45 AS A
	GROUP BY A.demam;

UPDATE tblHitung SET gejala = 'Demam' WHERE gejala IS NULL;

/*SAKIT KEPALA*/
INSERT INTO tblHitung(tingkat, jumlahdata, diagnosademam, diagnosaflu)
	SELECT A.sakitkepala AS SAKITKEPALA, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.diagnosa = 'Demam' AND B.sakitkepala = A.sakitkepala
    ) AS 'Demam',

		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.diagnosa = 'Flu' AND C.sakitkepala = A.sakitkepala
    ) AS 'Flu'
	FROM tblC45 AS A
	GROUP BY A.sakitkepala;

UPDATE tblHitung SET gejala = 'Sakit Kepala' WHERE gejala IS NULL;

/*NYERI*/
INSERT INTO tblHitung(tingkat, jumlahdata, diagnosademam, diagnosaflu)
	SELECT A.nyeri AS NYERI, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.diagnosa = 'Demam' AND B.nyeri = A.nyeri
    ) AS 'Demam',

		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.diagnosa = 'Flu' AND C.nyeri = A.nyeri
    ) AS 'Flu'
	FROM tblC45 AS A
	GROUP BY A.nyeri;

UPDATE tblHitung SET gejala = 'Flu' WHERE gejala IS NULL;

/*Lemas*/
INSERT INTO tblHitung(tingkat, jumlahdata, diagnosademam, diagnosaflu)
	SELECT A.lemas AS LEMAS, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.diagnosa = 'Demam' AND B.lemas = A.lemas
    ) AS 'Demam',

		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.diagnosa = 'Flu' AND C.lemas = A.lemas
    ) AS 'Flu'
	FROM tblC45 AS A
	GROUP BY A.lemas;

UPDATE tblHitung SET gejala = 'Lemas' WHERE gejala IS NULL;

/*Kelelahan*/
INSERT INTO tblHitung(tingkat, jumlahdata, diagnosademam, diagnosaflu)
	SELECT A.kelelahan AS KELELAHAN, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.diagnosa = 'Demam' AND B.kelelahan = A.kelelahan
    ) AS 'Demam',

		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.diagnosa = 'Flu' AND C.kelelahan = A.kelelahan
    ) AS 'Flu'
	FROM tblC45 AS A
	GROUP BY A.kelelahan;

UPDATE tblHitung SET gejala = 'Kelelahan' WHERE gejala IS NULL;

/*Hidung Tersumbat*/
INSERT INTO tblHitung(tingkat, jumlahdata, diagnosademam, diagnosaflu)
	SELECT A.hidungtersumbat AS HIDUNGTERSUMBAT, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.diagnosa = 'Demam' AND B.hidungtersumbat = A.hidungtersumbat
    ) AS 'Demam',

		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.diagnosa = 'Flu' AND C.hidungtersumbat = A.hidungtersumbat
    ) AS 'Flu'
	FROM tblC45 AS A
	GROUP BY A.hidungtersumbat;

UPDATE tblHitung SET gejala = 'Hidung Tersumbat' WHERE gejala IS NULL;

/*Bersin*/
INSERT INTO tblHitung(tingkat, jumlahdata, diagnosademam, diagnosaflu)
	SELECT A.bersin AS BERSIN, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.diagnosa = 'Demam' AND B.bersin = A.bersin
    ) AS 'Demam',

		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.diagnosa = 'Flu' AND C.bersin = A.bersin
    ) AS 'Flu'
	FROM tblC45 AS A
	GROUP BY A.bersin;

UPDATE tblHitung SET gejala = 'Bersin' WHERE gejala IS NULL;

/*Sakit Tenggorokan*/
INSERT INTO tblHitung(tingkat, jumlahdata, diagnosademam, diagnosaflu)
	SELECT A.sakittenggorokan AS SAKITTENGGOROKAN, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.diagnosa = 'Demam' AND B.sakittenggorokan = A.sakittenggorokan
    ) AS 'Demam',

		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.diagnosa = 'Flu' AND C.sakittenggorokan = A.sakittenggorokan
    ) AS 'Flu'
	FROM tblC45 AS A
	GROUP BY A.sakittenggorokan;

UPDATE tblHitung SET gejala = 'Sakit Tenggorokan' WHERE gejala IS NULL;

/*Sulit Bernafas*/
INSERT INTO tblHitung(tingkat, jumlahdata, diagnosademam, diagnosaflu)
	SELECT A.sulitbernafas AS SULITBERNAFAS, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.diagnosa = 'Demam' AND B.sulitbernafas = A.sulitbernafas
    ) AS 'Demam',

		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.diagnosa = 'Flu' AND C.sulitbernafas = A.sulitbernafas
    ) AS 'Flu'
	FROM tblC45 AS A
	GROUP BY A.sulitbernafas;

UPDATE tblHitung SET gejala = 'Sulit Bernafas' WHERE gejala IS NULL;

UPDATE tblHitung SET iterasi = 'Iterasi 1' WHERE iterasi IS NULL;

/*LANGKAH 4: menghitung entropy*/
UPDATE tblHitung SET entropy = (-(diagnosademam/jumlahdata) * log2(diagnosademam/jumlahdata))
+
(-(diagnosaflu/jumlahdata) * log2(diagnosaflu/jumlahdata));

UPDATE tblHItung SET entropy = 0 WHERE entropy IS NULL AND iterasi = 'Iterasi 1';

SELECT * FROM tblHitung;

/*LANGKAH 5: menghitung nilai gain*/
DROP TABLE IF EXISTS tblTampung;
CREATE TEMPORARY TABLE tblTampung
(
gejala VARCHAR(10),
gain DECIMAL(8, 4)
);

INSERT INTO tblTampung(gejala, gain)
SELECT gejala, @entropy -
SUM((jumlahdata/@jumlahdata) * entropy) AS GAIN
FROM tblHitung
WHERE iterasi = 'Iterasi 1'
GROUP BY gejala;

SELECT * FROM tblTampung;

UPDATE tblHitung SET GAIN =
	(
	SELECT gain
	FROM tblTampung
	WHERE gejala = tblHitung.gejala
	) WHERE iterasi = 'Iterasi 1';

SELECT * FROM tblHitung;

/*Iterasi berhenti di Iterasi 1 karena gejala Demam memiliki nilai gain tertinggi
tetapi di ketiga tingkatnya (Parah, Ringan, Tidak) memiliki nilai entropy yaitu 0
sehingga proses iterasi tidak dapat dilanjutkan*/
