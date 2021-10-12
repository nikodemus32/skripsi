DROP DATABASE IF EXISTS uasdbC45;
CREATE DATABASE uasdbC45;
USE uasdbC45;

CREATE TABLE tblC45
(
No VARCHAR(10),
Demam VARCHAR(10),
SakitKepala VARCHAR(10),
Nyeri VARCHAR(10),
Lemas VARCHAR(10),
Kelelahan VARCHAR(10),
HidungTersumbat VARCHAR(10),
Bersin VARCHAR(10),
SakitTenggorokan VARCHAR(10),
SulitBernapas VARCHAR(10),
Diagnosa VARCHAR(10)
);

INSERT INTO tblC45 VALUES
('P1', 'Tidak', 'Ringan', 'Tidak', 'Tidak', 'Tidak', 'Ringan', 'Parah', 'Parah', 'Ringan', 'Demam'),
('P2', 'Parah', 'Parah', 'Parah', 'Parah', 'Parah', 'Tidak', 'Tidak', 'Parah', 'Parah', 'Flu'),
('P3', 'Parah', 'Parah', 'Ringan', 'Parah', 'Parah', 'Parah', 'Tidak', 'Parah', 'Parah', 'Flu'),
('P4', 'Tidak', 'Tidak', 'Tidak', 'Ringan', 'Tidak', 'Parah', 'Tidak', 'Ringan', 'Ringan', 'Demam'),
('P5', 'Parah', 'Parah', 'Ringan', 'Parah', 'Parah', 'Parah', 'Tidak', 'Parah', 'Parah', 'Flu'),
('P6', 'Tidak', 'Tidak', 'Tidak', 'Ringan', 'Tidak', 'Parah', 'Parah', 'Parah', 'Tidak', 'Demam'),
('P7', 'Parah',	'Parah', 'Parah',	'Parah', 'Parah',	'Tidak', 'Tidak', 'Tidak', 'Parah',	'Flu'),
('P8', 'Tidak', 'Tidak', 'Tidak',	'Tidak', 'Tidak', 'Parah', 'Parah', 'Tidak', 'Ringan', 'Demam'),
('P9', 'Tidak', 'Ringan', 'Ringan', 'Tidak', 'Tidak', 'Parah', 'Parah', 'Parah', 'Parah', 'Demam'),
('P10', 'Parah', 'Parah', 'Parah', 'Ringan', 'Ringan', 'Tidak', 'Parah', 'Tidak', 'Parah', 'Flu'),
('P11', 'Tidak', 'Tidak', 'Tidak', 'Ringan', 'Tidak', 'Parah', 'Ringan', 'Parah', 'Tidak', 'Demam'),
('P12',	'Parah', 'Ringan', 'Parah', 'Ringan',	'Parah', 'Tidak', 'Parah', 'Tidak', 'Ringan', 'Flu'),
('P13', 'Tidak', 'Tidak', 'Ringan', 'Ringan', 'Tidak', 'Parah', 'Parah', 'Parah', 'Tidak', 'Demam'),
('P14', 'Parah', 'Parah', 'Parah', 'Parah', 'Ringan', 'Tidak',	'Parah', 'Parah', 'Parah', 'Flu'),
('P15', 'Ringan', 'Tidak', 'Tidak', 'Ringan', 'Tidak', 'Parah', 'Tidak', 'Parah', 'Ringan', 'Demam'),
('P16', 'Tidak', 'Tidak', 'Tidak', 'Tidak', 'Tidak', 'Parah', 'Parah', 'Parah', 'Parah', 'Demam'),
('P17',	'Parah', 'Ringan', 'Parah', 'Ringan', 'Ringan', 'Tidak', 'Tidak', 'Tidak', 'Parah', 'Flu');

SELECT * FROM tblC45;

CREATE TABLE tblJumlah
(
Atribut VARCHAR(20),
Informasi VARCHAR(20),
Jumlahdata INT,
Demam INT,
Flu INT,
Entropy DECIMAL(8,4),
Gain DECIMAL(8,4)
);

