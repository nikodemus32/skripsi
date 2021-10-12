/*NIM   : 16K10058
  NAMA  : EDRICK MINSON S
  FILE  : UAS DATA MINING
*/

DROP DATABASE IF EXISTS dbUAS;
CREATE DATABASE dbUAS;
USE dbUAS;

CREATE TABLE tblUAS
(
pasien VARCHAR(10),
sakit_demam VARCHAR(10),
sakit_kepala VARCHAR(10),
nyeri VARCHAR(10),
lemas VARCHAR(10),
kelelahan VARCHAR(10),
hidung_tesumbat VARCHAR(10),
bersin VARCHAR(10),
sakit_tenggorokan VARCHAR(10),
sulit_bernafas VARCHAR(10),
diagnosa VARCHAR(10)
);

INSERT INTO tblUAS VALUES
('P1','Tidak',	'Ringan',	'Tidak',	'Tidak',	'Tidak',	'Ringan',	'Parah',	'Parah',	'Ringan',	'Demam'),
('P2','Parah',	'Parah',	'Parah',	'Parah',	'Parah',	'Tidak',	'Tidak',	'Parah',	'Parah',	'Flu'),
('P3',	'Parah',	'Parah',	'Ringan',	'Parah',	'Parah',	'Parah',	'Tidak',	'Parah',	'Parah',	'Flu'),
('P4',	'Tidak',	'Tidak',	'Tidak',	'Ringan',	'Tidak',	'Parah',	'Tidak',	'Ringan',	'Ringan',	'Demam'),
('P5',	'Parah',	'Parah',	'Ringan',	'Parah',	'Parah',	'Parah',	'Tidak',	'Parah',	'Parah',	'Flu'),
('P6',	'Tidak',	'Tidak',	'Tidak',	'Ringan',	'Tidak',	'Parah',	'Parah',	'Parah',	'Tidak',	'Demam'),
('P7',	'Parah',	'Parah',	'Parah',	'Parah',	'Parah',	'Tidak',	'Tidak',	'Tidak',	'Parah',	'Flu'),
('P8',	'Tidak',	'Tidak',	'Tidak',	'Tidak',	'Tidak',	'Parah',	'Parah',	'Tidak',	'Ringan',	'Demam'),
('P9',	'Tidak',	'Ringan',	'Ringan',	'Tidak',	'Tidak',	'Parah',	'Parah',	'Parah',	'Parah',	'Demam'),
('P10',	'Parah',	'Parah',	'Parah',	'Ringan',	'Ringan',	'Tidak',	'Parah',	'Tidak',	'Parah',	'Flu'),
('P11',	'Tidak',	'Tidak',	'Tidak',	'Ringan',	'Tidak',	'Parah',	'Ringan',	'Parah',	'Tidak',	'Demam'),
('P12',	'Parah',	'Ringan',	'Parah',	'Ringan',	'Parah',	'Tidak',	'Parah',	'Tidak',	'Ringan',	'Flu'),
('P13',	'Tidak',	'Tidak',	'Ringan',	'Ringan',	'Tidak',	'Parah',	'Parah',	'Parah',	'Tidak',	'Demam'),
('P14',	'Parah',	'Parah',	'Parah',	'Parah',	'Ringan',	'Tidak',	'Parah',	'Parah',	'Parah',	'Flu'),
('P15',	'Ringan',	'Tidak',	'Tidak',	'Ringan',	'Tidak',	'Parah',	'Tidak',	'Parah',	'Ringan',	'Demam'),
('P16',	'Tidak',	'Tidak',	'Tidak',	'Tidak',	'Tidak',	'Parah',	'Parah',	'Parah',	'Parah',	'Demam'),
('P17',	'Parah',	'Ringan',	'Parah',	'Ringan',	'Ringan',	'Tidak',	'Tidak',	'Tidak',	'Parah',	'Flu');


SELECT * FROM tblUAS;


