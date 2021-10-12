-- Start No 1

DROP DATABASE IF EXISTS dbPenggajian;
CREATE DATABASE dbPenggajian;
USE dbPenggajian;

CREATE TABLE tblBuruh(
id INT PRIMARY KEY,
nama varchar(100)
);

CREATE TABLE tblPresensi(
id INT,
tanggal date,
jammasuk time,
jamkeluar time,
gajiharian double,
lemburmasuk time,
lemburkeluar time,
lemburperjam double,
FOREIGN KEY (id) REFERENCES tblBuruh(id)
);
-- END No 1


-- Start No 2
INSERT INTO tblBuruh VALUES
(1, "Harno"),
(2, "Lena"),
(3, "Wartoyo"),
(4, "Azis"),
(5, "Hendro");

INSERT INTO tblPresensi VALUES
(1, "2015-11-01", "07:30:00", "17:00:00", 80000, "17:30:00", "20:10:00",20000),
(1, "2015-11-02", "07:28:00", "17:30:00", 75000, "17:40:00", "21:13:00",20000),
(2, "2015-11-01", "07:40:00", "17:45:00", 82000, "17:55:00", "23:50:00",20000),
(2, "2015-11-02", "07:50:00", "17:15:00", 77000, "17:15:00", "02:10:00",20000),
(4, "2015-11-01", "07:35:00", "17:25:00", 67500, "17:20:00", "01:15:00",20000),
(4, "2015-11-02", "07:38:00", "17:55:00", 55000, "17:25:00", "20:40:00",20000),
(5, "2015-11-01", "07:39:00", "17:56:00", 76000, "17:33:00", "21:17:00",20000),
(5, "2015-11-02", "07:41:00", "17:58:00", 78000, "17:56:00", "23:40:00",20000),
(5, "2015-11-03", "07:50:00", "17:34:00", 65000, "17:05:00", "01:50:00",20000),
(5, "2015-11-04", "07:36:00", "17:35:00", 77500, "17:15:00", "03:10:00",20000);

-- SELECT * FROM tblBuruh;
-- SELECT * FROM tblPresensi;
-- END No 2

CREATE VIEW vwNomor3 AS
SELECT  tblBuruh.id AS "ID",
        tblBuruh.nama AS "Nama",
        tblPresensi.jammasuk AS "Jam Masuk",
        tblPresensi.jamkeluar AS "Jam Keluar",
        Case
          WHEN tblPresensi.jammasuk <= "07:30:00" THEN "07:30:00"
          ELSE tblPresensi.jammasuk
        END AS "Masuk Valid",
        CASE
          WHEN tblPresensi.jamkeluar >= "17:30:00" THEN "17:30:00"
          ELSE tblPresensi.jamkeluar
        END AS "Keluar Valid"
FROM tblBuruh
NATURAL JOIN tblPresensi;