DESC tblJumlah;

SELECT COUNT(*) INTO @JumlahData
FROM tblC45;

SELECT COUNT(*) INTO @Demam
FROM tblC45
WHERE Diagnosa = 'Demam';

SELECT COUNT(*) INTO @Flu
FROM tblC45
WHERE Diagnosa = 'Flu';

SELECT (-(@Demam/@JumlahData) * log2(@Demam/@Jumlahdata))
+
(-(@Flu/@JumlahData)*log2(@Flu/@JumlahData))
INTO @Entropy;

SELECT @JumlahData AS JUM_DATA,
@Demam AS DEMAM,
@Flu AS FLU,
ROUND(@Entropy, 4) AS ENTROPY;

INSERT INTO tblJumlah(Atribut, JumlahData, Demam, Flu, Entropy) VALUES
('TOTAL DATA', @JumlahData, @Demam, @Flu, @Entropy);

SELECT * FROM tblJumlah;

/*Demam*/
INSERT INTO tblJumlah(informasi, JumlahData, Demam, Flu)
	SELECT A.Demam AS DEMAM, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.Diagnosa = 'Demam' AND B.Demam = A.Demam
  ) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.Diagnosa = 'Flu' AND C.Demam = A.Demam
  ) AS 'FLU'
	FROM tblC45 AS A
	GROUP BY A.Demam;

UPDATE tblJumlah SET atribut = 'DEMAM' WHERE atribut IS NULL;

/*SakitKepala*/
INSERT INTO tblJumlah(informasi, JumlahData, Demam, Flu)
	SELECT A.SakitKepala AS SAKITKEPALA, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.Diagnosa = 'Demam' AND B.SakitKepala = A.SakitKepala
  ) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.Diagnosa = 'Demam' AND C.SakitKepala = A.SakitKepala
  ) AS 'FLU'
	FROM tblC45 AS A
	GROUP BY A.SakitKepala;

UPDATE tblJumlah SET atribut = 'SAKIT KEPALA' WHERE atribut IS NULL;

/*Nyeri*/
INSERT INTO tblJumlah(informasi, JumlahData, Demam, Flu)
	SELECT A.Nyeri AS NYERI, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.Nyeri = 'Demam' AND B.Nyeri = A.Nyeri
  ) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.Nyeri = 'Demam' AND C.Nyeri = A.Nyeri
  ) AS 'FLU'
	FROM tblC45 AS A
	GROUP BY A.Nyeri;

UPDATE tblJumlah SET atribut = 'NYERI' WHERE atribut IS NULL;

/*Lemas*/
INSERT INTO tblJumlah(informasi, JumlahData, Demam, Flu)
	SELECT A.Lemas AS LEMAS, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.Lemas = 'Demam' AND B.Lemas = A.Lemas
  ) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.Lemas = 'Flu' AND C.Lemas = A.Lemas
  ) AS 'FLU'
	FROM tblC45 AS A
	GROUP BY A.Lemas;

UPDATE tblJumlah SET atribut = 'LEMAS' WHERE atribut IS NULL;

/*Kelelahan*/
INSERT INTO tblJumlah(informasi, JumlahData, Demam, Flu)
	SELECT A.Kelelahan AS KELELAHAN, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.Kelelahan = 'Demam' AND B.Kelelahan = A.Kelelahan
  ) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.Kelelahan = 'Flu' AND C.Kelelahan = A.Kelelahan
  ) AS 'FLU'
	FROM tblC45 AS A
	GROUP BY A.Kelelahan;

UPDATE tblJumlah SET atribut = 'KELELAHAN' WHERE atribut IS NULL;

