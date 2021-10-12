/*LANGKAH 1: siapkan database dan data2 nya*/


-- KESIMPULAN nya adalah meyeleksi data secara satu persatu sampai tersisa 1 data yang akan menjadi hasil prediksi untuk kedepannya dengan hasil mendekati 1 yaituu sulit bernapas
-- KESIMPULAN nya adalah meyeleksi data secara satu persatu sampai tersisa 1 data yang akan menjadi hasil prediksi untuk kedepannya dengan hasil mendekati 1 yaituu sulit bernapas
-- KESIMPULAN nya adalah meyeleksi data secara satu persatu sampai tersisa 1 data yang akan menjadi hasil prediksi untuk kedepannya dengan hasil mendekati 1 yaituu sulit bernapas
-- KESIMPULAN nya adalah meyeleksi data secara satu persatu sampai tersisa 1 data yang akan menjadi hasil prediksi untuk kedepannya dengan hasil mendekati 1 yaituu sulit bernapas
-- KESIMPULAN nya adalah meyeleksi data secara satu persatu sampai tersisa 1 data yang akan menjadi hasil prediksi untuk kedepannya dengan hasil mendekati 1 yaituu sulit bernapas
-- KESIMPULAN nya adalah meyeleksi data secara satu persatu sampai tersisa 1 data yang akan menjadi hasil prediksi untuk kedepannya dengan hasil mendekati 1 yaituu sulit bernapas
-- KESIMPULAN nya adalah meyeleksi data secara satu persatu sampai tersisa 1 data yang akan menjadi hasil prediksi untuk kedepannya dengan hasil mendekati 1 yaituu sulit bernapas
-- KESIMPULAN nya adalah meyeleksi data secara satu persatu sampai tersisa 1 data yang akan menjadi hasil prediksi untuk kedepannya dengan hasil mendekati 1 yaituu sulit bernapas
-- KESIMPULAN nya adalah meyeleksi data secara satu persatu sampai tersisa 1 data yang akan menjadi hasil prediksi untuk kedepannya dengan hasil mendekati 1 yaituu sulit bernapas
-- KESIMPULAN nya adalah meyeleksi data secara satu persatu sampai tersisa 1 data yang akan menjadi hasil prediksi untuk kedepannya dengan hasil mendekati 1 yaituu sulit bernapas
-- KESIMPULAN nya adalah meyeleksi data secara satu persatu sampai tersisa 1 data yang akan menjadi hasil prediksi untuk kedepannya dengan hasil mendekati 1 yaituu sulit bernapas





DROP DATABASE IF EXISTS dbC45;
CREATE DATABASE dbC45;
USE dbC45;

CREATE TABLE tblC45
(
pasien varchar(10),
demam varchar(10),
sakitkepala varchar(10),
nyeri varchar(10),
lemas varchar(10),
kelelahan varchar(10),
hidungtersumbat varchar(10),
bersin  varchar(10),
sakittenggorokan varchar(10),
sulitbernapas varchar(10),
diagnosa varchar(10)
);

INSERT into tblC45 VALUES

(1,'Tidak','Ringan','Tidak','Tidak','Tidak','Ringan','Parah','Parah','Ringan','Demam'),
(2,'Parah','Parah','Parah','Parah','Parah','Tidak','Tidak','Parah','Parah','Flu'),
(3,'Parah','Parah','Ringan','Parah','Parah','Parah','Tidak','Parah','Parah','Flu'),
(4,'Tidak','Tidak','Tidak','Ringan','Tidak','Parah','Tidak','Ringan','Ringan','Demam'),
(5,'Parah','Parah','Ringan','Parah','Parah','Parah','Tidak','Parah','Parah','Flu'),
(6,'Tidak','Tidak','Tidak','Ringan','Tidak','Parah','Parah','Parah','Tidak','Demam'),
(7,'Parah','Parah','Parah','Parah','Parah','Tidak','Tidak','Tidak','Parah','Flu'),
(8,'Tidak','Tidak','Tidak','Tidak','Tidak','Parah','Parah','Tidak','Ringan','Demam'),
(9,'Tidak','Ringan','Ringan','Tidak','Tidak','Parah','Parah','Parah','Parah','Demam'),
(10,'Parah','Parah','Parah','Ringan','Ringan','Tidak','Parah','Tidak','Parah','Flu'),
(11,'Tidak','Tidak','Tidak','Ringan','Tidak','Parah','Ringan','Parah','Tidak','Demam'),
(12,'Parah','Ringan','Parah','Ringan','Parah','Tidak','Parah','Tidak','Ringan','Flu'),
(13,'Tidak','Tidak','Ringan','Ringan','Tidak','Parah','Parah','Parah','Tidak','Demam'),
(14,'Parah','Parah','Parah','Parah','Ringan','Tidak','Parah','Parah','Parah','Flu'),
(15,'Ringan','Tidak','Tidak','Ringan','Tidak','Parah','Tidak','Parah','Ringan','Demam'),
(16,'Tidak','Tidak','Tidak','Tidak','Tidak','Parah','Parah','Parah','Parah','Demam'),
(17,'Parah','Ringan','Parah','Ringan','Ringan','Tidak','Tidak','Tidak','Parah','Flu');


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
@demam AS JAWAB_NO,
@flu AS JAWAB_flu,
ROUND(@entropy, 4) AS ENTROPY;

INSERT INTO tblHitung(atribut, jumlahdata, demam, flu, entropy) VALUES
('TOTAL DATA', @jumlahdata, @demam, @flu, @entropy);

SELECT * FROM tblHitung;

/*LANGKAH 3: melakukan proses untuk setiap atribut*/

/*demam*/
INSERT INTO tblHitung(informasi, jumlahdata, demam, flu)
	SELECT A.demam AS demam, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.diagnosa = 'demam' AND B.demam = A.demam
		) AS 'demam',
	
		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.diagnosa = 'flu' AND C.demam = A.demam
		) AS 'flu'
	FROM tblC45 AS A
	GROUP BY A.demam;

UPDATE tblHitung SET atribut = 'demam' WHERE atribut IS NULL;

/*sakitkepala*/
INSERT INTO tblHitung(informasi, jumlahdata, demam, flu)
	SELECT A.sakitkepala AS sakitkepala, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.diagnosa = 'demam' AND B.sakitkepala = A.sakitkepala
		) AS 'demam',
	
		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.diagnosa = 'flu' AND C.sakitkepala = A.sakitkepala
		) AS 'flu'
	FROM tblC45 AS A
	GROUP BY A.sakitkepala;

UPDATE tblHitung SET atribut = 'sakitkepala' WHERE atribut IS NULL;


/*nyeri*/
INSERT INTO tblHitung(informasi, jumlahdata, demam, flu)
	SELECT A.nyeri AS nyeri, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.diagnosa = 'demam' AND B.nyeri = A.nyeri
		) AS 'demam',
	
		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.diagnosa = 'flu' AND C.nyeri = A.nyeri
		) AS 'flu'
	FROM tblC45 AS A
	GROUP BY A.nyeri;

UPDATE tblHitung SET atribut = 'nyeri' WHERE atribut IS NULL;


