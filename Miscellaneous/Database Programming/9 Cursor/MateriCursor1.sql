DROP DATABASE IF EXISTS dbCursorPertama;
CREATE DATABASE dbCursorPertama;
USE dbCursorPertama;

CREATE TABLE tblKomponen(
    nokomponen INT PRIMARY KEY NOT NULL,
    komponen VARCHAR(30)
);

CREATE TABLE tblSiswa(
    nis VARCHAR(4) PRIMARY KEY NOT NULL,
    namasiswa VARCHAR(30)
);


CREATE TABLE tblPelajaran(
    nopelajaran INT PRIMARY KEY NOT NULL,
    matapelajaran VARCHAR(30)
);

CREATE TABLE tblNilai(
    nis VARCHAR(4),
    nokomponen INT,
    nopelajaran INT,
    nilai DOUBLE,
    FOREIGN KEY(nis)
        REFERENCES tblSiswa(nis)
            ON UPDATE CASCADE,
    FOREIGN KEY(nokomponen)
        REFERENCES tblKomponen(nokomponen)
            ON UPDATE CASCADE,
    FOREIGN KEY(nopelajaran)
        REFERENCES tblPelajaran(nopelajaran)
            ON UPDATE CASCADE
);

load data local infile "tblSiswa.csv"
into table tblSiswa
fields terminated by ';'
enclosed by '''';

load data local infile "tblPelajaran.csv"
into table tblPelajaran
fields terminated by ";"
enclosed by '''';

load data local infile "tblKomponen.csv"
into table tblKomponen
fields terminated by ";"
enclosed by '''';

load data local infile "tblNilai.csv"
into table tblNilai
fields terminated by ";"
enclosed by '''';

-- NO 1
DELIMITER $$
    CREATE PROCEDURE spTampilSiswa(pNoPelajaran INT)
    BEGIN
        DECLARE a, b, c, hitungSiswa, hitungNilai, hitungPelajaran INT DEFAULT 0;
        DECLARE namaPelajaran, idPelajaran, idPelajaran2, nisSiswa, nisSiswa2, namaSiswa, siswaSebelum VARCHAR(30) DEFAULT '';
        DECLARE vSiswa VARCHAR(255) DEFAULT '';

        DECLARE cSiswa CURSOR FOR
            SELECT * FROM tblSiswa;
        DECLARE cNilai CURSOR FOR
            SELECT nis,nopelajaran FROM tblNilai;
        DECLARE cPelajaran CURSOR FOR
            SELECT nopelajaran, matapelajaran FROM tblPelajaran;

        SELECT COUNT(*) INTO hitungSiswa FROM tblSiswa;
        SELECT COUNT(*) INTO hitungPelajaran FROM tblPelajaran;
        SELECT COUNT(*) INTO hitungNilai FROM tblNilai;

        OPEN cPelajaran;
        WHILE a <> hitungPelajaran DO
            SET vSiswa='[';
            FETCH cPelajaran INTO idPelajaran, namaPelajaran;
            IF idPelajaran = pNoPelajaran THEN
                OPEN cNilai;
                SET b=0;
                WHILE b <> hitungNilai DO
                    FETCH cNilai INTO nisSiswa,idPelajaran2;
                    IF idPelajaran2 = idPelajaran THEN
                        OPEN cSiswa;
                        SET c=0;
                        WHILE c <> hitungSiswa DO
                             FETCH cSiswa INTO nisSiswa2,namaSiswa;
                             IF nisSiswa2 = nisSiswa && namaSiswa != siswaSebelum THEN
                                  SET siswaSebelum=namaSiswa;
                                  SET vSiswa = CONCAT(vSiswa,namaSiswa,', ');
                             END IF;
                             SET c=c+1;
                        END WHILE;
                        CLOSE cSiswa;

                    END IF;

                    SET b=b+1;
                END WHILE;
                CLOSE cNilai;

            SET vSiswa = CONCAT(vSiswa,']');
            SELECT CONCAT(pNoPelajaran,'-',namaPelajaran) AS 'Mata Pelajaran' ,vSiswa AS Siswa;
            END IF;

            SET a=a+1;
        END WHILE;
        CLOSE cPelajaran; /*tutup cursor*/
     END
     $$
     DELIMITER ;