/*HidungTersumbat*/
INSERT INTO tblJumlah(informasi, JumlahData, Demam, Flu)
	SELECT A.HidungTersumbat AS HIDUNGTERSUMBAT, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.HidungTersumbat = 'Demam' AND B.HidungTersumbat = A.HidungTersumbat
  ) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.HidungTersumbat = 'Flu' AND C.HidungTersumbat = A.HidungTersumbat
  ) AS 'FLU'
	FROM tblC45 AS A
	GROUP BY A.HidungTersumbat;

UPDATE tblJumlah SET atribut = 'HIDUNGTERSUMBAT' WHERE atribut IS NULL;

/*Bersin*/
INSERT INTO tblJumlah(informasi, JumlahData, Demam, Flu)
	SELECT A.BERSIN AS BERSIN, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.Bersin = 'Demam' AND B.Bersin = A.Bersin
  ) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.Bersin = 'Flu' AND C.Bersin = A.Bersin
  ) AS 'FLU'
	FROM tblC45 AS A
	GROUP BY A.Bersin;

UPDATE tblJumlah SET atribut = 'BERSIN' WHERE atribut IS NULL;

/*SakitTenggorokan*/
INSERT INTO tblJumlah(informasi, JumlahData, Demam, Flu)
	SELECT A.SakitTenggorokan AS SAKITTENGGOROKAN, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.SakitTenggorokan = 'Demam' AND B.SakitTenggorokan = A.SakitTenggorokan
  ) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.SakitTenggorokan = 'Flu' AND C.SakitTenggorokan = A.SakitTenggorokan
  ) AS 'FLU'
	FROM tblC45 AS A
	GROUP BY A.SakitTenggorokan;

UPDATE tblJumlah SET atribut = 'SAKIT TENGGOROKAN' WHERE atribut IS NULL;

/*SulitBernapas*/
INSERT INTO tblJumlah(informasi, JumlahData, Demam, Flu)
	SELECT A.SulitBernapas AS SULITBERNAPAS, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.SulitBernapas = 'Demam' AND B.SulitBernapas = A.SulitBernapas
  ) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.SulitBernapas = 'Flu' AND C.SulitBernapas = A.SulitBernapas
  ) AS 'FLU'
	FROM tblC45 AS A
	GROUP BY A.SulitBernapas;

UPDATE tblJumlah SET atribut = 'SULIT BERNAPAS' WHERE atribut IS NULL;

/*Entropy*/
UPDATE tblJumlah SET entropy = (-(Demam/JumlahData) * log2(Demam/JumlahData))
+
(-(Flu/JumlahData) * log2(Flu/JumlahData));

UPDATE tblJumlah SET entropy = 0 WHERE entropy IS NULL;

SELECT * FROM tblJumlah;

/*Gain*/
DROP TABLE IF EXISTS tblSimpan;
CREATE TEMPORARY TABLE tblSimpan
(
atribut VARCHAR(20),
gain DECIMAL(8, 4)
);

INSERT INTO tblSimpan(atribut, gain)
SELECT atribut, @entropy -
SUM((jumlahdata/@jumlahdata) * entropy) AS GAIN
FROM tblJumlah
GROUP BY atribut;

SELECT * FROM tblSimpan;

UPDATE tblJumlah SET GAIN =
	(
	SELECT gain
	FROM tblSimpan
	WHERE atribut = tblJumlah.atribut
	);

SELECT * FROM tblJumlah;


/*Iterasi 2*/
SELECT MAX(tblJumlah.gain) AS
maximal
FROM tblJumlah;

CREATE TABLE tblJumlah1
(
atribut VARCHAR(40),
informasi VARCHAR(20),
JumlahData INT,
Demam INT,
Flu INT,
entropy DECIMAL(8,4),
gain DECIMAL(8,4)
);

SELECT COUNT(*) INTO @SakitTenggorokantidakJumlahData
FROM tblC45
WHERE SakitTenggorokan = 'tidak';

SELECT COUNT(*) INTO @SakitTenggorokantidakDemam
FROM tblC45
WHERE SakitTenggorokan = 'tidak' AND diagnosa = 'Demam';

