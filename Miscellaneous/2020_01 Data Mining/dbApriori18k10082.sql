DROP DATABASE IF EXISTS dbApriori_18k10082;
CREATE DATABASE dbApriori_18k10082;
USE dbApriori_18k10082;

CREATE TABLE tblTransaksi(
  kodeTransaksi varchar(3) PRIMARY KEY
);
INSERT INTO tblTransaksi VALUES
('T01'),('T02'),('T03'),('T04'),('T05'),('T06'),('T07'),('T08'),('T09'),('T10');
-- SELECT * FROM tblTransaksi;

CREATE TABLE tblItem(
    kodeItem varchar(3) PRIMARY KEY,
    namaItem varchar(25)
);
INSERT INTO tblItem VALUES
('I1', 'Plums'),('I2', 'Lettuce'),('I3', 'Tomatoes'),
('I4', 'Celery'),('I5', 'Confectionery'),('I6', 'Apples'),
('I7', 'Carrots'),('I8', 'Potatoes'),('I9', 'Oranges'),
('I10', 'Peaces'),('I11', 'Beans'),('I12', 'Bananas'),
('I13', 'Onions');
-- SELECT * FROM tblItem;

CREATE TABLE tblDetailTransaksi(
  kodeTransaksi varchar(3),
  kodeItem varchar(3),
  FOREIGN KEY(kodeTransaksi) REFERENCES tblTransaksi(kodeTransaksi),
  FOREIGN KEY(kodeItem) REFERENCES tblItem(kodeItem)
);

INSERT INTO tblDetailTransaksi VALUES
('T01', 'I1'), ('T01', 'I2'), ('T01', 'I3'),
('T02', 'I4'), ('T02', 'I5'),
('T03', 'I5'),
('T04', 'I6'), ('T04', 'I7'), ('T04', 'I3'), ('T04', 'I8'), ('T04', 'I5'),
('T05', 'I6'), ('T05', 'I9'), ('T05', 'I2'), ('T05', 'I3'), ('T05', 'I5'),
('T06', 'I10'), ('T06', 'I9'), ('T06', 'I4'), ('T06', 'I8'),
('T07', 'I11'), ('T07', 'I2'), ('T07', 'I3'),
('T08', 'I9'), ('T08', 'I2'), ('T08', 'I7'), ('T08', 'I3'), ('T08', 'I5'),
('T09', 'I6'), ('T09', 'I12'), ('T09', 'I1'), ('T09', 'I7'), ('T09', 'I3'), ('T09', 'I13'), ('T09', 'I5'),
('T10', 'I6'), ('T10', 'I8');

CREATE TABLE tes(
  kode varchar(3),
  total int
);

INSERT INTO tes values
('I6', 4),
('I9', 3),
('I2', 4),
('I3', 6),
('I5', 6);
-- SELECT tblItem.namaItem, tblDetailTransaksi.kodeTransaksi, tblDetailTransaksi.kodeItem, count(tblDetailTransaksi.kodeItem) as total
-- FROM tblDetailTransaksi
-- NATURAL JOIN tblItem
-- GROUP BY tblDetailTransaksi.kodeItem;

