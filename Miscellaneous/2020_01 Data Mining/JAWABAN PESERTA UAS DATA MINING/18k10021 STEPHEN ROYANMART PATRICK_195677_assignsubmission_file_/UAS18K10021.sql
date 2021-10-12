-- Stephen Royanmart Patrick
-- 18.K1.0021
-- Unika SOEGIJAPRANATA

DROP DATABASE IF EXISTS dbC45;
CREATE DATABASE dbC45;
USE dbC45;

CREATE TABLE tblC45
(
    nourut VARCHAR(255),
    demam VARCHAR(255),
    sakitKepala VARCHAR(255),
    nyeri VARCHAR(255),
    lemas VARCHAR(255),
    kelelahan VARCHAR(255),
    hidungTersumbat VARCHAR(255),
    bersin VARCHAR(255),
    sakitTenggorokan VARCHAR(255),
    sulitBernafas VARCHAR(255),
    diagnosa VARCHAR(255)
);

INSERT INTO tblC45 VALUE
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
("P16",	"Tidak", 	"Tidak",	"Tidak",	"Tidak",	"Tidak",	"Parah",	"Parah",	"Parah",	"Parah",	"Demam"),
("P17",	"Parah",	"Ringan",	"Parah",	"Ringan",	"Ringan",	"Tidak",	"Tidak",	"Tidak",	"Parah",	"Flu");

SELECT * FROM tblC45;

-- Langkah 2, buat table hasil hitungan
CREATE TABLE tblHitung
(
    iterasi INT,
    atribut VARCHAR(255),
    informasi VARCHAR(20),
    jumlahdata INT,
    diagnosaflu INT,
    diagnosademam INT,
    entrophy DECIMAL(8,4) DEFAULT 0,
    gain DECIMAL(8,4) DEFAULT 0
);

CREATE TABLE tblPakai
(
    atribut VARCHAR(255),
    informasi VARCHAR(20)
);

SELECT COUNT(*) INTO @jumlahdata 
FROM tblC45;

SELECT COUNT(*) INTO @diagnosaflu
FROM tblC45
WHERE diagnosa='flu';

SELECT COUNT(*) INTO @diagnosademam
FROM tblC45
WHERE diagnosa='demam';

SET @iterasi=1;