SELECT COUNT(*) INTO @SakitTenggorokantidakFlu
FROM tblC45
WHERE SakitTenggorokan = 'tidak' AND diagnosa = 'Flu';

SELECT (-(@SakitTenggorokantidakDemam/@SakitTenggorokantidakJumlahData) * log2(@SakitTenggorokantidakDemam/@SakitTenggorokantidakJumlahData))
+
(-(@SakitTenggorokantidakFlu/@SakitTenggorokantidakJumlahData)*log2(@SakitTenggorokantidakFlu/@SakitTenggorokantidakJumlahData))
INTO @SakitTenggorokantidakentropy;

SELECT @SakitTenggorokantidakJumlahData AS JUM_DATA,
@SakitTenggorokantidakDemam AS JAWAB_NO,
@SakitTenggorokantidakFlu AS JAWAB_YES,
ROUND(@SakitTenggorokantidakentropy, 4) AS ENTROPY;

INSERT INTO tblJumlah1(atribut, JumlahData, Demam, Flu, entropy) VALUES
('SAKIT TENGGOROKAN', @SakitTenggorokantidakJumlahData, @SakitTenggorokantidakDemam, @SakitTenggorokantidakFlu, @SakitTenggorokantidakentropy);

SELECT * FROM tblJumlah1;

/*Demam*/
INSERT INTO tblJumlah1(informasi, JumlahData, Demam, Flu)
	SELECT A.Demam AS DEMAM, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.Diagnosa = 'Demam' AND B.Demam = A.Demam AND B.SakitTenggorokan = 'tidak'
	) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.Diagnosa = 'Flu' AND C.Demam = A.Demam AND C.SakitTenggorokan = 'tidak'
	) AS 'FLU'
	FROM tblC45 AS A
	WHERE A.SakitTenggorokan = 'tidak'
	GROUP BY A.Demam;

UPDATE tblJumlah1 SET atribut = 'DEMAM' WHERE atribut IS NULL;

/*SakitKepala*/
INSERT INTO tblJumlah1(informasi, JumlahData, Demam, Flu)
	SELECT A.SakitKepala AS SAKITKEPALA, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.Diagnosa = 'Demam' AND B.SakitKepala = A.SakitKepala AND B.SakitTenggorokan = 'tidak'
	) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.Diagnosa = 'Flu' AND C.SakitKepala = A.SakitKepala AND C.SakitTenggorokan = 'tidak'
	) AS 'FLU'
	FROM tblC45 AS A
	WHERE A.SakitTenggorokan = 'tidak'
	GROUP BY A.SakitKepala;

UPDATE tblJumlah1 SET atribut = 'SAKITKEPALA' WHERE atribut IS NULL;

/*Nyeri*/
INSERT INTO tblJumlah1(informasi, JumlahData, Demam, Flu)
	SELECT A.Nyeri AS NYERI, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.Diagnosa = 'Demam' AND B.Nyeri = A.Nyeri AND B.SakitTenggorokan = 'tidak'
	) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.Diagnosa = 'Flu' AND C.Nyeri = A.Nyeri AND C.SakitTenggorokan = 'tidak'
	) AS 'FLU'
	FROM tblC45 AS A
	WHERE A.SakitTenggorokan = 'tidak'
	GROUP BY A.Nyeri;

UPDATE tblJumlah1 SET atribut = 'NYERI' WHERE atribut IS NULL;

/*Lemas*/
INSERT INTO tblJumlah1(informasi, JumlahData, Demam, Flu)
	SELECT A.Lemas AS LEMAS, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.Diagnosa = 'Demam' AND B.Lemas = A.Lemas AND B.SakitTenggorokan = 'tidak'
	) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.Diagnosa = 'Flu' AND C.Lemas = A.Lemas AND C.SakitTenggorokan = 'tidak'
	) AS 'FLU'
	FROM tblC45 AS A
	WHERE A.SakitTenggorokan = 'tidak'
	GROUP BY A.Lemas;

