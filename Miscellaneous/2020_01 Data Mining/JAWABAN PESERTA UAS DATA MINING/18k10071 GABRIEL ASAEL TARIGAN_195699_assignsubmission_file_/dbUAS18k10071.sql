DROP DATABASE IF EXISTS dbUas;
CREATE DATABASE dbUas;
USE dbUas;

CREATE TABLE tblC45
(
  nourut VARCHAR(5),
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

insert into tblC45 values
  ("P1",	"Tidak",	"Ringan",	"Tidak",	"Tidak",	"Tidak",	"Ringan",	"Parah",	"Parah",	"Ringan",	"Demam"),
  ("P2",	"Parah",	"Parah",	"Parah",	"Parah",	"Parah",	"Tidak",	"Tidak",	"Parah",	"Parah",	"Flu"),
  ("P3",	"Parah",	"Parah",	"Ringan",	"Parah",	"Parah",	"Parah",	"Tidak",	"Parah",	"Parah",	"Flu"),
  ("P4",	"Tidak",	"Tidak",	"Tidak",	"Ringan",	"Tidak",	"Parah",	"Tidak",	"Ringan",	"Ringan",	"Demam"),
  ("P5",	"Parah",	"Parah",	"Ringan",	"Parah",	"Parah",	"Parah",	"Tidak",	"Parah",	"Parah",	"Flu"),
  ("P6",	"Tidak",	"Tidak",	"Tidak",	"Ringan",	"Tidak",	"Parah",	"Parah",	"Parah",	"Tidak",	"Demam"),
  ("P7",	"Parah",	"Parah",	"Parah",	"Parah",	"Parah",	"Tidak",	"Tidak",	"Tidak",	"Parah",	"Flu"),
  ("P8",	"Tidak",	"Tidak",	"Tidak",	"Tidak",	"Tidak",	"Parah",	"Parah",	"Tidak",	"Ringan",	"Demam"),
  ("P9",	"Tidak",	"Ringan",	"Ringan",	"Tidak",	"Tidak",	"Parah",	"Parah",	"Parah",	"Parah",	"Demam"),
  ("P10",	"Parah",	"Parah",	"Parah",	"Ringan",	"Ringan",	"Tidak",	"Parah",	"Tidak",	"Parah",	"Flu"),
  ("P11",	"Tidak",	"Tidak",	"Tidak",	"Ringan",	"Tidak",	"Parah",	"Ringan",	"Parah",	"Tidak",	"Demam"),
  ("P12",	"Parah",	"Ringan",	"Parah",	"Ringan",	"Parah",	"Tidak",	"Parah",	"Tidak",	"Ringan",	"Flu"),
  ("P13",	"Tidak",	"Tidak",	"Ringan",	"Ringan",	"Tidak",	"Parah",	"Parah",	"Parah",	"Tidak",	"Demam"),
  ("P14",	"Parah",	"Parah",	"Parah",	"Parah",	"Ringan",	"Tidak",	"Parah",	"Parah",	"Parah",	"Flu"),
  ("P15",	"Ringan",	"Tidak",	"Tidak",	"Ringan",	"Tidak",	"Parah",	"Tidak",	"Parah",	"Ringan",	"Demam"),
  ("P16",	"Tidak",	"Tidak",	"Tidak",	"Tidak",	"Tidak",	"Parah",	"Parah",	"Parah",	"Parah",	"Demam"),
  ("P17",	"Parah",	"Ringan",	"Parah",	"Ringan",	"Ringan",	"Tidak",	"Tidak",	"Tidak",	"Parah",	"Flu");

SELECT * FROM tblC45;

CREATE TABLE tblHitung
(
  atribut VARCHAR(20),
  informasi VARCHAR(20),
  jumlahdata INT,
  diagdemam INT,
  diagflu INT,
  entropy DECIMAL(8,4),
  gain DECIMAL(8,4)
);

DESC tblHitung;

SELECT COUNT(*) INTO @jumlahdata
FROM tblC45;

SELECT COUNT(*) INTO @diagdemam
FROM tblC45
WHERE diagnosa = 'Demam';

SELECT COUNT(*) INTO @diagflu
FROM tblC45
WHERE diagnosa = 'Flu';

SELECT (-(@diagdemam/@jumlahdata) * log2(@diagdemam/@jumlahdata))
+
(-(@diagflu/@jumlahdata)*log2(@diagflu/@jumlahdata))
INTO @entropy;

SELECT @jumlahdata AS JUMLAH_DATA,
@diagdemam AS jumlah_demam,
@diagflu AS jumlah_flu,
ROUND(@entropy, 4) AS ENTROPY;

INSERT INTO tblHitung(atribut, jumlahdata, diagdemam, diagflu, entropy) VALUES
('Total Data', @jumlahdata, @diagdemam, @diagflu, @entropy);

SELECT * FROM tblHitung;

/*demam*/
INSERT INTO tblHitung(informasi, jumlahdata, diagdemam, diagflu)
	SELECT A.demam AS DEMAM, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.diagnosa = 'Demam' AND B.demam = A.demam
  ) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.diagnosa = 'Flu' AND C.demam = A.demam
  ) AS 'FLU'
	FROM tblC45 AS A
	GROUP BY A.demam;