-- Langkah 3, melakukan proses untuk setiap atribut
-- Untuk pertama banget
DELIMITER ##
CREATE PROCEDURE spCek1()
BEGIN
    DECLARE i, done, vJumData INT DEFAULT 0;
    DECLARE vData VARCHAR(255);
    DECLARE vCode, vUpdate TEXT;
    DECLARE cData CURSOR FOR 
        SELECT `COLUMN_NAME` AS 'Kolom'
        FROM `INFORMATION_SCHEMA`.`COLUMNS` 
        WHERE `TABLE_SCHEMA`='dbC45' AND 
        `TABLE_NAME`='tblC45' AND 
        `COLUMN_NAME` NOT IN('nourut', 'diagnosa'); 
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    SELECT (-(@diagnosaflu/@jumlahdata) * LOG2(@diagnosaflu/@jumlahdata)) +
    (-(@diagnosademam/@jumlahdata) * LOG2(@diagnosademam/@jumlahdata)) INTO @entrophy;

    SELECT @jumlahdata AS JUM_DATA,
    @diagnosaflu AS Flu,
    @diagnosademam AS Demam,
    ROUND(@entrophy, 4) AS ENTROPHY;

    INSERT INTO tblHitung(iterasi, atribut, jumlahdata, diagnosaflu, diagnosademam, entrophy)
    VALUES(@iterasi, 'TOTAL DATA', @jumlahdata, @diagnosaflu, @diagnosademam, @entrophy);

    SELECT COUNT(*) INTO vJumData
    FROM `INFORMATION_SCHEMA`.`COLUMNS` 
    WHERE `TABLE_SCHEMA`='dbC45' AND 
        `TABLE_NAME`='tblC45' AND 
        `COLUMN_NAME` NOT IN('nourut', 'diagnosa'); 

    OPEN cData;
    WHILE i < vJumData
    DO
        FETCH cData INTO vData;
        SET vCode = CONCAT("INSERT INTO tblHitung(iterasi, informasi, jumlahdata, diagnosaflu, diagnosademam) ", "SELECT @iterasi, A.", vData, ", COUNT(*) AS JUMLAH_DATA,
            (
                SELECT COUNT(*) 
                FROM tblC45 AS B
                WHERE B.diagnosa = 'flu' AND B.", vData, "=A.", vData, "
            ) AS 'flu',
            (        
                SELECT COUNT(*) 
                FROM tblC45 AS C
                WHERE C.diagnosa = 'demam' AND C.", vData, "=A.", vData, "
            ) AS 'demam'
            FROM tblC45 AS A
            GROUP BY ", vData, ";");
        PREPARE eksekusi FROM vCode;
        EXECUTE eksekusi;

        SET vUpdate = CONCAT("UPDATE tblHitung SET atribut='", UCASE(vData), "' WHERE atribut IS NULL");
        PREPARE eksekusiUpdate FROM vUpdate;
        EXECUTE eksekusiUpdate;

        SET i=i+1;
    END WHILE;

    -- Langkah 4, menghitung entrophy
    UPDATE tblHitung SET entrophy = (-(diagnosaflu/jumlahdata)*LOG2(diagnosaflu/jumlahdata)) +
    (-(diagnosademam/jumlahdata) * LOG2(diagnosademam/jumlahdata))
    WHERE 
        diagnosaflu<>0 
        AND 
        diagnosademam<>0
        AND
        iterasi=@iterasi;

    -- Langkah 5, menghitung tabel temporer
    DROP TABLE IF EXISTS tblTampung;
    CREATE TEMPORARY TABLE tblTampung
    (
        atribut VARCHAR(255),
        gain DECIMAL(8,4)
    );

    INSERT INTO tblTampung(atribut, gain)
    SELECT atribut, @entrophy-SUM((jumlahdata/@jumlahdata) * entrophy) AS gain
    FROM tblHitung
    WHERE iterasi=@iterasi
    GROUP BY atribut;

    UPDATE tblHitung SET GAIN=
    (
        SELECT gain
        FROM tblTampung
        WHERE atribut=tblHitung.atribut
    )
    WHERE iterasi=@iterasi;

    -- Langkah 4, menghitung entrophy
    UPDATE tblHitung 
    SET entrophy = (-(diagnosaflu/jumlahdata)*LOG2(diagnosaflu/jumlahdata)) +
    (-(diagnosademam/jumlahdata) * LOG2(diagnosademam/jumlahdata))
    WHERE diagnosaflu<>0 AND diagnosademam<>0 AND iterasi=@iterasi;

    -- Langkah 5, menghitung tabel temporer
    DROP TABLE IF EXISTS tblTampung;
    CREATE TEMPORARY TABLE tblTampung
    (
        atribut VARCHAR(255),
        gain DECIMAL(8,4)
    );

    INSERT INTO tblTampung(atribut, gain)
    SELECT atribut, @entrophy-SUM((jumlahdata/@jumlahdata) * entrophy) AS gain
    FROM tblHitung
    WHERE iterasi=@iterasi
    GROUP BY atribut;

    UPDATE tblHitung SET GAIN=
    (
        SELECT gain
        FROM tblTampung
        WHERE atribut=tblHitung.atribut
    )
    WHERE iterasi=@iterasi;

    SELECT * FROM tblHitung;

    SELECT MAX(gain) INTO 
    @maxGain FROM tblHitung
    WHERE iterasi=@iterasi;

    INSERT INTO tblPakai
        SELECT atribut, informasi 
        FROM tblHitung
        WHERE 
            gain = @maxGain 
            AND 
            (entrophy = (SELECT MAX(entrophy) FROM tblHitung WHERE gain = @maxGain AND iterasi=@iterasi))
            AND iterasi=@iterasi;

    SELECT CONCAT(atribut," ",informasi) INTO @atribut
    FROM tblHitung
    WHERE gain=@maxGain AND entrophy<>0 AND iterasi=@iterasi;

    SELECT jumlahdata INTO @jumlahdata 
    FROM tblHitung
    WHERE gain=@maxGain AND entrophy<>0 AND iterasi=@iterasi;

    SELECT diagnosaflu INTO @diagnosaflu
    FROM tblHitung
    WHERE  gain=@maxGain AND entrophy<>0 AND iterasi=@iterasi;

    SELECT diagnosademam INTO @diagnosademam
    FROM tblHitung
    WHERE gain=@maxGain AND entrophy<>0 AND iterasi=@iterasi;

    SET @iterasi=@iterasi+1;
END##
DELIMITER ;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

DELIMITER ##
CREATE PROCEDURE spCekLoop()
BEGIN
    DECLARE i, done, vJumData INT DEFAULT 0;
    DECLARE vData VARCHAR(255);
    DECLARE vCode, vUpdate TEXT;
    DECLARE cData CURSOR FOR 
        SELECT `COLUMN_NAME` AS 'Kolom'
        FROM `INFORMATION_SCHEMA`.`COLUMNS` 
        WHERE `TABLE_SCHEMA`='dbC45' AND 
        `TABLE_NAME`='tblC45' AND 
        `COLUMN_NAME` NOT IN('nourut', 'diagnosa'); 
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    SELECT (-(@diagnosaflu/@jumlahdata) * LOG2(@diagnosaflu/@jumlahdata)) +
    (-(@diagnosademam/@jumlahdata) * LOG2(@diagnosademam/@jumlahdata)) INTO @entrophy;

    SELECT @jumlahdata AS JUM_DATA,
    @diagnosaflu AS Flu,
    @diagnosademam AS Demam,
    ROUND(@entrophy, 4) AS ENTROPHY;

    INSERT INTO tblHitung(iterasi, atribut, jumlahdata, diagnosaflu, diagnosademam, entrophy)
    VALUES(@iterasi, (SELECT GROUP_CONCAT(CONCAT(atribut, " ", informasi) SEPARATOR ", ") FROM tblPakai), @jumlahdata, @diagnosaflu, @diagnosademam, @entrophy);

    SELECT COUNT(*) INTO vJumData
    FROM `INFORMATION_SCHEMA`.`COLUMNS` 
    WHERE `TABLE_SCHEMA`='dbC45' AND 
        `TABLE_NAME`='tblC45' AND 
        `COLUMN_NAME` NOT IN('nourut', 'diagnosa'); 

    OPEN cData;
    WHILE i < vJumData
    DO
        FETCH cData INTO vData;
        IF vData NOT IN (SELECT atribut FROM tblPakai)
        THEN
            SET vCode = CONCAT("INSERT INTO tblHitung(iterasi, informasi, jumlahdata, diagnosaflu, diagnosademam) ", "SELECT @iterasi, A.", vData, ", COUNT(*) AS JUMLAH_DATA,
                (
                    SELECT COUNT(*) 
                    FROM tblC45 AS B
                    WHERE B.diagnosa = 'flu' ", (SELECT CONCAT('AND ', GROUP_CONCAT(CONCAT('A.', atribut, '=B.', atribut) SEPARATOR ' AND ')) FROM tblPakai), " AND B.", vData, "=A.", vData, "
                ) AS 'flu',
                (        
                    SELECT COUNT(*) 
                    FROM tblC45 AS C
                    WHERE C.diagnosa = 'demam' ", (SELECT CONCAT('AND ', GROUP_CONCAT(CONCAT('A.', atribut, '=C.', atribut) SEPARATOR ' AND ')) FROM tblPakai), " AND C.", vData, "=A.", vData, "
                ) AS 'demam'
                FROM tblC45 AS A
                WHERE ", (SELECT CONCAT(GROUP_CONCAT(CONCAT(atribut,'="', informasi, '"') SEPARATOR ' AND ')) FROM tblPakai), " 
                GROUP BY ", vData, ";");
            PREPARE eksekusi FROM vCode;
            EXECUTE eksekusi;

            SET vUpdate = CONCAT("UPDATE tblHitung SET atribut='", UCASE(vData), "' WHERE atribut IS NULL");
            PREPARE eksekusiUpdate FROM vUpdate;
            EXECUTE eksekusiUpdate;
        END IF;
        SET i=i+1;
    END WHILE;

    -- Langkah 4, menghitung entrophy
    UPDATE tblHitung SET entrophy = (-(diagnosaflu/jumlahdata)*LOG2(diagnosaflu/jumlahdata)) +
    (-(diagnosademam/jumlahdata) * LOG2(diagnosademam/jumlahdata))
    WHERE 
        diagnosaflu<>0 
        AND 
        diagnosademam<>0
        AND
        iterasi=@iterasi;

    -- Langkah 5, menghitung tabel temporer
    DROP TABLE IF EXISTS tblTampung;
    CREATE TEMPORARY TABLE tblTampung
    (
        atribut VARCHAR(255),
        gain DECIMAL(8,4)
    );

    INSERT INTO tblTampung(atribut, gain)
    SELECT atribut, @entrophy-SUM((jumlahdata/@jumlahdata) * entrophy) AS gain
    FROM tblHitung
    WHERE iterasi=@iterasi
    GROUP BY atribut;

    UPDATE tblHitung SET GAIN=
    (
        SELECT gain
        FROM tblTampung
        WHERE atribut=tblHitung.atribut
    )
    WHERE iterasi=@iterasi;

    SELECT * FROM tblHitung WHERE iterasi=@iterasi;

    -- Langkah 4, menghitung entrophy
    UPDATE tblHitung 
    SET entrophy = (-(diagnosaflu/jumlahdata)*LOG2(diagnosaflu/jumlahdata)) +
    (-(diagnosademam/jumlahdata) * LOG2(diagnosademam/jumlahdata))
    WHERE diagnosaflu<>0 AND diagnosademam<>0 AND iterasi=@iterasi;

    -- Langkah 5, menghitung tabel temporer
    DROP TABLE IF EXISTS tblTampung;
    CREATE TEMPORARY TABLE tblTampung
    (
        atribut VARCHAR(255),
        gain DECIMAL(8,4)
    );

    INSERT INTO tblTampung(atribut, gain)
    SELECT atribut, @entrophy-SUM((jumlahdata/@jumlahdata) * entrophy) AS gain
    FROM tblHitung
    WHERE iterasi=@iterasi
    GROUP BY atribut;

    UPDATE tblHitung SET GAIN=
    (
        SELECT gain
        FROM tblTampung
        WHERE atribut=tblHitung.atribut
    )
    WHERE iterasi=@iterasi;

    SELECT MAX(gain) INTO 
    @maxGain FROM tblHitung
    WHERE iterasi=@iterasi;

    INSERT INTO tblPakai
        SELECT atribut, informasi 
        FROM tblHitung
        WHERE 
            gain = @maxGain 
            AND 
            (entrophy = (SELECT MAX(entrophy) FROM tblHitung WHERE gain = @maxGain AND iterasi=@iterasi))
            AND 
            iterasi=@iterasi;

    SELECT CONCAT(atribut," ",informasi) INTO @atribut
    FROM tblHitung
    WHERE gain=@maxGain AND entrophy<>0 AND iterasi=@iterasi;

    SELECT jumlahdata INTO @jumlahdata 
    FROM tblHitung
    WHERE gain=@maxGain AND entrophy<>0 AND iterasi=@iterasi;

    SELECT diagnosaflu INTO @diagnosaflu
    FROM tblHitung
    WHERE  gain=@maxGain AND entrophy<>0 AND iterasi=@iterasi;

    SELECT diagnosademam INTO @diagnosademam
    FROM tblHitung
    WHERE gain=@maxGain AND entrophy<>0 AND iterasi=@iterasi;

    SET @iterasi=@iterasi+1;
END##

CREATE PROCEDURE spEksekusi()
BEGIN
    CALL spCek1();

    WHILE ((SELECT MAX(gain) FROM tblHitung WHERE iterasi=@iterasi-1)<>(SELECT ROUND(@entrophy,4)))
    DO
        CALL spCekLoop();
    END WHILE;

    IF (@iterasi-1=1)
        THEN
            SELECT UCASE(CONCAT("Apabila seorang ",atribut, " ",informasi,", Seseorang tersebut didiagnosa ", (IF(diagnosaflu>diagnosademam,'Flu','Demam')))) AS Kesimpulan
            FROM tblHitung 
            WHERE (gain=(SELECT MAX(gain) FROM tblHitung WHERE iterasi=@iterasi-1)) 
                AND (iterasi=@iterasi-1);
    ELSE
        SELECT UCASE(CONCAT("Apabila seorang ", (SELECT atribut FROM tblHitung WHERE (informasi IS NULL) AND iterasi=@iterasi-1), ", ", atribut, " ",informasi, ", Seseorang tersebut didiagnosa ", (IF(diagnosaflu>diagnosademam,'Flu','Demam')))) AS Kesimpulan
        FROM tblHitung 
        WHERE (gain=(SELECT MAX(gain) FROM tblHitung WHERE iterasi=@iterasi-1)) 
            AND (iterasi=@iterasi-1);
    END IF;
END##
DELIMITER ;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- Eksekusi -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
CALL spEksekusi();