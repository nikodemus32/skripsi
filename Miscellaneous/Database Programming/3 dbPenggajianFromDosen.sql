drop database if exists dbPenggajian;
create database dbPenggajian;
use dbPenggajian;

create table tblBuruh(
id int primary key,
nama varchar(100)
);

create table tblPresensi(
id int,
tanggal date,
jammasuk time,
jamkeluar time,
gajiharian double,
lemburmasuk time,
lemburkeluar time,
lemburperjam double,
foreign key(id) references tblBuruh(id)
);

insert into tblBuruh values
(1, 'Harno'),
(2, 'Lena'),
(3, 'Wartoyo'),
(4, 'Azis'),
(5, 'Hendro');

insert into tblPresensi values
(1, '2015-11-01', '07:30:00', '17:00:00', 80000 , '17:30', '20:10', 20000),
(1, '2015-11-02', '07:28:00', '17:30:00', 75000 , '17:40', '21:13', 20000),
(2, '2015-11-01', '07:40:00', '17:45:00', 82000 , '17:55', '23:50', 20000),
(2, '2015-11-02', '07:50:00', '17:15:00', 77000 , '17:15', '02:10', 20000),
(4, '2015-11-01', '07:35:00', '17:25:00', 67500 , '17:20', '01:15', 20000),
(4, '2015-11-02', '07:38:00', '17:55:00', 55000 , '17:25', '20:40', 20000),
(5, '2015-11-01', '07:39:00', '17:56:00', 76000 , '17:33', '21:17', 20000),
(5, '2015-11-02', '07:41:00', '17:58:00', 78000 , '17:56', '23:40', 20000),
(5, '2015-11-03', '07:50:00', '17:34:00', 65000 , '17:05', '01:50', 20000),
(5, '2015-11-04', '07:36:00', '17:35:00', 77500 , '17:15', '03:10', 20000);

-- select * from tblBuruh;
-- select * from tblPresensi;

select tblPresensi.ID,
tblBuruh.nama, tblPresensi.jammasuk, tblPresensi.jamkeluar,
IF(tblPresensi.jammasuk < '07:30:00', '07:30:00', tblPresensi.jammasuk) AS 'MASUKVALID',
IF(tblPresensi.jamkeluar > '17:30:00', '17:30:00', tblPresensi.jamkeluar) AS 'KELUARVALID'
from tblPresensi inner join tblBuruh using(id);

create view vwValidKerja as
select tblPresensi.ID,
tblBuruh.nama, tblPresensi.jammasuk, tblPresensi.jamkeluar,
IF(tblPresensi.jammasuk < '07:30:00', '07:30:00', tblPresensi.jammasuk) AS 'MASUKVALID',
IF(tblPresensi.jamkeluar > '17:30:00', '17:30:00', tblPresensi.jamkeluar) AS 'KELUARVALID',
tblPresensi.gajiharian AS GAJIHARIAN,
FORMAT((TIME_TO_SEC(IF(tblPresensi.jamkeluar > '17:30:00', '17:30:00', tblPresensi.jamkeluar)) - TIME_TO_SEC(IF(tblPresensi.jammasuk < '07:30:00', '07:30:00', tblPresensi.jammasuk)))/60, 0) AS SATUANMENIT
from tblPresensi inner join tblBuruh using(id);

create view vwHitungGaji as
SELECT ID, nama, jammasuk, jamkeluar, MASUKVALID, KELUARVALID,
GAJIHARIAN, CONCAT(SATUANMENIT, ' MENIT') AS KERJA, ROUND((SATUANMENIT/600) * GAJIHARIAN, 0) AS GAJI
FROM vwValidKerja;

create view vwTampilLembur as
select tblPresensi.ID,
tblBuruh.nama, tblPresensi.lemburmasuk,
IF(tblPresensi.lemburmasuk < '17:30:00', '17:30:00', tblPresensi.lemburmasuk) AS 'LEMBURMASUKVALID',
tblPresensi.lemburkeluar AS 'LEMBURKELUARVALID',
tblPresensi.lemburperjam
from tblPresensi inner join tblBuruh using(id);
select * from vwTampilLembur;


SELECT ID, NAMA, LEMBURMASUKVALID, LEMBURKELUARVALID,
IF(LEMBURKELUARVALID BETWEEN '17:30:00' AND '23:00:00',
FORMAT(((TIME_TO_SEC(vwTampilLembur.LEMBURKELUARVALID) - TIME_TO_SEC(vwTampilLembur.LEMBURMASUKVALID))/60)/60, 2) * vwTampilLembur.lemburperjam,
IF(LEMBURKELUARVALID BETWEEN '23:00:00' AND '23:59:59',
FORMAT(((TIME_TO_SEC(vwTampilLembur.LEMBURKELUARVALID) - TIME_TO_SEC('23:00:00'))/60)/60, 2) * vwTampilLembur.lemburperjam * 2,
FORMAT(((TIME_TO_SEC(vwTampilLembur.LEMBURKELUARVALID) - TIME_TO_SEC('00:00:00'))/60)/60, 2) * vwTampilLembur.lemburperjam * 2)
+FORMAT(((TIME_TO_SEC('23:00:00') - TIME_TO_SEC(vwTampilLembur.LEMBURMASUKVALID))/60)/60, 2) * vwTampilLembur.lemburperjam * 2
+FORMAT(((TIME_TO_SEC('23:59:59') - TIME_TO_SEC('23:00:00'))/60)/60, 2) * vwTampilLembur.lemburperjam
) AS UANGLEMBUR
FROM vwTampilLembur;

CREATE VIEW vwHitungLembur AS
SELECT ID, NAMA, SUM(
IF(LEMBURKELUARVALID BETWEEN '17:30:00' AND '23:00:00',
FORMAT(((TIME_TO_SEC(vwTampilLembur.LEMBURKELUARVALID) - TIME_TO_SEC(vwTampilLembur.LEMBURMASUKVALID))/60)/60, 2) * vwTampilLembur.lemburperjam,

IF(LEMBURKELUARVALID BETWEEN '23:00:00' AND '23:59:59',
FORMAT(((TIME_TO_SEC(vwTampilLembur.LEMBURKELUARVALID) - TIME_TO_SEC('23:00:00'))/60)/60, 2) * vwTampilLembur.lemburperjam * 2,

FORMAT(((TIME_TO_SEC(vwTampilLembur.LEMBURKELUARVALID) - TIME_TO_SEC('00:00:00'))/60)/60, 2) * vwTampilLembur.lemburperjam * 2)+FORMAT(((TIME_TO_SEC('23:00:00') - TIME_TO_SEC(vwTampilLembur.LEMBURMASUKVALID))/60)/60, 2) * vwTampilLembur.lemburperjam * 2
+FORMAT(((TIME_TO_SEC('23:59:59') - TIME_TO_SEC('23:00:00'))/60)/60, 2) * vwTampilLembur.lemburperjam
)) AS LEMBUR
FROM vwTampilLembur
GROUP BY ID, NAMA;


SELECT vwHitungGaji.ID, vwHitungGaji.NAMA,
vwHitungGaji.GAJI, vwHitungLembur.LEMBUR,
vwHitungGaji.GAJI + vwHitungLembur.LEMBUR AS GRANDTOTALPENDAPATANBURUH
FROM vwHitungGaji, vwHitungLembur
WHERE vwHitungGaji.ID = vwHitungLembur.ID
GROUP BY vwHitungGaji.ID;