/*lemas*/
INSERT INTO tblHitung(informasi, jumlahdata, demam, flu)
	SELECT A.lemas AS lemas, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.diagnosa = 'demam' AND B.lemas = A.lemas
		) AS 'demam',
	
		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.diagnosa = 'flu' AND C.lemas = A.lemas
		) AS 'flu'
	FROM tblC45 AS A
	GROUP BY A.lemas;

UPDATE tblHitung SET atribut = 'lemas' WHERE atribut IS NULL;


/*kelelahan*/
INSERT INTO tblHitung(informasi, jumlahdata, demam, flu)
	SELECT A.kelelahan AS kelelahan, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.diagnosa = 'demam' AND B.kelelahan = A.kelelahan
		) AS 'demam',
	
		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.diagnosa = 'flu' AND C.kelelahan = A.kelelahan
		) AS 'flu'
	FROM tblC45 AS A
	GROUP BY A.kelelahan;

UPDATE tblHitung SET atribut = 'kelelahan' WHERE atribut IS NULL;


/*hidungtersumbat*/
INSERT INTO tblHitung(informasi, jumlahdata, demam, flu)
	SELECT A.hidungtersumbat AS hidungtersumbat, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.diagnosa = 'demam' AND B.hidungtersumbat = A.hidungtersumbat
		) AS 'demam',
	
		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.diagnosa = 'flu' AND C.hidungtersumbat = A.hidungtersumbat
		) AS 'flu'
	FROM tblC45 AS A
	GROUP BY A.hidungtersumbat;

UPDATE tblHitung SET atribut = 'hidungtersumbat' WHERE atribut IS NULL;

/*bersin*/
INSERT INTO tblHitung(informasi, jumlahdata, demam, flu)
	SELECT A.bersin AS bersin, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.diagnosa = 'demam' AND B.bersin = A.bersin
		) AS 'demam',
	
		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.diagnosa = 'flu' AND C.bersin = A.bersin
		) AS 'flu'
	FROM tblC45 AS A
	GROUP BY A.bersin;

UPDATE tblHitung SET atribut = 'bersin' WHERE atribut IS NULL;


/*sakittenggorokan*/
INSERT INTO tblHitung(informasi, jumlahdata, demam, flu)
	SELECT A.sakittenggorokan AS sakittenggorokan, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.diagnosa = 'demam' AND B.sakittenggorokan = A.sakittenggorokan
		) AS 'demam',
	
		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.diagnosa = 'flu' AND C.sakittenggorokan = A.sakittenggorokan
		) AS 'flu'
	FROM tblC45 AS A
	GROUP BY A.sakittenggorokan;

UPDATE tblHitung SET atribut = 'sakittenggorokan' WHERE atribut IS NULL;



/*sulitbern*/
INSERT INTO tblHitung(informasi, jumlahdata, demam, flu)
	SELECT A.sulitbernapas AS sulitbernapas, COUNT(*) AS JUMLAH_DATA,
		(
		SELECT COUNT(*)
		FROM tblC45 AS B
		WHERE B.diagnosa = 'demam' AND B.sulitbernapas = A.sulitbernapas
		) AS 'demam',
	
		(
		SELECT COUNT(*)
		FROM tblC45 AS C
		WHERE C.diagnosa = 'flu' AND C.sulitbernapas = A.sulitbernapas
		) AS 'flu'
	FROM tblC45 AS A
	GROUP BY A.sulitbernapas;

UPDATE tblHitung SET atribut = 'sulitbernapas' WHERE atribut IS NULL;

/*LANGKAH 4: menghitung entropy*/
UPDATE tblHitung SET entropy = (-(demam/jumlahdata) * log2(demam/jumlahdata))
+
(-(flu/jumlahdata) * log2(flu/jumlahdata));

UPDATE tblHItung SET entropy = 0 WHERE entropy IS NULL;

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

SELECT atribut, MAX(gain) as Gain
FROM tblTampung;




-- 2


TRUNCATE TABLE tblHitung;

SELECT COUNT(*) INTO @jumlahdata
FROM tblC45 WHERE bersin = 'parah';

SELECT COUNT(*) INTO @demam 
FROM tblC45 WHERE diagnosa = 'demam' AND bersin = 'parah';

SELECT COUNT(*) INTO @flu FROM tblC45 
WHERE diagnosa = 'flu' AND bersin = 'parah';

SELECT (-(@demam/@jumlahdata) * log2(@demam/@jumlahdata)) + (-(@flu/@jumlahdata) * log2(@flu/@jumlahdata)) INTO @entropy;

SELECT @jumlahdata AS JUM_DATA,
@demam AS JAWAB_NO,
@flu AS JAWAB_flu,
ROUND(@entropy,4) AS ENTROPY;




-- demam
INSERT INTO tblHitung(informasi, jumlahdata, demam, flu)
    SELECT A.demam AS demam, COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*)
			FROM tblC45 AS B 
			WHERE B.diagnosa = 'demam' AND B.demam = A.demam AND bersin = 'parah'
        ) AS 'demam',
        (
            SELECT COUNT(*) 
			FROM tblC45 AS C 
			WHERE C.diagnosa = 'flu' AND C.demam = A.demam AND bersin = 'parah'
        ) AS 'flu'
    FROM tblC45 AS A WHERE bersin = 'parah' GROUP BY demam;

UPDATE tblHitung SET atribut = 'demam' WHERE atribut IS NULL;

-- sakitkepala
INSERT INTO tblHitung(informasi, jumlahdata, demam, flu)
    SELECT A.sakitkepala AS sakitkepala, COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*)
			FROM tblC45 AS B 
			WHERE B.diagnosa = 'demam' AND B.sakitkepala = A.sakitkepala AND bersin = 'parah'
        ) AS 'demam',
        (
            SELECT COUNT(*) 
			FROM tblC45 AS C 
			WHERE C.diagnosa = 'flu' AND C.sakitkepala = A.sakitkepala AND bersin = 'parah'
        ) AS 'flu'
    FROM tblC45 AS A WHERE bersin = 'parah' GROUP BY sakitkepala;

UPDATE tblHitung SET atribut = 'sakitkepala' WHERE atribut IS NULL;

-- nyeri

INSERT INTO tblHitung(informasi, jumlahdata, demam, flu)
    SELECT A.nyeri AS nyeri, COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*)
			FROM tblC45 AS B 
			WHERE B.diagnosa = 'demam' AND B.nyeri = A.nyeri AND bersin = 'parah'
        ) AS 'demam',
        (
            SELECT COUNT(*) 
			FROM tblC45 AS C 
			WHERE C.diagnosa = 'flu' AND C.nyeri = A.nyeri AND bersin = 'parah'
        ) AS 'flu'
    FROM tblC45 AS A WHERE bersin = 'parah' GROUP BY nyeri;

UPDATE tblHitung SET atribut = 'nyeri' WHERE atribut IS NULL;

