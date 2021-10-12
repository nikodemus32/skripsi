/*
  NIKODEMUS GALIH CANDRA WICAKSONO
  DATA D:/Galih/Unika Soegijapranata/Data Mining
  Monday, 02 November 2020 08:07
*/

DROP DATABASE IF EXISTS db18k10082_uts;
CREATE DATABASE db18k10082_uts;
USE db18k10082_uts;

/*START NOMOR 1*/
CREATE TABLE tblData(
  datake INT PRIMARY KEY,
  x double(8,2),
  y double(8,2)
);

/*Function untuk mendapatkan nilai x dan y(no 1 dan 2),
jika parameter batas diisi 'y' maka nilainya 30>x>80
jika selain y maka random antara 0-100
*/
DELIMITER $$
  CREATE FUNCTION sfAcakxy(batas varchar(1))
  RETURNS double
  BEGIN
    DECLARE nilai double DEFAULT 0.00;
    IF batas='y' THEN
      /*While supaya nilai >30 dan <80*/
      WHILE nilai<=0.3 OR nilai>=0.8 DO
      SET nilai=ROUND(RAND(),2);
      END WHILE;
    ELSE
      SET nilai=ROUND(rand(),2);
    END IF;
    SET nilai=nilai*100;
    RETURN nilai;
  END $$
  DELIMITER ;
-- SELECT sfAcakxy() AS tesNilai;

DELIMITER $$
  CREATE PROCEDURE spInsertTblData(berapa INT)
  BEGIN
    DECLARE i INT DEFAULT 0;
    WHILE i<>berapa DO
      INSERT INTO tblData VALUES(i+1, sfAcakxy('y'), sfAcakxy('y'));
    SET i=i+1;
    END WHILE;
  END $$
  DELIMITER ;
-- CALL spInsertTblData(30);
-- SELECT * FROM tblData;

/*END NOMOR 1*/





/*START NOMOR 2*/
/*
  tabel untuk Centroid,
  B untuk yang baru supaya looping berhenti otomatis
  jika x=xB dan y=yB maka looping berhenti otomatis
  dengan ada centroid lama dan baru lebih enak dilihat
*/
CREATE TABLE tblCentroid(
  centroid INT PRIMARY KEY,
  x double(8,2),
  xB double(8,2),
  y double(8,2),
  yB double(8,2)
);

/*
  Procedure untuk membuat centroid awal(pertama kali)
  sebanyak inputan user. Dipanggil 1 kali saat call procedure
  yang menjalankan proses inti (melooping otomatis)
 */
DELIMITER $$
  CREATE PROCEDURE spInsertTblCentroid(berapa int)
    BEGIN
      DECLARE i INT DEFAULT 0;
      TRUNCATE TABLE tblCentroid;
      WHILE i<>berapa DO
        INSERT INTO tblCentroid(centroid, xB, yB) VALUES(i+1, sfAcakxy('n'),sfAcakxy('n'));
      SET i=i+1;
      END WHILE;
    END $$
    DELIMITER ;

-- call spInsertTblCentroid(3);
-- SELECT * FROM tblCentroid;
/*END NOMOR 2*/

/*Tabel tambahan untuk stop looping otomatis*/
CREATE TABLE tblCluster(
  datake int PRIMARY KEY,
  cluster varchar(2),
  clusterBaru varchar(2)
);

/*
Procedure mengisi tblCluster.
dengan isi cluster '--' dan clusterBaru '',
clusterBaru diupdate setelah iterasi pertama,
sehingga hasil cluster dan clusterBaru yang sama
adalah 0
*/
DELIMITER $$
  CREATE PROCEDURE spInsertTblCluster()
  BEGIN
    DECLARE i, countTblData, cDatake INT DEFAULT 0;

    DECLARE cTblData cursor for SELECT datake FROM tblData;
    SELECT count(*) INTO countTblData FROM tblData;

    open cTblData;
      WHILE i<>countTblData DO
        fetch cTblData INTO cDatake;
          INSERT INTO tblCluster VALUES(cDatake, '--', '');
      SET i=i+1;
      END WHILE;
    close cTblData;
  END $$
DELIMITER ;


/*START NOMOR 3*/
CREATE TABLE tblJarak(
  datake int,
  x double(8,2),
  y double(8,2),
  centroid int,
  centroidX double(8,2),
  centroidY double(8,2),
  jarak double(8,2)
);

CREATE TABLE tblCariCluster(
  datake INT,
  x double(8,2),
  y double(8,2),

  jarak varchar(255),
  cluster varchar(2)
);

DELIMITER $$
CREATE PROCEDURE spJarak()
  BEGIN
    DECLARE i, i2,
            countTblData, countTblCentroid, /*count tabel*/
            cDatake, cCentroid INT DEFAULT 0; /*Primary key masing-masing tabel*/
    DECLARE  cxtD, cytD,  /*tblData*/
              cxtC, cxB, cytC, cyB double(8,2) default 0.00; /*tblCentroid*/

    DECLARE cTblData cursor for SELECT * FROM tblData;
    DECLARE cTblCentroid cursor for SELECT * FROM tblCentroid;

    SELECT COUNT(*) INTO countTblData FROM tblData;
    SELECT COUNT(*) INTO countTblCentroid FROM tblCentroid;

    open cTblData;
      WHILE i<>countTblData DO
      fetch cTblData INTO cDatake, cxtD, cytD;
        SET i2=0;

        open cTblCentroid;
          WHILE i2<>countTblCentroid DO
            fetch cTblCentroid INTO cCentroid, cxtC, cxB, cytC,cyB;
              -- TRUNCATE TABLE tblJarak;
              INSERT INTO tblJarak VALUES(cDatake, cxtD,cytD, /*tabel Data*/
                    cCentroid,cxB,cyB, /*tabel Centroid*/
                    ROUND(SQRT(POW((cxtD-cxB),2)+POW((cytD-cyB),2)),2));
          SET i2=i2+1;
          END WHILE;
        close cTblCentroid;

    SET i=i+1;
    END WHILE;
    close cTblData;
  END $$
  DELIMITER ;

