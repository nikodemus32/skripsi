DROP DATABASE IF EXISTS dbC45;
CREATE DATABASE dbC45;
USE dbC45;

CREATE TABLE tbData
(
    PASIEN VARCHAR(5),
    DEMAM VARCHAR(10),
    SAKIT_KEPALA VARCHAR(10),
    NYERI VARCHAR(10),
    LEMAS VARCHAR(10),
    KELELAHAN VARCHAR(10),
    HIDUNG_TERSUMBAT VARCHAR(10),
    BERSIN VARCHAR(10),
    SAKIT_TENGGOROKAN VARCHAR(10),
    SULIT_BERNAFAS VARCHAR(10),
    DIAGNOSA VARCHAR(10)
);

INSERT INTO tbData VALUES
('P1', 'Tidak',    'Ringan', 'Tidak',    'Tidak',     'Tidak', 'Ringan',    'Parah',    'Parah',    'Ringan',    'Demam'),
('P2', 'Parah',    'Parah', 'Parah',    'Parah',     'Parah', 'Tidak',    'Tidak',    'Parah',    'Parah',    'Flu'),
('P3', 'Parah',    'Parah', 'Ringan',    'Parah',     'Parah', 'Parah',    'Tidak',    'Parah',    'Parah',    'Flu'),
('P4', 'Tidak',    'Tidak', 'Tidak',    'Ringan',     'Tidak', 'Parah',    'Tidak',    'Ringan',    'Ringan',    'Demam'),
('P5', 'Parah',    'Parah', 'Ringan',    'Parah',     'Parah', 'Parah',    'Tidak',    'Parah',    'Parah',    'Flu'),
('P6', 'Tidak',    'Tidak', 'Tidak',    'Ringan',     'Tidak', 'Parah',    'Parah',    'Parah',    'Tidak',    'Demam'),
('P7', 'Parah',    'Parah', 'Parah',    'Parah',     'Parah', 'Tidak',    'Tidak',    'Tidak',    'Parah',    'Flu'),
('P8', 'Tidak',    'Tidak', 'Tidak',    'Tidak',     'Tidak', 'Parah',    'Parah',    'Tidak',    'Ringan',    'Demam'),
('P9', 'Tidak',    'Ringan', 'Ringan',    'Tidak',     'Tidak', 'Parah',    'Parah',    'Parah',    'Parah',    'Demam'),
('P10', 'Parah', 'Parah', 'Parah',    'Ringan',     'Ringan', 'Tidak',    'Parah',    'Tidak',    'Parah',    'Flu'),
('P11', 'Tidak', 'Tidak', 'Tidak',    'Ringan',     'Tidak', 'Parah',    'Ringan',    'Parah',    'Tidak',    'Demam'),
('P12', 'Parah', 'Ringan', 'Parah',    'Ringan',     'Parah', 'Tidak',    'Parah',    'Tidak',    'Ringan',    'Flu'),
('P13', 'Tidak', 'Tidak', 'Ringan',    'Ringan',     'Tidak', 'Parah',    'Parah',    'Parah',    'Tidak',    'Demam'),
('P14', 'Parah', 'Parah', 'Parah',    'Parah',     'Ringan', 'Tidak',    'Parah',    'Parah',    'Parah',    'Flu'),
('P15', 'Ringan', 'Tidak', 'Tidak',    'Ringan',     'Tidak', 'Parah',    'Tidak',    'Parah',    'Ringan',    'Demam'),
('P16', 'Tidak', 'Tidak', 'Tidak',    'Tidak',     'Tidak', 'Parah',    'Parah',    'Parah',    'Parah',    'Demam'),
('P17', 'Parah', 'Ringan', 'Parah',    'Ringan',     'Ringan', 'Tidak',    'Tidak',    'Tidak',    'Parah',    'Flu');

-- SELECT * FROM tbData;

CREATE TABLE tbHitung
(
    ATRIBUT VARCHAR(20),
    SUB_ATRIBUT VARCHAR(20),
    SUM_DATA VARCHAR(20),
    DIAG_DEMAM INT,
    DIAG_FLU INT,
    ENTROPY DECIMAL(8,4),
    GAIN DECIMAL(8,4)
);