CALL spTampilSiswa(2);
CALL spTampilSiswa(3);


-- NO 2
CREATE TABLE tblKomponenNilai(
    komponen VARCHAR(30) ,
    nilai DOUBLE
);
DELIMITER $$
CREATE PROCEDURE spRapot(pNomorIndukMahasiswa VARCHAR(4), pNoPelajaran VARCHAR(4))
BEGIN
    DECLARE nisSiswa, nisSiswa2 VARCHAR(4) DEFAULT 0;
    DECLARE namaSiswa, namaMataPelajaran, namaKomponen VARCHAR(30) DEFAULT '';
    DECLARE a, b, c, d, nomorKomponen, nomorKomponen2, hitungSiswa, hitungNilai, hitungPelajaran, hitungKomponen, nomorPelajaran, nomorPelajaran2 INT DEFAULT 0;
    DECLARE rataRata, nilaiUlangan DOUBLE DEFAULT 0.0;

    DECLARE cSiswa CURSOR FOR
        SELECT * FROM tblSiswa;
    DECLARE cNilai CURSOR FOR
        SELECT * FROM tblNilai;
    DECLARE cPelajaran CURSOR FOR
        SELECT * FROM tblPelajaran;
    DECLARE cKomponen CURSOR FOR
        SELECT * FROM tblKomponen;
    SELECT COUNT(*) INTO hitungSiswa FROM tblSiswa;
    SELECT COUNT(*) INTO hitungPelajaran FROM tblPelajaran;
    SELECT COUNT(*) INTO hitungNilai FROM tblNilai;
    SELECT COUNT(*) INTO hitungKomponen FROM tblKomponen;

    TRUNCATE TABLE tblKomponenNilai;

    OPEN cNilai;
    WHILE a <> hitungNilai DO
        FETCH cNilai INTO nisSiswa, nomorKomponen, nomorPelajaran, nilaiUlangan;
        IF nisSiswa = pNomorIndukMahasiswa && nomorPelajaran = pNoPelajaran THEN
            OPEN cPelajaran;
            OPEN cSiswa;
            SET b=0;
            WHILE c <> hitungPelajaran DO
                FETCH cPelajaran INTO nomorPelajaran2,namaMataPelajaran;
                IF nomorPelajaran2 = nomorPelajaran THEN
                    WHILE b <> hitungSiswa DO
                        FETCH cSiswa INTO nisSiswa2,namaSiswa;
                        IF nisSiswa2 = nisSiswa THEN
                            SELECT nisSiswa2 AS 'NIS',
                                   namaSiswa AS SISWA,
                                   namaMataPelajaran AS 'Mata Pelajaran';
                        END IF;
                        SET b=b+1;
                    END WHILE;
                END IF;
                SET c=c+1;

            END WHILE;
            CLOSE cSiswa;
            CLOSE cPelajaran;
            OPEN cKomponen;
            SET d=0;
            WHILE d <> hitungKomponen DO
                FETCH cKomponen INTO nomorKomponen2,namaKomponen;
                IF nomorKomponen2 = nomorKomponen THEN
                    INSERT INTO tblKomponenNilai VALUES
                    (namaKomponen, nilaiUlangan);
                    SET rataRata = rataRata+nilaiUlangan;

                END IF;
                SET d=d+1;
            END WHILE;
            CLOSE cKomponen;

        END IF;

        SET a=a+1;
    END WHILE;
    CLOSE cNilai;
    SELECT komponen ,nilai FROM tblKomponenNilai;
    SELECT rataRata/4 AS 'RATA RATA';


END$$
DELIMITER ;

CALL spRapot('7014', 4);
CALL spRapot('7012', 3);

