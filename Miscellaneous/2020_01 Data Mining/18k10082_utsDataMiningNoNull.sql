/*
  Nikodemus Galih Candra Wicaksono
  DATA D :"Galih/Unika Soegijapranata/Data Mining/"
*/
DROP DATABASE IF EXISTS dbUtsDM_18k10082;
CREATE DATABASE dbUtsDM_18k10082;
USE dbUtsDM_18k10082;

CREATE TABLE tblHasilTes(
  noTest int PRIMARY KEY,
  bahasa int,
  matematika int,
  logika int
);

INSERT INTO tblHasilTes VALUES
  (1101,80,98,45),
  (1102,20,65,98),
  (1103,27,38,16),
  (1104,70,99,97),
  (1105,92,99,93),
  (1106,46,45,88),
  (1107,57,39,92),
  (1108,91,17,45),
  (1109,58,58,91),
  (1110,10,57,94);

  CREATE TABLE tblCentroid(
    noTest int,
    clusterSebelum varchar(2),
    clusterBaru varchar(2)
  );

  DELIMITER $$
  CREATE PROCEDURE spInserttblCentroid()
  BEGIN
  DECLARE i, jumlahTblHasilTes, cNoTest int DEFAULT 0;

  DECLARE cTblHasilCek cursor for SELECT noTest FROM tblHasilTes;

  SELECT count(*) INTO jumlahTblHasilTes FROM tblHasilTes;
  open cTblHasilCek;
  WHILE i<>jumlahTblHasilTes DO
    fetch cTblHasilCek into cNoTest;
      INSERT INTO tblCentroid VALUES (cNoTest, '--', '');
  SET i=i+1;
  END WHILE;
  close cTblHasilCek;
  -- INSERT INTO tblCentroid values
  --   (1101, '--', ''),
  --   (1102, '--', ''),
  --   (1103, '--', ''),
  --   (1104, '--', ''),
  --   (1105, '--', ''),
  --   (1106, '--', ''),
  --   (1107, '--', ''),
  --   (1108, '--', ''),
  --   (1109, '--', ''),
  --   (1110, '--', '');
  END $$
  DELIMITER ;
  CALL spInserttblCentroid();
/*tblCentroid untuk mengentikan looping otomatis*/
-- SELECT * FROM tblCentroid;
/*tblCek awalnya untuk cek looping
jika cx dan cy sama dengan yang c baru semua
maka sudah sama semua cluster. (jadinya pakai tblCentroid)
*/
CREATE TABLE tblCek(
  -- c1x double,
  c1xB double,
  -- c1y double,
  c1yB double,

  -- c2x double,
  c2xB double,
  -- c2y double,
  c2yB double,

  -- c3x double,
  c3xB double,
  -- c3y double,
  c3yB double,

  -- c4x double,
  c4xB double,
  -- c4y double,
  c4yB double
);

/*Trigger untuk otomatis insert tblCek(tidak jadi)*/
-- DELIMITER $$
-- CREATE TRIGGER tgInserttblCentroid
-- AFTER INSERT ON tblCentroid
-- FOR EACH ROW
-- BEGIN
--   INSERT INTO tblCek
--   values(NEW.c1x, 0, NEW.c1y, 0,
--   NEW.c2x, 0, NEW.c2y, 0,
--   NEW.c3x, 0, NEW.c3y, 0,
--   NEW.c4x, 0, NEW.c4y, 0);
-- END
-- $$
-- DELIMITER ;

/*Untuk input random tblCekBaru(c1xB,c1yB,c2xB, dst)
dan 'NN' untuk yang sebelum*/
DELIMITER $$
  CREATE PROCEDURE spInserttblCek()
  BEGIN
  INSERT INTO tblCek values
    (  round(rand()*100,2),
       round(rand()*100,2),
       round(rand()*100,2),
       round(rand()*100,2),
       round(rand()*100,2),
       round(rand()*100,2),
       round(rand()*100,2),
       round(rand()*100,2));
  END $$
  DELIMITER ;

-- SELECT * FROM tblCek;