CREATE TABLE tblHitungan
(
gejala VARCHAR(20),
kondisi VARCHAR(20),
jumlahdata INT,
demam INT,
flu INT,
entropy DECIMAL(8,4),
gain DECIMAL(8,4)
);

CREATE TABLE tblHitungan2
(
gejala VARCHAR(20),
kondisi VARCHAR(20),
jumlahdata INT,
demam INT,
flu INT,
entropy DECIMAL(8,4),
gain DECIMAL(8,4)
);

set @jumlahdata =0;
set @demam=0;
set @flu=0;
set @entropy=0;

SELECT COUNT(*) FROM tblUAS
INTO @jumlahdata;

SELECT COUNT(*) FROM tblUAS
WHERE diagnosa = 'Demam'
INTO @demam;

SELECT COUNT(*) FROM tblUAS
WHERE diagnosa = 'Flu'
INTO @flu;

SELECT (-(@demam/@jumlahdata) * log2(@demam/@jumlahdata))
+
(-(@flu/@jumlahdata)*log2(@flu/@jumlahdata))
INTO @entropy;

SELECT @jumlahdata AS JUM_DATA,
@demam AS DEMAM,
@flu AS FLU,
ROUND(@entropy, 4) AS ENTROPY;

INSERT INTO tblHitungan(gejala, jumlahdata, demam, flu, entropy) VALUES
('TOTAL DATA', @jumlahdata, @demam, @flu, @entropy);

SELECT * FROM tblHitungan;



/*melakukan proses untuk setiap gejala*/

/*sakit_demam*/
INSERT INTO tblHitungan(kondisi, jumlahdata, demam, flu)
	SELECT A.sakit_demam AS 'DEMAM', COUNT(*) AS JUMLAH_DATA,
	(
		SELECT COUNT(*)
		FROM tblUAS AS B
		WHERE B.diagnosa = 'Demam' AND B.sakit_demam = A.sakit_demam
	) AS 'DEMAM',
	(
		SELECT COUNT(*)
		FROM tblUAS AS C
		WHERE C.diagnosa = 'Flu' AND C.sakit_demam = A.sakit_demam
	) AS 'FLU'
	FROM tblUAS AS A
	GROUP BY A.sakit_demam;

UPDATE tblHitungan SET gejala = 'Demam' WHERE gejala IS NULL;

/*sakit_kepala*/
INSERT INTO tblHitungan(kondisi, jumlahdata, demam, flu)
	SELECT A.sakit_kepala AS 'SAKIT KEPALA', COUNT(*) AS JUMLAH_DATA,
	(
		SELECT COUNT(*)
		FROM tblUAS AS B
		WHERE B.diagnosa = 'Demam' AND B.sakit_kepala = A.sakit_kepala
	) AS 'DEMAM',
	(
		SELECT COUNT(*)
		FROM tblUAS AS C
		WHERE C.diagnosa = 'Flu' AND C.sakit_kepala = A.sakit_kepala
	) AS 'FLU'
	FROM tblUAS AS A
	GROUP BY A.sakit_kepala;

UPDATE tblHitungan SET gejala = 'Sakit Kepala' WHERE gejala IS NULL;

/*nyeri*/
INSERT INTO tblHitungan(kondisi, jumlahdata, demam, flu)
	SELECT A.nyeri AS 'NYERI', COUNT(*) AS JUMLAH_DATA,
	(
		SELECT COUNT(*)
		FROM tblUAS AS B
		WHERE B.diagnosa = 'Demam' AND B.nyeri = A.nyeri
	) AS 'DEMAM',
	(
		SELECT COUNT(*)
		FROM tblUAS AS C
		WHERE C.diagnosa = 'Flu' AND C.nyeri = A.nyeri
	) AS 'FLU'
	FROM tblUAS AS A
	GROUP BY A.nyeri;

UPDATE tblHitungan SET gejala = 'Nyeri' WHERE gejala IS NULL;