SELECT * FROM tes ORDER BY total DESC;
-- SELECT * FROM tblDetailTransaksi;
--
-- /*START cara pak marlon*/
--
-- /*Langkah pertama : JOIN 1 item*/
-- SELECT namaItem as ITEM,
--   (SELECT count(*)
--   FROM tblDetailTransaksi
--   WHERE kodeItem=tblItem.kodeItem
--   ) AS FREKUENSI_SC
-- FROM tblItem
-- WHERE (SELECT count(*)
--   FROM tblDetailTransaksi
--   WHERE kodeItem=tblItem.kodeItem
-- ) >= 2;
--
-- /*Langkah 2 : JOIN 2 item*/
-- SELECT concat(K1.namaItem,',',K2.namaItem) as ITEM,
-- (
--   SELECT count(*)
--   FROM tblDetailTransaksi as tblA
--   INNER JOIN tblDetailTransaksi as tblB ON(tblA.kodeTransaksi = tblB.kodeTransaksi)
--   WHERE tblA.kodeItem = K1.kodeItem AND tblB.kodeItem=K2.kodeItem
-- ) AS FREKUENSI_SC2
-- FROM tblItem as K1, tblItem as K2
-- WHERE K2.kodeItem > K1.kodeItem AND
-- (
--   SELECT count(*)
--   FROM tblDetailTransaksi as tblA
--   INNER JOIN tblDetailTransaksi as tblB ON(tblA.kodeTransaksi = tblB.kodeTransaksi)
--   WHERE tblA.kodeItem = K1.kodeItem AND tblB.kodeItem=K2.kodeItem
-- ) >=2;
--
-- /*Langkah 3 : JOIN 3 item*/
-- SELECT concat(K1.namaItem,',',K2.namaItem,',',K3.namaItem) as ITEM,
-- (
--   SELECT count(*)
--   FROM tblDetailTransaksi as tblA
--   INNER JOIN tblDetailTransaksi as tblB ON(tblA.kodeTransaksi = tblB.kodeTransaksi)
--   INNER JOIN tblDetailTransaksi as tblC ON(tblA.kodeTransaksi = tblC.kodeTransaksi)
--   WHERE tblA.kodeItem = K1.kodeItem AND tblB.kodeItem=K2.kodeItem AND tblC.kodeItem=K3.kodeItem
-- ) AS FREKUENSI_SC3
-- FROM tblItem as K1, tblItem as K2, tblItem as K3
-- WHERE K2.kodeItem > K1.kodeItem AND
-- K3.kodeItem > K2.kodeItem AND
-- (
--   SELECT count(*)
--   FROM tblDetailTransaksi as tblA
--   INNER JOIN tblDetailTransaksi as tblB ON(tblA.kodeTransaksi = tblB.kodeTransaksi)
--   INNER JOIN tblDetailTransaksi as tblC ON(tblA.kodeTransaksi = tblC.kodeTransaksi)
--   WHERE tblA.kodeItem = K1.kodeItem AND tblB.kodeItem=K2.kodeItem AND tblC.kodeItem=K3.kodeItem
-- ) >=2;
--
-- /*Langkah 4 : JOIN 4 item*/
-- SELECT concat(K1.namaItem,',',K2.namaItem,',',K3.namaItem,',',K4.namaItem) as ITEM,
-- (
--   SELECT count(*)
--   FROM tblDetailTransaksi as tblA
--   INNER JOIN tblDetailTransaksi as tblB ON(tblA.kodeTransaksi = tblB.kodeTransaksi)
--   INNER JOIN tblDetailTransaksi as tblC ON(tblA.kodeTransaksi = tblC.kodeTransaksi)
--   INNER JOIN tblDetailTransaksi as tblD On(tblA.kodeTransaksi = tblD.kodeTransaksi)
--   WHERE tblA.kodeItem = K1.kodeItem AND tblB.kodeItem=K2.kodeItem
--         AND tblC.kodeItem=K3.kodeItem AND tblD.kodeItem=K4.kodeItem
-- ) AS FREKUENSI_SC4
-- FROM tblItem as K1, tblItem as K2, tblItem as K3, tblItem as K4
-- WHERE K2.kodeItem > K1.kodeItem AND
-- K3.kodeItem > K2.kodeItem AND
-- K4.kodeItem > K3.kodeItem AND
-- (
--   SELECT count(*)
--   FROM tblDetailTransaksi as tblA
--   INNER JOIN tblDetailTransaksi as tblB ON(tblA.kodeTransaksi = tblB.kodeTransaksi)
--   INNER JOIN tblDetailTransaksi as tblC ON(tblA.kodeTransaksi = tblC.kodeTransaksi)
--   INNER JOIN tblDetailTransaksi as tblD ON(tblA.kodeTransaksi = tblD.kodeTransaksi)
--   WHERE tblA.kodeItem = K1.kodeItem AND tblB.kodeItem=K2.kodeItem
--         AND tblC.kodeItem=K3.kodeItem AND tblD.kodeItem=K4.kodeItem
-- ) >=2;


/*Langkah 5 : JOIN 5 item (tidak karena tidak ada >2)*/
-- SELECT concat(K1.namaItem,',',K2.namaItem,',',K3.namaItem,',',K4.namaItem,',',K5.namaItem) as ITEM,
-- (
--   SELECT count(*)
--   FROM tblDetailTransaksi as tblA
--   INNER JOIN tblDetailTransaksi as tblB ON(tblA.kodeTransaksi = tblB.kodeTransaksi)
--   INNER JOIN tblDetailTransaksi as tblC ON(tblA.kodeTransaksi = tblC.kodeTransaksi)
--   INNER JOIN tblDetailTransaksi as tblD ON(tblA.kodeTransaksi = tblD.kodeTransaksi)
--   INNER JOIN tblDetailTransaksi as tblE ON(tblA.kodeTransaksi = tblE.kodeTransaksi)
--   WHERE tblA.kodeItem = K1.kodeItem AND tblB.kodeItem=K2.kodeItem
--         AND tblC.kodeItem=K3.kodeItem AND tblD.kodeItem=K4.kodeItem
--         AND tblE.kodeItem=K5.kodeItem
-- ) AS FREKUENSI_SC5
-- FROM tblItem as K1, tblItem as K2, tblItem as K3, tblItem as K4, tblItem as K5
-- WHERE K2.kodeItem > K1.kodeItem AND
-- K3.kodeItem > K2.kodeItem AND
-- K4.kodeItem > K3.kodeItem AND
-- K5.kodeItem > K4.kodeItem AND
-- (
--   SELECT count(*)
--   FROM tblDetailTransaksi as tblA
--   INNER JOIN tblDetailTransaksi as tblB ON(tblA.kodeTransaksi = tblB.kodeTransaksi)
--   INNER JOIN tblDetailTransaksi as tblC ON(tblA.kodeTransaksi = tblC.kodeTransaksi)
--   INNER JOIN tblDetailTransaksi as tblD On(tblA.kodeTransaksi = tblD.kodeTransaksi)
--   INNER JOIN tblDetailTransaksi as tblE On(tblA.kodeTransaksi = tblE.kodeTransaksi)
--   WHERE tblA.kodeItem = K1.kodeItem AND tblB.kodeItem=K2.kodeItem
--         AND tblC.kodeItem=K3.kodeItem AND tblD.kodeItem=K4.kodeItem
--         AND tblE.kodeItem=K5.kodeItem
-- ) >=2;