UPDATE tblJumlah1 SET atribut = 'LEMAS' WHERE atribut IS NULL;

/*Kelelahan*/
INSERT INTO tblJumlah1(informasi, JumlahData, Demam, Flu)
	SELECT A.Kelelahan AS KELELAHAN, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.Diagnosa = 'Demam' AND B.Kelelahan = A.Kelelahan AND B.SakitTenggorokan = 'tidak'
	) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.Diagnosa = 'Flu' AND C.Kelelahan = A.Kelelahan AND C.SakitTenggorokan = 'tidak'
	) AS 'FLU'
	FROM tblC45 AS A
	WHERE A.SakitTenggorokan = 'tidak'
	GROUP BY A.Kelelahan;

UPDATE tblJumlah1 SET atribut = 'KELELAHAN' WHERE atribut IS NULL;

/*HidungTersumbat*/
INSERT INTO tblJumlah1(informasi, JumlahData, Demam, Flu)
	SELECT A.HidungTersumbat AS HIDUNGTERSUMBAT, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.Diagnosa = 'Demam' AND B.HidungTersumbat = A.HidungTersumbat AND B.SakitTenggorokan = 'tidak'
	) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.Diagnosa = 'Flu' AND C.HidungTersumbat = A.HidungTersumbat AND C.SakitTenggorokan = 'tidak'
	) AS 'FLU'
	FROM tblC45 AS A
	WHERE A.SakitTenggorokan = 'tidak'
	GROUP BY A.HidungTersumbat;

UPDATE tblJumlah1 SET atribut = 'HIDUNGTERSUMBAT' WHERE atribut IS NULL;

/*Bersin*/
INSERT INTO tblJumlah1(informasi, JumlahData, Demam, Flu)
	SELECT A.Bersin AS BERSIN, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.Diagnosa = 'Demam' AND B.Bersin = A.Bersin AND B.SakitTenggorokan = 'tidak'
	) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.Diagnosa = 'Flu' AND C.Bersin = A.Bersin AND C.SakitTenggorokan = 'tidak'
	) AS 'FLU'
	FROM tblC45 AS A
	WHERE A.SakitTenggorokan = 'tidak'
	GROUP BY A.Bersin;

UPDATE tblJumlah1 SET atribut = 'BERSIN' WHERE atribut IS NULL;

/*SulitBernapas*/
INSERT INTO tblJumlah1(informasi, JumlahData, Demam, Flu)
	SELECT A.SulitBernapas AS SULITBERNAPAS, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.Diagnosa = 'Demam' AND B.SulitBernapas = A.SulitBernapas AND B.SakitTenggorokan = 'tidak'
	) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.Diagnosa = 'Flu' AND C.SulitBernapas = A.SulitBernapas AND C.SakitTenggorokan = 'tidak'
	) AS 'FLU'
	FROM tblC45 AS A
	WHERE A.SakitTenggorokan = 'tidak'
	GROUP BY A.SulitBernapas;

/*Entropy*/
UPDATE tblJumlah1 SET entropy = (-(Demam/JumlahData) * log2(Demam/JumlahData))
+
(-(Flu/JumlahData) * log2(Flu/JumlahData));

UPDATE tblJumlah1 SET entropy = 0 WHERE entropy IS NULL;

/*Gain*/
DROP TABLE IF EXISTS tblSimpan1;
CREATE TEMPORARY TABLE tblSimpan1
(
atribut VARCHAR(20),
gain DECIMAL(8, 4)
);

INSERT INTO tblSimpan1(atribut, gain)
SELECT atribut, @SakitTenggorokantidakentropy -
SUM((jumlahdata/@SakitTenggorokantidakJumlahData) * entropy) AS GAIN
FROM tblJumlah1
GROUP BY atribut;

SELECT * FROM tblSimpan1;

UPDATE tblJumlah1 SET GAIN =
	(
	SELECT gain
	FROM tblSimpan1
	WHERE atribut = tblJumlah1.atribut
	);

