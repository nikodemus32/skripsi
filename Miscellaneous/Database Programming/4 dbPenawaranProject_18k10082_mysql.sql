-- NO 1 START
DROP DATABASE IF EXISTS dbPenawaranProject;
CREATE DATABASE dbPenawaranProject;
USE dbPenawaranProject;

CREATE TABLE tblBarang(
  kodebarang int PRIMARY KEY,
  namabarang varchar(100)
);
CREATE TABLE tblProject(
  noproject int PRIMARY KEY,
  namaproject varchar(255),
  kepada varchar(100),
  alamat varchar(255),
  tanggalmulai datetime,
  tanggalselesai datetime
);
CREATE TABLE tblPenawaranHarga(
  noproject int,
  kodebarang INT,
  jumlah int,
  harga double,
  kategori varchar(100),
  FOREIGN KEY (noproject) REFERENCES tblProject(noproject),
  FOREIGN KEY (kodebarang) REFERENCES tblBarang(kodebarang)
);
 -- NO 1 END

 -- NO 2 START
INSERT INTO tblBarang VALUES
 (1, "Notebook Acer"),
 (2, "Notebook Asus"),
 (3, "Notebook HP"),
 (4, "Notebook Toshiba"),
 (5, "PC Asus"),
 (6, "PC HP"),
 (7, "PC Acer"),
 (8, "PC MSI"),
 (9, "Projector Benq"),
 (10, "Projector Asus"),
 (11, "Printer Canon"),
 (12, "Printer HP"),
 (13, "Printer Epson"),
 (14, "Scanner Canon"),
 (15, "Scanner HP");
INSERT INTO tblProject VALUES
 (1, "Project IT Paket 1", "Perusahaan A", "Semarang", "2015-11-12", "2016-01-21"),
 (2, "Project IT Paket 2", "Perusahaan B", "Salatiga", "2015-11-10", "2016-02-23"),
 (3, "Project IT Paket 2", "Perusahaan C", "Semarang", "2015-11-18", "2016-02-26"),
 (4, "Project IT Paket 3", "Perusahaan D", "Pekalongan", "2015-12-02", "2016-01-29"),
 (5, "Project IT Paket 4", "Perusahaan E", "Semarang", "2015-12-09", "2016-02-15"),
 (6, "Project IT Paket 4", "Perusahaan F", "Pekalongan", "2015-12-07", "2016-02-14"),
 (7, "Project IT Paket 1", "Perusahaan G", "Salatiga", "2015-11-26", "2016-01-16");
INSERT INTO tblPenawaranHarga VALUES
 (1, 3, 1, 6000000, "NOTEBOOK"),
 (7, 3, 7, 6000000, "NOTEBOOK"),
 (1, 6, 5, 4500000, "PC"),
 (7, 6, 2, 4500000, "PC"),
 (1, 12, 5, 450000, "PRINTER SCANNER"),
 (7, 12, 8, 450000, "PRINTER SCANNER"),
 (1, 15, 8, 550000, "PC"),
 (7, 15, 3, 550000, "PC"),
 (2, 1, 2, 5000000, "NOTEBOOK"),
 (6, 1, 1, 5000000, "NOTEBOOK"),
 (2, 7, 1, 4000000, "PC"),
 (6, 7, 1, 4000000, "PC"),
 (3, 2, 2, 5000000, "NOTEBOOK"),
 (5, 2, 6, 5000000, "NOTEBOOK"),
 (3, 5, 4, 4000000, "PC"),
 (5, 5, 3, 4000000, "PC"),
 (3, 10, 3, 6000000,"PROJECTOR"),
 (5, 10, 5, 6000000,"PROJECTOR"),
 (4, 4, 7, 6000000, "NOTEBOOK"),
 (4, 8, 1, 5500000, "PC"),
 (4, 9, 9, 400000, "PROJECTOR"),
 (4, 14, 6, 60000, "PRINTER SCANNER");

SELECT * FROM tblBarang;
SELECT * FROM tblProject;
SELECT * FROM tblPenawaranHarga;
-- NO 2 END

-- NO 3 START
CREATE VIEW vwNomor3 AS
  SELECT  CONCAT(tblProject.namaproject," : ", tblProject.kepada) AS PROJECT_KEPADA,
          SUM(tblPenawaranHarga.jumlah*tblPenawaranHarga.harga) AS TOTAL_HARGA_PROJECT
  FROM tblProject
  NATURAL JOIN tblPenawaranHarga
  GROUP BY tblProject.kepada, tblProject.namaproject;
-- NO 3 END

-- NO 4 START
CREATE VIEW vwNomor4 AS
  SELECT  tblBarang.namabarang,
          SUM(tblPenawaranHarga.jumlah*tblPenawaranHarga.harga) AS TOTAL
  FROM tblBarang
  NATURAL JOIN tblPenawaranHarga
  GROUP BY tblBarang.namabarang
  ORDER BY TOTAL desc;
