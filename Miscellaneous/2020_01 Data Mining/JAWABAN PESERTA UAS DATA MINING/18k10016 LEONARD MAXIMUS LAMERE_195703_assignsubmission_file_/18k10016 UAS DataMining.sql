DROP DATABASE IF EXISTS db18k10016;
CREATE DATABASE db18k10016;
USE db18k10016;

CREATE TABLE tblData
(
  nopasien VARCHAR(3),
  demam VARCHAR(10),
  sakitkepala VARCHAR(10),
  nyeri VARCHAR(10),
  lemas VARCHAR(10),
  kelelahan VARCHAR(10),
  hidungtersumbat VARCHAR(10),
  bersin VARCHAR(10),
  sakittenggorokan VARCHAR(10),
  sulitbernafas VARCHAR(10),
  diagnosa VARCHAR(10)
);

INSERT INTO tblData VALUES
("P1","Tidak","Ringan","Tidak","Tidak","Tidak","Ringan","Parah","Parah","Ringan","Demam"),
("P2","Parah","Parah","Parah","Parah","Parah","Tidak","Tidak","Parah","Parah","Flu"),
("P3","Parah","Parah","Ringan","Parah","Parah","Parah","Tidak","Parah","Parah","Flu"),
("P4","Tidak","Tidak","Tidak","Ringan","Tidak","Parah","Tidak","Ringan","Ringan","Demam"),
("P5","Parah","Parah","Ringan","Parah","Parah","Parah","Tidak","Parah","Parah","Flu"),
("P6","Tidak","Tidak","Tidak","Ringan","Tidak","Parah","Parah","Parah","Tidak","Demam"),
("P7","Parah","Parah","Parah","Parah","Parah","Tidak","Tidak","Tidak","Parah","Flu"),
("P8","Tidak","Tidak","Tidak","Tidak","Tidak","Parah","Parah","Tidak","Ringan","Demam"),
("P9","Tidak","Ringan","Ringan","Tidak","Tidak","Parah","Parah","Parah","Parah","Demam"),
("P10","Parah","Parah","Parah","Ringan","Ringan","Tidak","Parah","Tidak","Parah","Flu"),
("P11","Tidak","Tidak","Tidak","Ringan","Tidak","Parah","Ringan","Parah","Tidak","Demam"),
("P12","Parah","Ringan","Parah","Ringan","Parah","Tidak","Parah","Tidak","Ringan","Flu"),
("P13","Tidak","Tidak","Ringan","Ringan","Tidak","Parah","Parah","Parah","Tidak","Demam"),
("P14","Parah","Parah","Parah","Parah","Ringan","Tidak","Parah","Parah","Parah","Flu"),
("P15","Ringan","Tidak","Tidak","Ringan","Tidak","Parah","Tidak","Parah","Ringan","Demam"),
("P16","Tidak","Tidak","Tidak","Tidak","Tidak","Parah","Parah","Parah","Parah","Demam"),
("P17","Parah","Ringan","Parah","Ringan","Ringan","Tidak","Tidak","Tidak","Parah","Flu");


CREATE TABLE tblHitung
(
  langkah INT DEFAULT 0,
  atribut VARCHAR(20),
  informasi VARCHAR(20),
  jumlahdata INT,
  demam INT,
  flu INT,
  entropy DECIMAL(8,4),
  gain DECIMAL(8,4) DEFAULT 0
);

