DROP DATABASE IF EXISTS dbUasdiagnosa;
CREATE DATABASE dbUasdiagnosa;
USE dbUasdiagnosa;

CREATE TABLE tblPasien
(
    nourut INT,
    outlook VARCHAR(10),
    demam VARCHAR(10),
    sakit kepala VARCHAR(10),
    nyeri VARCHAR(10),
    kelelahan VARCHAR(10),
    hidung tersumbat VARCHAR(10),
    bersin VARCHAR(10),
    sakit tenggorokan VARCHAR(10),
    sulit bernafas VARCHAR(10),    
    diagnosa VARCHAR(10)
);

LOAD DATA LOCAL INFILE 'dbDiagnosa.csv'
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
    diagnosatidak INT,
    diagnosaringan INT,
    diagnosaparah INT,
    entropy decimal(8,4),
    gain decimal(8,4)
);

DESC tblHitung;

SELECT COUNT(*) INTO @jumlahdata FROM tblpasien;

SELECT COUNT(*) INTO @diagnosatidak FROM tblPasien WHERE diagnosa = 'tidak';

SELECT COUNT(*) INTO @diagnosaringan FROM tblPasien WHERE diagnosa = 'ringan';

SELECT COUNT(*) INTO @diagnosaparah FROM tblPasien WHERE diagnosa = 'parah';

SELECT (-(@diagnosatidak/@jumlahdata) * log2(@diagnosatidak/@jumlahdata)) + (-(@diagnosaringan/@jumlahdata) * log2(@diagnosaringan/@jumlahdata)) + (-(@diagnosaparah/@jumlahdata) * log2(@diagnosaparah/@jumlahdata)) INTO @entropy;

SELECT @jumlahdata AS JUM_DATA,
@diagnosatidak AS JAWAB_TIDAK, @diagnosaringan AS JAWAB_RINGAN, @diagnosaparah AS JAWAB_PARAH, ROUND(@entropy,4) AS ENTROPY;

INSERT INTO tblHitung(atribut, jumlahdata, diagnosatidak, diagnosaringan, diagnosaparah, entropy) VALUES ('TOTAL DATA', @jumlahdata, @diagnosatidak, @diagnosaringan, @diagnosaparah, @entropy);
SELECT * FROM tblHitung;

INSERT INTO tblHitung(informasi, jumlahdata, diagnosatidak, diagnosaringan, diagnosaparah)
    SELECT A.outlook AS OUTLOOK, COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*) FROM tblPasiaen AS B WHERE B.diagnosa = 'tidak' AND B.outlook = A.outlook
        ) AS 'TIDAK',
        (
            SELECT COUNT(*) FROM tblPasien AS C WHERE C.diagnosa = 'ringan' AND C.outlook = A.outlook
        ) AS 'RINGAN',
            SELECT COUNT(*) FROM tblPasien AS D WHERE D.diagnosa = 'parah' AND D.outlook = A.outlook
        ) AS 'PARAH'

    FROM tblPasien AS A GROUP BY outlook;

UPDATE tblHitung SET atribut = 'OUTLOOK' WHERE atribut IS NULL;

INSERT INTO tblHitung(informasi, jumlahdata, diagnosatidak, diagnosaringan, diagnosaparah)
    SELECT A.demam AS DEMAM, COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*) FROM tblPasien AS B WHERE B.diagnosa = 'tidak' AND B.demam = A.demam
        ) AS 'TIDAK',
        (
            SELECT COUNT(*) FROM tblPasien AS C WHERE C.diagnosa = 'ringan' AND C.demam = A.demam
        ) AS 'RINGAN',
        (
            SELECT COUNT(*) FROM tblPasien AS D WHERE D.diagnosa = 'parah' AND D.demam = A.demam

        ) AS 'PARAH'

    FROM tblPasien AS A GROUP BY demam;

UPDATE tblHitung SET atribut = 'DEMAM' WHERE atribut IS NULL;

INSERT INTO tblHitung(informasi, jumlahdata, diagnosatidak, diagnosaringan, diagnosaparah)
    SELECT A.sakit kepala AS SAKIT KEPALA, COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*) FROM tblPasien AS B WHERE B.diagnosa = 'tidak' AND B.sakit kepala = A.sakit kepala
        ) AS 'TIDAK',
        (
            SELECT COUNT(*) FROM tblPasien AS C WHERE C.diagnosa = 'ringan' AND C.sakit kepala = A.sakit kepala
        ) AS 'RINGAN',
        (
            SELECT COUNT(*) FROM tblPasien AS D WHERE C.diagnosa = 'parah' AND D.sakit kepala = A.sakit kepala
        ) AS 'PARAH'
    FROM tblPasien AS A GROUP BY sakit kepala;

UPDATE tblHitung SET atribut = 'SAKIT KEPALA' WHERE atribut IS NULL;

INSERT INTO tblHitung(informasi, jumlahdata, diagnosatidak, diagnosaringan, diagnosaparah)
    SELECT A.nyeri AS NYERI, COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*) FROM tblPasien AS B WHERE B.diagnosa = 'tidak' AND B.nyeri = A.nyeri
        ) AS 'TIDAK',
        (
            SELECT COUNT(*) FROM tblPasien AS C WHERE C.diagnosa = 'ringan' AND C.nyeri = A.nyeri
        ) AS 'RINGAN',
            SELECT COUNT(*) FROM tblPasien AS D WHERE D.diagnosa = 'parah' AND D.nyeri = A.nyeri
        ) AS 'PARAH'
    FROM tblPasien AS A GROUP BY nyeri;

UPDATE tblHitung SET atribut = 'NYERI' WHERE atribut IS NULL;