SELECT * FROM tblJumlah1;


/*Iterasi 3*/
SELECT MAX(tblJumlah1.gain) AS
maximal
FROM tblJumlah1;

CREATE TABLE tblJumlah2
(
atribut VARCHAR(40),
informasi VARCHAR(20),
JumlahData INT,
Demam INT,
Flu INT,
entropy DECIMAL(8,4),
gain DECIMAL(8,4)
);

SELECT COUNT(*) INTO @SulitBernapasringanJumlahData
FROM tblC45
WHERE SakitTenggorokan = 'ringan';

SELECT COUNT(*) INTO @SulitBernapasringanDemam
FROM tblC45
WHERE SulitBernapas = 'ringan' AND diagnosa = 'Demam';

SELECT COUNT(*) INTO @SulitBernapasringanFlu
FROM tblC45
WHERE SulitBernapas = 'ringan' AND diagnosa = 'Flu';

SELECT (-(@SulitBernapasringanDemam/@SulitBernapasringanJumlahData) * log2(@SulitBernapasringanDemam/@SulitBernapasringanJumlahData))
+
(-(@SulitBernapasringanFlu/@SulitBernapasringanJumlahData)*log2(@SulitBernapasringanFlu/@SulitBernapasringanJumlahData))
INTO @SulitBernapasringanentropy;

SELECT @SulitBernapasringanJumlahData AS JUM_DATA,
@SulitBernapasringanDemam AS JAWAB_NO,
@SulitBernapasringanFlu AS JAWAB_YES,
ROUND(@SulitBernapasringanentropy, 4) AS ENTROPY;

INSERT INTO tblJumlah2(atribut, JumlahData, Demam, Flu, entropy) VALUES
('SULIT BERNAPAS', @SulitBernapasringanJumlahData, @SulitBernapasringanDemam, @SulitBernapasringanFlu, @SulitBernapasringanentropy);

SELECT * FROM tblJumlah2;

/*Demam*/
INSERT INTO tblJumlah2(informasi, JumlahData, Demam, Flu)
	SELECT A.Demam AS DEMAM, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.Diagnosa = 'Demam' AND B.Demam = A.Demam AND B.SulitBernapas = 'ringan'
	) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.Diagnosa = 'Flu' AND C.Demam = A.Demam AND C.SulitBernapas = 'ringan'
	) AS 'FLU'
	FROM tblC45 AS A
	WHERE A.SulitBernapas = 'ringan'
	GROUP BY A.Demam;

UPDATE tblJumlah2 SET atribut = 'DEMAM' WHERE atribut IS NULL;

/*SakitKepala*/
INSERT INTO tblJumlah2(informasi, JumlahData, Demam, Flu)
	SELECT A.SakitKepala AS SAKITKEPALA, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.Diagnosa = 'Demam' AND B.SakitKepala = A.SakitKepala AND B.SulitBernapas = 'ringan'
	) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.Diagnosa = 'Flu' AND C.SakitKepala = A.SakitKepala AND C.SulitBernapas = 'ringan'
	) AS 'FLU'
	FROM tblC45 AS A
	WHERE A.SulitBernapas = 'ringan'
	GROUP BY A.SakitKepala;

UPDATE tblJumlah2 SET atribut = 'SAKITKEPALA' WHERE atribut IS NULL;

/*Nyeri*/
INSERT INTO tblJumlah2(informasi, JumlahData, Demam, Flu)
	SELECT A.Nyeri AS NYERI, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.Diagnosa = 'Demam' AND B.Nyeri = A.Nyeri AND B.SulitBernapas= 'ringan'
	) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.Diagnosa = 'Flu' AND C.Nyeri = A.Nyeri AND C.SulitBernapas = 'ringan'
	) AS 'FLU'
	FROM tblC45 AS A
	WHERE A.SulitBernapas = 'ringan'
	GROUP BY A.Nyeri;

UPDATE tblJumlah2 SET atribut = 'NYERI' WHERE atribut IS NULL;