/*lemas*/
INSERT INTO tblHitungan(kondisi, jumlahdata, demam, flu)
	SELECT A.lemas AS 'LEMAS', COUNT(*) AS JUMLAH_DATA,
	(
		SELECT COUNT(*)
		FROM tblUAS AS B
		WHERE B.diagnosa = 'Demam' AND B.lemas = A.lemas
	) AS 'DEMAM',
	(
		SELECT COUNT(*)
		FROM tblUAS AS C
		WHERE C.diagnosa = 'Flu' AND C.lemas = A.lemas
	) AS 'FLU'
	FROM tblUAS AS A
	GROUP BY A.lemas;

UPDATE tblHitungan SET gejala = 'Lemas' WHERE gejala IS NULL;

/*kelelahan*/
INSERT INTO tblHitungan(kondisi, jumlahdata, demam, flu)
	SELECT A.kelelahan AS 'kelelahan', COUNT(*) AS JUMLAH_DATA,
	(
		SELECT COUNT(*)
		FROM tblUAS AS B
		WHERE B.diagnosa = 'Demam' AND B.kelelahan = A.kelelahan
	) AS 'DEMAM',
	(
		SELECT COUNT(*)
		FROM tblUAS AS C
		WHERE C.diagnosa = 'Flu' AND C.kelelahan = A.kelelahan
	) AS 'FLU'
	FROM tblUAS AS A
	GROUP BY A.kelelahan;

UPDATE tblHitungan SET gejala = 'Kelelahan' WHERE gejala IS NULL;

/*hidung_tesumbat*/
INSERT INTO tblHitungan(kondisi, jumlahdata, demam, flu)
	SELECT A.hidung_tesumbat AS 'hidung_tesumbat', COUNT(*) AS JUMLAH_DATA,
	(
		SELECT COUNT(*)
		FROM tblUAS AS B
		WHERE B.diagnosa = 'Demam' AND B.hidung_tesumbat = A.hidung_tesumbat
	) AS 'DEMAM',
	(
		SELECT COUNT(*)
		FROM tblUAS AS C
		WHERE C.diagnosa = 'Flu' AND C.hidung_tesumbat = A.hidung_tesumbat
	) AS 'FLU'
	FROM tblUAS AS A
	GROUP BY A.hidung_tesumbat;

UPDATE tblHitungan SET gejala = 'Hidung Tersumbat' WHERE gejala IS NULL;

/*bersin*/
INSERT INTO tblHitungan(kondisi, jumlahdata, demam, flu)
	SELECT A.bersin AS 'bersin', COUNT(*) AS JUMLAH_DATA,
	(
		SELECT COUNT(*)
		FROM tblUAS AS B
		WHERE B.diagnosa = 'Demam' AND B.bersin = A.bersin
	) AS 'DEMAM',
	(
		SELECT COUNT(*)
		FROM tblUAS AS C
		WHERE C.diagnosa = 'Flu' AND C.bersin = A.bersin
	) AS 'FLU'
	FROM tblUAS AS A
	GROUP BY A.bersin;

UPDATE tblHitungan SET gejala = 'Bersin' WHERE gejala IS NULL;

/*sakit_tenggorokan*/
INSERT INTO tblHitungan(kondisi, jumlahdata, demam, flu)
	SELECT A.sakit_tenggorokan AS 'sakit_tenggorokan', COUNT(*) AS JUMLAH_DATA,
	(
		SELECT COUNT(*)
		FROM tblUAS AS B
		WHERE B.diagnosa = 'Demam' AND B.sakit_tenggorokan = A.sakit_tenggorokan
	) AS 'DEMAM',
	(
		SELECT COUNT(*)
		FROM tblUAS AS C
		WHERE C.diagnosa = 'Flu' AND C.sakit_tenggorokan = A.sakit_tenggorokan
	) AS 'FLU'
	FROM tblUAS AS A
	GROUP BY A.sakit_tenggorokan;

UPDATE tblHitungan SET gejala = 'Sakit Tenggorokan' WHERE gejala IS NULL;

