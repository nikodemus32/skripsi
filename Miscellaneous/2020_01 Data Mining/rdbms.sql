DROP DATABASE IF EXISTS dbrdbms;
CREATE DATABASE dbrdbms;
USE dbrdbms;

create table tblData
(
nomor int primary key,
nama varchar(25),
tgllahir datetime,
kotaasal varchar(25),
nomorpasangan int
);

insert into tblData values
(1, 'MARTIN'   , '2000-09-07 00:00:00', 'SEMARANG'  ,2),
(2, 'MARTINA'  , '2001-10-05 00:00:00', 'SALATIGA'  ,1),
(3, 'YOSEPH'   , '1998-11-01 00:00:00', 'MAGELANG'  ,4),
(4, 'MARIA'    , '2000-08-03 00:00:00', 'MAGELANG'  ,3),
(5, 'RICHARD'  , '1997-07-08 00:00:00', 'SALATIGA'  ,6),
(6, 'YOSEFIN'  , '1998-01-15 00:00:00', 'PEKALONGAN',5),
(7, 'CHRISTIAN', '1996-07-08 00:00:00', 'SEMARANG'  ,8),
(8, 'VANNIA'   , '1996-07-09 00:00:00', 'SEMARANG'  ,7);

/*NOMOR 1*/
SELECT a2.nama as INDIVIDU, a1.nama as PASANGANNYA
FROM tbldata as a1, tbldata as a2
WHERE a2.nomorpasangan=a1.nomor
AND a2.nomorpasangan%2=0;

/*NOMOR 2*/
SELECT a2.nama as INDIVIDU, a2.kotaasal as KOTA_ASAL_INDIVIDU,
      a1.nama as PASANGANNYA, a1.kotaasal as KOTA_ASAL_PASANGAN
FROM tbldata as a1, tbldata as a2
WHERE a2.nomorpasangan=a1.nomor
AND a2.nomorpasangan%2=0
AND a2.kotaasal=a1.kotaasal;

/*NOMOR 3*/
SELECT a2.nama as INDIVIDU, a2.tgllahir as TGL_LAHIR_INDIVIDU,
      a1.nama as PASANGANNYA, a1.tgllahir as TGL_LAHIR_PASANGAN,
      ABS(YEAR(a2.tgllahir)-YEAR(a1.tgllahir)) as SELISIH_UMUR
FROM tbldata as a1, tbldata as a2
WHERE a2.nomorpasangan=a1.nomor
AND a2.nomorpasangan%2=0;
