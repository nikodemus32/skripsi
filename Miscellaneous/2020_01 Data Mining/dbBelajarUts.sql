/*
  Nikodemus Galih Candra Wicaksono
  Sunday, 01 November 2020 14:55
  DATA D :"Galih/Unika Soegijapranata/Data Mining/"
*/
DROP DATABASE IF EXISTS dbBelajarUts;
CREATE DATABASE dbBelajarUts;
USE dbBelajarUts;

CREATE TABLE tblHasilTes(
  noTest int PRIMARY KEY,
  bahasa int,
  matematika int,
  logika int
);

INSERT INTO tblHasilTes VALUES
  (1101,80,98,45),
  (1102,20,65,98),
  (1103,27,38,16),
  (1104,70,99,97),
  (1105,92,99,93),
  (1106,46,45,88),
  (1107,57,39,92),
  (1108,91,17,45),
  (1109,58,58,91),
  (1110,10,57,94);

/*Tabel untuk menjadi Centroid,
  C dan CB bisa digunakan untuk menyimpulkan
  bahwa clusterBaru dan clusterLama sama,
  namun karena hasil adalah dari rata-rata dan tipe double
  kemungkinan pembulatan berbeda, jadinya menggunakan
  clusterLama dan ClusterBaru untuk mengambil Kesimpulan
*/
CREATE TABLE tblCentroid(
  C int PRIMARY KEY,
  Cx double default 0,
  CxB double default 0,
  Cy double default 0,
  CyB double default 0
);

DELIMITER $$
CREATE PROCEDURE spInsertTabeltes(berapa int)
  BEGIN
    DECLARE i int default 0;
    TRUNCATE TABLE tblCentroid;

    while i<>berapa DO
      INSERT INTO tblCentroid(C, CxB, CyB) values(i+1, round(rand()*100,2), round(rand()*100,2));
    SET i=i+1;
    END WHILE;
  END $$
  DELIMITER ;

/*Tabel untuk cek, jika cL sama dengan cB semuanya
maka looping otomatis berhenti*/
CREATE TABLE tblCluster(
  noTest varchar(4) PRIMARY KEY,
  cL varchar(2), /*Cluster Lama*/
  cB varchar(2) /*Cluster Baru*/
);

DROP VIEW IF EXISTS viewPsikologi;
  CREATE VIEW viewPsikologi AS
  SELECT tblHasilTes.noTest AS no,
    tblHasilTes.bahasa AS x,
    tblHasilTes.logika AS y
  FROM tblHasilTes;