DELIMITER $$
  CREATE PROCEDURE spCariCluster()
  BEGIN
    DECLARE spJarak, spJarak2 varchar(255) DEFAULT '';
    DECLARE cClusterBaru varchar(2);
    DECLARE countTblData, countTblCentroid, cDatake int default 0; /*count tabel*/
    DECLARE i,j INT DEFAULT 1;
    DECLARE  cxtD, cytD double(8,2);  /*tblData*/


    DECLARE cTblData cursor for SELECT * FROM tblData;
    SELECT COUNT(*) INTO countTblData FROM tblData;
    SELECT COUNT(*) INTO countTblCentroid FROM tblCentroid;
    open cTblData;
      WHILE i<>countTblData+1 DO
        SET j=1;
        SET spJarak='';
        fetch cTblData INTO cDatake, cxtD, cytD;
        /*set varchar untuk isi Jarak*/
          WHILE j<>countTblCentroid+1 DO
            SET spJarak2=CONCAT
            ('C',j,': (',(SELECT centroidX FROM tblJarak WHERE datake=i AND centroid=j),',',
              (SELECT centroidY FROM tblJarak WHERE datake=i AND centroid=j),')=',
              (SELECT jarak FROM tblJarak WHERE datake=i AND centroid=j),';__'
            );
            SET spJarak=CONCAT(spJarak,spJarak2);
          SET j=j+1;
          END WHILE;
          SET spJarak2=CONCAT
            ('C',j,': (',
              (SELECT centroidX FROM tblJarak WHERE datake=i AND centroid=j),',',
              (SELECT centroidY FROM tblJarak WHERE datake=i AND centroid=j),')=',
              (SELECT jarak FROM tblJarak WHERE datake=i AND centroid=j),';'
            );
          SET spJarak=CONCAT(spJarak,spJarak2);


          -- SELECT i as loopingKe, spJarak as Jarak;
          SET cClusterBaru=(SELECT concat('C',centroid) FROM tblJarak
            WHERE jarak=(SELECT min(jarak) FROM tblJarak WHERE datake=i));
          INSERT INTO tblCariCluster VALUES
            (cDatake, cxtD, cytD, spJarak,
              (SELECT concat('C',centroid) FROM tblJarak
              WHERE jarak=(SELECT min(jarak) FROM tblJarak WHERE datake=i))
            );
          UPDATE tblCluster SET clusterBaru=cClusterBaru WHERE datake=i;
      SET i=i+1;
      END WHILE;
    close cTblData;
  END $$
  DELIMITER ;
/*END NOMOR 3*/
-- DELIMITER $$
-- CREATE PROCEDURE spIterasi()
-- BEGIN
-- call spJarak();
-- call spCariCluster();
-- END $$
-- DELIMITER ;
--
-- DELIMITER $$
-- CREATE PROCEDURE spRunning(banyakTblData int, banyakCentroid int)
--   BEGIN
--     DECLARE cDatake, jumlahSama, countTblCluster, countTblCentroid, j, i int DEFAULT 0;
--     DECLARE cCluster, cCLusterBaru varchar(2) DEFAULT '';
--
--
--     DECLARE cTblCluster cursor for SELECT * FROM tblCluster;
--     SELECT count(*) INTO countTblCluster FROM tblCluster;
--     SELECT count(*) INTO countTblCentroid FROM tblCentroid;
--
--     call spInsertTblData(banyakTblData);
--     call spInsertTblCluster;
--     call spInsertTblCentroid(banyakCentroid);
--
--     WHILE jumlahSama<>countTblCluster DO
--       SET j=0;
--       call spIterasi();
--       open cTblCluster;
--       set jumlahSama=0;
--
--         WHILE i<>countTblCluster DO
--           fetch cTblCluster INTO cDatake, cCluster, cClusterBaru;
--             IF(cCluster=cClusterBaru) then
--               SET jumlahSama=jumlahSama+1;
--               UPDATE tblCluster SET cluster=(SELECT cluster FROM tblCariCluster WHERE datake=i) WHERE datake=i;
--             ELSE
--               UPDATE tblCluster SET cluster=clusterBaru WHERE datake=i;
--             END IF;
--         SET i=i+1;
--         END WHILE;
--
--       close cTblCluster;
--       WHILE j<>countTblCentroid DO
--         UPDATE tblCentroid SET x=xB, y=yB WHERE centroid=j+1;
--       SET j=j+1;
--       END WHILE ;
--     END WHILE;
--
--     SELECT * FROM tblData;
--     SELECT * FROM tblCluster;
--     SELECT * FROM tblCentroid;
--
--     SELECT * FROM tblJarak;
--     SELECT * FROM tblCariCluster;
--     SELECT * FROM tblCluster;
--     TRUNCATE TABLE tblData;
--     TRUNCATE TABLE tblCentroid;
--     TRUNCATE TABLE tblCluster;
--
--
--   END $$
--   DELIMITER ;

  -- call spRunning(20,4);
  call spInsertTblData(10);
  call spInsertTblCluster;
  call spInsertTblCentroid(3);
  call spJarak();
  call spCariCluster();
SELECT * FROM tblData;
SELECT * FROM tblCluster;
SELECT * FROM tblCentroid;

SELECT * FROM tblJarak;
SELECT * FROM tblCariCluster;
SELECT * FROM tblCluster;