-- lemas
INSERT INTO tblHitung(informasi, jumlahdata, demam, flu)
    SELECT A.lemas AS lemas, COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*)
			FROM tblC45 AS B 
			WHERE B.diagnosa = 'demam' AND B.lemas = A.lemas AND bersin = 'parah'
        ) AS 'demam',
        (
            SELECT COUNT(*) 
			FROM tblC45 AS C 
			WHERE C.diagnosa = 'flu' AND C.lemas = A.lemas AND bersin = 'parah'
        ) AS 'flu'
    FROM tblC45 AS A WHERE bersin = 'parah' GROUP BY lemas;

UPDATE tblHitung SET atribut = 'lemas' WHERE atribut IS NULL;


-- kelelahan

INSERT INTO tblHitung(informasi, jumlahdata, demam, flu)
    SELECT A.kelelahan AS kelelahan, COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*)
			FROM tblC45 AS B 
			WHERE B.diagnosa = 'demam' AND B.kelelahan = A.kelelahan AND bersin = 'parah'
        ) AS 'demam',
        (
            SELECT COUNT(*) 
			FROM tblC45 AS C 
			WHERE C.diagnosa = 'flu' AND C.kelelahan = A.kelelahan AND bersin = 'parah'
        ) AS 'flu'
    FROM tblC45 AS A WHERE bersin = 'parah' GROUP BY kelelahan;

UPDATE tblHitung SET atribut = 'kelelahan' WHERE atribut IS NULL;


-- hidungtersumbat
INSERT INTO tblHitung(informasi, jumlahdata, demam, flu)
    SELECT A.hidungtersumbat AS hidungtersumbat, COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*)
			FROM tblC45 AS B 
			WHERE B.diagnosa = 'demam' AND B.hidungtersumbat = A.hidungtersumbat AND bersin = 'parah'
        ) AS 'demam',
        (
            SELECT COUNT(*) 
			FROM tblC45 AS C 
			WHERE C.diagnosa = 'flu' AND C.hidungtersumbat = A.hidungtersumbat AND bersin = 'parah'
        ) AS 'flu'
    FROM tblC45 AS A WHERE bersin = 'parah' GROUP BY hidungtersumbat;

UPDATE tblHitung SET atribut = 'hidungtersumbat' WHERE atribut IS NULL;

-- sakittenggorokan

INSERT INTO tblHitung(informasi, jumlahdata, demam, flu)
    SELECT A.sakittenggorokan AS sakittenggorokan, COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*)
			FROM tblC45 AS B 
			WHERE B.diagnosa = 'demam' AND B.sakittenggorokan = A.sakittenggorokan AND bersin = 'parah'
        ) AS 'demam',
        (
            SELECT COUNT(*) 
			FROM tblC45 AS C 
			WHERE C.diagnosa = 'flu' AND C.sakittenggorokan = A.sakittenggorokan AND bersin = 'parah'
        ) AS 'flu'
    FROM tblC45 AS A WHERE bersin = 'parah' GROUP BY sakittenggorokan;

UPDATE tblHitung SET atribut = 'sakittenggorokan' WHERE atribut IS NULL;



-- sulitbernapas
INSERT INTO tblHitung(informasi, jumlahdata, demam, flu)
    SELECT A.sulitbernapas AS sulitbernapas, COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*)
			FROM tblC45 AS B 
			WHERE B.diagnosa = 'demam' AND B.sulitbernapas = A.sulitbernapas AND bersin = 'parah'
        ) AS 'demam',
        (
            SELECT COUNT(*) 
			FROM tblC45 AS C 
			WHERE C.diagnosa = 'flu' AND C.sulitbernapas = A.sulitbernapas AND bersin = 'parah'
        ) AS 'flu'
    FROM tblC45 AS A WHERE bersin = 'parah' GROUP BY sulitbernapas;

UPDATE tblHitung SET atribut = 'sulitbernapas' WHERE atribut IS NULL;


UPDATE tblHitung SET entropy = (-(demam/jumlahdata) * log2(demam/jumlahdata)) + (-(flu/jumlahdata) * log2(flu/jumlahdata));

UPDATE tblHitung SET entropy = 0 WHERE entropy IS NULL;

SELECT * FROM tblHitung;

DROP TABLE IF EXISTS tblTampung;
CREATE TEMPORARY TABLE tblTampung
(
    atribut VARCHAR(20),
    gain decimal(8,4)
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
SELECT atribut, MAX(gain) as Gain
FROM tblTampung;




-- 3



TRUNCATE TABLE tblHitung;

SELECT COUNT(*) INTO @jumlahdata
FROM tblC45 WHERE bersin = 'parah';

SELECT COUNT(*) INTO @demam 
FROM tblC45 WHERE diagnosa = 'demam' AND bersin = 'parah';

SELECT COUNT(*) INTO @flu FROM tblC45 
WHERE diagnosa = 'flu' AND bersin = 'parah';

SELECT (-(@demam/@jumlahdata) * log2(@demam/@jumlahdata)) + (-(@flu/@jumlahdata) * log2(@flu/@jumlahdata)) INTO @entropy;

SELECT @jumlahdata AS JUM_DATA,
@demam AS JAWAB_NO,
@flu AS JAWAB_flu,
ROUND(@entropy,4) AS ENTROPY;




-- sakitkepala
INSERT INTO tblHitung(informasi, jumlahdata, demam, flu)
    SELECT A.sakitkepala AS sakitkepala, COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*)
			FROM tblC45 AS B 
			WHERE B.diagnosa = 'demam' AND B.sakitkepala = A.sakitkepala AND bersin = 'parah' AND demam='tidak'
        ) AS 'demam',
        (
            SELECT COUNT(*) 
			FROM tblC45 AS C 
			WHERE C.diagnosa = 'flu' AND C.sakitkepala = A.sakitkepala AND bersin = 'parah' AND demam='tidak'
        ) AS 'flu'
    FROM tblC45 AS A WHERE bersin = 'parah' AND demam='tidak' GROUP BY sakitkepala;

UPDATE tblHitung SET atribut = 'sakitkepala' WHERE atribut IS NULL;

-- nyeri

INSERT INTO tblHitung(informasi, jumlahdata, demam, flu)
    SELECT A.nyeri AS nyeri, COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*)
			FROM tblC45 AS B 
			WHERE B.diagnosa = 'demam' AND B.nyeri = A.nyeri AND bersin = 'parah' AND demam='tidak'
        ) AS 'demam',
        (
            SELECT COUNT(*) 
			FROM tblC45 AS C 
			WHERE C.diagnosa = 'flu' AND C.nyeri = A.nyeri AND bersin = 'parah' AND demam='tidak'
        ) AS 'flu'
    FROM tblC45 AS A WHERE bersin = 'parah' AND demam='tidak' GROUP BY nyeri;

UPDATE tblHitung SET atribut = 'nyeri' WHERE atribut IS NULL;

-- lemas
INSERT INTO tblHitung(informasi, jumlahdata, demam, flu)
    SELECT A.lemas AS lemas, COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*)
			FROM tblC45 AS B 
			WHERE B.diagnosa = 'demam' AND B.lemas = A.lemas AND bersin = 'parah' AND demam='tidak'
        ) AS 'demam',
        (
            SELECT COUNT(*) 
			FROM tblC45 AS C 
			WHERE C.diagnosa = 'flu' AND C.lemas = A.lemas AND bersin = 'parah' AND demam='tidak'
        ) AS 'flu'
    FROM tblC45 AS A WHERE bersin = 'parah' AND demam='tidak' GROUP BY lemas;

