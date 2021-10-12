DROP DATABASE IF EXISTS dbSF;
CREATE DATABASE dbSF;
USE dbSF;

DELIMITER $$
CREATE FUNCTION sfInterval(pAwal int, pAkhir int, pInterval int)
RETURNS VARCHAR(255)
BEGIN
DECLARE hasil varchar(255);
SET hasil='';

WHILE pAwal<=pAkhir DO
  SET hasil=CONCAT(hasil, ' ',pAwal);
  SET pAwal=pAwal+pInterval;
END WHILE;

RETURN(hasil);
END ;
$$
DELIMITER ;
-- SELECT sfInterval(1, 40, 5) as Hasil;



DELIMITER $$
CREATE FUNCTION sfKarakter(pKode varchar(255))
RETURNS varchar(255)
BEGIN
  DECLARE hasil varchar(255);
  DECLARE panjangpKode int;
  DECLARE i int;
  DECLARE ascii varchar(2);
  DECLARE convertAscii varchar(1);

  SET hasil='';
  SET panjangpKode=LENGTH(pkode);
  SET i=1;

  WHILE i<panjangpKode DO
    SET ascii= MID(pKode,i,2);
    SET convertAscii= CHAR(ascii);
    SET hasil= CONCAT(hasil,convertAscii);
    SET i=i+3;
  END WHILE;
  RETURN(hasil);

END;
$$
DELIMITER ;
-- SELECT sfKarakter('72 69 76 76 79') as hasil;

DELIMITER $$
CREATE FUNCTION sfUlang(pKata varchar(20), pUlang int)
RETURNS varchar(255)
BEGIN
  DECLARE hasil varchar(255);
  DECLARE i int default 0;
  SET hasil=pKata;

  WHILE i<pUlang-1 DO
    SET hasil=CONCAT(hasil,'!',pKata);
    SET i=i+1;
  END WHILE;
  RETURN(hasil);
END;
$$
DELIMITER ;
-- SELECT sfUlang('ikom', 5) as Hasil;
-- select sfUlang('unika', 9) as Hasil;



DELIMITER $$
CREATE FUNCTION sfGanti(pKata varchar(100), pCari varchar(10), pGanti varchar(10))
RETURNS varchar(255)
BEGIN
  DECLARE panjangKata int;
  DECLARE panjangCari int;
  DECLARE hasil varchar(255);
  DECLARE i int;
  DECLARE vAmbil varchar(255);

  SET panjangKata=LENGTH(pKata);
  SET panjangCari=LENGTH(pCari);
  SET hasil='';
  SET i=1;

  WHILE i<=panjangKata+1 DO
      SET vAmbil=MID(pKata, i, panjangCari);

      CASE
        WHEN pCari=vAmbil THEN SET hasil=CONCAT(hasil,pGanti);
        WHEN pCari!=vAmbil THEN SET hasil=CONCAT(hasil,MID(vAmbil,1,(panjangCari/2)));
      END CASE;

      CASE
        WHEN pCari=vAmbil THEN SET i=i+panjangCari;
        WHEN pCari!=vAmbil THEN SET i=i+1;
      END CASE;
  END WHILE;
  RETURN(hasil);
END ;

$$
DELIMITER ;
-- select sfGanti('unika soegijapranata', 'a', '!!') as Ganti;
-- select sfGanti('bunga di bumi & buah di bulan', 'bu', '<!>') as Ganti;