/*sulit_bernafas*/
INSERT INTO tblHitungan(kondisi, jumlahdata, demam, flu)
	SELECT A.sulit_bernafas AS 'sulit_bernafas', COUNT(*) AS JUMLAH_DATA,
	(
		SELECT COUNT(*)
		FROM tblUAS AS B
		WHERE B.diagnosa = 'Demam' AND B.sulit_bernafas = A.sulit_bernafas
	) AS 'DEMAM',
	(
		SELECT COUNT(*)
		FROM tblUAS AS C
		WHERE C.diagnosa = 'Flu' AND C.sulit_bernafas = A.sulit_bernafas
	) AS 'FLU'
	FROM tblUAS AS A
	GROUP BY A.sulit_bernafas;

UPDATE tblHitungan SET gejala = 'Sulit Bernafas' WHERE gejala IS NULL;




/*menghitung entropy*/
UPDATE tblHitungan SET entropy = (-(demam/jumlahdata) * log2(demam/jumlahdata))
+
(-(flu/jumlahdata) * log2(flu/jumlahdata));

UPDATE tblHItungan SET entropy = 0 WHERE entropy IS NULL;

SELECT * FROM tblHitungan;

/*menghitung gain*/
DROP TABLE IF EXISTS tblGain;
CREATE TEMPORARY TABLE tblGain
(
gejala VARCHAR(20),
gain DECIMAL(8, 4)
);


INSERT INTO tblGain(gejala, gain)
SELECT gejala, @entropy -
SUM((jumlahdata/@jumlahdata) * entropy) AS GAIN
FROM tblHitungan
GROUP BY gejala;

SELECT * FROM tblGain;

UPDATE tblHitungan SET GAIN =
	(
	SELECT gain
	FROM tblGain
	WHERE gejala = tblHItungan.gejala
	);

SELECT * FROM tblHitungan;


/*ITERASI 2*/
SELECT * from tblUAS where sakit_kepala= 'Ringan';

set @jumlahdata2 =0;
set @demam2=0;
set @flu2=0;
set @entropy2=0;

SELECT COUNT(*) FROM tblUAS  where sakit_kepala= 'Ringan'
INTO @jumlahdata2;

SELECT COUNT(*) FROM tblUAS
WHERE diagnosa = 'Demam' AND sakit_kepala= 'Ringan'
INTO @demam2;

SELECT COUNT(*) FROM tblUAS
WHERE diagnosa = 'Flu' AND sakit_kepala= 'Ringan'
INTO @flu2;

SELECT (-(@demam2/@jumlahdata2) * log2(@demam2/@jumlahdata2))
+
(-(@flu2/@jumlahdata2)*log2(@flu2/@jumlahdata2))
INTO @entropy2;

SELECT @jumlahdata2 AS JUM_DATA,
@demam2 AS DEMAM,
@flu2 AS FLU,
ROUND(@entropy2, 4) AS ENTROPY;

INSERT INTO tblHitungan2(gejala, jumlahdata, demam, flu, entropy) VALUES
('Sakit Kepala Ringan', @jumlahdata2, @demam2, @flu2, @entropy2);

/*sakit_demam*/
INSERT INTO tblHitungan2(kondisi, jumlahdata, demam, flu)
	SELECT A.sakit_demam AS 'DEMAM', COUNT(*) AS JUMLAH_DATA,
	(
		SELECT COUNT(*)
		FROM tblUAS AS B
		WHERE B.diagnosa = 'Demam' AND B.sakit_demam = A.sakit_demam AND B.sakit_kepala = 'Ringan'
	) AS 'DEMAM',
	(
		SELECT COUNT(*)
		FROM tblUAS AS C
		WHERE C.diagnosa = 'Flu' AND C.sakit_demam = A.sakit_demam AND C.sakit_kepala='Ringan'
	) AS 'FLU'
	FROM tblUAS AS A
	where A.sakit_kepala = 'Ringan'
	GROUP BY A.sakit_demam;