-- SELECT tblHasilTes.noTest,
-- tblHasilTes.bahasa,
-- tblHasilTes.matematika,
-- tblHasilTes.logika,
--   CONCAT('(',tblCentroid.c1x,',', tblCentroid.c1y,')') AS 'C1',
--   CONCAT('(',tblCentroid.c2x,',', tblCentroid.c2y,')') AS 'C2',
--   CONCAT('(',tblCentroid.c3x,',', tblCentroid.c3y,')') AS 'C3',
--   CONCAT('(',tblCentroid.c4x,',', tblCentroid.c4y,')') AS 'C4'
-- FROM tblCentroid, tblHasilTes;
-- SELECT * FROM tblHasilTes;

/*View untuk dipakai procedure.
viewPsikologi jika parameter psikologi
viewInformatika jika parameter informatika*/

/*membuat view untuk Psikologi(bahasa dan logika)*/
DROP VIEW IF EXISTS viewPsikologi;
  CREATE VIEW viewPsikologi AS
  SELECT tblHasilTes.noTest AS no,
  tblHasilTes.bahasa AS x,
  tblHasilTes.logika AS y,
  tblCek.C1xB AS C1x,
  tblCek.C1yB AS C1y,
  tblCek.C2xB AS C2x,
  tblCek.C2yB AS C2y,
  tblCek.C3xB AS C3x,
  tblCek.C3yB AS C3y,
  tblCek.C4xB AS C4x,
  tblCek.C4yB AS C4y
  FROM tblHasilTes, tblCek;

/*membuat view untuk Informatika(matematika dan logika)*/
DROP VIEW IF EXISTS viewInformatika;
  CREATE VIEW viewInformatika AS
  SELECT tblHasilTes.noTest AS no,
  tblHasilTes.matematika AS x,
  tblHasilTes.logika AS y,
  tblCek.C1xB AS C1x,
  tblCek.C1yB AS C1y,
  tblCek.C2xB AS C2x,
  tblCek.C2yB AS C2y,
  tblCek.C3xB AS C3x,
  tblCek.C3yB AS C3y,
  tblCek.C4xB AS C4x,
  tblCek.C4yB AS C4y
  FROM tblHasilTes, tblCek;

/*
PROCEDURE ada yang di bagi 2(psikologi sendiri informatika sendiri) karena saat dicoba
psikologi dan informatika jadi satu dengan if berdasarkan parameter procedure
*/

/*membuat View untuk mendapatkan jarak terdekat menjadi "MASUK_CLUSTER" (Psikologi)*/
DELIMITER $$
  CREATE PROCEDURE spCreateVW()
  BEGIN
      DROP VIEW IF EXISTS vwPsikologi;
      CREATE VIEW vwPsikologi AS
      SELECT
        no, x, y, C1x, C1y, C2x, C2y, C3x,C3y,C4x,C4y,
        ROUND(SQRT(POW((x-C1x),2) + POW((y-C1y),2)),2) AS Jarak_ke_C1,
        ROUND(SQRT(POW((x-C2x),2) + POW((y-C2y),2)),2) AS Jarak_ke_C2,
        ROUND(SQRT(POW((x-C3x),2) + POW((y-C3y),2)),2) AS Jarak_ke_C3,
        ROUND(SQRT(POW((x-C4x),2) + POW((y-C3y),2)),2) AS Jarak_ke_C4
        ,
        IF(   SQRT(POW((x-C1x),2) + POW((y-C1y),2)) < SQRT(POW((x-C2x),2) + POW((y-C2y),2))
          AND SQRT(POW((x-C1x),2) + POW((y-C1y),2)) < SQRT(POW((x-C3x),2) + POW((y-C3y),2))
          AND SQRT(POW((x-C1x),2) + POW((y-C1y),2)) < SQRT(POW((x-C4x),2) + POW((y-C4y),2))
          ,
          'C1',
            IF(   SQRT(POW((x-C2x),2) + POW((y-C2y),2)) < SQRT(POW((x-C3x),2) + POW((y-C3y),2))
              AND SQRT(POW((x-C2x),2) + POW((y-C2y),2)) < SQRT(POW((x-C4x),2) + POW((y-C4y),2)),
              'C2',
              IF(
                SQRT(POW((x-C3x),2) + POW((y-C3y),2)) < SQRT(POW((x-C4x),2) + POW((y-C4y),2)),
                'C3',
                  'C4'
              )
            )
      ) AS MASUK_CLUSTER
      FROM viewPsikologi;
      SELECT * FROM vwPsikologi;
  END $$
  DELIMITER ;

