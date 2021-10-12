DROP DATABASE IF EXISTS dbSp2_18k10082;
CREATE DATABASE dbSp2_18k10082;
USE dbSp2_18k10082;

CREATE TABLE tblDesimal(
  desimal int
);

CREATE TABLE tblAstrologi(
  nama varchar(25),
  tglLahir datetime,
  astrologi varchar(30),
  umur int,
  hariLahir varchar(15)
);

/*PROCEDURE NOMOR 1*/
DELIMITER $$
  CREATE PROCEDURE spNomor1()
  BEGIN
    DECLARE des INT;
    DECLARE i INT;

    SET i=1;
    SET des=1;

  /*Looping menggunakan LOOP dari 1-25*/
    loop1sampai25 : LOOP
    IF i > 25 THEN
        LEAVE loop1sampai25;
      END IF;

      INSERT INTO tblDesimal values
        (des);
      SET i=i+1;
      SET des=des+1;
    END LOOP;

  /*Looping menggunakan REPEAT dari 26-50*/
    REPEAT
    INSERT INTO tblDesimal values
      (des);
      SET i=i+1;
      SET des=des+1;
      until i>50
    END REPEAT;

  /*Looping menggunakan WHILE*/
    WHILE i != 76 DO
      INSERT INTO tblDesimal(desimal) values (des);
      SET i=i+1;
      SET des=i;
    END WHILE;

    SELECT desimal AS DESIMAL, BIN(desimal) AS BINER,  oct(desimal) AS OKTAL, HEX(desimal) AS HEXADESIMAL FROM tblDesimal;

  END $$
DELIMITER ;


/*PROCEDURE NOMOR 2*/
DELIMITER $$
CREATE PROCEDURE spNomor2(spNama varchar(255), spTglLahir datetime)
BEGIN
DECLARE spAstrologi varchar(30);
DECLARE spUmur int;
DECLARE spHariLahir varchar(15);

SET spHariLahir=DAYNAME(spTglLahir);
/*mencari umur*/
CASE
  WHEN MONTH(now())>MONTH(spTglLahir) THEN SET spUmur=(YEAR(now())-YEAR(spTglLahir));
  WHEN MONTH(now())<MONTH(spTglLahir) THEN SET spUmur=YEAR(now())-YEAR(spTglLahir)-1;
  WHEN MONTH(now())=MONTH(spTglLahir) && DAY(now())>=DAY(spTglLahir) THEN SET spUmur=YEAR(now())-YEAR(spTglLahir);
  ELSE SET spUmur=(YEAR(now())-YEAR(spTglLahir))-1;
END CASE;

/*mencari hari(Indonesia)*/
CASE
  WHEN spHariLahir='Sunday' THEN SET spHariLahir='Minggu';
  WHEN spHariLahir='Monday' THEN SET spHariLahir='Senin';
  WHEN spHariLahir='Tuesday' THEN SET spHariLahir='Selasa';
  WHEN spHariLahir='Wednesday' THEN SET spHariLahir='Rabu';
  WHEN spHariLahir='Thursday' THEN SET spHariLahir='Kamis';
  WHEN spHariLahir='Friday' THEN SET spHariLahir='Jumat';
  WHEN spHariLahir='Saturday' THEN SET spHariLahir='Sabtu';
  ELSE SET spHariLahir=spHariLahir;
END CASE;

/*mencari astrologi*/
CASE
  WHEN MONTH(spTglLahir)=3 && DAY(spTglLahir)>=21 THEN SET spAstrologi='Aries';
  WHEN MONTH(spTglLahir)=4 && DAY(spTglLahir)<=18 THEN SET spAstrologi='Aries';
  WHEN MONTH(spTglLahir)=4 && DAY(spTglLahir)>=19 THEN SET spAstrologi='Taurus';
  WHEN MONTH(spTglLahir)=5 && DAY(spTglLahir)<=19 THEN SET spAstrologi='Taurus';
  WHEN MONTH(spTglLahir)=5 && DAY(spTglLahir)>=20 THEN SET spAstrologi='Gemini';
  WHEN MONTH(spTglLahir)=6 && DAY(spTglLahir)<=20 THEN SET spAstrologi='Gemini';
  WHEN MONTH(spTglLahir)=6 && DAY(spTglLahir)>=21 THEN SET spAstrologi='Cancer';
  WHEN MONTH(spTglLahir)=7 && DAY(spTglLahir)<=21 THEN SET spAstrologi='Cancer';
  WHEN MONTH(spTglLahir)=7 && DAY(spTglLahir)>=22 THEN SET spAstrologi='Leo';
  WHEN MONTH(spTglLahir)=8 && DAY(spTglLahir)<=21 THEN SET spAstrologi='Leo';
  WHEN MONTH(spTglLahir)=8 && DAY(spTglLahir)>=22 THEN SET spAstrologi='Virgo';
  WHEN MONTH(spTglLahir)=9 && DAY(spTglLahir)<=21 THEN SET spAstrologi='Virgo';
  WHEN MONTH(spTglLahir)=9 && DAY(spTglLahir)>=22 THEN SET spAstrologi='Libra';
  WHEN MONTH(spTglLahir)=10 && DAY(spTglLahir)<=22 THEN SET spAstrologi='Libra';
  WHEN MONTH(spTglLahir)=10 && DAY(spTglLahir)>=23 THEN SET spAstrologi='Scorpio';
  WHEN MONTH(spTglLahir)=11 && DAY(spTglLahir)<=21 THEN SET spAstrologi='Scorpio';
  WHEN MONTH(spTglLahir)=11 && DAY(spTglLahir)>=22 THEN SET spAstrologi='Sagitarius';
  WHEN MONTH(spTglLahir)=12 && DAY(spTglLahir)<=20 THEN SET spAstrologi='Sagitarius';
  WHEN MONTH(spTglLahir)=12 && DAY(spTglLahir)>=21 THEN SET spAstrologi='Capicorn';
  WHEN MONTH(spTglLahir)=1 && DAY(spTglLahir)<=19 THEN SET spAstrologi='Capicorn';
  WHEN MONTH(spTglLahir)=1 && DAY(spTglLahir)>=20 THEN SET spAstrologi='Aquarius';
  WHEN MONTH(spTglLahir)=2 && DAY(spTglLahir)<=17 THEN SET spAstrologi='Aquarius';
  WHEN MONTH(spTglLahir)=2 && DAY(spTglLahir)>=18 THEN SET spAstrologi='Pisces';
  WHEN MONTH(spTglLahir)=3 && DAY(spTglLahir)<=20 THEN SET spAstrologi='Pisces';
  ELSE SET spAstrologi='Astrologi tidak didapatkan';
END CASE;
INSERT INTO tblAstrologi(nama, tglLahir, astrologi, hariLahir, umur)
values (spNama, spTglLahir,spAstrologi,spHariLahir, spUmur);

SELECT nama AS NAMA,
        tglLahir AS TANGGALLAHIR,
        astrologi AS ASTROLOGI,
        CONCAT(umur," tahun") AS UMUR,
        CONCAT("Hari ",harilahir) AS HARILAHIR
FROM tblAstrologi;
END
$$
DELIMITER ;