UPDATE tblHitung SET atribut = 'lemas' WHERE atribut IS NULL;


-- kelelahan

INSERT INTO tblHitung(informasi, jumlahdata, demam, flu)
    SELECT A.kelelahan AS kelelahan, COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*)
			FROM tblC45 AS B 
			WHERE B.diagnosa = 'demam' AND B.kelelahan = A.kelelahan AND bersin = 'parah' AND demam='tidak'
        ) AS 'demam',
        (
            SELECT COUNT(*) 
			FROM tblC45 AS C 
			WHERE C.diagnosa = 'flu' AND C.kelelahan = A.kelelahan AND bersin = 'parah' AND demam='tidak'
        ) AS 'flu'
    FROM tblC45 AS A WHERE bersin = 'parah' AND demam='tidak' GROUP BY kelelahan;

UPDATE tblHitung SET atribut = 'kelelahan' WHERE atribut IS NULL;


-- hidungtersumbat
INSERT INTO tblHitung(informasi, jumlahdata, demam, flu)
    SELECT A.hidungtersumbat AS hidungtersumbat, COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*)
			FROM tblC45 AS B 
			WHERE B.diagnosa = 'demam' AND B.hidungtersumbat = A.hidungtersumbat AND bersin = 'parah' AND demam='tidak'
        ) AS 'demam',
        (
            SELECT COUNT(*) 
			FROM tblC45 AS C 
			WHERE C.diagnosa = 'flu' AND C.hidungtersumbat = A.hidungtersumbat AND bersin = 'parah' AND demam='tidak'
        ) AS 'flu'
    FROM tblC45 AS A WHERE bersin = 'parah' AND demam='tidak' GROUP BY hidungtersumbat;

UPDATE tblHitung SET atribut = 'hidungtersumbat' WHERE atribut IS NULL;

-- sakittenggorokan

INSERT INTO tblHitung(informasi, jumlahdata, demam, flu)
    SELECT A.sakittenggorokan AS sakittenggorokan, COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*)
			FROM tblC45 AS B 
			WHERE B.diagnosa = 'demam' AND B.sakittenggorokan = A.sakittenggorokan AND bersin = 'parah' AND demam='tidak'
        ) AS 'demam',
        (
            SELECT COUNT(*) 
			FROM tblC45 AS C 
			WHERE C.diagnosa = 'flu' AND C.sakittenggorokan = A.sakittenggorokan AND bersin = 'parah' AND demam='tidak'
        ) AS 'flu'
    FROM tblC45 AS A WHERE bersin = 'parah' AND demam='tidak' GROUP BY sakittenggorokan;

UPDATE tblHitung SET atribut = 'sakittenggorokan' WHERE atribut IS NULL;



-- sulitbernapas
INSERT INTO tblHitung(informasi, jumlahdata, demam, flu)
    SELECT A.sulitbernapas AS sulitbernapas, COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*)
			FROM tblC45 AS B 
			WHERE B.diagnosa = 'demam' AND B.sulitbernapas = A.sulitbernapas AND bersin = 'parah' AND demam='tidak'
        ) AS 'demam',
        (
            SELECT COUNT(*) 
			FROM tblC45 AS C 
			WHERE C.diagnosa = 'flu' AND C.sulitbernapas = A.sulitbernapas AND bersin = 'parah' AND demam='tidak'
        ) AS 'flu'
    FROM tblC45 AS A WHERE bersin = 'parah' AND demam='tidak' GROUP BY sulitbernapas;

UPDATE tblHitung SET atribut = 'sulitbernapas' WHERE atribut IS NULL;


UPDATE tblHitung SET entropy = (-(demam/jumlahdata) * log2(demam/jumlahdata)) + (-(flu/jumlahdata) * log2(flu/jumlahdata));

UPDATE tblHitung SET entropy = 0 WHERE entropy IS NULL;

SELECT * FROM tblHitung;

DROP TABLE IF EXISTS tblTampung;
CREATE TEMPORARY TABLE tblTampung
(
    atribut VARCHAR(20),
    gain decimal(8,4)
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
SELECT atribut, MAX(gain) as Gain
FROM tblTampung;





-- 4


TRUNCATE TABLE tblHitung;

SELECT COUNT(*) INTO @jumlahdata
FROM tblC45 WHERE bersin = 'parah';

SELECT COUNT(*) INTO @demam 
FROM tblC45 WHERE diagnosa = 'demam' AND bersin = 'parah' ;

SELECT COUNT(*) INTO @flu FROM tblC45 
WHERE diagnosa = 'flu' AND bersin = 'parah';

SELECT (-(@demam/@jumlahdata) * log2(@demam/@jumlahdata)) + (-(@flu/@jumlahdata) * log2(@flu/@jumlahdata)) INTO @entropy;

SELECT @jumlahdata AS JUM_DATA,
@demam AS JAWAB_NO,
@flu AS JAWAB_flu,
ROUND(@entropy,4) AS ENTROPY;




-- sakitkepala
INSERT INTO tblHitung(informasi, jumlahdata, demam, flu)
    SELECT A.sakitkepala AS sakitkepala, COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*)
			FROM tblC45 AS B 
			WHERE B.diagnosa = 'demam' AND B.sakitkepala = A.sakitkepala AND bersin = 'parah' AND demam='tidak' AND hidungtersumbat='parah'
        ) AS 'demam',
        (
            SELECT COUNT(*) 
			FROM tblC45 AS C 
			WHERE C.diagnosa = 'flu' AND C.sakitkepala = A.sakitkepala AND bersin = 'parah' AND demam='tidak' AND hidungtersumbat='parah'
        ) AS 'flu'
    FROM tblC45 AS A WHERE bersin = 'parah' AND demam='tidak' AND hidungtersumbat='parah' GROUP BY sakitkepala;

UPDATE tblHitung SET atribut = 'sakitkepala' WHERE atribut IS NULL;

-- nyeri

INSERT INTO tblHitung(informasi, jumlahdata, demam, flu)
    SELECT A.nyeri AS nyeri, COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*)
			FROM tblC45 AS B 
			WHERE B.diagnosa = 'demam' AND B.nyeri = A.nyeri AND bersin = 'parah' AND demam='tidak' AND hidungtersumbat='parah'
        ) AS 'demam',
        (
            SELECT COUNT(*) 
			FROM tblC45 AS C 
			WHERE C.diagnosa = 'flu' AND C.nyeri = A.nyeri AND bersin = 'parah' AND demam='tidak' AND hidungtersumbat='parah'
        ) AS 'flu'
    FROM tblC45 AS A WHERE bersin = 'parah' AND demam='tidak' AND hidungtersumbat='parah' GROUP BY nyeri;

UPDATE tblHitung SET atribut = 'nyeri' WHERE atribut IS NULL;

