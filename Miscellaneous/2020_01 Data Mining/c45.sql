DROP DATABASE IF EXISTS 18k10082_c45;
CREATE DATABASE 18k10082_c45;
USE 18k10082_c45;

CREATE TABLE tblC45(
	nourut INT,
	outlook VARCHAR(10),
	temperature VARCHAR(10),
	humadity VARCHAR(10),
	windy VARCHAR(10),
	play VARCHAR(10)
);

load data local infile "dbC45.csv"
into table tblC45
fields terminated by ";"
enclosed by ''''
ignore 1 lines;

-- SELECT * FROM tblC45;

CREATE TABLE tblHitung(
	iterasi INT,
	atribut VARCHAR(20),
	informasi VARCHAR(20),
	jumlahdata INT,
	playno INT,
	playyes INT,
	entropy DECIMAL(8,4),
	gain DECIMAL(8,4)
);

/*Menghitung(semua) untuk ITERASI 1*/
SELECT COUNT(*) INTO @jumlahdata FROM tblC45;
SELECT COUNT(*) INTO @playno FROM tblC45 WHERE play = 'no';
SELECT COUNT(*) INTO @playyes FROM tblC45 WHERE play = 'yes';
SELECT (-(@playno/@jumlahdata) * log2(@playno/@jumlahdata)) + (-(@playyes/@jumlahdata) * log2(@playyes/@jumlahdata)) INTO @entropy;
SELECT @jumlahdata AS JUMLAH_DATA, @playno JAWAB_NO, @playyes JAWAB_YES, ROUND(@entropy, 4) AS ENTROPY;

INSERT INTO tblHitung(atribut, jumlahdata, playno, playyes, entropy) VALUES
		('TOTAL', @jumlahdata, @playno, @playyes, @entropy);

/*OUTLOOK*/
INSERT INTO tblHitung(iterasi, atribut,informasi, jumlahdata, playno, playyes)
	SELECT 1,
		  'outlook',
		   A.outlook,
		   COUNT(*) AS JUMLAH_DATA,
		   (SELECT COUNT(*) FROM tblC45 AS B WHERE B.play = 'no' AND B.outlook = A.outlook) AS NO,
		   (SELECT COUNT(*) FROM tblC45 AS B WHERE B.play = 'yes' AND B.outlook = A.outlook) AS YES
	FROM tblC45 AS A
	GROUP BY A.outlook;

-- TEMPERATURE
INSERT INTO tblHitung(iterasi, atribut,informasi, jumlahdata, playno, playyes)
	SELECT 1,
		  'temperature',
		   A.temperature,
		   COUNT(*) AS JUMLAH_DATA,
		   (SELECT COUNT(*) FROM tblC45 AS B WHERE B.play = 'no' AND B.temperature = A.temperature) AS NO,
		   (SELECT COUNT(*) FROM tblC45 AS B WHERE B.play = 'yes' AND B.temperature = A.temperature) AS YES
	FROM tblC45 AS A
	GROUP BY A.temperature;

-- HUMADITY
INSERT INTO tblHitung(iterasi, atribut,informasi, jumlahdata, playno, playyes)
	SELECT 1,
		  'humadity',
		   A.humadity,
		   COUNT(*) AS JUMLAH_DATA,
		   (SELECT COUNT(*) FROM tblC45 AS B WHERE B.play = 'no' AND B.humadity = A.humadity) AS NO,
		   (SELECT COUNT(*) FROM tblC45 AS B WHERE B.play = 'yes' AND B.humadity = A.humadity) AS YES
	FROM tblC45 AS A
	GROUP BY A.humadity;

-- WINDY
INSERT INTO tblHitung(iterasi, atribut,informasi, jumlahdata, playno, playyes)
	SELECT 1,
		  'windy',
		   A.windy,
		   COUNT(*) AS JUMLAH_DATA,
		   (SELECT COUNT(*) FROM tblC45 AS B WHERE B.play = 'no' AND B.windy = A.windy) AS NO,
		   (SELECT COUNT(*) FROM tblC45 AS B WHERE B.play = 'yes' AND B.windy = A.windy) AS YES
	FROM tblC45 AS A
	GROUP BY A.windy;

UPDATE tblHitung SET entropy = (-(playno/jumlahdata) * log2(playno/jumlahdata)) + (-(playyes/jumlahdata) * log2(playyes/jumlahdata));
UPDATE tblHitung SET entropy = 0 WHERE entropy IS NULL;

-- SELECT * FROM tblHitung;

DROP TABLE IF EXISTS tblTampung;
CREATE TEMPORARY TABLE tblTampung(
	atribut VARCHAR(20)	,
	gain DECIMAL(8,4)
);

INSERT INTO tblTampung(atribut, gain)
SELECT atribut,
	   @entropy - SUM((jumlahdata/@jumlahdata) * entropy) AS GAIN
FROM tblHitung
GROUP BY atribut;

UPDATE tblHitung SET GAIN =
(
	SELECT gain
	FROM tblTampung
	WHERE atribut = tblHitung.atribut
);

-- SELECT * FROM tblTampung;
-- SELECT * FROM tblHitung;

CREATE TABLE tblHitung2(
	iterasi INT,
	atribut VARCHAR(20),
	informasi VARCHAR(20),
	jumlahdata INT,
	playno INT,
	playyes INT,
	entropy DECIMAL(8,4),
	gain DECIMAL(8,4)
);

/*Menghitung(semua) untuk ITERASI 2*/
SELECT COUNT(*) INTO @jumlahdata FROM tblC45 WHERE humadity = 'high';
SELECT COUNT(*) INTO @playno FROM tblC45 WHERE play = 'no' AND humadity = 'high';
SELECT COUNT(*) INTO @playyes FROM tblC45 WHERE play = 'yes' AND humadity = 'high';
SELECT (-(@playno/@jumlahdata) * log2(@playno/@jumlahdata)) + (-(@playyes/@jumlahdata) * log2(@playyes/@jumlahdata)) INTO @entropy;
SELECT @jumlahdata AS JUM_DATA, @playno JAWAB_NO, @playyes JAWAB_YES, ROUND(@entropy, 4) AS ENTROPY;
INSERT INTO tblHitung(atribut, informasi, jumlahdata, playno, playyes, entropy) VALUES
	('HUMADITY', 'HIGH', @jumlahdata, @playno, @playyes, @entropy);


/*OUTLOOK*/
INSERT INTO tblHitung2(iterasi, atribut,informasi, jumlahdata, playno, playyes)
	SELECT 2,
	  'outlook',
	   A.outlook,
	   COUNT(*) AS JUMLAH_DATA,
	   (SELECT COUNT(*) FROM tblC45 AS B WHERE B.play = 'no' AND B.outlook = A.outlook AND B.humadity = 'High') AS NO,
	   (SELECT COUNT(*) FROM tblC45 AS B WHERE B.play = 'yes' AND B.outlook = A.outlook AND B.humadity = 'High') AS YES
FROM tblC45 AS A
WHERE A.humadity = 'High'
GROUP BY A.outlook;
/*Temperature*/
INSERT INTO tblHitung2(iterasi, atribut,informasi, jumlahdata, playno, playyes)
	SELECT 2,
	  'temperature',
	   A.temperature,
	   COUNT(*) AS JUMLAH_DATA,
	   (SELECT COUNT(*) FROM tblC45 AS B WHERE B.play = 'no' AND B.temperature = A.temperature AND B.humadity = 'High') AS NO,
	   (SELECT COUNT(*) FROM tblC45 AS B WHERE B.play = 'yes' AND B.temperature = A.temperature AND B.humadity = 'High') AS YES
FROM tblC45 AS A
WHERE A.humadity = 'High'
GROUP BY A.temperature;
/*WINDY*/
INSERT INTO tblHitung2(iterasi, atribut,informasi, jumlahdata, playno, playyes)
	SELECT 2,
	  'windy',
	   A.windy,
	   COUNT(*) AS JUMLAH_DATA,
	   (SELECT COUNT(*) FROM tblC45 AS B WHERE B.play = 'no' AND B.windy = A.windy AND B.humadity = 'High') AS NO,
	   (SELECT COUNT(*) FROM tblC45 AS B WHERE B.play = 'yes' AND B.windy = A.windy AND B.humadity = 'High') AS YES
FROM tblC45 AS A
WHERE A.humadity = 'High'
GROUP BY A.windy;

UPDATE tblHitung SET entropy = (-(playno/jumlahdata) * log2(playno/jumlahdata)) + (-(playyes/jumlahdata) * log2(playyes/jumlahdata));
UPDATE tblHitung SET entropy = 0 WHERE entropy IS NULL;
	-- SELECT * FROM tblHitung;
DROP TABLE IF EXISTS tblTampung;
CREATE TEMPORARY TABLE tblTampung(
	atribut VARCHAR(20)	,
	gain DECIMAL(8,4)
);
-- TRUNCATE TABLE tblTampung;
	INSERT INTO tblTampung(atribut, gain)
SELECT atribut,
	   @entropy - SUM((jumlahdata/@jumlahdata) * entropy) AS GAIN
FROM tblHitung
WHERE iterasi = 2
GROUP BY atribut;
	UPDATE tblHitung SET GAIN =
(
	SELECT gain
	FROM tblTampung
	WHERE atribut = tblHitung.atribut
)
WHERE iterasi = 2;

SELECT * FROM tblTampung;
SELECT * FROM tblHitung;

/*Menghitung(semua) untuk ITERASI 3*/
SELECT COUNT(*) INTO @jumlahdata FROM tblC45 WHERE humadity = 'high' AND outlook = 'Rainy';
SELECT COUNT(*) INTO @playno FROM tblC45 WHERE play = 'no' AND humadity = 'high' AND outlook = 'Rainy';
SELECT COUNT(*) INTO @playyes FROM tblC45 WHERE play = 'yes' AND humadity = 'high' AND outlook = 'Rainy';
SELECT (-(@playno/@jumlahdata) * log2(@playno/@jumlahdata)) + (-(@playyes/@jumlahdata) * log2(@playyes/@jumlahdata)) INTO @entropy;
SELECT @jumlahdata AS JUM_DATA, @playno JAWAB_NO, @playyes JAWAB_YES, ROUND(@entropy, 4) AS ENTROPY;
INSERT INTO tblHitung(atribut, informasi, jumlahdata, playno, playyes, entropy) VALUES
	('OUTLOOK', 'Rainy', @jumlahdata, @playno, @playyes, @entropy);

/*Temperature*/
INSERT INTO tblHitung(iterasi, atribut,informasi, jumlahdata, playno, playyes)
SELECT 3,
	  'Temperature',
	   A.temperature,
	   COUNT(*) AS JUMLAH_DATA,
	   (SELECT COUNT(*) FROM tblC45 AS B WHERE B.play = 'no' AND B.temperature = A.temperature AND B.humadity = 'High' AND outlook = 'Rainy') AS NO,
	   (SELECT COUNT(*) FROM tblC45 AS B WHERE B.play = 'yes' AND B.temperature = A.temperature AND B.humadity = 'High' AND outlook = 'Rainy') AS YES
FROM tblC45 AS A
WHERE A.humadity = 'High' AND outlook = 'Rainy'
GROUP BY A.temperature;
/*WINDY*/
INSERT INTO tblHitung(iterasi, atribut,informasi, jumlahdata, playno, playyes)
SELECT 3,
	  'windy',
	   A.windy,
	   COUNT(*) AS JUMLAH_DATA,
	   (SELECT COUNT(*) FROM tblC45 AS B WHERE B.play = 'no' AND B.windy = A.windy AND B.humadity = 'High' AND outlook = 'Rainy') AS NO,
	   (SELECT COUNT(*) FROM tblC45 AS B WHERE B.play = 'yes' AND B.windy = A.windy AND B.humadity = 'High' AND outlook = 'Rainy') AS YES
FROM tblC45 AS A
WHERE A.humadity = 'High' AND outlook = 'Rainy'
GROUP BY A.windy;

UPDATE tblHitung SET entropy = (-(playno/jumlahdata) * log2(playno/jumlahdata)) + (-(playyes/jumlahdata) * log2(playyes/jumlahdata));
UPDATE tblHitung SET entropy = 0 WHERE entropy IS NULL;

	-- SELECT * FROM tblHitung;

DROP TABLE IF EXISTS tblTampung;
CREATE TEMPORARY TABLE tblTampung(
	atribut VARCHAR(20)	,
	gain DECIMAL(8,4)
);

TRUNCATE TABLE tblTampung;
INSERT INTO tblTampung(atribut, gain)
SELECT atribut,
	   @entropy - SUM((jumlahdata/@jumlahdata) * entropy) AS GAIN
FROM tblHitung
WHERE iterasi = 3
GROUP BY atribut;

UPDATE tblHitung SET GAIN =
(
	SELECT gain
	FROM tblTampung
	WHERE atribut = tblHitung.atribut
)
WHERE iterasi = 3;

UPDATE tblHitung SET GAIN=0 WHERE GAIN IS NULL;

SELECT * FROM tblTampung;
SELECT * FROM tblHitung;