delimiter $$
CREATE PROCEDURE spHitung()
BEGIN
  DECLARE jumData INT;
  DECLARE vDemam INT;
  DECLARE vFlu INT;
  DECLARE vLangkah INT DEFAULT 0;
  DECLARE vEntropy DECIMAL(8,4);
  DECLARE vStop INT DEFAULT 0;

  SELECT COUNT(*) INTO jumData
  FROM tblData;

  SELECT COUNT(*) INTO vDemam
  FROM tblData WHERE diagnosa = "Demam";

  SELECT COUNT(*) INTO vFlu
  FROM tblData WHERE diagnosa = "Flu";

  SELECT (-(vDemam/jumData)*log2(vDemam/jumData))
  +(-(vFlu/jumData)*log2(vFlu/jumData)) INTO vEntropy;

  INSERT INTO tblHitung(atribut,jumlahdata,demam,flu,entropy) VALUES
  ("TOTAL DATA",jumData, vDemam, vFlu, vEntropy);

  WHILE vStop <> 1 do

    IF vLangkah = 0 THEN
    INSERT INTO tblHitung(informasi,jumlahdata,demam,flu)
    SELECT A.demam AS DEMAM, COUNT(*) AS JUMLAH_DATA,
      (
        SELECT COUNT(*)
        FROM tblData AS B
        WHERE B.diagnosa = "Demam" AND B.demam = A.demam
      ) AS "DEMAM",
      (
        SELECT COUNT(*)
        FROM tblData AS C
        WHERE C.diagnosa = "Flu" AND C.demam = A.demam
      ) AS "FLU"
      FROM tblData AS A
      GROUP BY A.demam;
      UPDATE tblHitung SET atribut = "demam" WHERE atribut IS NULL;

    INSERT INTO tblHitung(informasi,jumlahdata,demam,flu)
    SELECT A.sakitkepala AS SAKIT_KEPALA, COUNT(*) AS JUMLAH_DATA,
      (
        SELECT COUNT(*)
        FROM tblData AS B
        WHERE B.diagnosa = "Demam" AND B.sakitkepala = A.sakitkepala
      ) AS "DEMAM",
      (
        SELECT COUNT(*)
        FROM tblData AS C
        WHERE C.diagnosa = "Flu" AND C.sakitkepala = A.sakitkepala
      ) AS "FLU"
      FROM tblData AS A
      GROUP BY A.sakitkepala;
      UPDATE tblHitung SET atribut = "sakitkepala" WHERE atribut IS NULL;

      INSERT INTO tblHitung(informasi,jumlahdata,demam,flu)
      SELECT A.nyeri AS NYERI, COUNT(*) AS JUMLAH_DATA,
        (
          SELECT COUNT(*)
          FROM tblData AS B
          WHERE B.diagnosa = "Demam" AND B.nyeri = A.nyeri
        ) AS "DEMAM",
        (
          SELECT COUNT(*)
          FROM tblData AS C
          WHERE C.diagnosa = "Flu" AND C.nyeri = A.nyeri
        ) AS "FLU"
      FROM tblData AS A
      GROUP BY A.nyeri;
      UPDATE tblHitung SET atribut = "nyeri" WHERE atribut IS NULL;

      INSERT INTO tblHitung(informasi,jumlahdata,demam,flu)
      SELECT A.lemas AS LEMAS, COUNT(*) AS JUMLAH_DATA,
        (
          SELECT COUNT(*)
          FROM tblData AS B
          WHERE B.diagnosa = "Demam" AND B.lemas = A.lemas
        ) AS "DEMAM",
        (
          SELECT COUNT(*)
          FROM tblData AS C
          WHERE C.diagnosa = "Flu" AND C.lemas = A.lemas
        ) AS "FLU"
      FROM tblData AS A
      GROUP BY A.lemas;
      UPDATE tblHitung SET atribut = "lemas" WHERE atribut IS NULL;

      INSERT INTO tblHitung(informasi,jumlahdata,demam,flu)
      SELECT A.kelelahan AS KELELAHAN, COUNT(*) AS JUMLAH_DATA,
        (
          SELECT COUNT(*)
          FROM tblData AS B
          WHERE B.diagnosa = "Demam" AND B.kelelahan = A.kelelahan
        ) AS "DEMAM",
        (
          SELECT COUNT(*)
          FROM tblData AS C
          WHERE C.diagnosa = "Flu" AND C.kelelahan = A.kelelahan
        ) AS "FLU"
      FROM tblData AS A
      GROUP BY A.kelelahan;
      UPDATE tblHitung SET atribut = "kelelahan" WHERE atribut IS NULL;

      INSERT INTO tblHitung(informasi,jumlahdata,demam,flu)
      SELECT A.hidungtersumbat AS HIDUNG_TERSUMBAT, COUNT(*) AS JUMLAH_DATA,
        (
          SELECT COUNT(*)
          FROM tblData AS B
          WHERE B.diagnosa = "Demam" AND B.hidungtersumbat = A.hidungtersumbat
        ) AS "DEMAM",
        (
          SELECT COUNT(*)
          FROM tblData AS C
          WHERE C.diagnosa = "Flu" AND C.hidungtersumbat = A.hidungtersumbat
        ) AS "FLU"
      FROM tblData AS A
      GROUP BY A.hidungtersumbat;
      UPDATE tblHitung SET atribut = "hidungtersumbat" WHERE atribut IS NULL;

      INSERT INTO tblHitung(informasi,jumlahdata,demam,flu)
      SELECT A.bersin AS BERSIN, COUNT(*) AS JUMLAH_DATA,
        (
          SELECT COUNT(*)
          FROM tblData AS B
          WHERE B.diagnosa = "Demam" AND B.bersin = A.bersin
        ) AS "DEMAM",
        (
          SELECT COUNT(*)
          FROM tblData AS C
          WHERE C.diagnosa = "Flu" AND C.bersin = A.bersin
        ) AS "FLU"
      FROM tblData AS A
      GROUP BY A.bersin;
      UPDATE tblHitung SET atribut = "bersin" WHERE atribut IS NULL;

      INSERT INTO tblHitung(informasi,jumlahdata,demam,flu)
      SELECT A.sakittenggorokan AS SAKIT_TENGGOROKAN, COUNT(*) AS JUMLAH_DATA,
        (
          SELECT COUNT(*)
          FROM tblData AS B
          WHERE B.diagnosa = "Demam" AND B.sakittenggorokan = A.sakittenggorokan
        ) AS "DEMAM",
        (
          SELECT COUNT(*)
          FROM tblData AS C
          WHERE C.diagnosa = "Flu" AND C.sakittenggorokan = A.sakittenggorokan
        ) AS "FLU"
      FROM tblData AS A
      GROUP BY A.sakittenggorokan;
      UPDATE tblHitung SET atribut = "sakittenggorokan" WHERE atribut IS NULL;

      INSERT INTO tblHitung(informasi,jumlahdata,demam,flu)
      SELECT A.sulitbernafas AS SULIT_BERNAFAS, COUNT(*) AS JUMLAH_DATA,
        (
          SELECT COUNT(*)
          FROM tblData AS B
          WHERE B.diagnosa = "Demam" AND B.sulitbernafas = A.sulitbernafas
        ) AS "DEMAM",
        (
          SELECT COUNT(*)
          FROM tblData AS C
          WHERE C.diagnosa = "Flu" AND C.sulitbernafas = A.sulitbernafas
        ) AS "FLU"
      FROM tblData AS A
      GROUP BY A.sulitbernafas;
      UPDATE tblHitung SET atribut = "sulitbernafas" WHERE atribut IS NULL;

      UPDATE tblHitung SET entropy = (-(demam/jumlahdata)*log2(demam/jumlahdata))
      +(-(flu/jumlahdata)*log2(flu/jumlahdata));
      UPDATE tblHitung SET entropy = 0 WHERE entropy IS NULL;

      CREATE TEMPORARY TABLE tblTampung
      (
        atribut VARCHAR(20),
        gain DECIMAL(8,4)
      );

      INSERT INTO tblTampung(atribut, gain)
      SELECT atribut, vEntropy - SUM((jumlahdata/jumData) * entropy) AS GAIN
      FROM tblHitung
      GROUP BY atribut;

      UPDATE tblHitung SET gain =
        (
          SELECT gain
          FROM tblTampung
          WHERE tblTampung.atribut = tblHitung.atribut AND tblHitung.langkah = 0
        );
      UPDATE tblHitung SET langkah = 1 WHERE langkah = 0;

    ELSEIF vLangkah > 0 THEN
      SELECT tblHitung.jumlahdata INTO jumData
      FROM tblHitung,tblTampung
      WHERE (demam <> 0 OR flu <> 0) AND langkah = 1
      GROUP BY tblHitung.gain
      HAVING  MAX(tblTampung.gain)=tblHitung.gain;

      SELECT tblHitung.demam INTO vDemam
      FROM tblHitung,tblTampung
      WHERE (demam <> 0 OR flu <> 0) AND langkah = 1
      GROUP BY tblHitung.gain
      HAVING  MAX(tblTampung.gain)=tblHitung.gain;

      SELECT tblHitung.flu INTO vFlu
      FROM tblHitung,tblTampung
      WHERE (demam <> 0 OR flu <> 0) AND langkah = 1
      GROUP BY tblHitung.gain
      HAVING  MAX(tblTampung.gain)=tblHitung.gain;

      SELECT tblHitung.entropy INTO vEntropy
      FROM tblHitung,tblTampung
      WHERE (demam <> 0 OR flu <> 0) AND langkah = 1
      GROUP BY tblHitung.gain
      HAVING  MAX(tblTampung.gain)=tblHitung.gain;
    END IF;

    SET vLangkah = vLangkah + 1;
    SET vStop = 1;

  END WHILE;

  SELECT * FROM tblHitung;

END $$
delimiter ;

call spHitung();