/*membuat View untuk mendapatkan jarak terdekat menjadi "MASUK_CLUSTER" (Informatika)*/
DELIMITER $$
  CREATE PROCEDURE spCreateVW2()
  BEGIN
      DROP VIEW IF EXISTS vwInformatika;
      CREATE VIEW vwInformatika AS
      SELECT
        no, x, y, C1x, C1y, C2x, C2y, C3x,C3y,C4x,C4y,
        ROUND(SQRT(POW((x-C1x),2) + POW((y-C1y),2)),2) AS Jarak_ke_C1,
        ROUND(SQRT(POW((x-C2x),2) + POW((y-C2y),2)),2) AS Jarak_ke_C2,
        ROUND(SQRT(POW((x-C3x),2) + POW((y-C3y),2)),2) AS Jarak_ke_C3,
        ROUND(SQRT(POW((x-C4x),2) + POW((y-C4y),2)),2) AS Jarak_ke_C4
        ,
        IF(   SQRT(POW((x-C1x),2) + POW((y-C1y),2)) < SQRT(POW((x-C2x),2) + POW((y-C2y),2))
          AND SQRT(POW((x-C1x),2) + POW((y-C1y),2)) < SQRT(POW((x-C3x),2) + POW((y-C3y),2))
          AND SQRT(POW((x-C1x),2) + POW((y-C1y),2)) < SQRT(POW((x-C4x),2) + POW((y-C4y),2)),
          'C1',
            IF(   SQRT(POW((x-C2x),2) + POW((y-C2y),2)) < SQRT(POW((x-C3x),2) + POW((y-C3y),2))
              AND SQRT(POW((x-C2x),2) + POW((y-C2y),2)) < SQRT(POW((x-C4x),2) + POW((y-C4y),2)),
              'C2',
              IF(
                  SQRT(POW((x-C3x),2) + POW((y-C3y),2)) < SQRT(POW((x-C4x),2) + POW((y-C4y),2)),
                  'C3',
                    'C4'
              )
            )
      ) AS MASUK_CLUSTER
      FROM viewInformatika;
      SELECT * FROM vwInformatika;
  END $$
  DELIMITER ;

/*mengupdate clusterBaru di tblCentroid dengan cluster baru yang didapatkan (vwPsikologi)*/
DELIMITER $$
  CREATE PROCEDURE sptblCentroid()
  BEGIN
    DECLARE cno, cx,cy, countVwPsikologi, i int default 0;
    DECLARE cC1x,cC1y,cC2x,cC2y,cC3x,cC3y,cC4x,cC4y double default 0;
    DECLARE cMASUK_CLUSTER varchar(2);
    DECLARE JC1, JC2, JC3, JC4 double(19,2);

    DECLARE cVwPsikologi cursor for SELECT * FROM vwPsikologi;
    SELECT count(*) INTO countVwPsikologi FROM vwPsikologi;
    SET i=0;
      open cVwPsikologi;
      WHILE i <> countVwPsikologi DO
        fetch cVwPsikologi into cno,cx,cy,cC1x,cC1y,cC2x,cC2y,
                                cC3x,cC3y,cC4x,cC4y,JC1,JC2,JC3,JC4,cMASUK_CLUSTER;
          UPDATE tblCentroid SET clusterBaru=cMASUK_CLUSTER WHERE noTest=cno;
      SET i=i+1;
      END WHILE;
      close cVwPsikologi;
  END $$
  DELIMITER ;

/*mengupdate clusterBaru di tblCentroid dengan cluster baru yang didapatkan (vwInformatika)*/
DELIMITER $$
  CREATE PROCEDURE sptblCentroid2()
  BEGIN
    DECLARE cno, cx,cy, countVwInformatika, i int default 0;
    DECLARE cC1x,cC1y,cC2x,cC2y,cC3x,cC3y,cC4x,cC4y double default 0;
    DECLARE cMASUK_CLUSTER varchar(2);
    DECLARE JC1, JC2, JC3, JC4 double(19,2);

    DECLARE cVwInformatika cursor for SELECT * FROM vwInformatika;
    SELECT count(*) INTO countVwInformatika FROM vwInformatika;
      open cVwInformatika;
      WHILE i <> countVwInformatika DO
        fetch cVwInformatika into cno,cx,cy,cC1x,cC1y,cC2x,cC2y,
                                  cC3x,cC3y,cC4x,cC4y,JC1,JC2,JC3,JC4,cMASUK_CLUSTER;
          UPDATE tblCentroid SET clusterBaru=cMASUK_CLUSTER WHERE noTest=cno;
      SET i=i+1;
      END WHILE;
      close cVwInformatika;
  END $$
  DELIMITER ;

