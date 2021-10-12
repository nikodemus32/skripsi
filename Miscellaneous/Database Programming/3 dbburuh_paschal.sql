--Nomor 1

drop database if exists dbburuh;
create database dbburuh;
use dbburuh;

create table tblBuruh(
  id INT PRIMARY KEY,
  nama VARCHAR(100)
);

create table tblPelanggan(
  id INT,
  tanggal DATE,
  jammasuk TIME,
  jamkeluar TIME,
  gajiharian DOUBLE,
  lemburmasuk TIME,
  lemburkeluar TIME,
  lemburperjam DOUBLE,
  foreign key (id) references tblBuruh(id)
);


--Nomor 2

insert into tblBuruh values
  (1,"Harno"),
  (2,"Lena"),
  (3,"Wartoyo"),
  (4,"Azis"),
  (5,"Hendro");

insert into tblPelanggan values
  (1,"2015-11-01","07:30:00","17:00:00","80000","17:30:00","20:10:00","20000"),
  (1,"2015-11-02","07:28:00","17:30:00","75000","17:40:00","21:13:00","20000"),
  (2,"2015-11-01","07:40:00","17:45:00","82000","17:55:00","23:50:00","20000"),
  (2,"2015-11-02","07:50:00","17:15:00","77000","17:15:00","02:10:00","20000"),
  (4,"2015-11-01","07:35:00","17:25:00","67500","17:20:00","01:15:00","20000"),
  (4,"2015-11-02","07:38:00","17:55:00","55000","17:25:00","20:40:00","20000"),
  (5,"2015-11-01","07:39:00","17:56:00","76000","17:33:00","21:17:00","20000"),
  (5,"2015-11-02","07:41:00","17:58:00","78000","17:56:00","23:40:00","20000"),
  (5,"2015-11-03","07:50:00","17:34:00","65000","17:05:00","01:50:00","20000"),
  (5,"2015-11-04","07:36:00","17:35:00","77500","17:15:00","03:10:00","20000");

DROP VIEW vwNomor1;
  CREATE VIEW vwNomor1 AS
  select * from tblBuruh;

DROP VIEW vwNomor2;
  Create View vwNomor2 AS
  select * from tblPelanggan;

--Nomor 3

DROP VIEW vwNomor3;
  Create View vwNomor3 AS
  select tblBuruh.id as ID, tblBuruh.nama as Nama, tblPelanggan.jammasuk as "Jam Masuk", tblPelanggan.jamkeluar as "Jam Keluar",
  CASE
  when tblPelanggan.jammasuk < "07:30:00" then "07:30:00"
  when tblPelanggan.jammasuk >= "07:30:00" then tblPelanggan.jammasuk
  end as "MASUK VALID",
  CASE
  when tblPelanggan.jamkeluar< "17:30:00" then "17:30:00"
  when tblPelanggan.jamkeluar >= "17:30:00" then tblPelanggan.jamkeluar
  end as "KELUAR VALID"

  FROM tblBuruh
  Natural join tblPelanggan;

