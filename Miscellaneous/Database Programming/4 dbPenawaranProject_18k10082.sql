DROP DATABASE IF EXISTS dbPenawaranProject;
CREATE DATABASE dbPenawaranProject;
USE dbPenawaranProject;

--Nomor 1
create table tblbarang
(
    kodebarang INT PRIMARY KEY,
    namabarang VARCHAR(100)
);
create table tblproject
(
    noproject INT PRIMARY KEY,
    namaproject VARCHAR(255),
    kepada VARCHAR(100),
    alamat VARCHAR(255),
    tanggalmulai DATETIME,
    tanggalselesai DATETIME
);
create table tblpenawaranharga
(
    noproject INT,
    kodebarang INT,
    jumlah INT,
    harga DOUBLE,
    kategori VARCHAR(100),
    FOREIGN KEY (kodebarang) REFERENCES tblbarang(kodebarang),
    FOREIGN KEY (noproject) REFERENCES tblproject(noproject)
);

INSERT INTO tblbarang VALUES
(1,"Notebook Acer"),
(2,"Notebook Asus"),
(3,"Notebook HP"),
(4,"Notebook Toshiba"),
(5,"PC Asus"),
(6,"PC HP"),
(7,"PC Acer"),
(8,"PC MSI"),
(9,"Projector Benq"),
(10,"Projector Asus"),
(11,"Printer Canon"),
(12,"Printer HP"),
(13,"Printer Epson"),
(14,"Scanner Canon"),
(15,"Scanner HP");

INSERT INTO tblproject VALUES
(1,"Project IT Paket 1","Perusahaan A","Semarang","2015/11/12","2016/01/21"),
(2,"Project IT Paket 2","Perusahaan B","Salatiga","2015/11/10","2016/02/23"),
(3,"Project IT Paket 2","Perusahaan C","Semarang","2015/11/18","2016/02/26"),
(4,"Project IT Paket 3","Perusahaan D","Pekalongan","2015/12/02","2016/01/29"),
(5,"Project IT Paket 4","Perusahaan E","Semarang","2015/12/09","2016/02/15"),
(6,"Project IT Paket 4","Perusahaan F","Pekalongan","2015/12/07","2016/02/14"),
(7,"Project IT Paket 1","Perusahaan G","Salatiga","2015/11/26","2016/01/16");

INSERT INTO tblpenawaranharga VALUES
(1,3,1,6000000,"Notebook"),
(7,3,7,6000000,"Notebook"),
(1,6,5,4500000,"PC"),
(7,6,2,4500000,"PC"),
(1,12,5,450000,"Printer Scanner"),
(7,12,8,450000,"Printer Scanner"),
(1,15,8,550000,"PC"),
(7,15,3,550000,"PC"),
(2,1,2,5000000,"Notebook"),
(6,1,1,5000000,"Notebook"),
(2,7,1,4000000,"PC"),
(6,7,1,4000000,"PC"),
(3,2,2,5000000,"Notebook"),
(5,2,6,5000000,"Notebook"),
(3,5,4,4000000,"PC"),
(5,5,3,4000000,"PC"),
(3,10,3,6000000,"Projector"),
(5,10,5,6000000,"Projector"),
(4,4,7,6000000,"Notebook"),
(4,8,1,5500000,"PC"),
(4,9,9,400000,"Projector"),
(4,14,6,60000,"Printer Scanner");

--1 dan 2
-- SELECT * from tblbarang;
-- SELECT * from tblproject;
-- SELECT * from tblpenawaranharga;

-- Nomor 3
Create View vwNomor3 AS

Select CONCAT(tblproject.namaproject, " : ", tblproject.kepada) AS "Project_Kepada", sum(tblpenawaranharga.jumlah * tblpenawaranharga.harga) AS "TOTAL_HARGA_PROJECT"
from tblbarang
NATURAL JOIN tblpenawaranharga
NATURAL JOIN tblproject
group by tblproject.kepada
order by tblproject.kepada;

--Nomor4
Create View vwNomor4 AS

