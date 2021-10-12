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

CREATE TABLE tblC(
  c1x double,
  c1y double,
  c2x double,
  c2y double,
  c3x double,
  c3y double,
  c4x double,
  c4y double
);

CREATE TABLE tblCek(
  c1x double, c1xB double,
  c1y double, c1yB double,

  c2x double, c2xB double,
  c2y double, c2yB double,

  c3x double, c3xB double,
  c3y double, c3yB double,

  c4x double, c4xB double,
  c4y double, c4yB double
);

DELIMITER $$
CREATE TRIGGER tgInsertTblC
AFTER INSERT ON tblC
FOR EACH ROW
BEGIN
  INSERT INTO tblCek
  values(NEW.c1x, 0, NEW.c1y, 0,
  NEW.c2x, 0, NEW.c2y, 0,
  NEW.c3x, 0, NEW.c3y, 0,
  NEW.c4x, 0, NEW.c4y, 0);
END
$$
DELIMITER ;

INSERT INTO tblC values
(round(rand()*100,2),round(rand()*100,2),round(rand()*100,2),round(rand()*100,2),
round(rand()*100,2),round(rand()*100,2),round(rand()*100,2),round(rand()*100,2));

SELECT
CONCAT('(',c1x,',',c1y,')') as C1,
CONCAT('(',c2x,',',c2y,')') as C2,
CONCAT('(',c3x,',',c3y,')') as C3,
CONCAT('(',c4x,',',c4y,')') as C4
FROM tblC;

SELECT * FROM tblCek;

-- SELECT tblHasilTes.noTest,
-- tblHasilTes.bahasa,
-- tblHasilTes.matematika,
-- tblHasilTes.logika,
--   CONCAT('(',tblC.c1x,',', tblC.c1y,')') AS 'C1',
--   CONCAT('(',tblC.c2x,',', tblC.c2y,')') AS 'C2',
--   CONCAT('(',tblC.c3x,',', tblC.c3y,')') AS 'C3',
--   CONCAT('(',tblC.c4x,',', tblC.c4y,')') AS 'C4'
-- FROM tblC, tblHasilTes;
-- SELECT * FROM tblHasilTes;



/*View untuk dipakai procedure.
viewPsikologi jika parameter psikologi
viewInformatika jika parameter informatika*/

DROP VIEW IF EXISTS viewPsikologi;
CREATE VIEW viewPsikologi AS
SELECT tblHasilTes.noTest AS no,
tblHasilTes.bahasa AS x,
tblHasilTes.logika AS y,
tblC.c1x AS c1x,
tblC.c1y AS c1y,
tblC.c2x AS c2x,
tblC.c2y AS c2y,
tblC.c3x AS c3x,
tblC.c3y AS c3y,
tblC.c4x AS c4x,
tblC.c4y AS c4y
FROM tblHasilTes, tblC;


DROP VIEW IF EXISTS viewInformatika;
CREATE VIEW viewInformatika AS
SELECT tblHasilTes.noTest AS no,
tblHasilTes.matematika AS x,
tblHasilTes.logika AS y,
tblC.c1x AS c1x,
tblC.c1y AS c1y,
tblC.c2x AS c2x,
tblC.c2y AS c2y,
tblC.c3x AS c3x,
tblC.c3y AS c3y,
tblC.c4x AS c4x,
tblC.c4y AS c4y
FROM tblHasilTes, tblC;




SELECT no,
x as bahasa,
y as logika,
CONCAT('(',c1x,',', c1y,')') AS 'C1',
CONCAT('(',c2x,',', c2y,')') AS 'C2',
CONCAT('(',c3x,',', c3y,')') AS 'C3',
CONCAT('(',c4x,',', c4y,')') AS 'C4'
FROM viewPsikologi;

SELECT no,
x as matematika,
y as logika,
CONCAT('(',c1x,',', c1y,')') AS 'C1',
CONCAT('(',c2x,',', c2y,')') AS 'C2',
CONCAT('(',c3x,',', c3y,')') AS 'C3',
CONCAT('(',c4x,',', c4y,')') AS 'C4'
FROM viewInformatika;


/*
procedure 1 :
iterasi untuk mendapatkan c baru.
kemudian c1234 baru di update ke tblCek;

procedure 2 :
jika c1=c1baru dan c2=c2baru dan c3=c3 baru dan c4=c4baru
maka iterasi berhenti
jika belum sama semua c1x c1y c2x dst maka, c lama di update menjadi c baru,
kemudian memanggil procedure1 dengan c

*/

