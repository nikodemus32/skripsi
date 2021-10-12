DROP DATABASE IF EXISTS dbPENYAKIT;
CREATE DATABASE dbPENYAKIT;
USE dbPENYAKIT;

CREATE TABLE tblPasien
(
    Pasien VARCHAR(10),
    Demam VARCHAR(10),
    Sakitkepala VARCHAR(10),
    Nyeri VARCHAR(10),
    Kelelahan VARCHAR(10),
    Hidungtersumbat VARCHAR(10),
    Bersin VARCHAR(10),
    Sakittenggorokan VARCHAR(10),
    Sulitbernafas VARCHAR(10),
    diagnosa VARCHAR(10)
);

LOAD DATA LOCAL INFILE 'dbPasien.csv'
INTO TABLE tblPasien
FIELDS TERMINATED BY ';'
ENCLOSED BY ''''
IGNORE 1 LINES;

SELECT * FROM tblPasien;

CREATE TABLE tblHitung
(
    atribut VARCHAR(20),
    informasi VARCHAR(20),
    jumlahdata INT,
    Tidak INT,
    Ringan INT,
    Parah INT,
    diagnosademam INT,
    diagnosaflu INT,
    entropy decimal(8,4),
    gain decimal(8,4)
);

DESC tblHitung;

SELECT COUNT(*) INTO @jumlahdata FROM tblPasien;

SELECT COUNT(*) INTO @diagnosademam FROM tblPasien WHERE diagnosa = 'demam';

SELECT COUNT(*) INTO @diagnosaflu FROM tblPasien WHERE diagnosa = 'flu';

SELECT (-(@diagnosademam/@jumlahdata) * log2(@diagnosademam/@jumlahdata)) + (-(@diagnosaflu/@jumlahdata) * log2(@diagnosaflu/@jumlahdata)) INTO @entropy;

SELECT @jumlahdata AS JUM_DATA,
@diagnosademam AS JAWAB_DEMAM, @diagnosaflu AS JAWAB_FLU, ROUND(@entropy,4) AS ENTROPY;

INSERT INTO tblHitung(atribut, jumlahdata, diagnosademam, diagnosaflu, entropy) VALUES ('TOTAL DATA', @jumlahdata, @diagnosademam, @diagnosaflu, @entropy);
SELECT * FROM tblHitung;

INSERT INTO tblHitung(informasi, jumlahdata, diagnosademam, diagnosaflu)
    SELECT A.Pasien AS PASIEN, COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*) FROM tblPasien AS B WHERE B.diagnosa = 'demam' AND B.Pasien = A.Pasien
        ) AS 'DEMAM',
        (
            SELECT COUNT(*) FROM tblPasien AS C WHERE C.diagnosa = 'flu' AND C.Pasien = A.Pasien
        ) AS 'FLU'
    FROM tblPasien AS A GROUP BY Pasien;

UPDATE tblHitung SET atribut = 'PASIEN' WHERE atribut IS NULL;

INSERT INTO tblHitung(informasi, jumlahdata, diagnosademam, diagnosaflu)
    SELECT A.Demam AS DEMAM, COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*) FROM tblPasien AS B WHERE B.diagnosa = 'demam' AND B.Demam = A.Demam
        ) AS 'DEMAM',
        (
            SELECT COUNT(*) FROM tblPasien AS C WHERE C.diagnosa = 'flu' AND C.Demam = A.Demam
        ) AS 'FLU'

    FROM tblPasien AS A GROUP BY demam;

UPDATE tblHitung SET atribut = 'DEMAM' WHERE atribut IS NULL;

INSERT INTO tblHitung(informasi, jumlahdata, diagnosademam, diagnosaflu)
    SELECT A.Sakitkepala AS SAKIT KEPALA, COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*) FROM tblPasien AS B WHERE B.diagnosa = 'demam' AND B.Sakitkepala = A.Sakitkepala
        ) AS 'DEMAM',
        (
            SELECT COUNT(*) FROM tblPasien AS C WHERE C.diagnosa = 'flu' AND C.Sakitkepala = A.Sakitkepala
        ) AS 'FLU'
    FROM tblPasien AS A GROUP BY Sakitkepala;

UPDATE tblHitung SET atribut = 'SAKITKEPALA' WHERE atribut IS NULL;

INSERT INTO tblHitung(informasi, jumlahdata, diagnosademam, diagnosaflu)
    SELECT A.Nyeri AS NYERI, COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*) FROM tblPasien AS B WHERE B.diagnosa = 'demam' AND B.Nyeri = A.Nyeri
        ) AS 'DEMAM',
        (
            SELECT COUNT(*) FROM tblPasien AS C WHERE C.diagnosa = 'flu' AND C.Nyeri = A.Nyeri
        ) AS 'FLU'
    FROM tblPasien AS A GROUP BY Nyeri;

UPDATE tblHitung SET atribut = 'NYERI' WHERE atribut IS NULL;

INSERT INTO tblHitung(informasi, jumlahdata, diagnosademam, diagnosaflu)
    SELECT A.Lemas AS LEMAS, COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*) FROM tblPasien AS B WHERE B.diagnosa = 'demam' AND B.Lemas = A.Lemas
        ) AS 'DEMAM',
        (
            SELECT COUNT(*) FROM tblPasien AS C WHERE C.diagnosa = 'flu' AND C.Lemas = A.Lemas
        ) AS 'FLU'
    FROM tblPasien AS A GROUP BY Lemas;

UPDATE tblHitung SET atribut = 'LEMAS' WHERE atribut IS NULL;

INSERT INTO tblHitung(informasi, jumlahdata, diagnosademam, diagnosaflu)
    SELECT A.Kelelahan AS KELELAHAN, COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*) FROM tblPasien AS B WHERE B.diagnosa = 'demam' AND B.Kelelahan = A.Kelelahan
        ) AS 'DEMAM',
        (
            SELECT COUNT(*) FROM tblPasien AS C WHERE C.diagnosa = 'flu' AND C.Kelelahan = A.Kelelahan
        ) AS 'FLU'
    FROM tblPasien AS A GROUP BY Kelelahan;

UPDATE tblHitung SET atribut = 'KELELAHAN' WHERE atribut IS NULL;

INSERT INTO tblHitung(informasi, jumlahdata, diagnosademam, diagnosaflu)
    SELECT A.Hidungtersumbat AS HIDUNGTERSUMBAT, COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*) FROM tblPasien AS B WHERE B.diagnosa = 'demam' AND B.Hidungtersumbat = A.Hidungtersumbat
        ) AS 'DEMAM',
        (
            SELECT COUNT(*) FROM tblPasien AS C WHERE C.diagnosa = 'flu' AND C.Hidungtersumbat = A.Hidungtersumbat
        ) AS 'FLU'
    FROM tblPasien AS A GROUP BY Hidungtersumbat;

UPDATE tblHitung SET atribut = 'HIDUNGTERSUMBAT' WHERE atribut IS NULL;

INSERT INTO tblHitung(informasi, jumlahdata, diagnosademam, diagnosaflu)
    SELECT A.Bersin AS BERSIN, COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*) FROM tblPasien AS B WHERE B.diagnosa = 'demam' AND B.Bersin = A.Bersin
        ) AS 'DEMAM',
        (
            SELECT COUNT(*) FROM tblPasien AS C WHERE C.diagnosa = 'flu' AND C.Bersin = A.Bersin
        ) AS 'FLU'
    FROM tblPasien AS A GROUP BY Bersin;

UPDATE tblHitung SET atribut = 'BERSIN' WHERE atribut IS NULL;

INSERT INTO tblHitung(informasi, jumlahdata, diagnosademam, diagnosaflu)
    SELECT A.Sakittenggorokan AS SAKITTENGGOROKAN, COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*) FROM tblPasien AS B WHERE B.diagnosa = 'demam' AND B.Sakittenggorokan = A.Sakittenggorokan
        ) AS 'DEMAM',
        (
            SELECT COUNT(*) FROM tblPasien AS C WHERE C.diagnosa = 'flu' AND C.Sakittenggorokan = A.Sakittenggorokan
        ) AS 'FLU'
    FROM tblPasien AS A GROUP BY Sakittenggorokan;

UPDATE tblHitung SET atribut = 'SAKITTENGGOROKAN' WHERE atribut IS NULL;

INSERT INTO tblHitung(informasi, jumlahdata, diagnosademam, diagnosaflu)
    SELECT A.Sulitbernafas AS SULITBERNAFAS, COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*) FROM tblPasien AS B WHERE B.diagnosa = 'demam' AND B.Sulitbernafas = A.Sulitbernafas
        ) AS 'DEMAM',
        (
            SELECT COUNT(*) FROM tblPasien AS C WHERE C.diagnosa = 'flu' AND C.Sulitbernafas = A.Sulitbernafas
        ) AS 'FLU'
    FROM tblPasien AS A GROUP BY Sulitbernafas;

UPDATE tblHitung SET atribut = 'SULITBERNAFAS' WHERE atribut IS NULL;


UPDATE tblHitung SET entropy = (-(diagnosademam/jumlahdata) * log2(diagnosademam/jumlahdata)) + (-(diagnosaflu/jumlahdata) * log2(diagnosaflu/jumlahdata));

UPDATE tblHitung SET entropy = 0 WHERE entropy IS NULL;

SELECT * FROM tblHitung;

DROP TABLE IF EXISTS tblTampung;
CREATE TEMPORARY TABLE tblTampung
(
    atribut VARCHAR(20),
    gain decimal(8,4)
);

INSERT INTO tblTampung(atribut, gain)
SELECT atribut, @entropy - SUM((jumlahdata/@jumlahdata) * entropy) AS GAIN FROM tblHitung GROUP BY atribut;

SELECT * FROM tblTampung;

UPDATE tblHitung SET GAIN =
    (
        SELECT gain
        FROM tblTampung
        WHERE atribut = tblHitung.atribut
    );

SELECT * FROM tblHitung;

/*-------------------------------------------------------Iterasi 2-------------------------------------------------------*/

TRUNCATE TABLE tblHitung;

SELECT COUNT(*) INTO @jumlahdata FROM tblPasien WHERE Sakitkepala = 'Ringan';

SELECT COUNT(*) INTO @diagnosademam FROM tblPasien WHERE diagnosa = 'demam' AND Sakitkepala = 'Ringan';

SELECT COUNT(*) INTO @diagnosaflu FROM tblC45 WHERE diagnosa = 'flu' AND Sakitkepala = 'Ringan';

SELECT (-(@diagnosademam/@jumlahdata) * log2(@diagnosademam/@jumlahdata)) + (-(@diagnosaflu/@jumlahdata) * log2(@diagnosaflu/@jumlahdata)) INTO @entropy;

SELECT @jumlahdata AS JUM_DATA,
@diagnosademam AS JAWAB_DEMAM, @diagnosaflu AS JAWAB_FLU, ROUND(@entropy,4) AS ENTROPY;

INSERT INTO tblHitung(atribut, jumlahdata, diagnosademam, diagnosaflu, entropy) VALUES ('TOTAL DATA', @jumlahdata, @diagnosademam, @diagnosaflu, @entropy);
SELECT * FROM tblHitung;

INSERT INTO tblHitung(informasi, jumlahdata, diagnosademam, diagnosaflu)
    SELECT A.Pasien AS PASIEN, COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*) FROM tblPasien AS B WHERE B.diagnosa = 'demam' AND B.Pasien = A.Pasien AND Sakitkepala = 'Ringan'
        ) AS 'DEMAM',
        (
            SELECT COUNT(*) FROM tblPasien AS C WHERE C.diagnosa = 'flu' AND C.Pasien = A.Pasien AND Sakitkepala = 'Ringan'
        ) AS 'FLU'
    FROM tblPasien AS A WHERE Sakitkepala = 'Ringan' GROUP BY Pasien;

UPDATE tblHitung SET atribut = 'PASIEN' WHERE atribut IS NULL;

INSERT INTO tblHitung(informasi, jumlahdata, diagnosademam, diagnosaflu)
    SELECT A.Demam AS DEMAM, COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*) FROM tblPasien AS B WHERE B.diagnosa = 'demam' AND B.Demam = A.Demam AND Sakitkepala = 'Ringan'
        ) AS 'DEMAM',
        (
            SELECT COUNT(*) FROM tblPasien AS C WHERE C.diagnosa = 'flu' AND C.Demam = A.Demam AND Sakitkepala = 'Ringan'
        ) AS 'FLU'
    FROM tblPasien AS A WHERE Sakitkepala = 'Ringan' GROUP BY Demam;

UPDATE tblHitung SET atribut = 'DEMAM' WHERE atribut IS NULL;

INSERT INTO tblHitung(informasi, jumlahdata, diagnosademam, diagnosaflu)
    SELECT A.Nyeri AS NYERI, COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*) FROM tblPasien AS B WHERE B.diagnosa = 'demam' AND B.Nyeri = A.Nyeri AND Sakitkepala = 'Ringan'
        ) AS 'DEMAM',
        (
            SELECT COUNT(*) FROM tblPasien AS C WHERE C.diagnosa = 'flu' AND C.Nyeri = A.Nyeri AND Sakitkepala = 'Ringan'
        ) AS 'FLU'
    FROM tblPasien AS A WHERE Sakitkepala = 'Ringan' GROUP BY Nyeri;

UPDATE tblHitung SET atribut = 'NYERI' WHERE atribut IS NULL;

INSERT INTO tblHitung(informasi, jumlahdata, diagnosademam, diagnosaflu)
    SELECT A.Lemas AS LEMAS, COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*) FROM tblPasien AS B WHERE B.diagnosa = 'demam' AND B.Lemas = A.Lemas AND Sakitkepala = 'Ringan'
        ) AS 'DEMAM',
        (
            SELECT COUNT(*) FROM tblPasien AS C WHERE C.diagnosa = 'flu' AND C.Lemas = A.Lemas AND Sakitkepala = 'Ringan'
        ) AS 'FLU'
    FROM tblPasien AS A WHERE Sakitkepala = 'Ringan' GROUP BY Lemas;

UPDATE tblHitung SET atribut = 'LEMAS' WHERE atribut IS NULL;

INSERT INTO tblHitung(informasi, jumlahdata, diagnosademam, diagnosaflu)
    SELECT A.Kelelahan AS KELELAHAN, COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*) FROM tblPasien AS B WHERE B.diagnosa = 'demam' AND B.Kelelahan = A.Kelelahan AND Sakitkepala = 'Ringan'
        ) AS 'DEMAM',
        (
            SELECT COUNT(*) FROM tblPasien AS C WHERE C.diagnosa = 'flu' AND C.Kelelahan = A.Kelelahan AND Sakitkepala = 'Ringan'
        ) AS 'FLU'
    FROM tblPasien AS A WHERE Sakitkepala = 'Ringan' GROUP BY Kelelahan;

UPDATE tblHitung SET atribut = 'KELELAHAN' WHERE atribut IS NULL;

INSERT INTO tblHitung(informasi, jumlahdata, diagnosademam, diagnosaflu)
    SELECT A.Hidungtersumbat AS HIDUNGTERSUMBAT, COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*) FROM tblPasien AS B WHERE B.diagnosa = 'demam' AND B.Hidungtersumbat = A.Hidungtersumbat AND Sakitkepala = 'Ringan'
        ) AS 'DEMAM',
        (
            SELECT COUNT(*) FROM tblPasien AS C WHERE C.diagnosa = 'flu' AND C.Hidungtersumbat = A.Hidungtersumbat AND Sakitkepala = 'Ringan'
        ) AS 'FLU'
    FROM tblPasien AS A WHERE Sakitkepala = 'Ringan' GROUP BY Hidungtersumbat;

UPDATE tblHitung SET atribut = 'HIDUNGTERSUMBAT' WHERE atribut IS NULL;

INSERT INTO tblHitung(informasi, jumlahdata, diagnosademam, diagnosaflu)
    SELECT A.Bersin AS BERSIN, COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*) FROM tblPasien AS B WHERE B.diagnosa = 'demam' AND B.Bersin = A.Bersin AND Sakitkepala = 'Ringan'
        ) AS 'DEMAM',
        (
            SELECT COUNT(*) FROM tblPasien AS C WHERE C.diagnosa = 'flu' AND C.Bersin = A.Bersin AND Sakitkepala = 'Ringan'
        ) AS 'FLU'
    FROM tblPasien AS A WHERE Sakitkepala = 'Ringan' GROUP BY Bersin;

UPDATE tblHitung SET atribut = 'BERSIN' WHERE atribut IS NULL;

INSERT INTO tblHitung(informasi, jumlahdata, diagnosademam, diagnosaflu)
    SELECT A.Sakittenggorokan AS SAKITTENGGOROKAN, COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*) FROM tblPasien AS B WHERE B.diagnosa = 'demam' AND B.Sakittenggorokan = A.Sakittenggorokan AND Sakitkepala = 'Ringan'
        ) AS 'DEMAM',
        (
            SELECT COUNT(*) FROM tblPasien AS C WHERE C.diagnosa = 'flu' AND C.Sakittenggorokan = A.Sakittenggorokan AND Sakitkepala = 'Ringan'
        ) AS 'FLU'
    FROM tblPasien AS A WHERE Sakitkepala = 'Ringan' GROUP BY Sakittenggorokan;

UPDATE tblHitung SET atribut = 'SAKITTENGGOROKAN' WHERE atribut IS NULL;

INSERT INTO tblHitung(informasi, jumlahdata, diagnosademam, diagnosaflu)
    SELECT A.Sulitbernafas AS Sulitbernafas, COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*) FROM tblPasien AS B WHERE B.diagnosa = 'demam' AND B.Sulitbernafas = A.Sulitbernafas AND Sakitkepala = 'Ringan'
        ) AS 'DEMAM',
        (
            SELECT COUNT(*) FROM tblPasien AS C WHERE C.diagnosa = 'flu' AND C.Sulitbernafas = A.Sulitbernafas AND Sakitkepala = 'Ringan'
        ) AS 'FLU'
    FROM tblPasien AS A WHERE Sakitkepala = 'Ringan' GROUP BY Sulitbernafas;

UPDATE tblHitung SET atribut = 'SULITBERNAFAS' WHERE atribut IS NULL;

UPDATE tblHitung SET entropy = (-(diagnosademam/jumlahdata) * log2(diagnosademam/jumlahdata)) + (-(diagnosaflu/jumlahdata) * log2(diagnosaflu/jumlahdata));

UPDATE tblHitung SET entropy = 0 WHERE entropy IS NULL;

SELECT * FROM tblHitung;

DROP TABLE IF EXISTS tblTampung;
CREATE TEMPORARY TABLE tblTampung
(
    atribut VARCHAR(20),
    gain decimal(8,4)
);

INSERT INTO tblTampung(atribut, gain)
SELECT atribut, @entropy - SUM((jumlahdata/@jumlahdata) * entropy) AS GAIN FROM tblHitung GROUP BY atribut;

SELECT * FROM tblTampung;

UPDATE tblHitung SET GAIN =
    (
        SELECT gain
        FROM tblTampung
        WHERE atribut = tblHitung.atribut
    );

SELECT * FROM tblHitung;

/*-------------------------------------------------------Iterasi 3-------------------------------------------------------*/

TRUNCATE TABLE tblHitung;

SELECT COUNT(*) INTO @jumlahdata FROM tblPasien WHERE Sakitkepala = 'Ringan' AND Pasien = 'Parah';

SELECT COUNT(*) INTO @diagnosademam FROM tblPasien WHERE diagnosa = 'demam' AND Sakitkepala = 'Ringan' AND Pasien = 'Parah';

SELECT COUNT(*) INTO @diagnosaflu FROM tblPasien WHERE diagnosa = 'flu' AND Sakitkepala = 'Ringan' AND Pasien = 'Parah';

SELECT (-(@diagnosademam/@jumlahdata) * log2(@diagnosademam/@jumlahdata)) + (-(@diagnosaflu/@jumlahdata) * log2(@diagnosaflu/@jumlahdata)) INTO @entropy;

SELECT @jumlahdata AS JUM_DATA,
@diagnosademam AS JAWAB_DEMAM, @diagnosaflu AS JAWAB_FLU, ROUND(@entropy,4) AS ENTROPY;

INSERT INTO tblHitung(atribut, jumlahdata, diagnosademam, diagnosaflu, entropy) VALUES ('TOTAL DATA', @jumlahdata, @diagnosademam, @diagnosaflu, @entropy);
SELECT * FROM tblHitung;

INSERT INTO tblHitung(informasi, jumlahdata, diagnosademam, diagnosaflu)
    SELECT A.Demam AS DEMAM, COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*) FROM tblPasien AS B WHERE B.diagnosa = 'demam' AND B.Demam = A.Demam AND Sakitkepala = 'Ringan' AND Pasien = 'Parah'
        ) AS 'DEMAM',
        (
            SELECT COUNT(*) FROM tblPasien AS C WHERE C.diagnosa = 'flu' AND C.Demam = A.Demam AND Sakitkepala = 'Ringan' AND Pasien = 'Parah'
        ) AS 'FLU'
    FROM tblPasien AS A WHERE Sakitkepala = 'Ringan' AND Pasien = 'Parah' GROUP BY Demam;

UPDATE tblHitung SET atribut = 'DEMAM' WHERE atribut IS NULL;

UPDATE tblHitung SET entropy = (-(diagnosademam/jumlahdata) * log2(diagnosademam/jumlahdata)) + (-(diagnosaflu/jumlahdata) * log2(diagnosaflu/jumlahdata));

UPDATE tblHitung SET entropy = 0 WHERE entropy IS NULL;

SELECT * FROM tblHitung;

DROP TABLE IF EXISTS tblTampung;
CREATE TEMPORARY TABLE tblTampung
(
    atribut VARCHAR(20),
    gain decimal(8,4)
);

INSERT INTO tblTampung(atribut, gain)
SELECT atribut, @entropy - SUM((jumlahdata/@jumlahdata) * entropy) AS GAIN FROM tblHitung GROUP BY atribut;

SELECT * FROM tblTampung;

UPDATE tblHitung SET GAIN =
    (
        SELECT gain
        FROM tblTampung
        WHERE atribut = tblHitung.atribut
    );

SELECT * FROM tblHitung;
