DROP DATABASE IF EXISTS dbCursor18k10082;
CREATE DATABASE dbCursor18k10082;
USE dbCursor18k10082;

CREATE TABLE tblSiswa(
  nis varchar(4) PRIMARY KEY,
  namasiswa varchar(30)
);
CREATE TABLE tblKomponen(
  nokomponen int PRIMARY KEY,
  komponen varchar(30)
);
CREATE TABLE tblPelajaran(
  nopelajaran int PRIMARY KEY,
  matapelajaran varchar(30)
);
CREATE TABLE tblNilai(
  nis varchar(4),
  nokomponen int,
  nopelajaran int,
  nilai double,
  FOREIGN KEY(nis) REFERENCES tblSiswa(nis),
  FOREIGN KEY(nokomponen) REFERENCES tblKomponen(nokomponen),
  FOREIGN KEY(nopelajaran) REFERENCES tblPelajaran(nopelajaran)
);

LOAD DATA LOCAL INFILE 'tblSiswa.csv'
INTO TABLE tblSiswa
FIELDS TERMINATED BY ';'
ENCLOSED BY '''';

LOAD DATA LOCAL INFILE 'tblKomponen.csv'
INTO TABLE tblKomponen
FIELDS TERMINATED BY ';'
ENCLOSED BY '''';

LOAD DATA LOCAL INFILE 'tblPelajaran.csv'
INTO TABLE tblPelajaran
FIELDS TERMINATED BY ';'
ENCLOSED BY '''';

LOAD DATA LOCAL INFILE 'tblNilai.csv'
INTO TABLE tblNilai
FIELDS TERMINATED BY ';'
ENCLOSED BY '''';

-- SELECT * FROM tblSiswa, tblPelajaran, tblKomponen, tblNilai;

-- START nomor 1
CREATE VIEW vwMapelSiswa as
SELECT DISTINCT(tblNilai.nopelajaran) as NO,
    tblPelajaran.matapelajaran as MAPEL,
    tblSiswa.namasiswa as NAMASISWA
FROM tblNilai
NATURAL JOIN tblPelajaran
NATURAL JOIN tblSiswa;

DELIMITER $$
CREATE PROCEDURE spTampilSiswa(pNoPelajaran int)
BEGIN
  DECLARE i, panjangNamaSiswa int default 0;
  DECLARE vJumlahData, vNo int;
  DECLARE namaSiswa, vNama, mapel, vMapel varchar(255);
  DECLARE cSiapa cursor for SELECT * FROM vwMapelSiswa;

  SET namaSiswa='Tidak Ada';
  SET mapel='Belum Tersedia';

  IF(pNoPelajaran<=0||pNoPelajaran>6) THEN SELECT mapel as 'Mata Pelajaran', namaSiswa as Siswa;

  ElSE
  SELECT count(*) into vJumlahData FROM vwMapelSiswa;
  open cSiapa;
  SET namaSiswa='[';
  while i <> vJumlahData DO
    fetch cSiapa INTO vNo, vMapel, vNama;
    if pNoPelajaran=vNo then
      SET namaSiswa=CONCAT(namaSiswa, vNama,', ');
      SET mapel=vMapel;
    END if;
    SET i=i+1;
  END while;
  SET panjangNamaSiswa=(LENGTH(namaSiswa))-2;
  SET namaSiswa=CONCAT(LEFT(namaSiswa,panjangNamaSiswa),']');
  SELECT
  CONCAT(pNoPelajaran,' - ', mapel) as 'Mata Pelajaran',
  namaSiswa as Siswa;
  close cSiapa;
  END IF;
END
$$
DELIMITER ;
CALL spTampilSiswa(7);
CALL spTampilSiswa(2);
CALL spTampilSiswa(3);
-- END NOMOR 1

-- START NOMOR 2
CREATE VIEW vwTabel as
SELECT
  tblNilai.nis as nis,
  tblSiswa.namasiswa as nama,
  tblNilai.nopelajaran as nopel,
  tblPelajaran.matapelajaran as mapel,
  tblNilai.nokomponen as nokom,
  tblKomponen.komponen as komponen,
  tblNilai.nilai as nilai
FROM tblNilai
NATURAL JOIN tblSiswa
NATURAL JOIN tblPelajaran
NATURAL JOIN tblKomponen;

