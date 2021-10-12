DROP DATABASE IF EXISTS dbC45;
CREATE DATABASE dbC45;
USE dbC45;

CREATE TABLE tblC45
(
nourut INT,
outlook VARCHAR(10),
temperature VARCHAR(10),
humadity VARCHAR(10),
windy VARCHAR(10),
play VARCHAR(10)
);

LOAD DATA LOCAL INFILE 'dbC45.csv'
INTO TABLE tblC45
FIELDS TERMINATED BY ';'
ENCLOSED BY ''''
IGNORE 1 LINES;

SELECT * FROM tblC45;

CREATE TABLE tblHitung
(
atribut VARCHAR(20),
informasi VARCHAR(20),
jumlahdata INT,
playno INT,
playyes INT,
entropy DECIMAL(8,4),
gain DECIMAL(8,4)
);

DESC tblHitung;

SELECT COUNT(*) INTO @jumlahdata
FROM tblC45;

SELECT COUNT(*) INTO @playno
FROM tblC45
WHERE play = 'no';

SELECT COUNT(*) INTO @playyes
FROM tblC45
WHERE play = 'yes';

SELECT (-(@playno/@jumlahdata) * log2(@playno/@jumlahdata))
+
(-(@playyes/@jumlahdata)*log2(@playyes/@jumlahdata))
INTO @entropy;

SELECT @jumlahdata AS JUM_DATA,
@playno AS JAWAB_NO,
@playyes AS JAWAB_YES,
ROUND(@entropy, 4) AS ENTROPY;

INSERT INTO tblHitung(atribut, jumlahdata, playno, playyes, entropy) VALUES
('TOTAL DATA', @jumlahdata, @playno, @playyes, @entropy);

SELECT * FROM tblHitung;

INSERT INTO tblHitung(informasi, jumlahdata, playno, playyes)
	SELECT A.outlook AS OUTLOOK, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.play = 'no' AND B.outlook = A.outlook
		) AS 'NO',
	
		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.play = 'yes' AND C.outlook = A.outlook
		) AS 'YES'
	FROM tblC45 AS A
	GROUP BY A.outlook;

UPDATE tblHitung SET atribut = 'OUTLOOK' WHERE atribut IS NULL;

/*TEMPERATURE*/
INSERT INTO tblHitung(informasi, jumlahdata, playno, playyes)
	SELECT A.temperature AS TEMPERATURE, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.play = 'no' AND B.temperature = A.temperature
		) AS 'NO',
	
		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.play = 'yes' AND C.temperature = A.temperature
		) AS 'YES'
	FROM tblC45 AS A
	GROUP BY A.temperature;

UPDATE tblHitung SET atribut = 'TEMPERATURE' WHERE atribut IS NULL;

/*HUMADITY*/
INSERT INTO tblHitung(informasi, jumlahdata, playno, playyes)
	SELECT A.humadity AS OUTLOOK, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.play = 'no' AND B.humadity = A.humadity
		) AS 'NO',
        
        (
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.play = 'yes' AND C.humadity = A.humadity
		) AS 'YES'
	FROM tblC45 AS A
	GROUP BY A.humadity;

UPDATE tblHitung SET atribut = 'HUMADITY' WHERE atribut IS NULL;

/*WINDY*/
INSERT INTO tblHitung(informasi, jumlahdata, playno, playyes)
	SELECT A.windy AS WINDY, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.play = 'no' AND B.windy = A.windy
		) AS 'NO',
	
		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.play = 'yes' AND C.windy = A.windy
		) AS 'YES'
	FROM tblC45 AS A
	GROUP BY A.windy;

    UPDATE tblHitung SET atribut = 'WINDY' WHERE atribut IS NULL;

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