CREATE VIEW vwNomor4 AS
SELECT tblBuruh.id AS ID,
       tblBuruh.nama AS Nama,
       tblPresensi.jammasuk ,
       tblPresensi.jamkeluar,
       CASE
        WHEN tblPresensi.jammasuk >= '07:30:00' THEN tblPresensi.jammasuk
        WHEN tblPresensi.jammasuk < '07:30:00' THEN "07:30:00"
       END AS MASUKVALID ,
       CASE
        WHEN tblPresensi.jamkeluar <= '17:30:00' THEN tblPresensi.jamkeluar
        WHEN tblPresensi.jamkeluar > '17:30:00' THEN "17:30:00"
       END AS KELUARVALID ,
       tblPresensi.gajiharian ,
       CASE
        WHEN tblPresensi.jammasuk < '07:30:00' THEN CONCAT(CAST((TIME_TO_SEC(tblPresensi.jamkeluar) - TIME_TO_SEC('07:30:00'))/60 AS DECIMAL(3,0)), ' Menit')
        WHEN tblPresensi.jamkeluar > '17:30:00' THEN CONCAT(CAST((TIME_TO_SEC('17:30:00') - TIME_TO_SEC(tblPresensi.jammasuk))/60 AS DECIMAL(3,0)), ' Menit')
        WHEN tblPresensi.jamkeluar > '17:30:00' AND tblPresensi.jammasuk < '07:30:00' THEN CONCAT(CAST((TIME_TO_SEC('17:30:00') - TIME_TO_SEC('07:30:00'))/60 AS DECIMAL(3,0)), ' Menit')
        ELSE CONCAT(CAST((TIME_TO_SEC(tblPresensi.jamkeluar) - TIME_TO_SEC(tblPresensi.jammasuk))/60 AS DECIMAL(3,0)), ' Menit')
       END AS KERJA,
       CASE
        WHEN tblPresensi.jammasuk < '07:30:00' THEN CAST((tblPresensi.gajiharian/600)*CAST((TIME_TO_SEC(tblPresensi.jamkeluar) - TIME_TO_SEC('07:30:00'))/60 AS DECIMAL(3,0)) AS DECIMAL(5,0))
        WHEN tblPresensi.jamkeluar > '17:30:00' THEN CAST((tblPresensi.gajiharian/600)*CAST((TIME_TO_SEC('17:30:00') - TIME_TO_SEC(tblPresensi.jammasuk))/60 AS DECIMAL(3,0)) AS DECIMAL(5,0))
        WHEN tblPresensi.jamkeluar > '17:30:00' AND tblPresensi.jammasuk < '07:30:00' THEN CAST((tblPresensi.gajiharian/600)*CAST((TIME_TO_SEC('17:30:00') - TIME_TO_SEC('07:30:00'))/60 AS DECIMAL(3,0)) AS DECIMAL(5,0))
        ELSE CAST((tblPresensi.gajiharian/600)*CAST((TIME_TO_SEC(tblPresensi.jamkeluar) - TIME_TO_SEC(tblPresensi.jammasuk))/60 AS DECIMAL(3,0)) AS DECIMAL(5,0))
       END AS GAJI
FROM tblBuruh
NATURAL JOIN tblPresensi;

CREATE VIEW vwNomor5 AS
SELECT  tblBuruh.id AS "ID",
        tblBuruh.nama AS "Nama",
        tblPresensi.lemburmasuk AS "lemburmasuk",
        tblPresensi.lemburkeluar AS "lemburkeluar",
        CASE
          WHEN tblPresensi.lemburmasuk <= "17:30:00" THEN "17:30:00"
          ELSE tblPresensi.lemburmasuk
        END AS "LEMBURMASUKVALID"
FROM tblBuruh
NATURAL JOIN tblPresensi;