DELIMITER $$

    CREATE PROCEDURE spUtama()
        BEGIN

            DECLARE vMuter INT DEFAULT 1;

            WHILE vMuter <> 0 DO

                -- Hitung Diagnosa
                call spHitungDiagnosa();

                -- Hitung Entropy
                call spHitungEntropy();

                -- Hitung Gain
                call spHitungGain();

                SET vMuter = 0;

            END WHILE;

        END$$

DELIMITER ;

DELIMITER $$

    CREATE PROCEDURE spHitungDiagnosa()
        BEGIN

            SELECT COUNT(*) INTO @SUM_DATA
            FROM tbData;

            SELECT COUNT(*) INTO @DIAG_DEMAM
            FROM tbData
            WHERE DIAGNOSA = 'Demam';

            SELECT COUNT(*) INTO @DIAG_FLU
            FROM tbData
            WHERE DIAGNOSA = 'Flu';

            SELECT (-(@DIAG_DEMAM/@SUM_DATA) * log2(@DIAG_DEMAM/@SUM_DATA))
            +
            (-(@DIAG_FLU/@SUM_DATA) * log2(@DIAG_FLU/@SUM_DATA))
            INTO @ENTROPY;

            SELECT @SUM_DATA AS JUM_DATA,
            @DIAG_DEMAM AS DIAGNOSA_DEMAM,
            @DIAG_FLU AS DIAGNOSA_FLU,
            ROUND(@ENTROPY, 4) AS ENTROPY;

            INSERT INTO tbHitung(ATRIBUT, SUM_DATA, DIAG_DEMAM, DIAG_FLU, ENTROPY) VALUES
            ('TOTAL DATA', @SUM_DATA, @DIAG_DEMAM, @DIAG_FLU, @ENTROPY);

            -- DEMAM
            INSERT INTO tbHitung(SUB_ATRIBUT, SUM_DATA, DIAG_DEMAM, DIAG_FLU)
            SELECT A.DEMAM AS DEMAM, COUNT(*) AS SUM_DATA,
                (
                    SELECT COUNT(*)
                    FROM tbData AS B
                    WHERE B.DIAGNOSA = 'DEMAM' AND B.DEMAM = A.DEMAM
                ) AS 'DEMAM',

                (
                    SELECT COUNT(*)
                    FROM tbData AS C
                    WHERE C.DIAGNOSA = 'FLU' AND C.DEMAM = A.DEMAM
                ) AS 'FLU'
            FROM tbData AS A
            GROUP BY A.DEMAM;

            UPDATE tbHitung SET ATRIBUT = 'DEMAM' WHERE ATRIBUT IS NULL;

            -- SAKIT_KEPALA
            INSERT INTO tbHitung(SUB_ATRIBUT, SUM_DATA, DIAG_DEMAM, DIAG_FLU)
            SELECT A.SAKIT_KEPALA AS SAKIT_KEPALA, COUNT(*) AS SUM_DATA,
                (
                    SELECT COUNT(*)
                    FROM tbData AS B
                    WHERE B.DIAGNOSA = 'DEMAM' AND B.SAKIT_KEPALA = A.SAKIT_KEPALA
                ) AS 'DEMAM',

                (
                    SELECT COUNT(*)
                    FROM tbData AS C
                    WHERE C.DIAGNOSA = 'FLU' AND C.SAKIT_KEPALA = A.SAKIT_KEPALA
                ) AS 'FLU'
            FROM tbData AS A
            GROUP BY A.SAKIT_KEPALA;

            UPDATE tbHitung SET ATRIBUT = 'SAKIT_KEPALA' WHERE ATRIBUT IS NULL;

            -- NYERI
            INSERT INTO tbHitung(SUB_ATRIBUT, SUM_DATA, DIAG_DEMAM, DIAG_FLU)
            SELECT A.NYERI AS NYERI, COUNT(*) AS SUM_DATA,
                (
                    SELECT COUNT(*)
                    FROM tbData AS B
                    WHERE B.DIAGNOSA = 'DEMAM' AND B.NYERI = A.NYERI
                ) AS 'DEMAM',

                (
                    SELECT COUNT(*)
                    FROM tbData AS C
                    WHERE C.DIAGNOSA = 'FLU' AND C.NYERI = A.NYERI
                ) AS 'FLU'
            FROM tbData AS A
            GROUP BY A.NYERI;

            UPDATE tbHitung SET ATRIBUT = 'NYERI' WHERE ATRIBUT IS NULL;

            -- LEMAS
            INSERT INTO tbHitung(SUB_ATRIBUT, SUM_DATA, DIAG_DEMAM, DIAG_FLU)
            SELECT A.LEMAS AS LEMAS, COUNT(*) AS SUM_DATA,
                (
                    SELECT COUNT(*)
                    FROM tbData AS B
                    WHERE B.DIAGNOSA = 'DEMAM' AND B.LEMAS = A.LEMAS
                ) AS 'DEMAM',

                (
                    SELECT COUNT(*)
                    FROM tbData AS C
                    WHERE C.DIAGNOSA = 'FLU' AND C.LEMAS = A.LEMAS
                ) AS 'FLU'
            FROM tbData AS A
            GROUP BY A.LEMAS;

            UPDATE tbHitung SET ATRIBUT = 'LEMAS' WHERE ATRIBUT IS NULL;

            -- KELELAHAN
            INSERT INTO tbHitung(SUB_ATRIBUT, SUM_DATA, DIAG_DEMAM, DIAG_FLU)
            SELECT A.KELELAHAN AS KELELAHAN, COUNT(*) AS SUM_DATA,
                (
                    SELECT COUNT(*)
                    FROM tbData AS B
                    WHERE B.DIAGNOSA = 'DEMAM' AND B.KELELAHAN = A.KELELAHAN
                ) AS 'DEMAM',

                (
                    SELECT COUNT(*)
                    FROM tbData AS C
                    WHERE C.DIAGNOSA = 'FLU' AND C.KELELAHAN = A.KELELAHAN
                ) AS 'FLU'
            FROM tbData AS A
            GROUP BY A.KELELAHAN;

            UPDATE tbHitung SET ATRIBUT = 'KELELAHAN' WHERE ATRIBUT IS NULL;

            -- HIDUNG_TERSUMBAT
            INSERT INTO tbHitung(SUB_ATRIBUT, SUM_DATA, DIAG_DEMAM, DIAG_FLU)
            SELECT A.HIDUNG_TERSUMBAT AS HIDUNG_TERSUMBAT, COUNT(*) AS SUM_DATA,
                (
                    SELECT COUNT(*)
                    FROM tbData AS B
                    WHERE B.DIAGNOSA = 'DEMAM' AND B.HIDUNG_TERSUMBAT = A.HIDUNG_TERSUMBAT
                ) AS 'DEMAM',

                (
                    SELECT COUNT(*)
                    FROM tbData AS C
                    WHERE C.DIAGNOSA = 'FLU' AND C.HIDUNG_TERSUMBAT = A.HIDUNG_TERSUMBAT
                ) AS 'FLU'
            FROM tbData AS A
            GROUP BY A.HIDUNG_TERSUMBAT;

            UPDATE tbHitung SET ATRIBUT = 'HIDUNG_TERSUMBAT' WHERE ATRIBUT IS NULL;

            -- BERSIN
            INSERT INTO tbHitung(SUB_ATRIBUT, SUM_DATA, DIAG_DEMAM, DIAG_FLU)
            SELECT A.BERSIN AS BERSIN, COUNT(*) AS SUM_DATA,
                (
                    SELECT COUNT(*)
                    FROM tbData AS B
                    WHERE B.DIAGNOSA = 'DEMAM' AND B.BERSIN = A.BERSIN
                ) AS 'DEMAM',

                (
                    SELECT COUNT(*)
                    FROM tbData AS C
                    WHERE C.DIAGNOSA = 'FLU' AND C.BERSIN = A.BERSIN
                ) AS 'FLU'
            FROM tbData AS A
            GROUP BY A.BERSIN;

            UPDATE tbHitung SET ATRIBUT = 'BERSIN' WHERE ATRIBUT IS NULL;

            -- SAKIT_TENGGOROKAN
            INSERT INTO tbHitung(SUB_ATRIBUT, SUM_DATA, DIAG_DEMAM, DIAG_FLU)
            SELECT A.SAKIT_TENGGOROKAN AS SAKIT_TENGGOROKAN, COUNT(*) AS SUM_DATA,
                (
                    SELECT COUNT(*)
                    FROM tbData AS B
                    WHERE B.DIAGNOSA = 'DEMAM' AND B.SAKIT_TENGGOROKAN = A.SAKIT_TENGGOROKAN
                ) AS 'DEMAM',

                (
                    SELECT COUNT(*)
                    FROM tbData AS C
                    WHERE C.DIAGNOSA = 'FLU' AND C.SAKIT_TENGGOROKAN = A.SAKIT_TENGGOROKAN
                ) AS 'FLU'
            FROM tbData AS A
            GROUP BY A.SAKIT_TENGGOROKAN;

            UPDATE tbHitung SET ATRIBUT = 'SAKIT_TENGGOROKAN' WHERE ATRIBUT IS NULL;

            -- SULIT_BERNAFAS
            INSERT INTO tbHitung(SUB_ATRIBUT, SUM_DATA, DIAG_DEMAM, DIAG_FLU)
            SELECT A.SULIT_BERNAFAS AS SULIT_BERNAFAS, COUNT(*) AS SUM_DATA,
                (
                    SELECT COUNT(*)
                    FROM tbData AS B
                    WHERE B.DIAGNOSA = 'DEMAM' AND B.SULIT_BERNAFAS = A.SULIT_BERNAFAS
                ) AS 'DEMAM',

                (
                    SELECT COUNT(*)
                    FROM tbData AS C
                    WHERE C.DIAGNOSA = 'FLU' AND C.SULIT_BERNAFAS = A.SULIT_BERNAFAS
                ) AS 'FLU'
            FROM tbData AS A
            GROUP BY A.SULIT_BERNAFAS;

            UPDATE tbHitung SET ATRIBUT = 'SULIT_BERNAFAS' WHERE ATRIBUT IS NULL;

        END$$

