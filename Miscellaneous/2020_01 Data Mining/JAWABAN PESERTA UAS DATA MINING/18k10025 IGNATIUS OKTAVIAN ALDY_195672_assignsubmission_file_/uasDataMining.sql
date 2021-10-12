DROP DATABASE IF EXISTS dbUas18k10025;
CREATE DATABASE dbUas18k10025;
USE dbUas18k10025;

CREATE table tblPenyakit(
  no varchar(25),
  demam varchar(25),
  sakit_kepala varchar(25),
  nyeri varchar(25),
  lemas varchar(25),
  kelelahan varchar(25),
  hidung_tersumbat varchar(25),
  bersin varchar(25),
  sakit_tenggorokan varchar(25),
  sulit_bernafas varchar(25),
  diagnosis varchar(25)
);

insert into tblPenyakit values
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
  ("P16", "Tidak", "Tidak", "Tidak", "Tidak", "Tidak", "Parah", "Parah", "Parah", "Parah", "Demam"),
  ("P17", "Parah", "Ringan", "Parah", "Ringan", "Ringan", "Tidak", "Tidak", "Tidak", "Parah", "Flu");

select * from tblPenyakit;

CREATE TABLE tblCount
(
atribut VARCHAR(20),
informasi VARCHAR(20),
jumlahdata INT,
demam INT,
flu INT,
entropy DECIMAL(8,4),
gain DECIMAL(8,4)
);

DESC tblCount;

SELECT COUNT(*) INTO @jumlahdata
FROM tblPenyakit;

SELECT COUNT(*) INTO @demam
FROM tblPenyakit
WHERE diagnosis = 'Demam';

SELECT COUNT(*) INTO @flu
FROM tblPenyakit
WHERE diagnosis = 'Flu';

SELECT (-(@demam/@jumlahdata) * log2(@demam/@jumlahdata))
+
(-(@flu/@jumlahdata)*log2(@flu/@jumlahdata))
INTO @entropy;

SELECT @jumlahdata AS JUM_DATA,
@demam AS DEMAM,
@flu AS FLU,
ROUND(@entropy, 4) AS ENTROPY;

INSERT INTO tblCount(atribut, jumlahdata, demam, flu, entropy) VALUES
('TOTAL DATA', @jumlahdata, @demam, @flu, @entropy);

SELECT * FROM tblCount;

-- Demam
INSERT INTO tblCount(informasi, jumlahdata, demam, flu)
	SELECT A.demam AS DEMAM, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblPenyakit AS B
		WHERE B.diagnosis = 'Demam' AND B.demam = A.demam
  ) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblPenyakit AS C
		WHERE C.diagnosis = 'Flu' AND C.demam = A.demam
  ) AS 'FLU'
	FROM tblPenyakit AS A
	GROUP BY A.demam;

UPDATE tblCount SET atribut = 'DEMAM' WHERE atribut IS NULL;

-- sakit kepala
INSERT INTO tblCount(informasi, jumlahdata, demam, flu)
	SELECT A.sakit_kepala AS SAKIT_KEPALA, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblPenyakit AS B
		WHERE B.diagnosis = 'Demam' AND B.sakit_kepala = A.sakit_kepala
  ) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblPenyakit AS C
		WHERE C.diagnosis = 'Flu' AND C.sakit_kepala = A.sakit_kepala
  ) AS 'FLU'
	FROM tblPenyakit AS A
	GROUP BY A.sakit_kepala;

UPDATE tblCount SET atribut = 'SAKIT KEPALA' WHERE atribut IS NULL;

-- nyeri
INSERT INTO tblCount(informasi, jumlahdata, demam, flu)
	SELECT A.nyeri AS NYERI, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblPenyakit AS B
		WHERE B.diagnosis = 'Demam' AND B.nyeri = A.nyeri
  ) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblPenyakit AS C
		WHERE C.diagnosis = 'Flu' AND C.nyeri = A.nyeri
  ) AS 'FLU'
	FROM tblPenyakit AS A
	GROUP BY A.nyeri;

UPDATE tblCount SET atribut = 'NYERI' WHERE atribut IS NULL;

-- lemas
INSERT INTO tblCount(informasi, jumlahdata, demam, flu)
	SELECT A.lemas AS LEMAS, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblPenyakit AS B
		WHERE B.diagnosis = 'Demam' AND B.lemas = A.lemas
  ) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblPenyakit AS C
		WHERE C.diagnosis = 'Flu' AND C.lemas = A.lemas
  ) AS 'FLU'
	FROM tblPenyakit AS A
	GROUP BY A.lemas;

