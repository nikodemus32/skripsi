-- drop database if exists dbnomor2;
-- create database dbnomor2;
-- use dbnomor2;
--
--
-- DELIMITER ##
-- CREATE PROCEDURE spNomor3(pKalimat varchar(255))
-- BEGIN
--   DECLARE panjang INT;
--   DECLARE i int default 1;
--   DECLARE karakter varchar(1);
--   SET panjang = LENGTH(pKalimat);
--
--   CREATE TABLE tblHuruf(
--     huruf varchar(5),
--     jumlah INT
--   );
--
--   while i < panjang DO
--     SET karakter=SUBSTRING(pKalimat,i,1);
--     INSERT INTO tblHuruf(huruf, jumlah) values (karakter, 1);
--     SET i=i+1;
--   END WHILE;
--
--   SELECT huruf AS huruf, SUM(jumlah) AS jumlah
--   FROM tblHuruf
--   GROUP BY huruf
--   ORDER BY huruf;
-- END ##
--
-- DELIMITER ;

DROP DATABASE IF EXISTS dbJawaban;
CREATE DATABASE dbJawaban;
USE dbJawaban;

CREATE TABLE tblHuruf
(
huruf VARCHAR(1),
jumlah INT
);

DELIMITER ##
CREATE PROCEDURE spNomor3(pKalimat VARCHAR(255))
BEGIN
    DECLARE i INT DEFAULT 65;
    DECLARE vPanjang INT;
    DECLARE vAmbil VARCHAR(1);

    -- DELETE FROM tblHuruf;
    WHILE i <= 65+28 DO
        INSERT INTO tblHuruf VALUES
        (CHAR(i), 0);
        SET i = i + 1;
    END WHILE;

    SELECT LENGTH(pKalimat) INTO vPanjang;
    SET i = 1;
    WHILE i<=vPanjang DO
        SELECT mid(pKalimat, i, 1) INTO vAmbil;
        UPDATE tblHuruf SET jumlah = jumlah + 1
        WHERE huruf = vAmbil;

         SET i = i+1;
     END WHILE;

    DELETE FROM tblHuruf WHERE jumlah = 0;
    SELECT * FROM tblHuruf;
END
##
DELIMITER ;

call spNomor3('sAYA sUKA SAMA SITU SEBAB SITU SUKA SENYUM SENYUM SENDIRI SAMA [SAPI SAYA]');