UPDATE tblHitungan2 SET gejala = 'Demam' WHERE gejala IS NULL;


/*nyeri*/
INSERT INTO tblHitungan2(kondisi, jumlahdata, demam, flu)
	SELECT A.nyeri AS 'NYERI', COUNT(*) AS JUMLAH_DATA,
	(
		SELECT COUNT(*)
		FROM tblUAS AS B
		WHERE B.diagnosa = 'Demam' AND B.nyeri = A.nyeri AND B.sakit_kepala = 'Ringan'
	) AS 'DEMAM',
	(
		SELECT COUNT(*)
		FROM tblUAS AS C
		WHERE C.diagnosa = 'Flu' AND C.nyeri = A.nyeri AND C.sakit_kepala = 'Ringan'
	) AS 'FLU'
	FROM tblUAS AS A
	where A.sakit_kepala = 'Ringan'
	GROUP BY A.nyeri;

UPDATE tblHitungan2 SET gejala = 'Nyeri' WHERE gejala IS NULL;

/*lemas*/
INSERT INTO tblHitungan2(kondisi, jumlahdata, demam, flu)
	SELECT A.lemas AS 'LEMAS', COUNT(*) AS JUMLAH_DATA,
	(
		SELECT COUNT(*)
		FROM tblUAS AS B
		WHERE B.diagnosa = 'Demam' AND B.lemas = A.lemas AND B.sakit_kepala = 'Ringan'
	) AS 'DEMAM',
	(
		SELECT COUNT(*)
		FROM tblUAS AS C
		WHERE C.diagnosa = 'Flu' AND C.lemas = A.lemas AND C.sakit_kepala = 'Ringan'
	) AS 'FLU'
	FROM tblUAS AS A
	WHERE A.sakit_kepala = 'Ringan'
	GROUP BY A.lemas;

UPDATE tblHitungan2 SET gejala = 'Lemas' WHERE gejala IS NULL;

/*kelelahan*/
INSERT INTO tblHitungan2(kondisi, jumlahdata, demam, flu)
	SELECT A.kelelahan AS 'kelelahan', COUNT(*) AS JUMLAH_DATA,
	(
		SELECT COUNT(*)
		FROM tblUAS AS B
		WHERE B.diagnosa = 'Demam' AND B.kelelahan = A.kelelahan AND B.sakit_kepala = 'Ringan'
	) AS 'DEMAM',
	(
		SELECT COUNT(*)
		FROM tblUAS AS C
		WHERE C.diagnosa = 'Flu' AND C.kelelahan = A.kelelahan AND C.sakit_kepala = 'Ringan'
	) AS 'FLU'
	FROM tblUAS AS A
	where A.sakit_kepala = 'Ringan'
	GROUP BY A.kelelahan;

UPDATE tblHitungan2 SET gejala = 'Kelelahan' WHERE gejala IS NULL;

/*hidung_tesumbat*/
INSERT INTO tblHitungan2(kondisi, jumlahdata, demam, flu)
	SELECT A.hidung_tesumbat AS 'hidung_tesumbat', COUNT(*) AS JUMLAH_DATA,
	(
		SELECT COUNT(*)
		FROM tblUAS AS B
		WHERE B.diagnosa = 'Demam' AND B.hidung_tesumbat = A.hidung_tesumbat AND B.sakit_kepala = 'Ringan'
	) AS 'DEMAM',
	(
		SELECT COUNT(*)
		FROM tblUAS AS C
		WHERE C.diagnosa = 'Flu' AND C.hidung_tesumbat = A.hidung_tesumbat AND C.sakit_kepala = 'Ringan'
	) AS 'FLU'
	FROM tblUAS AS A
	where A.sakit_kepala = 'Ringan'
	GROUP BY A.hidung_tesumbat;

UPDATE tblHitungan2 SET gejala = 'Hidung Tersumbat' WHERE gejala IS NULL;