/*
PROCEDURE proses 1 Iterasi( mendapatkan jarak terkecil dan kemudian dijadikan cluster)
(psikologi dan Informatika)
*/
DELIMITER $$
  CREATE PROCEDURE spIterasi(jurusan varchar(20))
  BEGIN
    /*START if jurusan=psikologi*/
    IF jurusan="psikologi" THEN
      call spCreateVW();
      -- SELECT
      --   no,x,y,C1x,C1y,C2x,C2y,C3x,C3y,C4x,C4y,MASUK_CLUSTER
      -- FROM vwPsikologi;
      call sptblCentroid();
      SELECT noTest as 'noTest Psikologi',clusterSebelum,clusterBaru FROM tblCentroid;
    /*END if jurusan=psikologi*/


    /*START if jurusan!=psikologi(Informatika)*/
    ELSEIF jurusan="informatika" THEN
      call spCreateVW2();
      -- SELECT
      --   no,x,y,C1x,C1y,C2x,C2y,C3x,C3y,C4x,C4y,MASUK_CLUSTER
      -- FROM vwInformatika;
      call sptblCentroid2();
      SELECT noTest as 'noTest Informatika',clusterSebelum,clusterBaru FROM tblCentroid;
    END IF;
    -- /*END if jurusan!=psikologi(Informatika)*/
  END $$
  DELIMITER ;

/*Function untuk mendapatkan nilai C1xB,C1yB dst baru
(psikologi dan informatika gabung)*/
DELIMITER $$
  CREATE FUNCTION sfHitungCBaru(central varchar(2), xy varchar(1), jurusan varchar(20))
  RETURNS double
  BEGIN
    DECLARE hasil double;
    /*START if jurusan=psikologi*/
    IF jurusan='psikologi' THEN
      IF xy='x' THEN
        SET hasil = (SELECT ROUND(AVG(x),2) as NilaiCbaru
                      from vwPsikologi
                      GROUP by MASUK_CLUSTER
                      HAVING MASUK_CLUSTER=central);
      ELSE
        SET hasil = ( SELECT ROUND(AVG(y),2) as NilaiCbaru
                      from vwPsikologi
                      GROUP by MASUK_CLUSTER
                      HAVING MASUK_CLUSTER=central);
      END IF;

    /*END if jurusan=psikologi*/

    /*START if jurusan=informatika*/
    ELSEIF jurusan='informatika' THEN
      IF xy='x' THEN
        SET hasil = ( SELECT ROUND(AVG(x),2) as NilaiCbaru
                      from vwInformatika
                      GROUP by MASUK_CLUSTER
                      HAVING MASUK_CLUSTER=central);
      ELSE
        SET hasil = ( SELECT ROUND(AVG(y),2) as NilaiCbaru
                      from vwInformatika
                      GROUP by MASUK_CLUSTER
                      HAVING MASUK_CLUSTER=central);
      END IF;
    END IF;
    /*START if jurusan=informatika*/
    RETURN(hasil);
  END $$
  DELIMITER ;


/*Procedure untuk otomatis menjalankan algoritma K-Means
looping sampai semua clusterSebelum=clusterBaru
pada tblCek dengan noTest sama
*/

