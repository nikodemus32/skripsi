DROP DATABASE IF EXISTS dbKmeans18k10082;
CREATE DATABASE dbKmeans18k10082;
USE dbKmeans18k10082;

CREATE TABLE tblData(
  kode int,
  jenis varchar(50),
  nama varchar(200),
  harga int,
  qty double
);

INSERT INTO tblData values
(1,'Permen', 'Kiss', 46, 24),
(1,'Permen', 'Kopiko', 25, 35),
(1,'Permen', 'Frozz', 10, 45),
(1,'Permen', 'Hexos', 43, 19),
(1,'Permen', 'Relaxa', 49, 21),

(2,'Minuman', 'Frezta Lemon', 45, 25),
(2,'Minuman', 'Mizone', 39, 21),
(2,'Minuman', 'Teh Sostro', 41, 34),
(2,'Minuman', 'Pulpy Orange', 62, 15),
(2,'Minuman', 'Aqua Botol', 15, 37),

(3,'Snack', 'Chitato', 85, 24),
(3,'Snack', 'Potato', 92, 21),
(3,'Snack', 'Taro', 42, 45),
(3,'Snack', 'Kacang Garuda', 73, 19),
(3,'Snack', 'Lays BBQ', 47, 35),

(4,'Biskuit', 'Gerry Cocho', 37, 23),
(4,'Biskuit', 'Good Time', 65, 10),
(4,'Biskuit', 'Roma', 51, 13),
(4,'Biskuit', 'Tango', 46, 25),
(4,'Biskuit', 'Nissin', 57, 8);

SELECT * FROM tblData;

CREATE TABLE tblC(
  kode int,
  c1x double,
  c1y double,
  c2x double,
  c2y double
);

INSERT INTO tblC values
(1, 30, 40, 45, 23),
(2, 32, 35, 55, 20),
(3, 46, 42, 80, 20),
(4, 46, 24, 60, 11);

SELECT kode,
if(kode=1, 'Permen', if(kode=2,'Minuman',if(kode=3,'Snack','Biskuit'))) as jenis,
CONCAT('(', c1x, ',' , c1y, ')') as C1,
CONCAT('(', c2x, ',' , c2y, ')') as C2
FROM tblC;

DELIMITER $$
CREATE PROCEDURE spIterasi1(kodeKe int)
BEGIN
DROP TABLE IF EXISTS tblIterasi1;
CREATE TABLE tblIterasi1 AS

SELECT
  tblData.kode as KODE,
  tblData.nama AS DATA,
  tblData.harga AS X,
  tblData.qty AS Y,
  tblC.c1x as c1x,
  tblC.c1y as c1y,
  tblC.c2x as c2x,
  tblC.c2y as c2y,
  SQRT(POW((tblData.harga - tblC.c1x),2) + POW((tblData.qty - tblC.c1y),2)) AS 'Jarak dengan C1',
  SQRT(POW((tblData.harga - tblC.c2x),2) + POW((tblData.qty - tblC.c2y),2)) AS 'Jarak dengan C2',
  /*if(kondisi, benar, salah)*/
  IF(SQRT(POW((tblData.harga - tblC.c1x),2) + POW((tblData.qty - tblC.c1y),2))
        > SQRT(POW((tblData.harga - tblC.c2x),2) + POW((tblData.qty - tblC.c2y),2))
        , 'C2', 'C1') AS MASUK_CLUSTER
from tblData
NATURAL JOIN tblC
where tblData.kode=kodeKe;
-- and tblC.kode=kodeKe; /*tidak perlu karena sudah di natural join, otomatis tbl C mengikuti where*/

SELECT DISTINCT(MASUK_CLUSTER) as CBaru,
ROUND(AVG(X),2) as CxBaru, ROUND(AVG(Y),2) as CyBaru

from tblIterasi1
group by MASUK_CLUSTER
order by MASUK_CLUSTER;

END $$
DELIMITER ;


call spIterasi1(1);
-- SELECT * FROM tblIterasi1;

call spIterasi1(2);
-- SELECT * FROM tblIterasi1;

call spIterasi1(3);
-- SELECT * FROM tblIterasi1;

call spIterasi1(4);
-- SELECT * FROM tblIterasi1;
