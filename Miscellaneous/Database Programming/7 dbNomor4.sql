DROP DATABASE IF EXISTS dbNomor4_18k10082;
CREATE DATABASE dbNomor4_18k10082;
USE dbNomor4_18k10082;

Create Table tblNomor4
  (
  no int primary key auto_increment,
  kalimat varchar(255) not null
  ) engine = InnoDB;

DELIMITER $$
  CREATE PROCEDURE spGantiHurufS
  (pKalimat varchar(255), pGanti varchar(1), pSimbol varchar(1))
  BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE vPanjang INT;
    DECLARE vAmbil VARCHAR(1);
    DECLARE vHasil VARCHAR(255) DEFAULT '';

    SELECT LENGTH(pKalimat) INTO vPanjang;

    WHILE i<=vPanjang DO
      SET vAmbil = MID(pKalimat, i, 1);
      IF UCASE(vAmbil) = UCASE(pGanti) THEN SET vHasil = CONCAT(vHasil, pSimbol);
        ELSE SET vHasil = CONCAT(vHasil, vAmbil);
      END IF;

      SET i=i+1;

    END WHILE;

    INSERT INTO tblNomor4 VALUES(null, vHasil);
    SELECT * FROM tblNomor4;


    END; $$
DELIMITER ;

call spGantiHurufS('SAYA SUKA SAMA SITU SEBAB SITU SUKA SENYUM SENYUM SENDIRI SAMA SAPI SAYA', 'S', '#');
call spGantiHurufS('SAYA SUKA SAMA SITU SEBAB SITU SUKA SENYUM SENYUM SENDIRI SAMA SAPI SAYA', 'S', '*');
call spGantiHurufS('SAYA SUKA SAMA SITU SEBAB SITU SUKA SENYUM SENYUM SENDIRI SAMA SAPI SAYA', 'A', '4');