-- lemas
INSERT INTO tblHitung(informasi, jumlahdata, demam, flu)
    SELECT A.lemas AS lemas, COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*)
			FROM tblC45 AS B 
			WHERE B.diagnosa = 'demam' AND B.lemas = A.lemas AND bersin = 'parah' AND demam='tidak' AND hidungtersumbat='parah'
        ) AS 'demam',
        (
            SELECT COUNT(*) 
			FROM tblC45 AS C 
			WHERE C.diagnosa = 'flu' AND C.lemas = A.lemas AND bersin = 'parah' AND demam='tidak' AND hidungtersumbat='parah'
        ) AS 'flu'
    FROM tblC45 AS A WHERE bersin = 'parah' AND demam='tidak' AND hidungtersumbat='parah' GROUP BY lemas;

UPDATE tblHitung SET atribut = 'lemas' WHERE atribut IS NULL;


-- kelelahan

INSERT INTO tblHitung(informasi, jumlahdata, demam, flu)
    SELECT A.kelelahan AS kelelahan, COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*)
			FROM tblC45 AS B 
			WHERE B.diagnosa = 'demam' AND B.kelelahan = A.kelelahan AND bersin = 'parah' AND demam='tidak' AND hidungtersumbat='parah'
        ) AS 'demam',
        (
            SELECT COUNT(*) 
			FROM tblC45 AS C 
			WHERE C.diagnosa = 'flu' AND C.kelelahan = A.kelelahan AND bersin = 'parah' AND demam='tidak' AND hidungtersumbat='parah'
        ) AS 'flu'
    FROM tblC45 AS A WHERE bersin = 'parah' AND demam='tidak' AND hidungtersumbat='parah' GROUP BY kelelahan;

UPDATE tblHitung SET atribut = 'kelelahan' WHERE atribut IS NULL;



INSERT INTO tblHitung(informasi, jumlahdata, demam, flu)
    SELECT A.sakittenggorokan AS sakittenggorokan, COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*)
			FROM tblC45 AS B 
			WHERE B.diagnosa = 'demam' AND B.sakittenggorokan = A.sakittenggorokan AND bersin = 'parah' AND demam='tidak' AND hidungtersumbat='parah'
        ) AS 'demam',
        (
            SELECT COUNT(*) 
			FROM tblC45 AS C 
			WHERE C.diagnosa = 'flu' AND C.sakittenggorokan = A.sakittenggorokan AND bersin = 'parah' AND demam='tidak' AND hidungtersumbat='parah'
        ) AS 'flu'
    FROM tblC45 AS A WHERE bersin = 'parah' AND demam='tidak' AND hidungtersumbat='parah' GROUP BY sakittenggorokan;

UPDATE tblHitung SET atribut = 'sakittenggorokan' WHERE atribut IS NULL;



-- sulitbernapas
INSERT INTO tblHitung(informasi, jumlahdata, demam, flu)
    SELECT A.sulitbernapas AS sulitbernapas, COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*)
			FROM tblC45 AS B 
			WHERE B.diagnosa = 'demam' AND B.sulitbernapas = A.sulitbernapas AND bersin = 'parah' AND demam='tidak' AND hidungtersumbat='parah'
        ) AS 'demam',
        (
            SELECT COUNT(*) 
			FROM tblC45 AS C 
			WHERE C.diagnosa = 'flu' AND C.sulitbernapas = A.sulitbernapas AND bersin = 'parah' AND demam='tidak' AND hidungtersumbat='parah'
        ) AS 'flu'
    FROM tblC45 AS A WHERE bersin = 'parah' AND demam='tidak' AND hidungtersumbat='parah' GROUP BY sulitbernapas;

UPDATE tblHitung SET atribut = 'sulitbernapas' WHERE atribut IS NULL;


UPDATE tblHitung SET entropy = (-(demam/jumlahdata) * log2(demam/jumlahdata)) + (-(flu/jumlahdata) * log2(flu/jumlahdata));

UPDATE tblHitung SET entropy = 0 WHERE entropy IS NULL;

SELECT * FROM tblHitung;

DROP TABLE IF EXISTS tblTampung;
CREATE TEMPORARY TABLE tblTampung
(
    atribut VARCHAR(20),
    gain decimal(8,4)
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
SELECT atribut, MAX(gain) as Gain
FROM tblTampung;



-- 5


TRUNCATE TABLE tblHitung;

SELECT COUNT(*) INTO @jumlahdata
FROM tblC45 WHERE bersin = 'parah';

SELECT COUNT(*) INTO @demam 
FROM tblC45 WHERE diagnosa = 'demam' AND bersin = 'parah' ;

SELECT COUNT(*) INTO @flu FROM tblC45 
WHERE diagnosa = 'flu' AND bersin = 'parah';

SELECT (-(@demam/@jumlahdata) * log2(@demam/@jumlahdata)) + (-(@flu/@jumlahdata) * log2(@flu/@jumlahdata)) INTO @entropy;

SELECT @jumlahdata AS JUM_DATA,
@demam AS JAWAB_NO,
@flu AS JAWAB_flu,
ROUND(@entropy,4) AS ENTROPY;




-- sakitkepala
INSERT INTO tblHitung(informasi, jumlahdata, demam, flu)
    SELECT A.sakitkepala AS sakitkepala, COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*)
			FROM tblC45 AS B 
			WHERE B.diagnosa = 'demam' AND B.sakitkepala = A.sakitkepala AND bersin = 'parah' AND demam='tidak' AND hidungtersumbat='parah' AND kelelahan='tidak'
        ) AS 'demam',
        (
            SELECT COUNT(*) 
			FROM tblC45 AS C 
			WHERE C.diagnosa = 'flu' AND C.sakitkepala = A.sakitkepala AND bersin = 'parah' AND demam='tidak' AND hidungtersumbat='parah'  AND kelelahan='tidak'
        ) AS 'flu'
    FROM tblC45 AS A WHERE bersin = 'parah' AND demam='tidak' AND hidungtersumbat='parah'  AND kelelahan='tidak' GROUP BY sakitkepala;

UPDATE tblHitung SET atribut = 'sakitkepala' WHERE atribut IS NULL;

-- nyeri

INSERT INTO tblHitung(informasi, jumlahdata, demam, flu)
    SELECT A.nyeri AS nyeri, COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*)
			FROM tblC45 AS B 
			WHERE B.diagnosa = 'demam' AND B.nyeri = A.nyeri AND bersin = 'parah' AND demam='tidak' AND hidungtersumbat='parah'  AND kelelahan='tidak'
        ) AS 'demam',
        (
            SELECT COUNT(*) 
			FROM tblC45 AS C 
			WHERE C.diagnosa = 'flu' AND C.nyeri = A.nyeri AND bersin = 'parah' AND demam='tidak' AND hidungtersumbat='parah'  AND kelelahan='tidak'
        ) AS 'flu'
    FROM tblC45 AS A WHERE bersin = 'parah' AND demam='tidak' AND hidungtersumbat='parah'  AND kelelahan='tidak' GROUP BY nyeri;

UPDATE tblHitung SET atribut = 'nyeri' WHERE atribut IS NULL;