CREATE VIEW vwNomor6 AS
SELECT  tblBuruh.id AS 'ID',
        tblBuruh.nama AS 'Nama',
        CASE
          WHEN tblPresensi.lemburmasuk <= '17:30:00' THEN '17:30:00'
          ELSE tblPresensi.lemburmasuk
        END AS 'LEMBURMASUKVALID',
        tblPresensi.lemburkeluar AS 'LEMBURKELUARVALID',

        Case
          WHEN tblPresensi.lemburmasuk <= '17:30:00' AND (tblPresensi.lemburkeluar between '17:30:00' AND '23:00:00')
            THEN CAST(tblPresensi.lemburperjam*CAST((TIME_TO_SEC(tblPresensi.lemburkeluar)-TIME_TO_SEC('17:30:00'))/3600 AS DECIMAL(5,3)) AS DECIMAL(5,0))
          WHEN tblPresensi.lemburmasuk <= '17:30:00' AND (tblPresensi.lemburkeluar between '17:30:00' AND '24:00:00')
            THEN (CAST(tblPresensi.lemburperjam*CAST((TIME_TO_SEC(tblPresensi.lemburkeluar)-TIME_TO_SEC('17:30:00'))/3600 AS DECIMAL(5,3)) AS DECIMAL(5,0)))
            +((CAST(tblPresensi.lemburperjam*CAST((TIME_TO_SEC(tblPresensi.lemburkeluar)-TIME_TO_SEC('23:00:00'))/3600 AS DECIMAL(5,3)) AS DECIMAL(5,0)))*2)
          WHEN tblPresensi.lemburmasuk <= '17:30:00' AND (tblPresensi.lemburkeluar between '00:00:00' AND '05:00:00')
            THEN (CAST(tblPresensi.lemburperjam*CAST((TIME_TO_SEC(tblPresensi.lemburkeluar)-TIME_TO_SEC('17:30:00'))/3600 AS DECIMAL(5,3)) AS DECIMAL(5,0))) +
            ((CAST(tblPresensi.lemburperjam*CAST(((TIME_TO_SEC(tblPresensi.lemburkeluar)+TIME_TO_SEC('24:00:00'))-TIME_TO_SEC('23:00:00'))/3600 AS DECIMAL(5,3)) AS DECIMAL(5,0)))*2)

          WHEN tblPresensi.lemburmasuk > '17:30:00' AND (tblPresensi.lemburkeluar between '17:30:00' AND '23:00:00')
            THEN CAST(tblPresensi.lemburperjam*CAST((TIME_TO_SEC(tblPresensi.lemburkeluar)-TIME_TO_SEC(tblPresensi.lemburmasuk))/3600 AS DECIMAL(5,3)) AS DECIMAL(5,0))
          WHEN tblPresensi.lemburmasuk > '17:30:00' AND (tblPresensi.lemburkeluar between '17:30:00' AND '24:00:00')
            THEN (CAST(tblPresensi.lemburperjam*CAST((TIME_TO_SEC(tblPresensi.lemburkeluar)-TIME_TO_SEC(tblPresensi.lemburmasuk))/3600 AS DECIMAL(5,3)) AS DECIMAL(5,0))) +((CAST(tblPresensi.lemburperjam*CAST((TIME_TO_SEC(tblPresensi.lemburkeluar)-TIME_TO_SEC('23:00:00'))/3600 AS DECIMAL(5,3)) AS DECIMAL(5,0)))*2)
          WHEN tblPresensi.lemburmasuk > '17:30:00' AND (tblPresensi.lemburkeluar between '00:00:00' AND '05:00:00')
            THEN (CAST(tblPresensi.lemburperjam*CAST((TIME_TO_SEC(tblPresensi.lemburkeluar)+TIME_TO_SEC('24:00:00')-TIME_TO_SEC(tblPresensi.lemburmasuk))/3600 AS DECIMAL(5,3)) AS DECIMAL(5,0)))+((CAST(tblPresensi.lemburperjam*CAST(((TIME_TO_SEC(tblPresensi.lemburkeluar)+TIME_TO_SEC('24:00:00'))-TIME_TO_SEC('23:00:00'))/3600 AS DECIMAL(5,3)) AS DECIMAL(5,0)))*2)
          END AS 'UANGLEMBUR'
FROM tblBuruh
NATURAL JOIN tblPresensi;

CREATE VIEW vwNomor7 AS
SELECT vwNomor6.ID,
vwNomor6.nama,
SUM(DISTINCT vwNomor4.GAJI) as GAJI,
SUM(DISTINCT vwNomor6.UANGLEMBUR) as LEMBUR,
SUM(DISTINCT vwNomor4.GAJI)+SUM(DISTINCT vwNomor6.UANGLEMBUR) AS GRANDTOTALPENDAPATANBURUH
FROM vwNomor6
NATURAL JOIN vwNomor5
NATURAL JOIN vwNomor4
GROUP BY vwNomor6.nama
ORDER BY vwNomor6.ID asc;