DELIMITER ;

DELIMITER $$

    CREATE PROCEDURE spHitungEntropy()
        BEGIN

            UPDATE tbHitung SET ENTROPY = (-(DIAG_DEMAM/SUM_DATA) * log2(DIAG_DEMAM/SUM_DATA))
            +
            (-(DIAG_FLU/SUM_DATA) * log2(DIAG_FLU/SUM_DATA));

            UPDATE tbHitung SET ENTROPY = 0 WHERE ENTROPY IS NULL;

        END$$

DELIMITER ;

DELIMITER $$

    CREATE PROCEDURE spHitungGain()
        BEGIN

            DROP TABLE IF EXISTS tbTampung;
            CREATE TEMPORARY TABLE tbTampung
            (
                ATRIBUT VARCHAR(20),
                GAIN DECIMAL(8, 4)
            );

            INSERT INTO tbTampung(ATRIBUT, GAIN)
            SELECT ATRIBUT, @ENTROPY - 
            SUM((SUM_DATA/@SUM_DATA) * ENTROPY) AS GAIN
            FROM tbHitung
            GROUP BY ATRIBUT;

            UPDATE tbHitung SET GAIN = 
                (
                    SELECT gain
                    FROM tbTampung
                    WHERE ATRIBUT = tbHitung.ATRIBUT
                );

            SELECT * FROM tbHitung;
            
            SELECT * FROM tbTampung;

            SELECT * FROM tbTampung WHERE GAIN = (SELECT MAX(GAIN) FROM tbTampung);

        END$$

DELIMITER ;

call spUtama();