UPDATE tblCount SET atribut = 'LEMAS' WHERE atribut IS NULL;

-- kelelahan
INSERT INTO tblCount(informasi, jumlahdata, demam, flu)
	SELECT A.kelelahan AS KELELAHAN, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblPenyakit AS B
		WHERE B.diagnosis = 'Demam' AND B.kelelahan = A.kelelahan
  ) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblPenyakit AS C
		WHERE C.diagnosis = 'Flu' AND C.kelelahan = A.kelelahan
  ) AS 'FLU'
	FROM tblPenyakit AS A
	GROUP BY A.kelelahan;

UPDATE tblCount SET atribut = 'KELELAHAN' WHERE atribut IS NULL;

-- hidung tersumbat
INSERT INTO tblCount(informasi, jumlahdata, demam, flu)
	SELECT A.hidung_tersumbat AS HIDUNG_TERSUMBAT, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblPenyakit AS B
		WHERE B.diagnosis = 'Demam' AND B.hidung_tersumbat = A.hidung_tersumbat
  ) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblPenyakit AS C
		WHERE C.diagnosis = 'Flu' AND C.hidung_tersumbat = A.hidung_tersumbat
  ) AS 'FLU'
	FROM tblPenyakit AS A
	GROUP BY A.lemas;

UPDATE tblCount SET atribut = 'HIDUNG TERSUMBAT' WHERE atribut IS NULL;

-- bersin
INSERT INTO tblCount(informasi, jumlahdata, demam, flu)
	SELECT A.bersin AS BERSIN, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblPenyakit AS B
		WHERE B.diagnosis = 'Demam' AND B.bersin = A.bersin
  ) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblPenyakit AS C
		WHERE C.diagnosis = 'Flu' AND C.bersin = A.bersin
  ) AS 'FLU'
	FROM tblPenyakit AS A
	GROUP BY A.bersin;

UPDATE tblCount SET atribut = 'BERSIN' WHERE atribut IS NULL;

-- sakit tenggorokan
INSERT INTO tblCount(informasi, jumlahdata, demam, flu)
	SELECT A.sakit_tenggorokan AS SAKIT_TENGGOROKAN, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblPenyakit AS B
		WHERE B.diagnosis = 'Demam' AND B.sakit_tenggorokan = A.sakit_tenggorokan
  ) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblPenyakit AS C
		WHERE C.diagnosis = 'Flu' AND C.sakit_tenggorokan = A.sakit_tenggorokan
  ) AS 'FLU'
	FROM tblPenyakit AS A
	GROUP BY A.sakit_tenggorokan;

UPDATE tblCount SET atribut = 'SAKIT TENGGOROKAN' WHERE atribut IS NULL;

-- sulit bernafas
INSERT INTO tblCount(informasi, jumlahdata, demam, flu)
	SELECT A.sulit_bernafas AS SULIT_BERNAFAS, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblPenyakit AS B
		WHERE B.diagnosis = 'Demam' AND B.sulit_bernafas = A.sulit_bernafas
  ) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblPenyakit AS C
		WHERE C.diagnosis = 'Flu' AND C.sulit_bernafas = A.sulit_bernafas
  ) AS 'FLU'
	FROM tblPenyakit AS A
	GROUP BY A.sulit_bernafas;

UPDATE tblCount SET atribut = 'SULIT BERNAFAS' WHERE atribut IS NULL;

-- menghitung entropy
UPDATE tblCount SET entropy = (-(demam/jumlahdata) * log2(demam/jumlahdata))
+
(-(flu/jumlahdata) * log2(flu/jumlahdata));

UPDATE tblCount SET entropy = 0 WHERE entropy IS NULL;

SELECT * FROM tblCount;

-- menghitung nilai gain
DROP TABLE IF EXISTS tblTampung;
CREATE TEMPORARY TABLE tblTampung
(
atribut VARCHAR(20),
gain DECIMAL(8, 4)
);

INSERT INTO tblTampung(atribut, gain)
SELECT atribut, @entropy -
SUM((jumlahdata/@jumlahdata) * entropy) AS GAIN
FROM tblCount
GROUP BY atribut;

SELECT * FROM tblTampung;

UPDATE tblCount SET GAIN =
	(
	SELECT gain
	FROM tblTampung
	WHERE atribut = tblCount.atribut
	);

SELECT * FROM tblCount;
