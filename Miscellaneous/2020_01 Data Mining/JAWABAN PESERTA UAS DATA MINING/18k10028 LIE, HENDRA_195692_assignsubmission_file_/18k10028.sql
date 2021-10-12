/*
####################
##                ##
##    18K10028    ##
##    LIE HENDRA  ##
##                ##
####################
*/

DROP DATABASE IF EXISTS uas;
CREATE DATABASE uas;
USE uas;

CREATE TABLE diagnosa(
  p1 VARCHAR(3), -- pasien
  p2 VARCHAR(10), -- demam
  p3 VARCHAR(10), -- sakit kepala
  p4 VARCHAR(10), -- nyeri
  p5 VARCHAR(10), -- lemas
  p6 VARCHAR(10), -- kelelahan
  p7 VARCHAR(10), -- hidung tersumbat
  p8 VARCHAR(10), -- bersin
  p9 VARCHAR(10), -- sakit tenggorokan
  p10 VARCHAR(10), -- sulit bernapas
  diagnosa VARCHAR(10)
);

CREATE TABLE kon(k VARCHAR(10));
INSERT INTO kon VALUES("tidak"),("ringan"),("parah");

CREATE TABLE dia(d VARCHAR(10));
INSERT INTO dia VALUES("DEMAM"),("FLU");

CREATE TABLE r(
  rk VARCHAR(10),
  rr VARCHAR(10)
);

DELIMITER $$
CREATE PROCEDURE pDiag(pasien INT)
BEGIN
  DECLARE i INT DEFAULT 1;
  DECLARE p INT DEFAULT 0;

  SET p = pasien+1;

  WHILE i <> p DO
    SELECT * INTO @r2 FROM kon ORDER BY RAND() LIMIT 1;
    SELECT * INTO @r3 FROM kon ORDER BY RAND() LIMIT 1;
    SELECT * INTO @r4 FROM kon ORDER BY RAND() LIMIT 1;
    SELECT * INTO @r5 FROM kon ORDER BY RAND() LIMIT 1;
    SELECT * INTO @r6 FROM kon ORDER BY RAND() LIMIT 1;
    SELECT * INTO @r7 FROM kon ORDER BY RAND() LIMIT 1;
    SELECT * INTO @r8 FROM kon ORDER BY RAND() LIMIT 1;
    SELECT * INTO @r9 FROM kon ORDER BY RAND() LIMIT 1;
    SELECT * INTO @r10 FROM kon ORDER BY RAND() LIMIT 1;
    SELECT * INTO @d FROM dia ORDER BY RAND() LIMIT 1;

    SET @p1 = CONCAT('P',i);

    INSERT INTO r VALUES
    (@p1,@r2),
    (@p1,@r3),
    (@p1,@r4),
    (@p1,@r5),
    (@p1,@r6),
    (@p1,@r7),
    (@p1,@r8),
    (@p1,@r9),
    (@p1,@r10);

    INSERT INTO diagnosa VALUES
      (@p1,@r2,@r3,@r4,@r5,@r6,@r7,@r8,@r9,@r10,NULL);

    SELECT COUNT(*) INTO @tidak FROM r WHERE rr = "tidak";
    SELECT COUNT(*) INTO @ringan FROM r WHERE rr = "ringan";
    SELECT COUNT(*) INTO @parah FROM r WHERE rr = "parah";

    IF @parah >= 5 OR @ringan >=3 AND @parah >=3 THEN
      UPDATE diagnosa SET diagnosa = 'DEMAM' WHERE diagnosa IS NULL AND p1 = @p1;
    ELSE
      UPDATE diagnosa SET diagnosa = 'FLU' WHERE diagnosa IS NULL AND p1 = @p1;
    END IF;

    SET @tidak = 0;
    SET @ringan = 0;
    SET @parah = 0;

    TRUNCATE TABLE r;
    SET i = i+1;
  END WHILE;

  SELECT * FROM diagnosa;

  TRUNCATE TABLE diagnosa;
END $$
DELIMITER ;

CALL pDiag(17);


--
