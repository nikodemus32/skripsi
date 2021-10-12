DROP DATABASE IF EXISTS dbApriori;
CREATE DATABASE dbApriori;
USE dbApriori;

CREATE TABLE tblTransaksi
(
  notransaksi varchar(4) PRIMARY KEY
);

INSERT INTO tblTransaksi values
('T100'),
('T200'),
('T300'),
('T400'),
('T500'),
('T600'),
('T700'),
('T800'),
('T900');

SELECT * FROM tblTransaksi;

CREATE TABLE tblItem(
  noitem varchar (2) Primary KEY,
  keterangan varchar(10)
);

INSERT INTO tblItem values
('I1', 'Item1'),
('I2', 'Item2'),
('I3', 'Item3'),
('I4', 'Item4'),
('I5', 'Item5');

SELECT * FROM tblItem;

CREATE TABLE tblDetilTransaksi(
  notransaksi varchar(4),
  noitem varchar(2),
  foreign key(notransaksi) references tblTransaksi(notransaksi),
  foreign KEY(noitem) references tblItem(noitem)
);

INSERT INTO tblDetilTransaksi values
('T100', 'I1'), ('T100', 'I2'), ('T100', 'I5'),
('T200', 'I2'), ('T200', 'I4'),
('T300', 'I2'), ('T300', 'I3'),
('T400', 'I1'), ('T400', 'I2'), ('T400', 'I4'),
('T500', 'I1'), ('T500', 'I3'),
('T600', 'I2'), ('T600', 'I3'),
('T700', 'I1'), ('T700', 'I3'),
('T800', 'I1'), ('T800', 'I2'), ('T800', 'I3'), ('T800', 'I5'),
('T900', 'I1'), ('T900', 'I2'), ('T900', 'I3');

SELECT * FROM tblDetilTransaksi;

/*Langkah pertama : menghitung item dan frekuensinya nya
menggunakan sub query
dengan minimum support count =2,
where(setelah from tblItem) sudah proses prune*/
Select noitem as ITEM,
  (SELECT count(*)
   from tblDetilTransaksi
   where noitem=tblItem.noitem
  ) AS FREKUENSI_SC
from tblItem
where (SELECT count(*)
 from tblDetilTransaksi
 where noitem=tblItem.noitem
)>=2 ;

/*langkah 2 : join 2 item
dengan minimum support count =2,
where(setelah AND) adalah proses prune*/
select concat(C1.noitem,',',C2.noitem) as ITEM,
  (
    select count(*)
    FROM tblDetilTransaksi as tblC
    INNER JOIN tblDetilTransaksi as tblD ON (tblC.notransaksi = tblD.notransaksi)
    WHERE tblC.noitem = C1.noitem AND tblD.noitem = C2.noitem
  ) AS FREKUENSI_SC
from tblItem as C1, tblItem as C2
where C2.noitem > C1.noitem AND/*supaya tidak double contoh: I1 I3 dan I3 I1*/
(
  select count(*)
  FROM tblDetilTransaksi as tblC
  INNER JOIN tblDetilTransaksi as tblD ON (tblC.notransaksi = tblD.notransaksi)
  WHERE tblC.noitem = C1.noitem AND tblD.noitem = C2.noitem
) >=2
;

/*langkah 3 : join 3 item*/
select concat(C1.noitem,',',C2.noitem,',',C3.noitem) as ITEM,
(
  select count(*)
  FROM tblDetilTransaksi as tblC
  INNER JOIN tblDetilTransaksi as tblD ON (tblC.notransaksi = tblD.notransaksi)
  INNER JOIN tblDetilTransaksi as tblE ON (tblC.notransaksi = tblE.notransaksi)
  WHERE tblC.noitem = C1.noitem AND tblD.noitem = C2.noitem AND tblE.noitem=C3.noitem
) AS FREKUENSI_SC
from tblItem as C1, tblItem as C2, tblItem as C3
where C2.noitem > C1.noitem
AND C3.noitem > C2.noitem AND /*supaya tidak double contoh: I1 I2 I3 dan I3 I2 I1*/
(
  select count(*)
  FROM tblDetilTransaksi as tblC
  INNER JOIN tblDetilTransaksi as tblD ON (tblC.notransaksi = tblD.notransaksi)
  INNER JOIN tblDetilTransaksi as tblE ON (tblC.notransaksi = tblE.notransaksi)
  WHERE tblC.noitem = C1.noitem AND tblD.noitem = C2.noitem AND tblE.noitem=C3.noitem
) >=2
;