INSERT INTO tblHitung(informasi, jumlahdata, diagnosatidak, diagnosaringan, diagnosaparah)
    SELECT A.lemas AS LEMAS, COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*) FROM tblPasien AS B WHERE B.diagnosa = 'tidak' AND B.lemas = A.lemas
        ) AS 'TIDAK',
        (
            SELECT COUNT(*) FROM tblPasien AS C WHERE C.diagnosa = 'ringan' AND C.lemas = A.lemas
        ) AS 'RINGAN',
            SELECT COUNT(*) FROM tblPasien AS D WHERE D.diagnosa = 'parah' AND D.lemas = A.lemas
        ) AS 'PARAH'
    FROM tblPasien AS A GROUP BY lemas;

UPDATE tblHitung SET atribut = 'LEMAS' WHERE atribut IS NULL;

INSERT INTO tblHitung(informasi, jumlahdata, diagnosatidak, diagnosaringan, diagnosaparah)
    SELECT A.kelelahan AS KELELAHAN, COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*) FROM tblPasien AS B WHERE B.diagnosa = 'tidak' AND B.kelelahan = A.kelelahan
        ) AS 'TIDAK',
        (
            SELECT COUNT(*) FROM tblPasien AS C WHERE C.diagnosa = 'ringan' AND C.kelelahan = A.kelelahan
        ) AS 'RINGAN',
            SELECT COUNT(*) FROM tblPasien AS D WHERE D.diagnosa = 'parah' AND D.kelelahan = A.kelelahan
        ) AS 'PARAH'
    FROM tblPasien AS A GROUP BY nyeri;

UPDATE tblHitung SET atribut = 'KELELAHAN' WHERE atribut IS NULL;

INSERT INTO tblHitung(informasi, jumlahdata, diagnosatidak, diagnosaringan, diagnosaparah)
    SELECT A.hidung tersumbat AS HIDUNG TERSUMBAT, COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*) FROM tblPasien AS B WHERE B.diagnosa = 'tidak' AND B.hidung tersumbat = A.hidung tersumbat
        ) AS 'TIDAK',
        (
            SELECT COUNT(*) FROM tblPasien AS C WHERE C.diagnosa = 'ringan' AND C.hidung tersumbat = A.hidung tersumbat
        ) AS 'RINGAN',
            SELECT COUNT(*) FROM tblPasien AS D WHERE D.diagnosa = 'parah' AND D.hidung tersumbat = A.hidung tersumbat
        ) AS 'PARAH'
    FROM tblPasien AS A GROUP BY hidung tersumbat;

UPDATE tblHitung SET atribut = 'HIDUNG TERSUMBAT' WHERE atribut IS NULL;

INSERT INTO tblHitung(informasi, jumlahdata, diagnosatidak, diagnosaringan, diagnosaparah)
    SELECT A.bersin AS BERSIN, COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*) FROM tblPasien AS B WHERE B.diagnosa = 'tidak' AND B.bersin = A.bersin
        ) AS 'TIDAK',
        (
            SELECT COUNT(*) FROM tblPasien AS C WHERE C.diagnosa = 'ringan' AND C.bersin = A.bersin
        ) AS 'RINGAN',
            SELECT COUNT(*) FROM tblPasien AS D WHERE D.diagnosa = 'parah' AND D.bersin = A.bersin
        ) AS 'PARAH'
    FROM tblPasien AS A GROUP BY bersin;

UPDATE tblHitung SET atribut = 'BERSIN' WHERE atribut IS NULL;

INSERT INTO tblHitung(informasi, jumlahdata, diagnosatidak, diagnosaringan, diagnosaparah)
    SELECT A.sakit tenggorokan AS SAKIT TENGGOROKAN, COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*) FROM tblPasien AS B WHERE B.diagnosa = 'tidak' AND B.sakit tenggorokan = A.sakit tenggorokan
        ) AS 'TIDAK',
        (
            SELECT COUNT(*) FROM tblPasien AS C WHERE C.diagnosa = 'ringan' AND C.sakit tenggorokan = A.sakit tenggorokan
        ) AS 'RINGAN',
            SELECT COUNT(*) FROM tblPasien AS D WHERE D.diagnosa = 'parah' AND D.sakit tenggorokan = A.sakit tenggorokan
        ) AS 'PARAH'
    FROM tblPasien AS A GROUP BY sakit tenggorokan;

UPDATE tblHitung SET atribut = 'SAKIT TENGGOROKAN' WHERE atribut IS NULL;

INSERT INTO tblHitung(informasi, jumlahdata, diagnosatidak, diagnosaringan, diagnosaparah)
    SELECT A.sulit bernafas AS SULIT BERNAFAS, COUNT(*) AS JUMLAH_DATA,
        (
            SELECT COUNT(*) FROM tblPasien AS B WHERE B.diagnosa = 'tidak' AND B.sulit bernafas = A.sulit bernafas
        ) AS 'TIDAK',
        (
            SELECT COUNT(*) FROM tblPasien AS C WHERE C.diagnosa = 'ringan' AND C.sulit bernafas = A.sulit bernafas
        ) AS 'RINGAN',
            SELECT COUNT(*) FROM tblPasien AS D WHERE D.diagnosa = 'parah' AND D.sulit bernafas = A.sulit bernafas
        ) AS 'PARAH'
    FROM tblPasien AS A GROUP BY sulit bernafas;

UPDATE tblHitung SET atribut = 'SULIT BERNAFAS' WHERE atribut IS NULL;


UPDATE tblHitung SET entropy = (-(diagnosatidak/jumlahdata) * log2(diagnosatidak/jumlahdata)) + (-(diagnosaringan/jumlahdata) * log2(diagnosaringan/jumlahdata) + (-(diagnosaparah/jumlahdata) * log2(diagnosaparah/jumlahdata));

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