-- NO 3

DELIMITER $$
CREATE PROCEDURE spLaporan(pNomorPelajaran INT, pNoKomponen INT)
BEGIN
    DECLARE vNis, vNis2, vMapel VARCHAR(4) DEFAULT 0;
    DECLARE vNamaSiswa, vNamaPelajaran, vKomponen VARCHAR(30) DEFAULT '';
    DECLARE a, b, c, d, vNoKomponen, vNoKomponen2, hitungSiswa, hitungNilai, hitungPelajaran, hitungKomponen, nomorPelajaran, nomorPelajaran2 INT DEFAULT 0;
    DECLARE rataRata, vMax, nilaiUlangan DOUBLE DEFAULT 0.0;
    DECLARE vMin DOUBLE DEFAULT 100;


    DECLARE cSiswa CURSOR FOR
        SELECT * FROM tblSiswa;
    DECLARE cNilai CURSOR FOR
        SELECT * FROM tblNilai;
    DECLARE cPelajaran CURSOR FOR
        SELECT * FROM tblPelajaran;
    DECLARE cKomponen CURSOR FOR
        SELECT * FROM tblKomponen;

    DROP TABLE IF EXISTS tblNo3;
    CREATE TABLE tblNo3(
      noKomponen INT,
      komponenPenilaian VARCHAR(30),
      nilai DOUBLE,
      siswa VARCHAR(50)
    );

    SELECT COUNT(*) INTO hitungSiswa FROM tblSiswa;
    SELECT COUNT(*) INTO hitungPelajaran FROM tblPelajaran;
    SELECT COUNT(*) INTO hitungNilai FROM tblNilai;
    SELECT COUNT(*) INTO hitungKomponen FROM tblKomponen;

    TRUNCATE TABLE tblNo3;
    OPEN cPelajaran;
    WHILE b <> hitungPelajaran DO
        FETCH cPelajaran INTO nomorPelajaran2,vNamaPelajaran;
        IF nomorPelajaran2 = pNomorPelajaran THEN
            SELECT vNamaPelajaran AS 'Mata Pelajaran';
        END IF;
        SET b=b+1;
    END WHILE;
    CLOSE cPelajaran;

    OPEN cNilai;
    WHILE a <> hitungNilai DO
        FETCH cNilai INTO vNis, vNoKomponen, nomorPelajaran, nilaiUlangan;
        IF nomorPelajaran = pNomorPelajaran && vNoKomponen = pNoKomponen THEN
            OPEN cKomponen;
            OPEN cSiswa;
            SET c=0;
            WHILE c <> hitungKomponen DO
                FETCH cKomponen INTO vNoKomponen2,vKomponen;
                IF vNoKomponen2 = vNoKomponen THEN
                    SET d=0;
                    WHILE d <> hitungSiswa DO
                        FETCH cSiswa INTO vNis2, vNamaSiswa;
                        IF vNis2 = vNis THEN
                            INSERT INTO tblNo3 VALUES
                            (vNoKomponen, vKomponen, nilaiUlangan,CONCAT(vNis2,' - ',vNamaSiswa));
                            SET rataRata = rataRata + nilaiUlangan;
                            IF nilaiUlangan >= vMax THEN
                                SET vMax = nilaiUlangan;
                            ELSEIF nilaiUlangan <= vMin THEN
                                SET vMin = nilaiUlangan;
                            END IF;

                        END IF;

                        SET d=d+1;
                    END WHILE;

                END IF;

                SET c=c+1;
            END WHILE;

            CLOSE cKomponen;
            CLOSE cSiswa;

        END IF;
        SET a=a+1;
    END WHILE;

    CLOSE cNilai;

    SELECT noKomponen, komponenPenilaian, nilai, siswa FROM tblNo3;

    SELECT vMax AS Maksimal,
           vMin as Minimal,
           rataRata/6 as 'Rerata Mata Pelajaran';

END$$

DELIMITER ;

CALL spLaporan(2, 3);
