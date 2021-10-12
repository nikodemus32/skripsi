/*
  Nikodemus Galh Candra Wicaksono
  Stored Function 2020/05/06
*/

DROP DATABASE IF EXISTS dbSF06Mei;
CREATE DATABASE dbSF06Mei;
USE dbSF06Mei;

CREATE TABLE tblTinggi(
  nama varchar(255),
  tinggi int,
  beratIdeal float
);

/*Nomor 1*/
DELIMITER $$
  CREATE FUNCTION sfWaktu(pDetik int)
  RETURNS varchar(255)
  BEGIN
      DECLARE hasil varchar(255);
      DECLARE hari, jam, menit,detik float;
      DECLARE satuHari, satuJam, satuMenit int;
      SET satuHari = 60*60*24;
      SET satuJam = 60*60;
      SET satuMenit = 60;

      SET hari = floor (pDetik/satuHari);
      SET jam = floor ((pDetik- hari*satuHari)/satujam);
      SET menit = floor(((pDetik- hari*satuHari)-jam*satuJam)/satuMenit);
      set detik = floor(((pDetik- hari*satuHari)-jam*satuJam)-menit*60);
      CASE
        WHEN hari=0 && jam>=1 && menit>=1  && detik>=1 THEN SET hasil=CONCAT(pDetik,' = ',jam, ' jam ', menit, ' menit ', detik, ' detik');
        WHEN hari=0 && jam>=1 && menit>=1  && detik>=0 THEN SET hasil=CONCAT(pDetik,' = ',jam, ' jam ', menit, ' menit ', detik, ' detik');
        WHEN hari=0 && jam>=1 && menit=0  && detik>=1 THEN SET hasil=CONCAT(pDetik,' = ',jam, ' jam ', menit, ' menit ', detik, ' detik');
        WHEN hari=0 && jam>=1 && menit=0  && detik=0 THEN SET hasil=CONCAT(pDetik,' = ',jam, ' jam ', menit, ' menit ', detik, ' detik');

        WHEN hari=0 && jam=0 && menit>=1  && detik>=1  THEN SET hasil=CONCAT(pDetik,' = ',menit, ' menit ', detik, ' detik');
        WHEN hari=0 && jam=0 && menit>=1  && detik=0 THEN SET hasil=CONCAT(pDetik,' = ',menit, ' menit ', detik, ' detik');
        WHEN hari=0 && jam=0 && menit=0  && detik>=1 THEN SET hasil=CONCAT(detik, ' detik');
        WHEN hari=0 && jam=0 && menit=0  && detik=0 THEN SET hasil=CONCAT(detik, ' detik');

        ELSE SET hasil=CONCAT(pDetik,' = ',hari, ' hari ', jam, ' jam ', menit, ' menit ', detik, ' detik');
      END CASE;
      RETURN(hasil);
  END ;
  $$
DELIMITER ;

SELECT sfWaktu(100000) as 'HASIL (nomor 1)';
-- SELECT sfWaktu(3900) as 'HASIL (nomor 1)';
-- SELECT sfWaktu(440) as 'HASIL (nomor 1)';

/*Nomor 2 versi 1 without table*/
DELIMITER $$
  CREATE FUNCTION BeratIdeal(nama varchar(255), tinggiBadan int)
  RETURNS varchar(255)
  BEGIN
    DECLARE beratIdeal float;
    DECLARE hasil varchar(255);
    SET beratIdeal=ROUND((tinggiBadan - 100) - (0.1*(tinggiBadan-100)), 2);

    SET hasil=CONCAT(nama, '     Tinggi=', tinggiBadan, '   Berat Ideal=', beratIdeal );
    RETURN(hasil);
  END ;
  $$
DELIMITER ;
SELECT BeratIdeal('Desy', 157) as 'HASIL (Nomor 2)';
SELECT BeratIdeal('Lili', 162) as 'HASIL (Nomor 2)';
SELECT BeratIdeal('Mikael', 175) as 'HASIL (Nomor 2)';
SELECT BeratIdeal('Benny', 170) as 'HASIL (Nomor 2)';
SELECT BeratIdeal('Nikodemus Galih', 180) as 'HASIL (Nomor 2)';

/*Nomor 2 versi 2 with table*/
DELIMITER $$
CREATE FUNCTION sfBeratIdeal(Nama VARCHAR(100), Tinggi int)
  RETURNS float
  BEGIN
  DECLARE bbIdeal float;
  SET bbIdeal=ROUND((Tinggi - 100) - (0.1*(Tinggi-100)),2);
  INSERT INTO tblTinggi values
  (Nama,Tinggi,bbIdeal);
  RETURN(bbIdeal);
  END ;
  $$
DELIMITER ;

-- SELECT sfBeratIdeal("Desy",157) AS 'Desy';
-- SELECT sfBeratIdeal("Lili",162) AS 'Lili';
-- SELECT sfBeratIdeal("Mikael",175) AS 'Mikael';
-- SELECT sfBeratIdeal("Benny",170) AS 'Benny';
-- SELECT * FROM tblTinggi;



/*nomor 3*/
DELIMITER $$
CREATE FUNCTION sfHuruf(pKata varchar(255))
RETURNS varchar(255)
BEGIN
  DECLARE hasil varchar(255);
  DECLARE temp_kata varchar(1);
  DECLARE vokal, konsonan, lain int DEFAULT 0;
  DECLARE i, panjang int;

  SET panjang=LENGTH(pKata);
  SET i=1;

  WHILE i != panjang+1 DO
    SET temp_kata= SUBSTRING(pKata,i,1);
    CASE
    WHEN UCASE(temp_kata) IN('a','i','u','e','o')
      THEN SET vokal=vokal+1;
    WHEN UCASE(temp_kata) IN ('b','c','d','f','g','h','j','k','l','m','n','p','q','r','s','t','v','w','x','y','z')
      THEN SET konsonan=konsonan+1;
    ELSE SET lain=lain+1;
    END CASE;
    SET i=i+1;
  END WHILE;
  SET hasil=CONCAT(vokal, ' huruf vokal ', konsonan, ' konsonan dan ', lain, ' karakter lain (',pKata,')');
  RETURN(hasil);
END ;
$$
DELIMITER ;
--
SELECT sfHuruf('Fakultas Ilmu Komputer') AS 'HASIL (Nomor 3)';
-- SELECT sfHuruf('Unika Soegijapranata') AS 'HASIL (Nomor 3)';
-- SELECT sfHuruf('Nikodemus Galih Candra Wicaksono') AS 'HASIL (Nomor 3)';