SELECT tblbarang.namabarang as "NAMABARANG", sum(tblpenawaranharga.jumlah * tblpenawaranharga.harga) AS "TOTAL"
from tblbarang
NATURAL JOIN (tblpenawaranharga)
group by tblbarang.namabarang
ORDER by sum(tblpenawaranharga.jumlah * tblpenawaranharga.harga) desc;

--Nomor5

Create View vwNomor5 AS

SELECT
 tblProject2.kepada AS PROJECT2 ,
  (SELECT SUM(tblpenawaranharga.harga*tblpenawaranharga.jumlah)
  FROM tblpenawaranharga
 WHERE tblpenawaranharga.noproject=tblProject2.noproject ) AS TOTAL2,
  tblProject1.kepada AS PROJECT1,
  (SELECT SUM(tblpenawaranharga.harga*tblpenawaranharga.jumlah)
 FROM tblpenawaranharga
     WHERE tblpenawaranharga.noproject=tblProject1.noproject ) AS TOTAL1,
    CASE
   WHEN (SELECT SUM(tblpenawaranharga.harga*tblpenawaranharga.jumlah)
          FROM tblpenawaranharga
      WHERE tblpenawaranharga.noproject=tblProject2.noproject )
     >
         (SELECT SUM(tblpenawaranharga.harga*tblpenawaranharga.jumlah)
       FROM tblpenawaranharga
        WHERE tblpenawaranharga.noproject=tblProject1.noproject )
     THEN CONCAT('Project 2 Prioritas, selisih harga ',
      ((SELECT SUM(tblpenawaranharga.harga*tblpenawaranharga.jumlah)
      FROM tblpenawaranharga
    WHERE tblpenawaranharga.noproject=tblProject2.noproject )
      -
    (SELECT SUM(tblpenawaranharga.harga*tblpenawaranharga.jumlah)
      FROM tblpenawaranharga
      WHERE tblpenawaranharga.noproject=tblProject1.noproject ))
        )

  WHEN (SELECT SUM(tblpenawaranharga.harga*tblpenawaranharga.jumlah)
      FROM tblpenawaranharga
    WHERE tblpenawaranharga.noproject=tblProject1.noproject )
   >
    (SELECT SUM(tblpenawaranharga.harga*tblpenawaranharga.jumlah)
FROM tblpenawaranharga
         WHERE tblpenawaranharga.noproject=tblProject2.noproject )
           THEN CONCAT('Project 1 Prioritas, selisih harga ',
         ((SELECT SUM(tblpenawaranharga.harga*tblpenawaranharga.jumlah)
         FROM tblpenawaranharga
           WHERE tblpenawaranharga.noproject=tblProject1.noproject )
     -
     (SELECT SUM(tblpenawaranharga.harga*tblpenawaranharga.jumlah)
          FROM tblpenawaranharga
       WHERE tblpenawaranharga.noproject=tblProject2.noproject ))
        )

          ELSE 'Anda belum membuat'
        END AS KETERANGAN
FROM tblproject AS tblProject1,
     tblproject AS tblProject2
WHERE tblProject2.kepada!=tblProject1.kepada;


--Nomor 6
CREATE VIEW vwNomor6 AS
SELECT
  tblProject3.kepada AS PROJECT3,
  (SELECT SUM(tblpenawaranharga.harga*tblpenawaranharga.jumlah)
    FROM tblpenawaranharga WHERE tblpenawaranharga.noproject=tblProject3.noproject ) AS TOTAL3,
  tblProject2.kepada AS PROJECT2 ,
  (SELECT SUM(tblpenawaranharga.harga*tblpenawaranharga.jumlah)
    FROM tblpenawaranharga WHERE tblpenawaranharga.noproject=tblProject2.noproject ) AS TOTAL2,
  tblProject1.kepada AS PROJECT1,
  (SELECT SUM(tblpenawaranharga.harga*tblpenawaranharga.jumlah)
    FROM tblpenawaranharga WHERE tblpenawaranharga.noproject=tblProject1.noproject ) AS TOTAL1
FROM tblproject AS tblProject1,
     tblproject AS tblProject2,
     tblproject AS tblProject3

WHERE tblProject3.kepada != tblProject2.kepada
AND tblProject3.kepada != tblProject1.kepada
AND tblProject2.kepada != tblProject1.kepada;