DELIMITER $$
CREATE PROCEDURE spRapot(pNomorInduk varchar(4), pNoPelajaran int)
BEGIN
  DECLARE i,j INT DEFAULT 0;
  DECLARE vJumlahData, vNop, vNok int;
  DECLARE vNis varchar(4);
  DECLARE vNama, vMapel, vKomponen, mapel, nama, komponen varchar(30);
  DECLARE vNilai, nilai double;
  DECLARE temp_temp_average double;
  DECLARE cRapot1 cursor for SELECT * FROM vwTabel;

  SET temp_temp_average=0;

  DROP TABLE IF EXISTS tblRapot;
  CREATE TABLE tblRapot(
    komponen varchar(30),
    nilai double
  );

  SELECT count(*) INTO vJumlahData FROM vwTabel;
  open cRapot1;
    while i<>vJumlahData DO
    fetch cRapot1 INTO vNis, vNama, vNop, vMapel, vNok, vKomponen, vNilai;
      IF(pNomorInduk=vNis && pNoPelajaran=vNop) THEN SET nama=vNama, mapel=vMapel;
      END IF;
      IF(pNomorInduk=vNis && pNoPelajaran=vNop) THEN INSERT INTO tblRapot values(vKomponen, vNilai);
      END IF;
      IF(pNomorInduk=vNis && pNoPelajaran=vNop) THEN SET temp_temp_average=temp_temp_average+vNilai;
      END IF;
      SET i=i+1;
    END while;
    SELECT pNomorInduk as NIS, nama as SISWA, mapel as 'Mata Pelajaran';
    SELECT * FROM tblRapot;
    SELECT temp_temp_average/4 as 'Rerata Seluruh Nilai';
  close cRapot1;

END
$$
DELIMITER ;

CALL spRapot('7014', 4);
CALL spRapot('7012', 3);
-- END NOMOR 2

-- START NOMOR 3
DELIMITER $$
CREATE PROCEDURE spLaporan(pNomorPelajaran INT, pNoKomponen INT)
BEGIN
    DECLARE fNis, fNis2 VARCHAR(4) DEFAULT 0;
    DECLARE fNamaSiswa, fNamaPelajaran, fKomponen VARCHAR(30) DEFAULT '';
    DECLARE
      i, i2, i3, i4,
      fNoKomponen, fNoKomponen2,
      countTblSiswa, countTblNilai, countTblPelajaran, countTblKomponen, countTblNomor3,
      fNomorPelajaran, fNomorPelajaran2 INT DEFAULT 0;
    DECLARE temp_average, maksimal, fNilai DOUBLE DEFAULT 0.0;
    DECLARE minimal DOUBLE DEFAULT 100;

    DECLARE cSiswa CURSOR FOR SELECT * FROM tblSiswa;
    DECLARE cNilai CURSOR FOR SELECT * FROM tblNilai;
    DECLARE cPelajaran CURSOR FOR SELECT * FROM tblPelajaran;
    DECLARE cKomponen CURSOR FOR SELECT * FROM tblKomponen;

    DROP TABLE IF EXISTS tblNomor3;
    CREATE TABLE tblNomor3(
      noKomponen INT,
      komponenPenilaian VARCHAR(30),
      nilai DOUBLE,
      siswa VARCHAR(50)
    );

    SELECT COUNT(*) INTO countTblSiswa FROM tblSiswa;
    SELECT COUNT(*) INTO countTblPelajaran FROM tblPelajaran;
    SELECT COUNT(*) INTO countTblKomponen FROM tblKomponen;
    SELECT COUNT(*) INTO countTblNilai FROM tblNilai;

    TRUNCATE TABLE tblNomor3;
    open cPelajaran;
    WHILE i <> countTblPelajaran DO
        fetch cPelajaran INTO fNomorPelajaran,fNamaPelajaran;
        IF fNomorPelajaran = pNomorPelajaran THEN
            SELECT fNamaPelajaran AS 'Mata Pelajaran';
        END IF;
        SET i=i+1;
    END WHILE;
    close cPelajaran;

    open cNilai;
    WHILE i2 <> countTblNilai DO
    fetch cNilai INTO fNis, fNoKomponen, fNomorPelajaran2, fNilai;
      IF fNomorPelajaran2=pNomorPelajaran && pNoKomponen=fNoKomponen THEN

        open cKomponen;
        SET i3=0;
        WHILE i3<>countTblKomponen DO
        fetch cKomponen INTO fNoKomponen2, fKomponen;
          IF fNoKomponen2=fNoKomponen THEN set i4=0;

            open cSiswa;
            WHILE i4 <> countTblSiswa DO
            fetch cSiswa INTO fNis2, fNamaSiswa;

              IF fNis=fNis2 THEN
                INSERT INTO tblNomor3 values
                (fNoKomponen, fKomponen,fNilai,CONCAT(fNis2, ' - ', fNamaSiswa));
                SET temp_average = temp_average + fNilai;

                IF fNilai >= maksimal THEN SET maksimal=fNilai;
                ELSEIF fNilai<= minimal THEN SET minimal=fNilai;
                END IF;

              END IF;

            SET i4=i4+1;
            END WHILE;
            close cSiswa;

          END IF;
        SET i3=i3+1;
        END WHILE;
        close cKomponen;

      END IF;
      SET i2=i2+1;
    END WHILE;
    close cNilai;

    SELECT count(*) INTO countTblNomor3 FROM tblNomor3;
    SELECT
      noKomponen as 'No Komponen',
      komponenPenilaian as 'Komponen Penilaian',
      nilai as 'Nilai',
      siswa as 'Siswa'
   FROM tblNomor3;

    SELECT maksimal AS Maksimal,
           minimal as Minimal,
           temp_average/countTblNomor3 as 'Rerata Mata Pelajaran';

END$$

DELIMITER ;

CALL spLaporan(2, 3);
CALL spLaporan(3,4);
-- END NOMOR 3