-- lemas
INSERT INTO tblHitung(informasi, jumlahdata, demam, flu)
    SELECT A.lemas AS lemas, COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*)
			FROM tblC45 AS B 
			WHERE B.diagnosa = 'demam' AND B.lemas = A.lemas AND bersin = 'parah' AND demam='tidak' AND hidungtersumbat='parah'  AND kelelahan='tidak'
        ) AS 'demam',
        (
            SELECT COUNT(*) 
			FROM tblC45 AS C 
			WHERE C.diagnosa = 'flu' AND C.lemas = A.lemas AND bersin = 'parah' AND demam='tidak' AND hidungtersumbat='parah'  AND kelelahan='tidak'
        ) AS 'flu'
    FROM tblC45 AS A WHERE bersin = 'parah' AND demam='tidak' AND hidungtersumbat='parah'  AND kelelahan='tidak' GROUP BY lemas;

UPDATE tblHitung SET atribut = 'lemas' WHERE atribut IS NULL;


INSERT INTO tblHitung(informasi, jumlahdata, demam, flu)
    SELECT A.sakittenggorokan AS sakittenggorokan, COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*)
			FROM tblC45 AS B 
			WHERE B.diagnosa = 'demam' AND B.sakittenggorokan = A.sakittenggorokan AND bersin = 'parah' AND demam='tidak' AND hidungtersumbat='parah'  AND kelelahan='tidak'
        ) AS 'demam',
        (
            SELECT COUNT(*) 
			FROM tblC45 AS C 
			WHERE C.diagnosa = 'flu' AND C.sakittenggorokan = A.sakittenggorokan AND bersin = 'parah' AND demam='tidak' AND hidungtersumbat='parah'  AND kelelahan='tidak'
        ) AS 'flu'
    FROM tblC45 AS A WHERE bersin = 'parah' AND demam='tidak' AND hidungtersumbat='parah'  AND kelelahan='tidak' GROUP BY sakittenggorokan;

UPDATE tblHitung SET atribut = 'sakittenggorokan' WHERE atribut IS NULL;



-- sulitbernapas
INSERT INTO tblHitung(informasi, jumlahdata, demam, flu)
    SELECT A.sulitbernapas AS sulitbernapas, COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*)
			FROM tblC45 AS B 
			WHERE B.diagnosa = 'demam' AND B.sulitbernapas = A.sulitbernapas AND bersin = 'parah' AND demam='tidak' AND hidungtersumbat='parah'  AND kelelahan='tidak'
        ) AS 'demam',
        (
            SELECT COUNT(*) 
			FROM tblC45 AS C 
			WHERE C.diagnosa = 'flu' AND C.sulitbernapas = A.sulitbernapas AND bersin = 'parah' AND demam='tidak' AND hidungtersumbat='parah'  AND kelelahan='tidak'
        ) AS 'flu'
    FROM tblC45 AS A WHERE bersin = 'parah' AND demam='tidak' AND hidungtersumbat='parah'  AND kelelahan='tidak' GROUP BY sulitbernapas;

UPDATE tblHitung SET atribut = 'sulitbernapas' WHERE atribut IS NULL;


UPDATE tblHitung SET entropy = (-(demam/jumlahdata) * log2(demam/jumlahdata)) + (-(flu/jumlahdata) * log2(flu/jumlahdata));

UPDATE tblHitung SET entropy = 0 WHERE entropy IS NULL;

SELECT * FROM tblHitung;

DROP TABLE IF EXISTS tblTampung;
CREATE TEMPORARY TABLE tblTampung
(
    atribut VARCHAR(20),
    gain decimal(8,4)
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
SELECT atribut, MAX(gain) as Gain
FROM tblTampung;



-- 6

TRUNCATE TABLE tblHitung;

SELECT COUNT(*) INTO @jumlahdata
FROM tblC45 WHERE bersin = 'parah';

SELECT COUNT(*) INTO @demam 
FROM tblC45 WHERE diagnosa = 'demam' AND bersin = 'parah' ;

SELECT COUNT(*) INTO @flu FROM tblC45 
WHERE diagnosa = 'flu' AND bersin = 'parah';

SELECT (-(@demam/@jumlahdata) * log2(@demam/@jumlahdata)) + (-(@flu/@jumlahdata) * log2(@flu/@jumlahdata)) INTO @entropy;

SELECT @jumlahdata AS JUM_DATA,
@demam AS JAWAB_NO,
@flu AS JAWAB_flu,
ROUND(@entropy,4) AS ENTROPY;




-- sakitkepala
INSERT INTO tblHitung(informasi, jumlahdata, demam, flu)
    SELECT A.sakitkepala AS sakitkepala, COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*)
			FROM tblC45 AS B 
			WHERE B.diagnosa = 'demam' AND B.sakitkepala = A.sakitkepala AND bersin = 'parah' AND demam='tidak' AND hidungtersumbat='parah' AND kelelahan='tidak' AND lemas='tidak'
        ) AS 'demam',
        (
            SELECT COUNT(*) 
			FROM tblC45 AS C 
			WHERE C.diagnosa = 'flu' AND C.sakitkepala = A.sakitkepala AND bersin = 'parah' AND demam='tidak' AND hidungtersumbat='parah'  AND kelelahan='tidak'  AND lemas='tidak'
        ) AS 'flu'
    FROM tblC45 AS A WHERE bersin = 'parah' AND demam='tidak' AND hidungtersumbat='parah'  AND kelelahan='tidak' AND lemas='tidak' GROUP BY sakitkepala;

UPDATE tblHitung SET atribut = 'sakitkepala' WHERE atribut IS NULL;

-- nyeri

INSERT INTO tblHitung(informasi, jumlahdata, demam, flu)
    SELECT A.nyeri AS nyeri, COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*)
			FROM tblC45 AS B 
			WHERE B.diagnosa = 'demam' AND B.nyeri = A.nyeri AND bersin = 'parah' AND demam='tidak' AND hidungtersumbat='parah'  AND kelelahan='tidak'  AND lemas='tidak'
        ) AS 'demam',
        (
            SELECT COUNT(*) 
			FROM tblC45 AS C 
			WHERE C.diagnosa = 'flu' AND C.nyeri = A.nyeri AND bersin = 'parah' AND demam='tidak' AND hidungtersumbat='parah'  AND kelelahan='tidak' AND lemas='tidak'
        ) AS 'flu'
    FROM tblC45 AS A WHERE bersin = 'parah' AND demam='tidak' AND hidungtersumbat='parah'  AND kelelahan='tidak' AND lemas='tidak' GROUP BY nyeri;

UPDATE tblHitung SET atribut = 'nyeri' WHERE atribut IS NULL;



INSERT INTO tblHitung(informasi, jumlahdata, demam, flu)
    SELECT A.sakittenggorokan AS sakittenggorokan, COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*)
			FROM tblC45 AS B 
			WHERE B.diagnosa = 'demam' AND B.sakittenggorokan = A.sakittenggorokan AND bersin = 'parah' AND demam='tidak' AND hidungtersumbat='parah'  AND kelelahan='tidak' AND lemas='tidak'
        ) AS 'demam',
        (
            SELECT COUNT(*) 
			FROM tblC45 AS C 
			WHERE C.diagnosa = 'flu' AND C.sakittenggorokan = A.sakittenggorokan AND bersin = 'parah' AND demam='tidak' AND hidungtersumbat='parah'  AND kelelahan='tidak' AND lemas='tidak'
        ) AS 'flu'
    FROM tblC45 AS A WHERE bersin = 'parah' AND demam='tidak' AND hidungtersumbat='parah'  AND kelelahan='tidak' AND lemas='tidak' GROUP BY sakittenggorokan;

