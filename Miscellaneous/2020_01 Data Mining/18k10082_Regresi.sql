DROP DATABASE IF EXISTS db18k10082_DataMining1;
CREATE DATABASE db18k10082_DataMining1;
USE db18k10082_DataMining1;

CREATE TABLE tblPenduduk(
  tahunSensus int,
  jumlahJiwa float
);

CREATE TABLE tblGaji(
  lamaKerja int,
  gaji float /*Dalam juta*/
);

INSERT INTO tblPenduduk VALUES
(1930,	60.7),
(1961,	97.1),
(1971,	119.2),
(1980,	146.9),
(1990,	178.6),
(2000,	205.1),
(2010,	237.6);

INSERT INTO tblGaji VALUES
(3,	3),
(8,	5.7),
(9,	6.4),
(13,	7.2),
(3,	3.6),
(6,	4.3),
(11,	5.9),
(21,	9),
(1,	2),
(16,	8.3);

CREATE TABLE tblPrediksi(
  prediksi varchar(20),
  nilaiPrediksi float,
  hasilPrediksi float
);
/*Prediksi Penduduk*/
SELECT * FROM tblPenduduk;

SELECT AVG(tahunSensus) into @avgXSensus from tblPenduduk;
SELECT AVG(jumlahJiwa) into @avgYJmlh from tblPenduduk;
SELECT ROUND(@avgXSensus, 2) as RATAX, ROUND(@avgYJmlh,2) as RATAY;

SELECT tahunSensus, @avgXSensus, ROUND(tahunSensus-@avgXSensus, 2) as 'Xi-Xrata'
from tblPenduduk;

SELECT jumlahJiwa, @avgYJmlh, ROUND(jumlahJiwa-@avgYJmlh, 2) 'Yi-Yrata'
from tblPenduduk;

SELECT SUM(ROUND(tahunSensus-@avgXSensus,2) * ROUND(jumlahJiwa-@avgYJmlh, 2))
  INTO @sumAtasPenduduk from tblPenduduk;

SELECT ROUND(SUM(pow(tahunSensus-@avgXSensus, 2)),2)
  INTO @sumBawahPenduduk FROM tblPenduduk;
SELECT @sumAtasPenduduk / @sumBawahPenduduk INTO @betaPenduduk;
SELECT @avgYJmlh-(@betaPenduduk*@avgXSensus) INTO @alpaPenduduk;
SELECT @sumAtasPenduduk, @sumBawahPenduduk, @betaPenduduk, @alpaPenduduk;



/*Prediksi gaji*/
SELECT * FROM tblGaji;

SELECT AVG(lamaKerja) into @avgXkerja from tblGaji;
SELECT AVG(gaji) into @avgYgaji from tblGaji;
SELECT ROUND(@avgXkerja, 2) as RATAX, ROUND(@avgYgaji,2) as RATAY;

SELECT lamaKerja, @avgXkerja, ROUND(lamaKerja-@avgXkerja, 2) as 'Xi-Xrata'
from tblGaji;

SELECT gaji, @avgYgaji, ROUND(gaji-@avgYgaji, 2) 'Yi-Yrata'
from tblGaji;

SELECT SUM(ROUND(lamaKerja-@avgXkerja,2) * ROUND(gaji-@avgYgaji, 2))
  INTO @sumAtasGaji from tblGaji;

SELECT ROUND(SUM(pow(lamaKerja-@avgXkerja, 2)),2)
  INTO @sumBawahGaji FROM tblGaji;
SELECT @sumAtasGaji / @sumBawahGaji INTO @betaGaji;
SELECT @avgYgaji-(@betaGaji*@avgXkerja) INTO @alpaGaji;
SELECT @sumAtasGaji, @sumBawahGaji, @betaGaji, @alpaGaji;

INSERT INTO tblPrediksi VALUES
("Penduduk(juta jiwa)", 2020, @alpaPenduduk+(@betaPenduduk*2020)),
("Penduduk(juta jiwa)", 2025, @alpaPenduduk+(@betaPenduduk*2025)),
("Penduduk(juta jiwa)", 2050, @alpaPenduduk+(@betaPenduduk*2050)),
("Gaji(juta rupiah)", 10, @alpaGaji+(@betaGaji*10)),
("Gaji(juta rupiah)", 25, @alpaGaji+(@betaGaji*25));

SELECT * FROM tblPrediksi;
