DROP DATABASE IF EXISTS db18k10082_c45;
CREATE DATABASE db18k10082_c45;
USE db18k10082_c45;

CREATE TABLE tblC45(
  nourut int primary key,
  outlook varchar(10),
  temperature varchar(10),
  humadity varchar(10),
  windy varchar(10),
  play varchar(10)
);

load data local infile "dbC45.csv"
into table tblC45
fields terminated by ";"
enclosed by ''''
ignore 1 lines;

SELECT * FROM tblC45;

CREATE TABLE tblHitung(
  atribut varchar(20),
  informasi varchar(20),
  jumlahdata int,
  playno int,
  playyes int,
  entropy DECIMAL(8,4),
  gain DECIMAL(8,4)
);

DESC tblHitung;

SELECT @jumlahdata := COUNT(*) FROM tblC45;

SELECT @playno := COUNT(*) FROM tblC45 WHERE play='no';

SELECT @playyes := COUNT(*) FROM tblC45 WHERE play='yes';

SELECT (-(@playno/@jumlahdata) * log2(@playno/@jumlahdata)) + (-(@playyes/@jumlahdata) * log2(@playyes/@jumlahdata)) INTO @entropy;

SELECT @jumlahdata AS JUM_DATA, @playno JAWAB_NO, @playyes JAWAB_YES, ROUND(@entropy, 4) AS ENTROPY;

INSERT INTO tblHitung(atribut, jumlahdata, playno, playyes, entropy) VALUES
('Total Data', @jumlahdata, @playno, @playyes, @entropy);

-- SELECT * FROM tblHitung;

/*Langkah 3*/
/*OUTLOOK*/
INSERT INTO tblHitung(informasi, jumlahdata, playno, playyes)
SELECT  A.outlook, COUNT(*) AS JUMLAH_DATA,
        (SELECT COUNT(*) FROM tblC45 as B WHERE B.play='no' AND B.outlook=A.outlook) AS NO,
        (SELECT COUNT(*) FROM tblC45 as B WHERE B.play='yes' AND B.outlook=A.outlook) AS YES
from tblC45 as A
GROUP BY outlook;

UPDATE tblHitung set atribut='OUTLOOK' where atribut IS NULL;

/*TEMPERATURE*/
INSERT INTO tblHitung(informasi, jumlahdata, playno, playyes)
SELECT  A.temperature, COUNT(*) AS JUMLAH_DATA,
        (SELECT COUNT(*) FROM tblC45 as B WHERE B.play='no' AND B.temperature=A.temperature) AS NO,
        (SELECT COUNT(*) FROM tblC45 as B WHERE B.play='yes' AND B.temperature=A.temperature) AS YES
from tblC45 as A
GROUP BY temperature;

UPDATE tblHitung set atribut='temperature' where atribut IS NULL;

/*HUMADITY*/
INSERT INTO tblHitung(informasi, jumlahdata, playno, playyes)
SELECT  A.humadity, COUNT(*) AS JUMLAH_DATA,
        (SELECT COUNT(*) FROM tblC45 as B WHERE B.play='no' AND B.humadity=A.humadity) AS NO,
        (SELECT COUNT(*) FROM tblC45 as B WHERE B.play='yes' AND B.humadity=A.humadity) AS YES
from tblC45 as A
GROUP BY humadity;

UPDATE tblHitung set atribut='humadity' where atribut IS NULL;

/*WINDY*/
INSERT INTO tblHitung(informasi, jumlahdata, playno, playyes)
SELECT  A.windy, COUNT(*) AS JUMLAH_DATA,
        (SELECT COUNT(*) FROM tblC45 as B WHERE B.play='no' AND B.windy=A.windy) AS NO,
        (SELECT COUNT(*) FROM tblC45 as B WHERE B.play='yes' AND B.windy=A.windy) AS YES
from tblC45 as A
GROUP BY windy;

UPDATE tblHitung set atribut='windy' where atribut IS NULL;

/*LANGKAH 4 menghitung entropy*/
UPDATE tblHitung SET entropy=(-(playno/jumlahdata) * log2(playno/jumlahdata)) + (-(playyes/jumlahdata) * log2(playyes/jumlahdata))
    WHERE entropy is null AND (playyes !=0 or playno!=0);
UPDATE tblHitung SET entropy=0 WHERE entropy is null;

/*LANGKAH 5 menghitung nilai gain*/
DROP TABLE IF EXISTS tblTampung;
CREATE TEMPORARY TABLE tblTampung(
  atribut varchar(20),
  gain decimal(8,4)
);
INSERT INTO tblTampung(atribut, gain)
SELECT atribut, @entropy-SUM((jumlahdata/@jumlahdata) * entropy) AS GAIN
FROM tblHitung
GROUP BY atribut;

SELECT * FROM tblTampung;

UPDATE tblHitung SET GAIN=
(
  SELECT GAIN
  FROM tblTampung
  WHERE atribut=tblHitung.atribut
);
SELECT * FROM tblHitung;
