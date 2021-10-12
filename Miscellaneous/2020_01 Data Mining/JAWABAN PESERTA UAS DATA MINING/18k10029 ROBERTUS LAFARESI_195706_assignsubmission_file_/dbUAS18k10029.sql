/*LANGKAH 1: siapkan database dan data2 nya*/
DROP DATABASE IF EXISTS dbUAS18k10029;
CREATE DATABASE dbUAS18k10029;
USE dbUAS18k10029;

CREATE TABLE tblC45
(
pasien              VARCHAR(50),
Demam               VARCHAR(10),
Sakit_Kepala        VARCHAR(10),
Nyeri               VARCHAR(10), 
Lemas               VARCHAR(10), 
Kelelahan           VARCHAR(10),
hidung_tersumbat    VARCHAR(10),
Bersin              VARCHAR(10),
Sakit_Tenggorokan   VARCHAR(10),
Sulit_bernafas      VARCHAR(10),
Diagnosa            VARCHAR(10)
);

LOAD DATA LOCAL INFILE 'UAS.csv'
INTO TABLE tblC45
FIELDS TERMINATED BY ';'
ENCLOSED BY ''''
IGNORE 1 LINES;

Select * from tblC45;

CREATE TABLE tblHitung
(
atribut VARCHAR(20),
informasi VARCHAR(20),
total INT,
flu INT,
demam INT,
entropy DECIMAL(8,4),
gain DECIMAL(8,4)
);

CREATE TABLE tblIterasi2
(
atribut VARCHAR(20),
informasi VARCHAR(20),
total INT,
flu INT,
demam INT,
entropy DECIMAL(8,4),
gain DECIMAL(8,4)
);

DESC tblHitung;

/*tblHitung*/

SELECT COUNT(*) INTO @total FROM tblC45;

SELECT COUNT(*) INTO @flu FROM tblC45
WHERE Diagnosa = 'Flu';

SELECT COUNT(*) INTO @demam FROM tblC45
WHERE Diagnosa = 'Demam';

SELECT (-(@flu/@total) * log2(@flu/@total))
+
(-(@demam/@total)*log2(@demam/@total))
INTO @entropy;

SELECT @total AS JUM_DATA,
@flu AS FLU,
@demam AS Demam,
ROUND(@entropy, 4) AS ENTROPY;

INSERT INTO tblHitung(atribut, total, flu, demam, entropy) VALUES
('TOTAL DATA', @total, @flu, @demam, @entropy);

SELECT * FROM tblHitung;

DELIMITER //

CREATE PROCEDURE Iterasi1()

BEGIN
    INSERT INTO tblHitung(informasi, total, flu, demam)
    SELECT A.Demam, COUNT(*) AS Total,
    	(
    	SELECT COUNT(*)
    	FROM tblC45 AS B
    	WHERE B.Diagnosa = 'Flu' AND B.Demam = A.Demam
    	) AS 'Flu',

    	(
    	SELECT COUNT(*)
    	FROM tblC45 AS C
    	WHERE C.Diagnosa = 'Demam' AND C.Demam = A.Demam
    	) AS 'Demam'
    FROM tblC45 AS A
    GROUP BY A.Demam;
    UPDATE tblHitung SET atribut = 'Demam' WHERE atribut IS NULL;

    INSERT INTO tblHitung(informasi, total, flu, demam)
    SELECT A.Nyeri, COUNT(*) AS Total,
    	(
    	SELECT COUNT(*)
    	FROM tblC45 AS B
    	WHERE B.Diagnosa = 'Flu' AND B.Nyeri = A.Nyeri
    	) AS 'Flu',

    	(
    	SELECT COUNT(*)
    	FROM tblC45 AS C
    	WHERE C.Diagnosa = 'Demam' AND C.Nyeri = A.Nyeri
    	) AS 'Demam'
    FROM tblC45 AS A
    GROUP BY A.Nyeri;
    UPDATE tblHitung SET atribut = 'Nyeri' WHERE atribut IS NULL;

    INSERT INTO tblHitung(informasi, total, flu, demam)
    SELECT A.Sakit_Kepala, COUNT(*) AS Total,
    	(
    	SELECT COUNT(*)
    	FROM tblC45 AS B
    	WHERE B.Diagnosa = 'Flu' AND B.Sakit_Kepala = A.Sakit_Kepala
    	) AS 'Flu',

    	(
    	SELECT COUNT(*)
    	FROM tblC45 AS C
    	WHERE C.Diagnosa = 'Demam' AND C.Sakit_Kepala = A.Sakit_Kepala
    	) AS 'Demam'
    FROM tblC45 AS A
    GROUP BY A.Sakit_Kepala;
    UPDATE tblHitung SET atribut = 'Sakit_Kepala' WHERE atribut IS NULL;

    INSERT INTO tblHitung(informasi, total, flu, demam)
    SELECT A.Lemas, COUNT(*) AS Total,
    	(
    	SELECT COUNT(*)
    	FROM tblC45 AS B
    	WHERE B.Diagnosa = 'Flu' AND B.Lemas = A.Lemas
    	) AS 'Flu',

    	(
    	SELECT COUNT(*)
    	FROM tblC45 AS C
    	WHERE C.Diagnosa = 'Demam' AND C.Lemas = A.Lemas
    	) AS 'Demam'
    FROM tblC45 AS A
    GROUP BY A.Lemas;
    UPDATE tblHitung SET atribut = 'Lemas' WHERE atribut IS NULL;

    INSERT INTO tblHitung(informasi, total, flu, demam)
    SELECT A.kelelahan, COUNT(*) AS Total,
    	(
    	SELECT COUNT(*)
    	FROM tblC45 AS B
    	WHERE B.Diagnosa = 'Flu' AND B.kelelahan = A.kelelahan
    	) AS 'Flu',

    	(
    	SELECT COUNT(*)
    	FROM tblC45 AS C
    	WHERE C.Diagnosa = 'Demam' AND C.kelelahan = A.kelelahan
    	) AS 'Demam'
    FROM tblC45 AS A
    GROUP BY A.kelelahan;
    UPDATE tblHitung SET atribut = 'kelelahan' WHERE atribut IS NULL;

    INSERT INTO tblHitung(informasi, total, flu, demam)
    SELECT A.hidung_tersumbat, COUNT(*) AS Total,
    	(
    	SELECT COUNT(*)
    	FROM tblC45 AS B
    	WHERE B.Diagnosa = 'Flu' AND B.hidung_tersumbat = A.hidung_tersumbat
    	) AS 'Flu',

    	(
    	SELECT COUNT(*)
    	FROM tblC45 AS C
    	WHERE C.Diagnosa = 'Demam' AND C.hidung_tersumbat = A.hidung_tersumbat
    	) AS 'Demam'
    FROM tblC45 AS A
    GROUP BY A.hidung_tersumbat;
    UPDATE tblHitung SET atribut = 'hidung_tersumbat' WHERE atribut IS NULL;

    INSERT INTO tblHitung(informasi, total, flu, demam)
    SELECT A.bersin, COUNT(*) AS Total,
    	(
    	SELECT COUNT(*)
    	FROM tblC45 AS B
    	WHERE B.Diagnosa = 'Flu' AND B.bersin = A.bersin
    	) AS 'Flu',

    	(
    	SELECT COUNT(*)
    	FROM tblC45 AS C
    	WHERE C.Diagnosa = 'Demam' AND C.bersin = A.bersin
    	) AS 'Demam'
    FROM tblC45 AS A
    GROUP BY A.bersin;
    UPDATE tblHitung SET atribut = 'bersin' WHERE atribut IS NULL;

    INSERT INTO tblHitung(informasi, total, flu, demam)
    SELECT A.sakit_tenggorokan, COUNT(*) AS Total,
    	(
    	SELECT COUNT(*)
    	FROM tblC45 AS B
    	WHERE B.Diagnosa = 'Flu' AND B.sakit_tenggorokan = A.sakit_tenggorokan
    	) AS 'Flu',

    	(
    	SELECT COUNT(*)
    	FROM tblC45 AS C
    	WHERE C.Diagnosa = 'Demam' AND C.sakit_tenggorokan = A.sakit_tenggorokan
    	) AS 'Demam'
    FROM tblC45 AS A
    GROUP BY A.sakit_tenggorokan;
    UPDATE tblHitung SET atribut = 'sakit_tenggorokan' WHERE atribut IS NULL;

    INSERT INTO tblHitung(informasi, total, flu, demam)
    SELECT A.sulit_bernafas, COUNT(*) AS Total,
    	(
    	SELECT COUNT(*)
    	FROM tblC45 AS B
    	WHERE B.Diagnosa = 'Flu' AND B.sulit_bernafas = A.sulit_bernafas
    	) AS 'Flu',

    	(
    	SELECT COUNT(*)
    	FROM tblC45 AS C
    	WHERE C.Diagnosa = 'Demam' AND C.sulit_bernafas = A.sulit_bernafas
    	) AS 'Demam'
    FROM tblC45 AS A
    GROUP BY A.sulit_bernafas;
    UPDATE tblHitung SET atribut = 'sulit_bernafas' WHERE atribut IS NULL;

END //

DELIMITER ;

call Iterasi1();

UPDATE tblHitung SET entropy = (-(flu/total) * log2(flu/total))
+
(-(demam/total) * log2(demam/total));

UPDATE tblHItung SET entropy = 0 WHERE entropy IS NULL;

DROP TABLE IF EXISTS tblTampung;
CREATE TEMPORARY TABLE tblTampung
(
atribut VARCHAR(20),
gain DECIMAL(8, 4)
);

INSERT INTO tblTampung(atribut, gain)
SELECT atribut, @entropy - 
SUM((total/@total) * entropy) AS GAIN
FROM tblHitung
GROUP BY atribut;

--SELECT * FROM tblTampung;

UPDATE tblHitung SET GAIN = 
	(
	SELECT gain
	FROM tblTampung
	WHERE atribut = tblHitung.atribut
	);

SELECT * FROM tblHitung;

-----------------------------------------------------------------

SELECT COUNT(*) INTO @total FROM tblC45
WHERE Demam = 'Tidak' AND Kelelahan = 'Tidak';

SELECT COUNT(*) INTO @flu FROM tblC45
WHERE Diagnosa = 'flu' AND Demam = 'Tidak' AND Kelelahan = 'Tidak';

SELECT COUNT(*) INTO @demam FROM tblC45
WHERE Diagnosa = 'demam' AND Demam = 'Tidak' AND Kelelahan = 'Tidak';

SELECT (-(@flu/@total) * log2(@flu/@total))
+
(-(@demam/@total)*log2(@demam/@total))
INTO @entropy;

SELECT @total AS JUM_DATA,
@flu AS FLU,
@demam AS Demam,
ROUND(@entropy, 4) AS ENTROPY;

INSERT INTO tblIterasi2(atribut, total, flu, demam, entropy) VALUES
('Demam/kelelahan', @total, @flu, @demam, @entropy);

SELECT * FROM tblIterasi2;

DELIMITER //

CREATE PROCEDURE Iterasi2()

BEGIN

	INSERT INTO tblIterasi2(informasi, total, flu, demam)
    SELECT A.Sakit_Kepala, COUNT(*) AS Total,
    	(
    	SELECT COUNT(*)
    	FROM tblC45 AS B
    	WHERE B.Diagnosa = 'Flu' AND B.kelelahan = 'Tidak' AND B.Demam = 'Tidak' AND B.Sakit_Kepala = A.Sakit_Kepala
    	) AS 'Flu',

    	(
    	SELECT COUNT(*)
    	FROM tblC45 AS C
    	WHERE C.Diagnosa = 'Demam' AND C.kelelahan = 'Tidak' AND C.Demam = 'Tidak' AND C.Sakit_Kepala = A.Sakit_Kepala
    	) AS 'Demam'
    FROM tblC45 AS A
    WHERE kelelahan = 'Tidak'
    GROUP BY A.Sakit_Kepala;
    UPDATE tblIterasi2 SET atribut = 'Sakit_Kepala' WHERE atribut IS NULL;

	INSERT INTO tblIterasi2(informasi, total, flu, demam)
    SELECT A.Nyeri, COUNT(*) AS Total,
    	(
    	SELECT COUNT(*)
    	FROM tblC45 AS B
    	WHERE B.Diagnosa = 'Flu' AND B.kelelahan = 'Tidak' AND B.Demam = 'Tidak' AND B.Nyeri = A.Nyeri
    	) AS 'Flu',

    	(
    	SELECT COUNT(*)
    	FROM tblC45 AS C
    	WHERE C.Diagnosa = 'Demam' AND C.kelelahan = 'Tidak' AND C.Demam = 'Tidak' AND C.Nyeri = A.Nyeri
    	) AS 'Demam'
    FROM tblC45 AS A
    WHERE kelelahan = 'Tidak'
    GROUP BY A.Nyeri;
    UPDATE tblIterasi2 SET atribut = 'Nyeri' WHERE atribut IS NULL;

    INSERT INTO tblIterasi2(informasi, total, flu, demam)
    SELECT A.Lemas, COUNT(*) AS Total,
    	(
    	SELECT COUNT(*)
    	FROM tblC45 AS B
    	WHERE B.Diagnosa = 'Flu' AND B.kelelahan = 'Tidak' AND B.Demam = 'Tidak' AND B.Lemas = A.Lemas
    	) AS 'Flu',

    	(
    	SELECT COUNT(*)
    	FROM tblC45 AS C
    	WHERE C.Diagnosa = 'Demam' AND C.kelelahan = 'Tidak' AND C.Demam = 'Tidak' AND C.Lemas = A.Lemas
    	) AS 'Demam'
    FROM tblC45 AS A
    WHERE kelelahan = 'Tidak'
    GROUP BY A.Lemas;
    UPDATE tblIterasi2 SET atribut = 'Lemas' WHERE atribut IS NULL;

    INSERT INTO tblIterasi2(informasi, total, flu, demam)
    SELECT A.hidung_tersumbat, COUNT(*) AS Total,
    	(
    	SELECT COUNT(*)
    	FROM tblC45 AS B
    	WHERE B.Diagnosa = 'Flu' AND B.kelelahan = 'Tidak' AND B.Demam = 'Tidak' AND B.hidung_tersumbat = A.hidung_tersumbat
    	) AS 'Flu',

    	(
    	SELECT COUNT(*)
    	FROM tblC45 AS C
    	WHERE C.Diagnosa = 'Demam' AND C.kelelahan = 'Tidak' AND C.Demam = 'Tidak' AND C.hidung_tersumbat = A.hidung_tersumbat
    	) AS 'Demam'
    FROM tblC45 AS A
    WHERE kelelahan = 'Tidak'
    GROUP BY A.hidung_tersumbat;
    UPDATE tblIterasi2 SET atribut = 'hidung_tersumbat' WHERE atribut IS NULL;

    INSERT INTO tblIterasi2(informasi, total, flu, demam)
    SELECT A.bersin, COUNT(*) AS Total,
    	(
    	SELECT COUNT(*)
    	FROM tblC45 AS B
    	WHERE B.Diagnosa = 'Flu' AND B.kelelahan = 'Tidak' AND B.Demam = 'Tidak' AND B.bersin = A.bersin
    	) AS 'Flu',

    	(
    	SELECT COUNT(*)
    	FROM tblC45 AS C
    	WHERE C.Diagnosa = 'Demam' AND C.kelelahan = 'Tidak' AND C.Demam = 'Tidak' AND C.bersin = A.bersin
    	) AS 'Demam'
    FROM tblC45 AS A
    WHERE kelelahan = 'Tidak'
    GROUP BY A.bersin;
    UPDATE tblIterasi2 SET atribut = 'bersin' WHERE atribut IS NULL;

    INSERT INTO tblIterasi2(informasi, total, flu, demam)
    SELECT A.sakit_tenggorokan, COUNT(*) AS Total,
    	(
    	SELECT COUNT(*)
    	FROM tblC45 AS B
    	WHERE B.Diagnosa = 'Flu' AND B.kelelahan = 'Tidak' AND B.Demam = 'Tidak' AND B.sakit_tenggorokan = A.sakit_tenggorokan
    	) AS 'Flu',

    	(
    	SELECT COUNT(*)
    	FROM tblC45 AS C
    	WHERE C.Diagnosa = 'Demam' AND C.kelelahan = 'Tidak' AND C.Demam = 'Tidak' AND C.sakit_tenggorokan = A.sakit_tenggorokan
    	) AS 'Demam'
    FROM tblC45 AS A
    WHERE kelelahan = 'Tidak'
    GROUP BY A.sakit_tenggorokan;
    UPDATE tblIterasi2 SET atribut = 'sakit_tenggorokan' WHERE atribut IS NULL;

    INSERT INTO tblIterasi2(informasi, total, flu, demam)
    SELECT A.sulit_bernafas, COUNT(*) AS Total,
    	(
    	SELECT COUNT(*)
    	FROM tblC45 AS B
    	WHERE B.Diagnosa = 'Flu' AND B.kelelahan = 'Tidak' AND B.Demam = 'Tidak' AND B.sulit_bernafas = A.sulit_bernafas
    	) AS 'Flu',

    	(
    	SELECT COUNT(*)
    	FROM tblC45 AS C
    	WHERE C.Diagnosa = 'Demam' AND C.kelelahan = 'Tidak' AND C.Demam = 'Tidak' AND C.sulit_bernafas = A.sulit_bernafas
    	) AS 'Demam'
    FROM tblC45 AS A
    WHERE kelelahan = 'Tidak'
    GROUP BY A.sulit_bernafas;
    UPDATE tblIterasi2 SET atribut = 'sulit_bernafas' WHERE atribut IS NULL;

END //

DELIMITER ;

call Iterasi2();

UPDATE tblIterasi2 SET entropy = (-(@flu/@total) * log2(@flu/@total))
+
(-(@demam/@total) * log2(@demam/@total));

UPDATE tblIterasi2 SET entropy = 0 WHERE entropy IS NULL;

DROP TABLE IF EXISTS tblTampung;
CREATE TEMPORARY TABLE tblTampung
(
atribut VARCHAR(20),
gain DECIMAL(8, 4)
);

INSERT INTO tblTampung(atribut, gain)
SELECT atribut, @entropy - 
SUM((total/@total) * entropy) AS GAIN
FROM tblIterasi2
GROUP BY atribut;

--SELECT * FROM tblTampung;

UPDATE tblIterasi2 SET GAIN = 
	(
	SELECT gain
	FROM tblTampung
	WHERE atribut = tblIterasi2.atribut
	);

SELECT * FROM tblIterasi2;



-------------------------------------------------------------------------------------------------------------------------------