/*Lemas*/
INSERT INTO tblJumlah2(informasi, JumlahData, Demam, Flu)
	SELECT A.Lemas AS LEMAS, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.Diagnosa = 'Demam' AND B.Lemas = A.Lemas AND B.SulitBernapas = 'ringan'
	) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.Diagnosa = 'Flu' AND C.Lemas = A.Lemas AND C.SulitBernapas = 'ringan'
	) AS 'FLU'
	FROM tblC45 AS A
	WHERE A.SulitBernapas = 'ringan'
	GROUP BY A.Lemas;

UPDATE tblJumlah2 SET atribut = 'LEMAS' WHERE atribut IS NULL;

/*Kelelahan*/
INSERT INTO tblJumlah2(informasi, JumlahData, Demam, Flu)
	SELECT A.Kelelahan AS KELELAHAN, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.Diagnosa = 'Demam' AND B.Kelelahan = A.Kelelahan AND B.SulitBernapas = 'ringan'
	) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.Diagnosa = 'Flu' AND C.Kelelahan = A.Kelelahan AND C.SulitBernapas = 'ringan'
	) AS 'FLU'
	FROM tblC45 AS A
	WHERE A.SulitBernapas = 'ringan'
	GROUP BY A.Kelelahan;

UPDATE tblJumlah2 SET atribut = 'KELELAHAN' WHERE atribut IS NULL;

/*HidungTersumbat*/
INSERT INTO tblJumlah2(informasi, JumlahData, Demam, Flu)
	SELECT A.HidungTersumbat AS HIDUNGTERSUMBAT, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.Diagnosa = 'Demam' AND B.HidungTersumbat = A.HidungTersumbat AND B.SulitBernapas = 'ringan'
	) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.Diagnosa = 'Flu' AND C.HidungTersumbat = A.HidungTersumbat AND C.SulitBernapas = 'ringan'
	) AS 'FLU'
	FROM tblC45 AS A
	WHERE A.SulitBernapas = 'ringan'
	GROUP BY A.HidungTersumbat;

UPDATE tblJumlah2 SET atribut = 'HIDUNGTERSUMBAT' WHERE atribut IS NULL;

/*Bersin*/
INSERT INTO tblJumlah2(informasi, JumlahData, Demam, Flu)
	SELECT A.Bersin AS BERSIN, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.Diagnosa = 'Demam' AND B.Bersin = A.Bersin AND B.SulitBernapas = 'ringan'
	) AS 'DEMAM',

		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.Diagnosa = 'Flu' AND C.Bersin = A.Bersin AND C.SulitBernapas = 'ringan'
	) AS 'FLU'
	FROM tblC45 AS A
	WHERE A.SulitBernapas = 'ringan'
	GROUP BY A.Bersin;

UPDATE tblJumlah2 SET atribut = 'BERSIN' WHERE atribut IS NULL;

/*Entropy*/
UPDATE tblJumlah2 SET entropy = (-(Demam/JumlahData) * log2(Demam/JumlahData))
+
(-(Flu/JumlahData) * log2(Flu/JumlahData));

UPDATE tblJumlah2 SET entropy = 0 WHERE entropy IS NULL;

/*Gain*/
DROP TABLE IF EXISTS tblSimpan2;
CREATE TEMPORARY TABLE tblSimpan2
(
atribut VARCHAR(20),
gain DECIMAL(8, 4)
);

INSERT INTO tblSimpan2(atribut, gain)
SELECT atribut, @SakitTenggorokantidakentropy -
SUM((jumlahdata/@SakitTenggorokantidakJumlahData) * entropy) AS GAIN
FROM tblJumlah2
GROUP BY atribut;

SELECT * FROM tblSimpan1;

UPDATE tblJumlah2 SET GAIN =
	(
	SELECT gain
	FROM tblSimpan2
	WHERE atribut = tblJumlah2.atribut
	);

SELECT * FROM tblJumlah2;