-- NO 4 END

-- NO 5 START
CREATE VIEW vwNomor5a AS
SELECT
      tblProject2.kepada AS PROJECT2,

      CASE
        WHEN tblProject2.kepada="Perusahaan A" THEN
          (SELECT SUM(tblPenawaranHarga.jumlah*tblPenawaranHarga.harga)
          FROM tblProject
          NATURAL JOIN tblPenawaranHarga
          GROUP BY tblProject.kepada
          HAVING tblProject.kepada="Perusahaan A")
        WHEN tblProject2.kepada="Perusahaan B" THEN
          (SELECT SUM(tblPenawaranHarga.jumlah*tblPenawaranHarga.harga)
          FROM tblProject
          NATURAL JOIN tblPenawaranHarga
          GROUP BY tblProject.kepada
          HAVING tblProject.kepada="Perusahaan B")
        WHEN tblProject2.kepada="Perusahaan C" THEN
          (SELECT SUM(tblPenawaranHarga.jumlah*tblPenawaranHarga.harga)
          FROM tblProject
          NATURAL JOIN tblPenawaranHarga
          GROUP BY tblProject.kepada
          HAVING tblProject.kepada="Perusahaan C")
        WHEN tblProject2.kepada="Perusahaan D" THEN
          (SELECT SUM(tblPenawaranHarga.jumlah*tblPenawaranHarga.harga)
          FROM tblProject
          NATURAL JOIN tblPenawaranHarga
          GROUP BY tblProject.kepada
          HAVING tblProject.kepada="Perusahaan D")
        WHEN tblProject2.kepada="Perusahaan E" THEN
          (SELECT SUM(tblPenawaranHarga.jumlah*tblPenawaranHarga.harga)
          FROM tblProject
          NATURAL JOIN tblPenawaranHarga
          GROUP BY tblProject.kepada
          HAVING tblProject.kepada="Perusahaan E")
        WHEN tblProject2.kepada="Perusahaan F" THEN
          (SELECT SUM(tblPenawaranHarga.jumlah*tblPenawaranHarga.harga)
          FROM tblProject
          NATURAL JOIN tblPenawaranHarga
          GROUP BY tblProject.kepada
          HAVING tblProject.kepada="Perusahaan F")
        WHEN tblProject2.kepada="Perusahaan G" THEN
          (SELECT SUM(tblPenawaranHarga.jumlah*tblPenawaranHarga.harga)
          FROM tblProject
          NATURAL JOIN tblPenawaranHarga
          GROUP BY tblProject.kepada
          HAVING tblProject.kepada="Perusahaan G")
      END AS TOTAL2,

      tblProject1.kepada AS PROJECT1,

        CASE
          WHEN tblProject1.kepada="Perusahaan A" THEN
            (SELECT SUM(tblPenawaranHarga.jumlah*tblPenawaranHarga.harga)
            FROM tblProject
            NATURAL JOIN tblPenawaranHarga
            GROUP BY tblProject.kepada
            HAVING tblProject.kepada="Perusahaan A")
          WHEN tblProject1.kepada="Perusahaan B" THEN
            (SELECT SUM(tblPenawaranHarga.jumlah*tblPenawaranHarga.harga)
            FROM tblProject
            NATURAL JOIN tblPenawaranHarga
            GROUP BY tblProject.kepada
            HAVING tblProject.kepada="Perusahaan B")
          WHEN tblProject1.kepada="Perusahaan C" THEN
            (SELECT SUM(tblPenawaranHarga.jumlah*tblPenawaranHarga.harga)
            FROM tblProject
            NATURAL JOIN tblPenawaranHarga
            GROUP BY tblProject.kepada
            HAVING tblProject.kepada="Perusahaan C")
          WHEN tblProject1.kepada="Perusahaan D" THEN
            (SELECT SUM(tblPenawaranHarga.jumlah*tblPenawaranHarga.harga)
            FROM tblProject
            NATURAL JOIN tblPenawaranHarga
            GROUP BY tblProject.kepada
            HAVING tblProject.kepada="Perusahaan D")
          WHEN tblProject1.kepada="Perusahaan E" THEN
            (SELECT SUM(tblPenawaranHarga.jumlah*tblPenawaranHarga.harga)
            FROM tblProject
            NATURAL JOIN tblPenawaranHarga
            GROUP BY tblProject.kepada
            HAVING tblProject.kepada="Perusahaan E")
          WHEN tblProject1.kepada="Perusahaan F" THEN
            (SELECT SUM(tblPenawaranHarga.jumlah*tblPenawaranHarga.harga)
            FROM tblProject
            NATURAL JOIN tblPenawaranHarga
            GROUP BY tblProject.kepada
            HAVING tblProject.kepada="Perusahaan F")
          WHEN tblProject1.kepada="Perusahaan G" THEN
            (SELECT SUM(tblPenawaranHarga.jumlah*tblPenawaranHarga.harga)
            FROM tblProject
            NATURAL JOIN tblPenawaranHarga
            GROUP BY tblProject.kepada
            HAVING tblProject.kepada="Perusahaan G")
        END AS TOTAL1
  FROM  tblProject AS tblProject1,
        tblProject AS tblProject2
  WHERE tblProject2.kepada != tblProject1.kepada
  GROUP BY tblProject2.kepada, tblProject1.kepada;

