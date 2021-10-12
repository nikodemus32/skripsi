DROP DATABASE IF EXISTS dbKNN;
CREATE DATABASE dbKNN;
USE dbKNN;

CREATE TABLE tblData(
  barang varchar(15),
  produksi decimal(8,2),
  ketahanan decimal(8,2),
  kualitas varchar(5)
);


/*START UNTUK CARA 2*/
CREATE TABLE tblHitung(
  barang varchar(15),
  produksi decimal(8,2),
  ketahanan decimal(8,2),
  kualitas varchar(5),
  jarak decimal(8,2),
  rekomendasi varchar(1)
);

/*Trigger untuk insert automatis ke tblHitung*/
DELIMITER $$
CREATE TRIGGER tbAutoInsert
AFTER INSERT ON tblData
FOR EACH ROW
BEGIN
  INSERT INTO tblHitung(barang, produksi, ketahanan, kualitas)
  VALUES(NEW.barang, NEW.produksi, NEW.ketahanan, NEW.kualitas);
END
$$
DELIMITER ;
/*END UNTUK CARA 2*/

-- DELIMITER $$
-- CREATE PROCEDURE spInsertData(
--       vBarang varchar(15),
--       vProduksi decimal(8,2),
--       vKetahanan decimal(8,2),
--       vKualitas varchar(5))
-- BEGIN
--   INSERT INTO tblData values(vBarang, vProduksi, vKetahanan, vKualitas);
-- END $$
-- DELIMITER ;

-- CALL spInsertData('A',7,6,'BURUK');
-- CALL spInsertData('B',6,6,'BURUK');
-- CALL spInsertData('C',6,5,'BURUK');
-- CALL spInsertData('D',1,3,'BAIK');
-- CALL spInsertData('E',2,4,'BAIK');
-- CALL spInsertData('F',2,2,'BAIK');

-- SELECT * FROM tblData;

DELIMITER $$
CREATE PROCEDURE spRandomData(vBerapa int)
BEGIN
  DECLARE i int default 0;

  WHILE i <> vBerapa DO
    INSERT INTO tblData values (i, rand()*10, rand()*10, CEILING(rand()*10));
  SET i = i+1;
  END WHILE;

  UPDATE tblData set kualitas = 'BAIK' where kualitas mod 2=0;
  UPDATE tblData set kualitas = 'BURUK' where kualitas mod 2<>0;
END $$
DELIMITER ;


CALL spRandomData(100000);

-- SELECT * FROM tblData;
/*Cara 1*/
DELIMITER $$
CREATE FUNCTION sfDistance(x1 decimal(8,2), y1 decimal(8,2),
                          x2 decimal(8,2), y2 decimal(8,2))
RETURNS decimal(8,2)
BEGIN
  DECLARE vJarak decimal(8,2);
  set vJarak = sqrt(pow((x1-x2),2)+pow((y1-y2),2));
  RETURN(vJarak);
END ;
$$
DELIMITER ;

SELECT barang, produksi as X, ketahanan as Y,
  concat('(',produksi,',',ketahanan,')') as TITIK1,
  '(3,5)' as TITIK2,
  sfDistance(produksi,ketahanan,3,5) as Jarak,
  kualitas as Hasil
from tblData
ORDER BY sfDistance(produksi, ketahanan,3,5) ASC;

/*cara kedua, menggunakan programming

*/

DELIMITER $$
  CREATE PROCEDURE spHitungJarak(vX decimal(8,2), vY decimal(8,2), vK int)
BEGIN
  DECLARE i, vJumData int default 0;
  DECLARE x1, y1, vJarak decimal(8,2);
  DECLARE vBarang varchar(15);
  DECLARE cHitung cursor for select barang, produksi, ketahanan from tblHitung;

  SELECT count(*) into vJumData from tblHitung;
  open cHitung;
    WHILE i <> vJumData DO
    fetch cHitung into vBarang,x1,y1;
      set vJarak=sfDistance(x1,y1,vX,vY);
      UPDATE tblHitung set jarak=vJarak where barang =vBarang;
    SET i=i+1;
    END WHILE;
  close cHitung;

  SELECT hasil.kualitas, count(*) as jumlah
  FROM (
    SELECT * FROM tblHitung ORDER BY jarak LIMIT vK) as hasil
  GROUP BY hasil.kualitas;
END $$
DELIMITER ;

call spHitungJarak(3,5,4);