/*
PROCEDURE untuk mendapatkan cbaru
*/
DELIMITER $$
CREATE PROCEDURE spIterasi(jurusan varchar(20))
BEGIN
  DROP TABLE IF EXISTS tblIterasi;

  IF(jurusan='psikologi') THEN
  DROP VIEW IF EXISTS vwPsikologi;
  CREATE VIEW vwPsikologi AS
  SELECT
    no, x, y, c1x, c1y, c2x, c2y, c3x,c3y,c4x,c4y,
    ROUND(SQRT(POW((x-c1x),2) + POW((y-c1y),2)),2) AS 'Jarak ke C1',
    ROUND(SQRT(POW((x-c2x),2) + POW((y-c2y),2)),2) AS 'Jarak ke C2',
    ROUND(SQRT(POW((x-c3x),2) + POW((y-c3y),2)),2) AS 'Jarak ke C3',
    ROUND(SQRT(POW((x-c4x),2) + POW((y-c4y),2)),2) AS 'Jarak ke C4'
    ,
    IF(SQRT(POW((x-c1x),2) + POW((y-c1y),2)) < SQRT(POW((x-c2x),2) + POW((y-c2y),2))
      AND SQRT(POW((x-c1x),2) + POW((y-c1y),2)) < SQRT(POW((x-c3x),2) + POW((y-c3y),2))
      AND SQRT(POW((x-c1x),2) + POW((y-c1y),2)) < SQRT(POW((x-c4x),2) + POW((y-c4y),2)),
      'C1',
        IF(SQRT(POW((x-c2x),2) + POW((y-c2y),2)) < SQRT(POW((x-c3x),2) + POW((y-c3y),2))
          AND SQRT(POW((x-c2x),2) + POW((y-c2y),2)) < SQRT(POW((x-c4x),2) + POW((y-c4y),2)),
          'C2',
          IF(
            SQRT(POW((x-c3x),2) + POW((y-c3y),2)) < SQRT(POW((x-c4x),2) + POW((y-c4y),2)), 'C3','C4'
          )
        )
  ) AS MASUK_CLUSTER
  FROM viewPsikologi;
  SELECT * FROM vwPsikologi;


  ELSE
  DROP VIEW IF EXISTS vwInformatika;
  CREATE VIEW vwInformatika AS
  SELECT
    no, x, y, c1x, c1y, c2x, c2y, c3x,c3y,c4x,c4y,
    ROUND(SQRT(POW((x-c1x),2) + POW((y-c1y),2)),2) AS 'Jarak ke C1',
    ROUND(SQRT(POW((x-c2x),2) + POW((y-c2y),2)),2) AS 'Jarak ke C2',
    ROUND(SQRT(POW((x-c3x),2) + POW((y-c3y),2)),2) AS 'Jarak ke C3',
    ROUND(SQRT(POW((x-c4x),2) + POW((y-c4y),2)),2) AS 'Jarak ke C4'
    ,
    IF(SQRT(POW((x-c1x),2) + POW((y-c1y),2)) < SQRT(POW((x-c2x),2) + POW((y-c2y),2))
      AND SQRT(POW((x-c1x),2) + POW((y-c1y),2)) < SQRT(POW((x-c3x),2) + POW((y-c3y),2))
      AND SQRT(POW((x-c1x),2) + POW((y-c1y),2)) < SQRT(POW((x-c4x),2) + POW((y-c4y),2)),
      'C1',
        IF(SQRT(POW((x-c2x),2) + POW((y-c2y),2)) < SQRT(POW((x-c3x),2) + POW((y-c3y),2))
          AND SQRT(POW((x-c2x),2) + POW((y-c2y),2)) < SQRT(POW((x-c4x),2) + POW((y-c4y),2)),
          'C2',
          IF(
            SQRT(POW((x-c3x),2) + POW((y-c3y),2)) < SQRT(POW((x-c4x),2) + POW((y-c4y),2)), 'C3','C4'
          )
        )
  ) AS MASUK_CLUSTER
  FROM viewInformatika;
  SELECT * FROM vwInformatika;
  END IF;
END $$
DELIMITER ;

call spIterasi('psikologi');
call spIterasi('Informatika');



/*Procedure untuk otomatis
looping sampai clusterSebelum dan clusterBaru
tblCek sama semua
*/
-- DELIMITER $$
-- CREATE PROCEDURE spRunning()
-- BEGIN
-- DECLARE vNoTest int;
-- DECLARE cTblCek cursor for SELECT
-- END $$
-- DELIMITER ;






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