/*bersin*/
INSERT INTO tblHitungan2(kondisi, jumlahdata, demam, flu)
	SELECT A.bersin AS 'bersin', COUNT(*) AS JUMLAH_DATA,
	(
		SELECT COUNT(*)
		FROM tblUAS AS B
		WHERE B.diagnosa = 'Demam' AND B.bersin = A.bersin AND B.sakit_kepala = 'Ringan'
	) AS 'DEMAM',
	(
		SELECT COUNT(*)
		FROM tblUAS AS C
		WHERE C.diagnosa = 'Flu' AND C.bersin = A.bersin AND C.sakit_kepala = 'Ringan'
	) AS 'FLU'
	FROM tblUAS AS A
	where A.sakit_kepala= 'Ringan'
	GROUP BY A.bersin;

UPDATE tblHitungan2 SET gejala = 'Bersin' WHERE gejala IS NULL;

/*sakit_tenggorokan*/
INSERT INTO tblHitungan2(kondisi, jumlahdata, demam, flu)
	SELECT A.sakit_tenggorokan AS 'sakit_tenggorokan', COUNT(*) AS JUMLAH_DATA,
	(
		SELECT COUNT(*)
		FROM tblUAS AS B
		WHERE B.diagnosa = 'Demam' AND B.sakit_tenggorokan = A.sakit_tenggorokan AND B.sakit_kepala = 'Ringan'
	) AS 'DEMAM',
	(
		SELECT COUNT(*)
		FROM tblUAS AS C
		WHERE C.diagnosa = 'Flu' AND C.sakit_tenggorokan = A.sakit_tenggorokan AND C.sakit_kepala = 'Ringan'
	) AS 'FLU'
	FROM tblUAS AS A
	where A.sakit_kepala = 'Ringan'
	GROUP BY A.sakit_tenggorokan;

UPDATE tblHitungan2 SET gejala = 'Sakit Tenggorokan' WHERE gejala IS NULL;

/*sulit_bernafas*/
INSERT INTO tblHitungan2(kondisi, jumlahdata, demam, flu)
	SELECT A.sulit_bernafas AS 'sulit_bernafas', COUNT(*) AS JUMLAH_DATA,
	(
		SELECT COUNT(*)
		FROM tblUAS AS B
		WHERE B.diagnosa = 'Demam' AND B.sulit_bernafas = A.sulit_bernafas AND B.sakit_kepala = 'Ringan'
	) AS 'DEMAM',
	(
		SELECT COUNT(*)
		FROM tblUAS AS C
		WHERE C.diagnosa = 'Flu' AND C.sulit_bernafas = A.sulit_bernafas AND C.sakit_kepala = 'Ringan'
	) AS 'FLU'
	FROM tblUAS AS A
	where A.sakit_kepala = 'Ringan'
	GROUP BY A.sulit_bernafas;

UPDATE tblHitungan2 SET gejala = 'Sulit Bernafas' WHERE gejala IS NULL;




/*menghitung entropy*/
UPDATE tblHitungan2 SET entropy = (-(demam/jumlahdata) * log2(demam/jumlahdata))
+
(-(flu/jumlahdata) * log2(flu/jumlahdata));

UPDATE tblHItungan2 SET entropy = 0 WHERE entropy IS NULL;

SELECT * FROM tblHitungan2;

/*menghitung gain*/
DROP TABLE IF EXISTS tblGain2;
CREATE TEMPORARY TABLE tblGain2
(
gejala VARCHAR(20),
gain DECIMAL(8, 4)
);


INSERT INTO tblGain2(gejala, gain)
SELECT gejala, @entropy2 -
SUM((jumlahdata/@jumlahdata2) * entropy) AS GAIN
FROM tblHitungan2
GROUP BY gejala;

SELECT * FROM tblGain2;

UPDATE tblHitungan2 SET GAIN =
	(
	SELECT gain
	FROM tblGain2
	WHERE gejala = tblHItungan2.gejala
);

SELECT * FROM tblHitungan2;