UPDATE tblHitung SET atribut = 'sakittenggorokan' WHERE atribut IS NULL;



-- sulitbernapas
INSERT INTO tblHitung(informasi, jumlahdata, demam, flu)
    SELECT A.sulitbernapas AS sulitbernapas, COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*)
			FROM tblC45 AS B 
			WHERE B.diagnosa = 'demam' AND B.sulitbernapas = A.sulitbernapas AND bersin = 'parah' AND demam='tidak' AND hidungtersumbat='parah'  AND kelelahan='tidak' AND lemas='tidak'
        ) AS 'demam',
        (
            SELECT COUNT(*) 
			FROM tblC45 AS C 
			WHERE C.diagnosa = 'flu' AND C.sulitbernapas = A.sulitbernapas AND bersin = 'parah' AND demam='tidak' AND hidungtersumbat='parah'  AND kelelahan='tidak' AND lemas='tidak'
        ) AS 'flu'
    FROM tblC45 AS A WHERE bersin = 'parah' AND demam='tidak' AND hidungtersumbat='parah'  AND kelelahan='tidak' AND lemas='tidak' GROUP BY sulitbernapas;

UPDATE tblHitung SET atribut = 'sulitbernapas' WHERE atribut IS NULL;


UPDATE tblHitung SET entropy = (-(demam/jumlahdata) * log2(demam/jumlahdata)) + (-(flu/jumlahdata) * log2(flu/jumlahdata));

UPDATE tblHitung SET entropy = 0 WHERE entropy IS NULL;

SELECT * FROM tblHitung;

DROP TABLE IF EXISTS tblTampung;
CREATE TEMPORARY TABLE tblTampung
(
    atribut VARCHAR(20),
    gain decimal(8,4)
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
SELECT atribut, MAX(gain) as Gain
FROM tblTampung;



-- 7

TRUNCATE TABLE tblHitung;

SELECT COUNT(*) INTO @jumlahdata
FROM tblC45 WHERE bersin = 'parah';

SELECT COUNT(*) INTO @demam 
FROM tblC45 WHERE diagnosa = 'demam' AND bersin = 'parah' ;

SELECT COUNT(*) INTO @flu FROM tblC45 
WHERE diagnosa = 'flu' AND bersin = 'parah';

SELECT (-(@demam/@jumlahdata) * log2(@demam/@jumlahdata)) + (-(@flu/@jumlahdata) * log2(@flu/@jumlahdata)) INTO @entropy;

SELECT @jumlahdata AS JUM_DATA,
@demam AS JAWAB_NO,
@flu AS JAWAB_flu,
ROUND(@entropy,4) AS ENTROPY;




-- sakitkepala
INSERT INTO tblHitung(informasi, jumlahdata, demam, flu)
    SELECT A.sakitkepala AS sakitkepala, COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*)
			FROM tblC45 AS B 
			WHERE B.diagnosa = 'demam' AND B.sakitkepala = A.sakitkepala AND bersin = 'parah' AND demam='tidak' AND hidungtersumbat='parah' AND kelelahan='tidak' AND lemas='tidak' AND nyeri='tidak'
        ) AS 'demam',
        (
            SELECT COUNT(*) 
			FROM tblC45 AS C 
			WHERE C.diagnosa = 'flu' AND C.sakitkepala = A.sakitkepala AND bersin = 'parah' AND demam='tidak' AND hidungtersumbat='parah'  AND kelelahan='tidak'  AND lemas='tidak'  AND nyeri='tidak'
        ) AS 'flu'
    FROM tblC45 AS A WHERE bersin = 'parah' AND demam='tidak' AND hidungtersumbat='parah'  AND kelelahan='tidak' AND lemas='tidak' AND nyeri='tidak' GROUP BY sakitkepala;

UPDATE tblHitung SET atribut = 'sakitkepala' WHERE atribut IS NULL;




-- sakit tenggorokan
INSERT INTO tblHitung(informasi, jumlahdata, demam, flu)
    SELECT A.sakittenggorokan AS sakittenggorokan, COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*)
			FROM tblC45 AS B 
			WHERE B.diagnosa = 'demam' AND B.sakittenggorokan = A.sakittenggorokan AND bersin = 'parah' AND demam='tidak' AND hidungtersumbat='parah'  AND kelelahan='tidak' AND lemas='tidak'  AND nyeri='tidak'
        ) AS 'demam',
        (
            SELECT COUNT(*) 
			FROM tblC45 AS C 
			WHERE C.diagnosa = 'flu' AND C.sakittenggorokan = A.sakittenggorokan AND bersin = 'parah' AND demam='tidak' AND hidungtersumbat='parah'  AND kelelahan='tidak' AND lemas='tidak'  AND nyeri='tidak'
        ) AS 'flu'
    FROM tblC45 AS A WHERE bersin = 'parah' AND demam='tidak' AND hidungtersumbat='parah'  AND kelelahan='tidak' AND lemas='tidak'  AND nyeri='tidak' GROUP BY sakittenggorokan;

UPDATE tblHitung SET atribut = 'sakittenggorokan' WHERE atribut IS NULL;



-- sulitbernapas
INSERT INTO tblHitung(informasi, jumlahdata, demam, flu)
    SELECT A.sulitbernapas AS sulitbernapas, COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*)
			FROM tblC45 AS B 
			WHERE B.diagnosa = 'demam' AND B.sulitbernapas = A.sulitbernapas AND bersin = 'parah' AND demam='tidak' AND hidungtersumbat='parah'  AND kelelahan='tidak' AND lemas='tidak'  AND nyeri='tidak'
        ) AS 'demam',
        (
            SELECT COUNT(*) 
			FROM tblC45 AS C 
			WHERE C.diagnosa = 'flu' AND C.sulitbernapas = A.sulitbernapas AND bersin = 'parah' AND demam='tidak' AND hidungtersumbat='parah'  AND kelelahan='tidak' AND lemas='tidak'  AND nyeri='tidak'
        ) AS 'flu'
    FROM tblC45 AS A WHERE bersin = 'parah' AND demam='tidak' AND hidungtersumbat='parah'  AND kelelahan='tidak' AND lemas='tidak'  AND nyeri='tidak' GROUP BY sulitbernapas;

UPDATE tblHitung SET atribut = 'sulitbernapas' WHERE atribut IS NULL;


UPDATE tblHitung SET entropy = (-(demam/jumlahdata) * log2(demam/jumlahdata)) + (-(flu/jumlahdata) * log2(flu/jumlahdata));

UPDATE tblHitung SET entropy = 0 WHERE entropy IS NULL;

SELECT * FROM tblHitung;

