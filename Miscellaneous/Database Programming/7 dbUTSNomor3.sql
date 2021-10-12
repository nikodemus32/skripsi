DROP DATABASE IF EXISTS dbVokal;
CREATE DATABASE dbVokal;
USE dbVokal;

CREATE TABLE tblData
(
no INT PRIMARY KEY AUTO_INCREMENT,
kalimat VARCHAR(255) NOT NULL
) ENGINE = InnoDB;

DELIMITER $$
CREATE PROCEDURE spGantiHuruf(pKalimat VARCHAR(255))
BEGIN
    DECLARE vPanjang INT;
    DECLARE i INT;
    DECLARE vAmbil VARCHAR(1);
    DECLARE vHasil VARCHAR(255) DEFAULT '';

    SELECT LENGTH(pKalimat) INTO vPanjang;
    SET i=1;

    WHILE i<=vPanjang DO
        SET vAmbil = MID(pKalimat, i, 1);
        IF UCASE(vAmbil) IN('A', 'I', 'U', 'E', 'O') THEN
            SET vHasil = CONCAT(vHasil, '#');
        ELSE
            SET vHasil = CONCAT(vHasil, vAmbil);
        END IF;

        SET i=i+1;
    END WHILE;

    INSERT INTO tblData VALUES(null, vHasil);

    SELECT * FROM tblData;
END;
$$
DELIMITER ;

CALL spGantiHuruf('UNIKA SOEGIJAPRANATA');
CALL spGantiHuruf('FAKULTAS ILMU KOMPUTER');
CALL spGantiHuruf('TEKNIK INFORMATIKA');
CALL spGantiHuruf('DATABASE PROGRAMMING');
CALL spGantiHuruf('fakultas ilmu komputer unika soegijapranata semarang');