UPDATE tblHitung SET atribut = 'DEMAM' WHERE atribut IS NULL;

/*sakitkepala*/
INSERT INTO tblHitung(informasi, jumlahdata, diagdemam, diagflu)
	SELECT A.sakitkepala AS SAKITKEPALA, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.diagnosa = 'Demam' AND B.sakitkepala = A.sakitkepala
  ) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.diagnosa = 'Flu' AND C.sakitkepala = A.sakitkepala
  ) AS 'FLU'
	FROM tblC45 AS A
	GROUP BY A.sakitkepala;

UPDATE tblHitung SET atribut = 'SAKITKEPALA' WHERE atribut IS NULL;

/*nyeri*/
INSERT INTO tblHitung(informasi, jumlahdata, diagdemam, diagflu)
	SELECT A.nyeri AS NYERI, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.diagnosa = 'Demam' AND B.nyeri = A.nyeri
  ) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.diagnosa = 'Flu' AND C.nyeri = A.nyeri
  ) AS 'FLU'
	FROM tblC45 AS A
	GROUP BY A.nyeri;

UPDATE tblHitung SET atribut = 'NYERI' WHERE atribut IS NULL;

/*lemas*/
INSERT INTO tblHitung(informasi, jumlahdata, diagdemam, diagflu)
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

UPDATE tblHitung SET atribut = 'LEMAS' WHERE atribut IS NULL;

/*kelelahan*/
INSERT INTO tblHitung(informasi, jumlahdata, diagdemam, diagflu)
	SELECT A.kelelahan AS KELELAHAN, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.diagnosa = 'Demam' AND B.kelelahan = A.kelelahan
  ) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.diagnosa = 'Flu' AND C.kelelahan = A.kelelahan
  ) AS 'FLU'
	FROM tblC45 AS A
	GROUP BY A.kelelahan;

UPDATE tblHitung SET atribut = 'KELELAHAN' WHERE atribut IS NULL;

/*hidungtersumbat*/
INSERT INTO tblHitung(informasi, jumlahdata, diagdemam, diagflu)
	SELECT A.hidungtersumbat AS HIDUNGTERSUMBAT, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.diagnosa = 'Demam' AND B.hidungtersumbat = A.hidungtersumbat
  ) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.diagnosa = 'Flu' AND C.hidungtersumbat = A.hidungtersumbat
  ) AS 'FLU'
	FROM tblC45 AS A
	GROUP BY A.hidungtersumbat;

UPDATE tblHitung SET atribut = 'HIDUNGTERSUMBAT' WHERE atribut IS NULL;

/*bersin*/
INSERT INTO tblHitung(informasi, jumlahdata, diagdemam, diagflu)
	SELECT A.bersin AS BERSIN, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.diagnosa = 'Demam' AND B.bersin = A.bersin
  ) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.diagnosa = 'Flu' AND C.bersin = A.bersin
  ) AS 'FLU'
	FROM tblC45 AS A
	GROUP BY A.bersin;

UPDATE tblHitung SET atribut = 'BERSIN' WHERE atribut IS NULL;

/*sakittenggorokan*/
INSERT INTO tblHitung(informasi, jumlahdata, diagdemam, diagflu)
	SELECT A.sakittenggorokan AS SAKITTENGGOROKAN, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.diagnosa = 'Demam' AND B.sakittenggorokan = A.sakittenggorokan
  ) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.diagnosa = 'Flu' AND C.sakittenggorokan = A.sakittenggorokan
  ) AS 'FLU'
	FROM tblC45 AS A
	GROUP BY A.sakittenggorokan;

UPDATE tblHitung SET atribut = 'SAKITTENGGOROKAN' WHERE atribut IS NULL;

/*sulitbernafas*/
INSERT INTO tblHitung(informasi, jumlahdata, diagdemam, diagflu)
	SELECT A.sulitbernafas AS SULITBERNAFAS, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.diagnosa = 'Demam' AND B.sulitbernafas = A.sulitbernafas
  ) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.diagnosa = 'Flu' AND C.sulitbernafas = A.sulitbernafas
  ) AS 'FLU'
	FROM tblC45 AS A
	GROUP BY A.sulitbernafas;

UPDATE tblHitung SET atribut = 'SULITBERNAFAS' WHERE atribut IS NULL;

UPDATE tblHitung SET entropy = (-(diagdemam/jumlahdata) * log2(diagdemam/jumlahdata))
+
(-(diagflu/jumlahdata) * log2(diagflu/jumlahdata));

UPDATE tblHItung SET entropy = 0 WHERE entropy IS NULL;

SELECT * FROM tblHitung;

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

select atribut, gain
from tblTampung where gain = 0.9975;
