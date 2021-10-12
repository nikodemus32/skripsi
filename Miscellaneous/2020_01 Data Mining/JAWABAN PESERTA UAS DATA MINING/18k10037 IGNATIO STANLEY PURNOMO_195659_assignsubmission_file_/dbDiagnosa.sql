DROP DATABASE IF EXISTS dbDiagnosa;
CREATE DATABASE dbDiagnosa;
USE dbDiagnosa;

CREATE TABLE tblDiagnosa(
  Nopasien VARCHAR(10),
  Demam VARCHAR(20),
  SakitKepala VARCHAR(20),
  Nyeri VARCHAR(20),
  Lemas VARCHAR(20),
  Kelelahan VARCHAR(20),
  HidungTersumbat VARCHAR(20),
  Bersin VARCHAR(20),
  SakitTenggorokan VARCHAR(20),
  SulitBernafas VARCHAR(20),
  Diagnosa VARCHAR(20)
);

INSERT INTO tblDiagnosa values
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

SELECT * FROM tblDiagnosa;

CREATE TABLE tblItung(
  iterasi VARCHAR(20),
  gejala VARCHAR(20),
  tingkat VARCHAR(20),
  jumlah INT,
  diagnosademam INT,
  diagnosaflu INT,
  entropy DECIMAL(8,4),
  gain DECIMAL(8,4)
);

DESC tblItung;

--iterasi1--
SELECT COUNT(*) INTO @jumlah
FROM tblDiagnosa;

SELECT COUNT(*) INTO @diagnosademam
FROM tblDiagnosa
WHERE Diagnosa = 'Demam';

SELECT COUNT(*) INTO @diagnosaflu
FROM tblDiagnosa
WHERE Diagnosa = 'Flu';

SELECT (-(@diagnosademam/@jumlah) * log2(@diagnosademam/@jumlah))+
(-(@diagnosaflu/@jumlah)*log2(@diagnosaflu/@jumlah))
INTO @entropy;

SELECT @jumlah AS JUMLAH,
@diagnosademam AS DIAGNOSA_DEMAM,
@diagnosaflu AS DIAGNOSA_FLU,
ROUND(@entropy, 4) AS ENTROPY;

INSERT INTO tblItung(iterasi, gejala, jumlah, diagnosademam, diagnosaflu, entropy) VALUES
('Iterasi 1', '', @jumlah, @diagnosademam, @diagnosaflu, @entropy);
SELECT * FROM tblItung;

/*proses atribut*/
--Demam--
INSERT INTO tblItung(tingkat, jumlah, diagnosademam, diagnosaflu)
	SELECT A.Demam AS DEMAM, COUNT(*) AS JUMLAHDATA,
		(
		SELECT COUNT(*)
		FROM tblDiagnosa AS B
		WHERE B.Diagnosa = 'Demam' AND B.Demam = A.Demam
    ) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblDiagnosa AS C
		WHERE C.Diagnosa = 'Flu' AND C.Demam = A.Demam
  ) AS 'FLU'
	FROM tblDiagnosa AS A
	GROUP BY A.Demam;

UPDATE tblItung SET gejala = 'DEMAM' WHERE gejala IS NULL;

--sakitkepala--
INSERT INTO tblItung(tingkat, jumlah, diagnosademam, diagnosaflu)
	SELECT A.SakitKepala AS SAKITKEPALA, COUNT(*) AS JUMLAHDATA,
		(
		SELECT COUNT(*)
		FROM tblDiagnosa AS B
		WHERE B.Diagnosa = 'Demam' AND B.SakitKepala = A.SakitKepala
  ) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblDiagnosa AS C
		WHERE C.Diagnosa = 'Flu' AND C.SakitKepala = A.SakitKepala
  ) AS 'FLU'
	FROM tblDiagnosa AS A
	GROUP BY A.SakitKepala;

UPDATE tblItung SET gejala = 'SAKITKEPALA' WHERE gejala IS NULL;

--nyeri--
INSERT INTO tblItung(tingkat, jumlah, diagnosademam, diagnosaflu)
	SELECT A.Nyeri AS NYERI, COUNT(*) AS JUMLAHDATA,
		(
		SELECT COUNT(*)
		FROM tblDiagnosa AS B
		WHERE B.Diagnosa = 'Demam' AND B.Nyeri = A.Nyeri
  ) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblDiagnosa AS C
		WHERE C.Diagnosa = 'Flu' AND C.Nyeri = A.Nyeri
  ) AS 'FLU'
	FROM tblDiagnosa AS A
	GROUP BY A.Nyeri;

UPDATE tblItung SET gejala = 'NYERI' WHERE gejala IS NULL;

--lemas--
INSERT INTO tblItung(tingkat, jumlah, diagnosademam, diagnosaflu)
	SELECT A.Lemas AS LEMAS, COUNT(*) AS JUMLAHDATA,
		(
		SELECT COUNT(*)
		FROM tblDiagnosa AS B
		WHERE B.Diagnosa = 'Demam' AND B.Lemas = A.Lemas
  ) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblDiagnosa AS C
		WHERE C.Diagnosa = 'Flu' AND C.Lemas = A.Lemas
  ) AS 'Flu'
	FROM tblDiagnosa AS A
	GROUP BY A.Lemas;