--Nomor4
DROP VIEW vwNomor4;
  Create View vwNomor4   AS
    select tblBuruh.id as ID, tblBuruh.nama as Nama, tblPelanggan.jammasuk as "JamMasuk", tblPelanggan.jamkeluar as "JamKeluar",
    CASE
      when tblPelanggan.jammasuk < "07:30:00" then "07:30:00"
      when tblPelanggan.jammasuk >= "07:30:00" then tblPelanggan.jammasuk
    end as "MASUKVALID",
    CASE
      when tblPelanggan.jamkeluar< "17:30:00" then "17:30:00"
      when tblPelanggan.jamkeluar >= "17:30:00" then tblPelanggan.jamkeluar
    end as "KELUARVALID",
    tblPelanggan.gajiharian as "GAJIHARIAN",
    CASE  when tblPelanggan.jammasuk<"07:30:00" and tblPelanggan.jamkeluar<"17:30:00" then CONCAT(ROUND(TIME_TO_SEC(TIMEDIFF(tblPelanggan.jamkeluar,"07:30:00"))/60)," MENIT")
          when tblPelanggan.jammasuk>="07:30:00" and tblPelanggan.jamkeluar<"17:30:00" then CONCAT(ROUND(TIME_TO_SEC(TIMEDIFF(tblPelanggan.jamkeluar,tblPelanggan.jammasuk))/60)," MENIT")
          when tblPelanggan.jammasuk<"07:30:00" and tblPelanggan.jamkeluar>="17:30:00" then CONCAT(ROUND(TIME_TO_SEC(TIMEDIFF("17:30:00","07:30:00"))/60)," MENIT")
          when tblPelanggan.jammasuk>="07:30:00" and tblPelanggan.jamkeluar>="17:30:00" then CONCAT(ROUND(TIME_TO_SEC(TIMEDIFF("17:30:00",tblPelanggan.jammasuk))/60)," MENIT")
    END AS KERJA,
    CASE
          WHEN tblPelanggan.jammasuk<"07:30:00" and tblPelanggan.jamkeluar<"17:30:00" and (TIME_TO_SEC(TIMEDIFF(tblPelanggan.jamkeluar,"07:30:00"))/60)=600 then ROUND(tblPelanggan.gajiharian)
          WHEN tblPelanggan.jammasuk>="07:30:00" and tblPelanggan.jamkeluar<"17:30:00" and (TIME_TO_SEC(TIMEDIFF(tblPelanggan.jamkeluar,tblPelanggan.jammasuk))/60) =600 then ROUND(tblPelanggan.gajiharian)
          WHEN tblPelanggan.jammasuk<"07:30:00" and tblPelanggan.jamkeluar>="17:30:00" and (TIME_TO_SEC(TIMEDIFF("17:30:00","07:30:00"))/60)=600 then ROUND(tblPelanggan.gajiharian)
          WHEN tblPelanggan.jammasuk>="07:30:00" and tblPelanggan.jamkeluar>="17:30:00" and (TIME_TO_SEC(TIMEDIFF("17:30:00",tblPelanggan.jammasuk))/60) =600 then ROUND(tblPelanggan.gajiharian)
          WHEN tblPelanggan.jammasuk<"07:30:00" and tblPelanggan.jamkeluar<"17:30:00" and (TIME_TO_SEC(TIMEDIFF(tblPelanggan.jamkeluar,"07:30:00"))/60)<600 then
                ROUND((tblPelanggan.gajiharian/600)*(TIME_TO_SEC(TIMEDIFF(tblPelanggan.jamkeluar,"07:30:00"))/60))
          WHEN tblPelanggan.jammasuk>="07:30:00" and tblPelanggan.jamkeluar<"17:30:00" and (TIME_TO_SEC(TIMEDIFF(tblPelanggan.jamkeluar,tblPelanggan.jammasuk))/60)<600 then
                ROUND((tblPelanggan.gajiharian/600)*(TIME_TO_SEC(TIMEDIFF(tblPelanggan.jamkeluar,tblPelanggan.jammasuk))/60))
          WHEN tblPelanggan.jammasuk<"07:30:00" and tblPelanggan.jamkeluar>="17:30:00" and (TIME_TO_SEC(TIMEDIFF("17:30:00","07:30:00"))/60)<600 then
                ROUND((tblPelanggan.gajiharian/600)*(TIME_TO_SEC(TIMEDIFF("17:30:00","07:30:00"))/60))
          WHEN tblPelanggan.jammasuk>="07:30:00" and tblPelanggan.jamkeluar>="17:30:00" and (TIME_TO_SEC(TIMEDIFF("17:30:00",tblPelanggan.jammasuk))/60)<600 then
                ROUND((tblPelanggan.gajiharian/600)*(TIME_TO_SEC(TIMEDIFF("17:30:00",tblPelanggan.jammasuk))/60))
    END AS GAJI
    FROM tblBuruh
    Natural join tblPelanggan;

--nomor5

DROP VIEW vwNomor5;
  Create View vwNomor5   AS
  select tblBuruh.id as ID, tblBuruh.nama as Nama, tblPelanggan.lemburmasuk as "Lembur Masuk", tblPelanggan.lemburkeluar as "Lembur Keluar",
  CASE
    when tblPelanggan.lemburmasuk < "17:30:00" then "17:30:00"
    when tblPelanggan.lemburmasuk >= "17:30:00" then tblPelanggan.lemburmasuk
  end as "LEMBUR MASUK VALID"
  FROM tblBuruh
  Natural join tblPelanggan;

--nomor6
CREATE VIEW vwNomor6 AS
SELECT tblPelanggan.id, nama,
CASE
  when tblPelanggan.lemburmasuk < "17:30:00" then "17:30:00"
  when tblPelanggan.lemburmasuk >= "17:30:00" then tblPelanggan.lemburmasuk
end as "LEMBUR MASUK VALID",
tblPelanggan.lemburkeluar,
IF(tblPelanggan.lemburkeluar BETWEEN '17:30:00' AND '23:00:00',FORMAT(((TIME_TO_SEC(tblPelanggan.lemburkeluar) - TIME_TO_SEC(tblPelanggan.lemburmasuk))/60)/60, 2) * tblPelanggan.lemburperjam,
IF(tblPelanggan.lemburkeluar BETWEEN '23:00:00' AND '23:59:59',FORMAT(((TIME_TO_SEC(tblPelanggan.lemburkeluar) - TIME_TO_SEC('23:00:00'))/60)/60, 2) * tblPelanggan.lemburperjam * 2,
FORMAT(((TIME_TO_SEC(tblPelanggan.lemburkeluar) - TIME_TO_SEC('00:00:00'))/60)/60, 2) * tblPelanggan.lemburperjam * 2)
+FORMAT(((TIME_TO_SEC('23:00:00') - TIME_TO_SEC(tblPelanggan.lemburmasuk))/60)/60, 2) * tblPelanggan.lemburperjam * 2+FORMAT(((TIME_TO_SEC('23:59:59') - TIME_TO_SEC('23:00:00'))/60)/60, 2) * tblPelanggan.lemburperjam
) AS UANGLEMBUR

FROM tblBuruh
NATURAL JOIN tblPelanggan;

--nomor7


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