DROP TABLE IF EXISTS tblTampung;
CREATE TEMPORARY TABLE tblTampung
(
    atribut VARCHAR(20),
    gain decimal(8,4)
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
SELECT atribut, MAX(gain) as Gain
FROM tblTampung;


-- 8
TRUNCATE TABLE tblHitung;

SELECT COUNT(*) INTO @jumlahdata
FROM tblC45 WHERE bersin = 'parah';

SELECT COUNT(*) INTO @demam 
FROM tblC45 WHERE diagnosa = 'demam' AND bersin = 'parah' ;

SELECT COUNT(*) INTO @flu FROM tblC45 
WHERE diagnosa = 'flu' AND bersin = 'parah';

SELECT (-(@demam/@jumlahdata) * log2(@demam/@jumlahdata)) + (-(@flu/@jumlahdata) * log2(@flu/@jumlahdata)) INTO @entropy;

SELECT @jumlahdata AS JUM_DATA,
@demam AS JAWAB_NO,
@flu AS JAWAB_flu,
ROUND(@entropy,4) AS ENTROPY;


-- sakit tenggorokan
INSERT INTO tblHitung(informasi, jumlahdata, demam, flu)
    SELECT A.sakittenggorokan AS sakittenggorokan, COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*)
			FROM tblC45 AS B 
			WHERE B.diagnosa = 'demam' AND B.sakittenggorokan = A.sakittenggorokan AND bersin = 'parah' AND demam='tidak' AND hidungtersumbat='parah'  AND kelelahan='tidak' AND lemas='tidak'  AND nyeri='tidak' AND sakitkepala='tidak'
        ) AS 'demam',
        (
            SELECT COUNT(*) 
			FROM tblC45 AS C 
			WHERE C.diagnosa = 'flu' AND C.sakittenggorokan = A.sakittenggorokan AND bersin = 'parah' AND demam='tidak' AND hidungtersumbat='parah'  AND kelelahan='tidak' AND lemas='tidak'  AND nyeri='tidak' AND sakitkepala='tidak'
        ) AS 'flu'
    FROM tblC45 AS A WHERE bersin = 'parah' AND demam='tidak' AND hidungtersumbat='parah'  AND kelelahan='tidak' AND lemas='tidak'  AND nyeri='tidak'  AND sakitkepala='tidak' GROUP BY sakittenggorokan;

UPDATE tblHitung SET atribut = 'sakittenggorokan' WHERE atribut IS NULL;



-- sulitbernapas
INSERT INTO tblHitung(informasi, jumlahdata, demam, flu)
    SELECT A.sulitbernapas AS sulitbernapas, COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*)
			FROM tblC45 AS B 
			WHERE B.diagnosa = 'demam' AND B.sulitbernapas = A.sulitbernapas AND bersin = 'parah' AND demam='tidak' AND hidungtersumbat='parah'  AND kelelahan='tidak' AND lemas='tidak'  AND nyeri='tidak' AND sakitkepala='tidak'
        ) AS 'demam',
        (
            SELECT COUNT(*) 
			FROM tblC45 AS C 
			WHERE C.diagnosa = 'flu' AND C.sulitbernapas = A.sulitbernapas AND bersin = 'parah' AND demam='tidak' AND hidungtersumbat='parah'  AND kelelahan='tidak' AND lemas='tidak'  AND nyeri='tidak' AND sakitkepala='tidak'
        ) AS 'flu'
    FROM tblC45 AS A WHERE bersin = 'parah' AND demam='tidak' AND hidungtersumbat='parah'  AND kelelahan='tidak' AND lemas='tidak'  AND nyeri='tidak' AND sakitkepala='tidak' GROUP BY sulitbernapas;

UPDATE tblHitung SET atribut = 'sulitbernapas' WHERE atribut IS NULL;


UPDATE tblHitung SET entropy = (-(demam/jumlahdata) * log2(demam/jumlahdata)) + (-(flu/jumlahdata) * log2(flu/jumlahdata));

UPDATE tblHitung SET entropy = 0 WHERE entropy IS NULL;

SELECT * FROM tblHitung;

DROP TABLE IF EXISTS tblTampung;
CREATE TEMPORARY TABLE tblTampung
(
    atribut VARCHAR(20),
    gain decimal(8,4)
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
SELECT atribut, MAX(gain) as Gain
FROM tblTampung;

-- 9
TRUNCATE TABLE tblHitung;

SELECT COUNT(*) INTO @jumlahdata
FROM tblC45 WHERE bersin = 'parah';

SELECT COUNT(*) INTO @demam 
FROM tblC45 WHERE diagnosa = 'demam' AND bersin = 'parah' ;

SELECT COUNT(*) INTO @flu FROM tblC45 
WHERE diagnosa = 'flu' AND bersin = 'parah';

SELECT (-(@demam/@jumlahdata) * log2(@demam/@jumlahdata)) + (-(@flu/@jumlahdata) * log2(@flu/@jumlahdata)) INTO @entropy;

SELECT @jumlahdata AS JUM_DATA,
@demam AS JAWAB_NO,
@flu AS JAWAB_flu,
ROUND(@entropy,4) AS ENTROPY;

-- sulitbernapas
INSERT INTO tblHitung(informasi, jumlahdata, demam, flu)
    SELECT A.sulitbernapas AS sulitbernapas, COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*)
			FROM tblC45 AS B 
			WHERE B.diagnosa = 'demam' AND B.sulitbernapas = A.sulitbernapas AND bersin = 'parah' AND demam='tidak' AND hidungtersumbat='parah'  AND kelelahan='tidak' AND lemas='tidak'  AND nyeri='tidak' AND sakitkepala='tidak' AND sakittenggorokan='parah'
        ) AS 'demam',
        (
            SELECT COUNT(*) 
			FROM tblC45 AS C 
			WHERE C.diagnosa = 'flu' AND C.sulitbernapas = A.sulitbernapas AND bersin = 'parah' AND demam='tidak' AND hidungtersumbat='parah'  AND kelelahan='tidak' AND lemas='tidak'  AND nyeri='tidak' AND sakitkepala='tidak' AND sakittenggorokan='parah'
        ) AS 'flu'
    FROM tblC45 AS A WHERE bersin = 'parah' AND demam='tidak' AND hidungtersumbat='parah'  AND kelelahan='tidak' AND lemas='tidak'  AND nyeri='tidak' AND sakitkepala='tidak' AND sakittenggorokan='parah' GROUP BY sulitbernapas;

UPDATE tblHitung SET atribut = 'sulitbernapas' WHERE atribut IS NULL;


UPDATE tblHitung SET entropy = (-(demam/jumlahdata) * log2(demam/jumlahdata)) + (-(flu/jumlahdata) * log2(flu/jumlahdata));

UPDATE tblHitung SET entropy = 0 WHERE entropy IS NULL;

SELECT * FROM tblHitung;

DROP TABLE IF EXISTS tblTampung;
CREATE TEMPORARY TABLE tblTampung
(
    atribut VARCHAR(20),
    gain decimal(8,4)
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
SELECT atribut, MAX(gain) as Gain
FROM tblTampung;