UPDATE tblItung SET gejala = 'LEMAS' WHERE gejala IS NULL;

--kelelahan--
INSERT INTO tblItung(tingkat, jumlah, diagnosademam, diagnosaflu)
	SELECT A.Kelelahan AS KELELAHAN, COUNT(*) AS JUMLAHDATA,
		(
		SELECT COUNT(*)
		FROM tblDiagnosa AS B
		WHERE B.Diagnosa = 'Demam' AND B.Kelelahan = A.Kelelahan
  ) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblDiagnosa AS C
		WHERE C.Diagnosa = 'Flu' AND C.Kelelahan = A.Kelelahan
  ) AS 'Flu'
	FROM tblDiagnosa AS A
	GROUP BY A.Kelelahan;

UPDATE tblItung SET gejala = 'KELELAHAN' WHERE gejala IS NULL;

--hidungtersumbat--
INSERT INTO tblItung(tingkat, jumlah, diagnosademam, diagnosaflu)
	SELECT A.HidungTersumbat AS HIDUNGTERSUMBAT, COUNT(*) AS JUMLAHDATA,
		(
		SELECT COUNT(*)
		FROM tblDiagnosa AS B
		WHERE B.Diagnosa = 'Demam' AND B.HidungTersumbat = A.HidungTersumbat
  ) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblDiagnosa AS C
		WHERE C.Diagnosa = 'Flu' AND C.HidungTersumbat = A.HidungTersumbat
  ) AS 'Flu'
	FROM tblDiagnosa AS A
	GROUP BY A.HidungTersumbat;

UPDATE tblItung SET gejala = 'HIDUNGTERSUMBAT' WHERE gejala IS NULL;

--bersin--
INSERT INTO tblItung(tingkat, jumlah, diagnosademam, diagnosaflu)
	SELECT A.Bersin AS BERSIN, COUNT(*) AS JUMLAHDATA,
		(
		SELECT COUNT(*)
		FROM tblDiagnosa AS B
		WHERE B.Diagnosa = 'Demam' AND B.Bersin = A.Bersin
  ) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblDiagnosa AS C
		WHERE C.Diagnosa = 'Flu' AND C.Bersin = A.Bersin
  ) AS 'Flu'
	FROM tblDiagnosa AS A
	GROUP BY A.Bersin;

UPDATE tblItung SET gejala = 'BERSIN' WHERE gejala IS NULL;

--sakittenggorokan--
INSERT INTO tblItung(tingkat, jumlah, diagnosademam, diagnosaflu)
	SELECT A.SakitTenggorokan AS SAKITTENGGOROKAN, COUNT(*) AS JUMLAHDATA,
		(
		SELECT COUNT(*)
		FROM tblDiagnosa AS B
		WHERE B.Diagnosa = 'Demam' AND B.SakitTenggorokan = A.SakitTenggorokan
  ) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblDiagnosa AS C
		WHERE C.Diagnosa = 'Flu' AND C.SakitTenggorokan = A.SakitTenggorokan
  ) AS 'Flu'
	FROM tblDiagnosa AS A
	GROUP BY A.SakitTenggorokan;

UPDATE tblItung SET gejala = 'SAKITTENGGOROKAN' WHERE gejala IS NULL;

--sulitbernafas--
INSERT INTO tblItung(tingkat, jumlah, diagnosademam, diagnosaflu)
	SELECT A.SulitBernafas AS SULITBERNAFAS, COUNT(*) AS JUMLAHDATA,
		(
		SELECT COUNT(*)
		FROM tblDiagnosa AS B
		WHERE B.Diagnosa = 'Demam' AND B.SulitBernafas = A.SulitBernafas
  ) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblDiagnosa AS C
		WHERE C.Diagnosa = 'Flu' AND C.SulitBernafas = A.SulitBernafas
  ) AS 'Flu'
	FROM tblDiagnosa AS A
	GROUP BY A.SulitBernafas;

UPDATE tblItung SET gejala = 'SULITBERNAFAS' WHERE gejala IS NULL;


/*ENTROPY*/
UPDATE tblItung SET entropy = (-(diagnosademam/jumlah) * log2(diagnosademam/jumlah))
+
(-(diagnosaflu/jumlah) * log2(diagnosaflu/jumlah));

UPDATE tblItung SET entropy = 0 WHERE entropy IS NULL;

SELECT * FROM tblItung;


/*GAIN*/
DROP TABLE IF EXISTS tblSementara;
CREATE TEMPORARY TABLE tblSementara
(
gejala VARCHAR(20),
gain DECIMAL(8, 4)
);

INSERT INTO tblSementara(gejala, gain)
SELECT gejala, @entropy -
SUM((jumlah/@jumlah) * entropy) AS GAIN
FROM tblItung
GROUP BY gejala;

SELECT * FROM tblSementara;

UPDATE tblItung SET GAIN =
	(
	SELECT gain
	FROM tblSementara
	WHERE gejala = tblItung.gejala
);

SELECT * FROM tblItung;