CREATE VIEW vwNomor5 AS
  SELECT  vwNomor5a.PROJECT2,
        vwNomor5a.TOTAL2,
        vwNomor5a.PROJECT1,
        vwNomor5a.TOTAL1,
        CASE
          WHEN vwNomor5a.TOTAL2>vwNomor5a.TOTAL1
          THEN CONCAT("Project 2 Prioritas, selisih harga ", vwNomor5a.TOTAL2-vwNomor5a.TOTAL1)
          WHEN vwNomor5a.TOTAL2<vwNomor5a.TOTAL1
          THEN CONCAT("Project 1 Prioritas, selisih harga ", vwNomor5a.TOTAL1-vwNomor5a.TOTAL2)
        END AS KETERANGAN
  FROM vwNomor5a;
-- NO 5 END

-- NO 6 START
CREATE VIEW vwNomor6 AS
  SELECT
        tblProject3.kepada AS PROJECT3,

        CASE
          WHEN tblProject3.kepada="Perusahaan A" THEN
            (SELECT SUM(tblPenawaranHarga.jumlah*tblPenawaranHarga.harga)
            FROM tblProject
            NATURAL JOIN tblPenawaranHarga
            GROUP BY tblProject.kepada
            HAVING tblProject.kepada="Perusahaan A")
          WHEN tblProject3.kepada="Perusahaan B" THEN
            (SELECT SUM(tblPenawaranHarga.jumlah*tblPenawaranHarga.harga)
            FROM tblProject
            NATURAL JOIN tblPenawaranHarga
            GROUP BY tblProject.kepada
            HAVING tblProject.kepada="Perusahaan B")
          WHEN tblProject3.kepada="Perusahaan C" THEN
            (SELECT SUM(tblPenawaranHarga.jumlah*tblPenawaranHarga.harga)
            FROM tblProject
            NATURAL JOIN tblPenawaranHarga
            GROUP BY tblProject.kepada
            HAVING tblProject.kepada="Perusahaan C")
          WHEN tblProject3.kepada="Perusahaan D" THEN
            (SELECT SUM(tblPenawaranHarga.jumlah*tblPenawaranHarga.harga)
            FROM tblProject
            NATURAL JOIN tblPenawaranHarga
            GROUP BY tblProject.kepada
            HAVING tblProject.kepada="Perusahaan D")
          WHEN tblProject3.kepada="Perusahaan E" THEN
            (SELECT SUM(tblPenawaranHarga.jumlah*tblPenawaranHarga.harga)
            FROM tblProject
            NATURAL JOIN tblPenawaranHarga
            GROUP BY tblProject.kepada
            HAVING tblProject.kepada="Perusahaan E")
          WHEN tblProject3.kepada="Perusahaan F" THEN
            (SELECT SUM(tblPenawaranHarga.jumlah*tblPenawaranHarga.harga)
            FROM tblProject
            NATURAL JOIN tblPenawaranHarga
            GROUP BY tblProject.kepada
            HAVING tblProject.kepada="Perusahaan F")
          WHEN tblProject3.kepada="Perusahaan G" THEN
            (SELECT SUM(tblPenawaranHarga.jumlah*tblPenawaranHarga.harga)
            FROM tblProject
            NATURAL JOIN tblPenawaranHarga
            GROUP BY tblProject.kepada
            HAVING tblProject.kepada="Perusahaan G")
        END AS TOTAL3,

        tblProject2.kepada AS PROJECT2,

        CASE
          WHEN tblProject2.kepada="Perusahaan A" THEN
            (SELECT SUM(tblPenawaranHarga.jumlah*tblPenawaranHarga.harga)
            FROM tblProject
            NATURAL JOIN tblPenawaranHarga
            GROUP BY tblProject.kepada
            HAVING tblProject.kepada="Perusahaan A")
          WHEN tblProject2.kepada="Perusahaan B" THEN
            (SELECT SUM(tblPenawaranHarga.jumlah*tblPenawaranHarga.harga)
            FROM tblProject
            NATURAL JOIN tblPenawaranHarga
            GROUP BY tblProject.kepada
            HAVING tblProject.kepada="Perusahaan B")
          WHEN tblProject2.kepada="Perusahaan C" THEN
            (SELECT SUM(tblPenawaranHarga.jumlah*tblPenawaranHarga.harga)
            FROM tblProject
            NATURAL JOIN tblPenawaranHarga
            GROUP BY tblProject.kepada
            HAVING tblProject.kepada="Perusahaan C")
          WHEN tblProject2.kepada="Perusahaan D" THEN
            (SELECT SUM(tblPenawaranHarga.jumlah*tblPenawaranHarga.harga)
            FROM tblProject
            NATURAL JOIN tblPenawaranHarga
            GROUP BY tblProject.kepada
            HAVING tblProject.kepada="Perusahaan D")
          WHEN tblProject2.kepada="Perusahaan E" THEN
            (SELECT SUM(tblPenawaranHarga.jumlah*tblPenawaranHarga.harga)
            FROM tblProject
            NATURAL JOIN tblPenawaranHarga
            GROUP BY tblProject.kepada
            HAVING tblProject.kepada="Perusahaan E")
          WHEN tblProject2.kepada="Perusahaan F" THEN
            (SELECT SUM(tblPenawaranHarga.jumlah*tblPenawaranHarga.harga)
            FROM tblProject
            NATURAL JOIN tblPenawaranHarga
            GROUP BY tblProject.kepada
            HAVING tblProject.kepada="Perusahaan F")
          WHEN tblProject2.kepada="Perusahaan G" THEN
            (SELECT SUM(tblPenawaranHarga.jumlah*tblPenawaranHarga.harga)
            FROM tblProject
            NATURAL JOIN tblPenawaranHarga
            GROUP BY tblProject.kepada
            HAVING tblProject.kepada="Perusahaan G")
        END AS TOTAL2,

        tblProject1.kepada AS PROJECT1,

          CASE
            WHEN tblProject1.kepada="Perusahaan A" THEN
              (SELECT SUM(tblPenawaranHarga.jumlah*tblPenawaranHarga.harga)
              FROM tblProject
              NATURAL JOIN tblPenawaranHarga
              GROUP BY tblProject.kepada
              HAVING tblProject.kepada="Perusahaan A")
            WHEN tblProject1.kepada="Perusahaan B" THEN
              (SELECT SUM(tblPenawaranHarga.jumlah*tblPenawaranHarga.harga)
              FROM tblProject
              NATURAL JOIN tblPenawaranHarga
              GROUP BY tblProject.kepada
              HAVING tblProject.kepada="Perusahaan B")
            WHEN tblProject1.kepada="Perusahaan C" THEN
              (SELECT SUM(tblPenawaranHarga.jumlah*tblPenawaranHarga.harga)
              FROM tblProject
              NATURAL JOIN tblPenawaranHarga
              GROUP BY tblProject.kepada
              HAVING tblProject.kepada="Perusahaan C")
            WHEN tblProject1.kepada="Perusahaan D" THEN
              (SELECT SUM(tblPenawaranHarga.jumlah*tblPenawaranHarga.harga)
              FROM tblProject
              NATURAL JOIN tblPenawaranHarga
              GROUP BY tblProject.kepada
              HAVING tblProject.kepada="Perusahaan D")
            WHEN tblProject1.kepada="Perusahaan E" THEN
              (SELECT SUM(tblPenawaranHarga.jumlah*tblPenawaranHarga.harga)
              FROM tblProject
              NATURAL JOIN tblPenawaranHarga
              GROUP BY tblProject.kepada
              HAVING tblProject.kepada="Perusahaan E")
            WHEN tblProject1.kepada="Perusahaan F" THEN
              (SELECT SUM(tblPenawaranHarga.jumlah*tblPenawaranHarga.harga)
              FROM tblProject
              NATURAL JOIN tblPenawaranHarga
              GROUP BY tblProject.kepada
              HAVING tblProject.kepada="Perusahaan F")
            WHEN tblProject1.kepada="Perusahaan G" THEN
              (SELECT SUM(tblPenawaranHarga.jumlah*tblPenawaranHarga.harga)
              FROM tblProject
              NATURAL JOIN tblPenawaranHarga
              GROUP BY tblProject.kepada
              HAVING tblProject.kepada="Perusahaan G")
          END AS TOTAL1
  FROM  tblProject AS tblProject1,
        tblProject AS tblProject2,
        tblProject AS tblProject3
  WHERE tblProject3.kepada != tblProject2.kepada
  AND tblProject3.kepada != tblProject1.kepada
  AND tblProject2.kepada != tblProject1.kepada
  GROUP BY tblProject3.kepada, tblProject2.kepada, tblProject1.kepada;
-- NO 6 END