-- /*END cara pak marlon*/











/*Coba VIEW*/
-- CREATE VIEW vwFrekuensi AS
-- SELECT concat(K1.namaItem,',',K2.namaItem,',',K3.namaItem,',',K4.namaItem) as ITEM,
-- (
--   SELECT count(*)
--   FROM tblDetailTransaksi as tblA
--   INNER JOIN tblDetailTransaksi as tblB ON(tblA.kodeTransaksi = tblB.kodeTransaksi)
--   INNER JOIN tblDetailTransaksi as tblC ON(tblA.kodeTransaksi = tblC.kodeTransaksi)
--   INNER JOIN tblDetailTransaksi as tblD On(tblA.kodeTransaksi = tblD.kodeTransaksi)
--   WHERE tblA.kodeItem = K1.kodeItem AND tblB.kodeItem=K2.kodeItem
--         AND tblC.kodeItem=K3.kodeItem AND tblD.kodeItem=K4.kodeItem
-- ) AS FREKUENSI_SC4
-- FROM tblItem as K1, tblItem as K2, tblItem as K3, tblItem as K4
-- WHERE K2.kodeItem > K1.kodeItem AND
-- K3.kodeItem > K2.kodeItem AND
-- K4.kodeItem > K3.kodeItem AND
-- (
--   SELECT count(*)
--   FROM tblDetailTransaksi as tblA
--   INNER JOIN tblDetailTransaksi as tblB ON(tblA.kodeTransaksi = tblB.kodeTransaksi)
--   INNER JOIN tblDetailTransaksi as tblC ON(tblA.kodeTransaksi = tblC.kodeTransaksi)
--   INNER JOIN tblDetailTransaksi as tblD ON(tblA.kodeTransaksi = tblD.kodeTransaksi)
--   WHERE tblA.kodeItem = K1.kodeItem AND tblB.kodeItem=K2.kodeItem
--         AND tblC.kodeItem=K3.kodeItem AND tblD.kodeItem=K4.kodeItem
-- ) >=2;

/*Coba SUM Frekuensi untuk otomatis iterasi jika >2*/
-- SELECT SUM(vwFrekuensi.FREKUENSI_SC4) AS FREKUENSI_SC4
-- FROM vwFrekuensi;
-- SELECT * FROM vwFrekuensi;

-- CREATE VIEW vwFrekuensi2 AS
--
-- ;

-- SELECT * FROM vwFrekuensi2
-- --
-- SELECT concat(ITEMtemp,',', namaItem)
--
-- FROM tblItem, vwFrekuensi
-- ;







-- DROP TABLE IF EXISTS tblFrekuensi;
-- CREATE TABLE tblFrekuensi(
--   iterasi int,
--   namaItemF varchar(255),
--   frekuensi int
-- );
--
--
-- DELIMITER $$
-- CREATE PROCEDURE spIterasi()
-- BEGIN
-- DECLARE iSp, sumFrekuensi,i1, iterasi, frekuensi int DEFAULT 0;
-- DECLARE kodeTransaksiSp, kodeTransaksiDSp,
--         kodeItemSp, kodeItemDSp varchar(3) DEFAULT "";
-- DECLARE namaItemSp varchar(25) DEFAULT "";
--
-- SET iterasi=iterasi+1;
--
-- SELECT count(*) INTO countTblItem FROM tblItem;
-- SELECT count(*) INTO countTblTransaksi FROM tblTransaksi;
-- SELECT count(*) INTO countTblDetailTransaksi FROM tblDetailTransaksil;
-- open cIterasi;
--   WHILE i1 <> countTblDetailTransaksi DO
--     fetch cIterasi INTO kodeTransaksiDSp, kodeItemDSp;
--
--
--     SET i1=i1+1;
--   END WHILE;
-- close cIterasi;
-- INSERT
-- END
-- $$
-- DELIMITER ;


/*Konsep awal jika selama SUM frekuensi > minimum support (2)
maka while berjalan(while untuk iterasi otomatis).

*/