DELIMITER $$
  CREATE PROCEDURE spRunning(jurusan varchar(20))
  BEGIN
    DECLARE jumlahSama, counttblCentroid, i, cNoTest, pengulangan int default 0;
    DECLARE cClusterSebelum, cClusterBaru varchar(2) default '';

    DECLARE ctblCentroid cursor for SELECT * FROM tblCentroid;
    SELECT count(*) INTO counttblCentroid FROM tblCentroid;
    CALL spInserttblCek();

    WHILE jumlahSama<>counttblCentroid DO
      SET pengulangan= pengulangan+1;
      SELECT pengulangan as 'looping ke';
      CALL spIterasi(jurusan);
      open ctblCentroid;
        SET jumlahSama=0;
        SET i=0;
        WHILE i<>counttblCentroid DO
          fetch ctblCentroid INTO cNoTest, cClusterSebelum, cClusterBaru;
            IF(cClusterSebelum=cClusterBaru) THEN
              SET jumlahSama=jumlahSama+1;
              UPDATE tblCentroid SET clusterSebelum=clusterBaru WHERE noTest=1101+i;
            ELSE
              UPDATE tblCentroid SET clusterSebelum=clusterBaru WHERE noTest=1101+i;
            END IF;
        SET i=i+1;
        END WHILE;
      close ctblCentroid;

      -- SELECT jumlahSama as Jumlah;
      /*Tidak jadi karena pembanding jadinya menggunakan tblCentroid*/
      -- UPDATE tblCek SET
      -- c1x=c1xB, c1y=c1yB,
      -- c2x=c2xB, c2y=c2yB,
      -- c3x=c3xB, c3y=c3yB,
      -- c4x=c4xB, c4y=c4yB;
      --
      -- SELECT * FROM tblCek;

      /*di IF jika NULL nilai menjadi -1111 supaya nilai tidak NULL. jika nilai C -1111
      maka tidak mungkin menjadi 'MASUK_CLUSTER', karena default akan masuk C4
      jika ada JARAK_ke yang NULL
      */
      UPDATE tblCek SET
      c1xB=IF(sfHitungCBaru('C1','x',jurusan)!='NULL',sfHitungCBaru('C1','x',jurusan),0-1111),
        c1yB=IF(sfHitungCBaru('C1','y',jurusan)!='NULL',sfHitungCBaru('C1','x',jurusan),0-1111),
      c2xB=IF(sfHitungCBaru('C2','x',jurusan)!='NULL',sfHitungCBaru('C2','x',jurusan),0-1111),
        c2yB=IF(sfHitungCBaru('C2','y',jurusan)!='NULL',sfHitungCBaru('C2','x',jurusan),0-1111),
      c3xB=IF(sfHitungCBaru('C3','x',jurusan)!='NULL',sfHitungCBaru('C3','x',jurusan),0-1111),
        c3yB=IF(sfHitungCBaru('C3','y',jurusan)!='NULL',sfHitungCBaru('C3','x',jurusan),0-1111),
      c4xB=IF(sfHitungCBaru('C4','x',jurusan)!='NULL',sfHitungCBaru('C4','x',jurusan),0-1111),
        c4yB=IF(sfHitungCBaru('C4','y',jurusan)!='NULL',sfHitungCBaru('C4','x',jurusan),0-1111);

      SELECT * FROM tblCek;
    END WHILE;
    /*di truncate supaya saat call spRunning
    isi data posisi kosong, tidak ada data dari call spRunning() sebelumnya
    */
    TRUNCATE TABLE tblCek;
    TRUNCATE TABLE tblCentroid;
    CALL spInserttblCentroid();
  END $$
  DELIMITER ;


/*TES LOOPING OTOMATIS*/
-- CREATE TABLE tblTes(
--   tes varchar(2),
--   no1 int,
--   no2 int
-- );
--
-- INSERT INTO tblTes values
-- ('aa', 1,2),
-- ('bb', 2,2),
-- ('cc', 4,2),
-- ('dd', 5,5),
-- ('ee', 6,2);
--
-- DELIMITER $$
-- CREATE PROCEDURE spTes()
-- BEGIN
--   DECLARE vjumlah, vno1, vno2, v2no1, v2no2, sama, i int default 0;
--   DECLARE vtes,v2tes varchar(2);
--   DECLARE cTes cursor for SELECT * FROM tblTes;
--   DECLARE cTes2 cursor for SELECT * FROM tblTes;
--
--   SELECT count(*) into vjumlah FROM tblTes;
--
--   open cTes;
--     while i<>vjumlah DO
--     fetch cTes into vtes, vno1, vno2;
--       IF(vno1=vno2) THEN
--         SET sama = sama +1;
--       END IF;
--     SET i=i+1;
--     END WHILE;
--
--   close cTes;
--
--   SELECT sama as sama;
--   SELECT * FROM tblTes;
--
--   SET i=0;
--   IF(vjumlah!=sama) THEN
--   open cTes;
--     while i<>vjumlah DO
--     fetch cTes into vtes, vno1, vno2;
--         UPDATE tblTes SET no1=vno2, no2=0 where tes=vtes;
--     SET i=i+1;
--     END WHILE;
--   close cTes;
--   END IF;
--   SELECT * FROM tblTes;
-- END $$
-- DELIMITER ;
--
-- call spTes();


call spRunning('psikologi');
call spRunning('informatika');
