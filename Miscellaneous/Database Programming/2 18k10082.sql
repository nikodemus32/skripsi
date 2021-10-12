USE dbPenjualanBarang;

--NO 1
DROP VIEW IF EXISTS viewMinimum;
CREATE VIEW viewMinimum AS
SELECT kdbarang ,
       namabarang ,
       jumlahstok ,
       minimum
FROM tblBarang
WHERE jumlahstok <= minimum;
SELECT * FROM viewMinimum;

--NO 2
DROP VIEW IF EXISTS viewKelamin;
CREATE VIEW viewKelamin AS
SELECT jkelamin as 'Jenis Kelamin' ,
       Count(jkelamin)
FROM tblPelanggan
GROUP BY jkelamin;
SELECT * FROM viewKelamin;


--NO 4\
DROP VIEW IF EXISTS viewTransaksiPelanggan;
CREATE VIEW viewTransaksiPelanggan AS
SELECT tblPelanggan.kdpel as 'Kode Pelanggan' ,
       tblPelanggan.namapel as 'Nama Pelanggan' ,
       COUNT(tblTransaksi.kdpel)
FROM tblPelanggan
NATURAL JOIN tblTransaksi
GROUP BY  tblTransaksi.kdpel
HAVING COUNT(tblTransaksi.kdpel) >= 10;
SELECT * FROM viewTransaksiPelanggan;

--NO 5
DROP VIEW IF EXISTS viewTerlaris;
CREATE VIEW viewTerlaris AS
SELECT tblBarang.kdbarang as 'Kode Barang' ,
       tblBarang.namabarang as 'Nama Barang' ,
       sum(tblRinciTransaksi.jumlah) as Jumlah
FROM tblBarang
NATURAL JOIN tblRinciTransaksi
GROUP BY tblBarang.kdbarang
ORDER BY SUM(tblRinciTransaksi.jumlah) DESC;

SELECT * FROM viewTerlaris;

--NO 6
DROP VIEW IF EXISTS viewUlangTahun;
CREATE VIEW viewUlangTahun AS
SELECT tblPelanggan.kdpel AS 'Kode Pelanggan' ,
       tblPelanggan.namapel AS 'Nama Pelanggan' ,
       tblPelanggan.tgllahir AS 'Tanggal Lahir' ,
       SUM(tblRinciTransaksi.jumlah * tblRinciTransaksi.harga) AS 'Total Bayar' ,
       CASE
       WHEN month(tblPelanggan.tgllahir) = month(now()) THEN "50 %"
       END AS "Discount" ,
       SUM(tblRinciTransaksi.jumlah * tblRinciTransaksi.harga)*(50/100) AS 'Hasil Discount'
FROM tblPelanggan
NATURAL JOIN tblTransaksi
NATURAL JOIN tblRinciTransaksi
GROUP BY tblPelanggan.kdpel
HAVING month(tblPelanggan.tgllahir) = month(now());

SELECT * FROM viewUlangTahun;

--NO 7
DROP VIEW IF EXISTS viewKunjungan;
CREATE VIEW viewKunjungan AS
SELECT tblPelanggan.kdpel as 'Kode Pelanggan' ,
       tblPelanggan.namapel as 'Nama Pelanggan' ,
       COUNT(tblTransaksi.kdpel) AS 'Jumlah Kunjungan',
       "30 %" AS Discount
FROM tblPelanggan
NATURAL JOIN tblTransaksi
GROUP BY  tblTransaksi.kdpel
HAVING COUNT(tblTransaksi.kdpel) > 10  ;
SELECT * FROM viewKunjungan;

--NO 8
DROP VIEW viewPekerjaan;
CREATE VIEW viewPekerjaan AS
select kdpel as 'Kode Pelanggan',
namapel as 'Nama Pelanggan',
pekerjaan as 'Pekerjaan',
CASE
  when pekerjaan = 'MAHASISWA' then "30%"
  when pekerjaan = 'POLWAN' then "20%"
  when pekerjaan = 'pns' then "10%"
  else "No discount"
end as "Diskon"
from tblPelanggan
where (pekerjaan ="MAHASISWA") OR (pekerjaan = "pns") or (pekerjaan = "polwan")
order by pekerjaan desc;

SELECT * FROM viewPekerjaan;

--NO 9
DROP VIEW view9;
CREATE VIEW view9 AS
SELECT tblPelanggan.kdpel AS 'Kode Pelanggan' ,
       tblPelanggan.namapel AS 'Nama Pelanggan' ,
       tblPelanggan.pekerjaan ,
       SUM(tblRinciTransaksi.jumlah * tblRinciTransaksi.harga) AS 'Total Bayar' ,
       CASE
         when tblPelanggan.pekerjaan = 'IRT' AND tblPelanggan.namapel LIKE'I%' then SUM(tblRinciTransaksi.jumlah * tblRinciTransaksi.harga)-(SUM(tblRinciTransaksi.jumlah * tblRinciTransaksi.harga)*(10/100))
         when tblPelanggan.pekerjaan = 'IRT' AND tblPelanggan.namapel LIKE'K%' then SUM(tblRinciTransaksi.jumlah * tblRinciTransaksi.harga)-(SUM(tblRinciTransaksi.jumlah * tblRinciTransaksi.harga)*(15/100))
         when tblPelanggan.pekerjaan = 'IRT' AND tblPelanggan.namapel LIKE'O%' then SUM(tblRinciTransaksi.jumlah * tblRinciTransaksi.harga)-(SUM(tblRinciTransaksi.jumlah * tblRinciTransaksi.harga)*(20/100))
         when tblPelanggan.pekerjaan = 'IRT' AND tblPelanggan.namapel LIKE'M%' then SUM(tblRinciTransaksi.jumlah * tblRinciTransaksi.harga)-(SUM(tblRinciTransaksi.jumlah * tblRinciTransaksi.harga)*(25/100))
         ELSE SUM(tblRinciTransaksi.jumlah * tblRinciTransaksi.harga)
       end as "Hasil Discount"
FROM tblPelanggan
NATURAL JOIN tblTransaksi
NATURAL JOIN tblRinciTransaksi
GROUP BY tblPelanggan.kdpel
HAVING (tblPelanggan.namapel LIKE'I%' OR
       tblPelanggan.namapel LIKE'K%' OR
       tblPelanggan.namapel LIKE'O%' OR
       tblPelanggan.namapel LIKE'M%') AND
       tblPelanggan.pekerjaan = 'IRT'
ORDER BY tblPelanggan.namapel;

SELECT * FROM view9;

--NO 3
DROP VIEW IF EXISTS viewUmur
CREATE VIEW viewUmur AS
SELECT 'UMUR <= 10',
       COUNT(tgllahir) AS Jumlah
FROM tblPelanggan
WHERE year(now())-year(tgllahir) <= 10;

select * from viewUmur;
