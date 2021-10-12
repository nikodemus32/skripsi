/*
  NAMA : FIDELIS RAYMOND JOSE A
  NIM  : 18.K1.0062
  UAS DATA MINING
  SENIN, 11 JANUARI 2021
*/
DROP DATABASE IF EXISTS dbUASC45;
CREATE DATABASE dbUASC45;
USE dbUASC45;
  CREATE TABLE tblData (
    kode VARCHAR(10),
    demam VARCHAR(10),
    sakit_kepala VARCHAR(10),
    nyeri VARCHAR(10),
    lemas VARCHAR(10),
    kelelahan VARCHAR(10),
    hidung_tersumbat VARCHAR(10),
    bersin VARCHAR(10),
    sakit_tenggorokan VARCHAR(10),
    sulit_bernafas VARCHAR(10),
    diagnosa VARCHAR(10)
  );

  CREATE TABLE tblHitung (
    iterasi INT,
    atribut VARCHAR(25),
    informasi VARCHAR(10),
    jumlahdata INT,
    demam INT,
    flu INT,
    entropy DECIMAL(8,4),
    hit_gain DECIMAL(8,4),
    gain DECIMAL(8,4)
  );

  INSERT INTO tblData VALUES
    ('P1','Tidak','Ringan','Tidak','Tidak','Tidak','Ringan','Parah','Parah','Ringan','Demam'),
    ('P2','Parah','Parah','Parah','Parah','Parah','Tidak','Tidak','Parah','Parah','Flu '),
    ('P3','Parah','Parah','Ringan','Parah','Parah','Parah','Tidak','Parah','Parah','Flu'),
    ('P4','Tidak','Tidak','Tidak','Ringan','Tidak','Parah','Tidak','Ringan','Ringan','Demam'),
    ('P5','Parah','Parah','Ringan','Parah','Parah','Parah','Tidak','Parah','Parah','Flu'),
    ('P6','Tidak','Tidak','Tidak','Ringan','Tidak','Parah','Parah','Parah','Tidak','Demam'),
    ('P7','Parah','Parah','Parah','Parah','Parah','Tidak','Tidak','Tidak','Parah','Flu'),
    ('P8','Tidak','Tidak','Tidak','Tidak','Tidak','Parah','Parah','Tidak','Ringan','Demam'),
    ('P9','Tidak','Ringan','Ringan','Tidak','Tidak','Parah','Parah','Parah','Parah','Demam'),
    ('P10','Parah','Parah','Parah','Ringan','Ringan','Tidak','Parah','Tidak','Parah','Flu'),
    ('P11','Tidak','Tidak','Tidak','Ringan','Tidak','Parah','Ringan','Parah','Tidak','Demam'),
    ('P12','Parah','Ringan','Parah','Ringan','Parah','Tidak','Parah','Tidak','Ringan','Flu'),
    ('P13','Tidak','Tidak','Ringan','Ringan','Tidak','Parah','Parah','Parah','Tidak','Demam'),
    ('P14','Parah','Parah','Parah','Parah','Ringan','Tidak','Parah','Parah','Parah','Flu'),
    ('P15','Ringan','Tidak','Tidak','Ringan','Tidak','Parah','Tidak','Parah','Ringan','Demam'),
    ('P16','Tidak','Tidak','Tidak','Tidak','Tidak','Parah','Parah','Parah','Parah','Demam'),
    ('P17','Parah','Ringan','Parah','Ringan','Ringan','Tidak','Tidak','Tidak','Parah','Flu');

    DELIMITER ##
    CREATE FUNCTION sfHitungData(namaKolom1 VARCHAR(25),keteranganKolom1 VARCHAR(25),namaKolom2 VARCHAR(25),keteranganKolom2 VARCHAR(25),keterangan VARCHAR(25))
    RETURNS INT
    BEGIN
      DECLARE vResult INT;
      IF namaKolom1 IS NOT NULL THEN
        IF namaKolom1 = 'demam' AND keteranganKolom1 IS NOT NULL THEN
          IF namaKolom2 = 'sakit_kepala' AND keteranganKolom2 IS NOT NULL THEN
            SELECT COUNT(*) INTO vResult FROM tblData WHERE demam = keteranganKolom1 AND sakit_kepala = keteranganKolom2 AND diagnosa = keterangan;
          ELSEIF namaKolom2 = 'nyeri' AND keteranganKolom2 IS NOT NULL THEN
            SELECT COUNT(*) INTO vResult FROM tblData WHERE demam = keteranganKolom1 AND nyeri = keteranganKolom2 AND diagnosa = keterangan;
          ELSEIF namaKolom2 = 'lemas' AND keteranganKolom2 IS NOT NULL THEN
            SELECT COUNT(*) INTO vResult FROM tblData WHERE demam = keteranganKolom1 AND lemas = keteranganKolom2 AND diagnosa = keterangan;
          ELSEIF namaKolom2 = 'kelelahan' AND keteranganKolom2 IS NOT NULL THEN
            SELECT COUNT(*) INTO vResult FROM tblData WHERE demam = keteranganKolom1 AND kelelahan = keteranganKolom2 AND diagnosa = keterangan;
          ELSEIF namaKolom2 = 'hidung_tersumbat' AND keteranganKolom2 IS NOT NULL THEN
            SELECT COUNT(*) INTO vResult FROM tblData WHERE demam = keteranganKolom1 AND hidung_tersumbat = keteranganKolom2 AND diagnosa = keterangan;
          ELSEIF namaKolom2 = 'bersin' AND keteranganKolom2 IS NOT NULL THEN
            SELECT COUNT(*) INTO vResult FROM tblData WHERE demam = keteranganKolom1 AND bersin = keteranganKolom2 AND diagnosa = keterangan;
          ELSEIF namaKolom2 = 'sakit_tenggorokan' AND keteranganKolom2 IS NOT NULL THEN
            SELECT COUNT(*) INTO vResult FROM tblData WHERE demam = keteranganKolom1 AND sakit_tenggorokan = keteranganKolom2 AND diagnosa = keterangan;
          ELSEIF namaKolom2 = 'sulit_bernafas' AND keteranganKolom2 IS NOT NULL THEN
            SELECT COUNT(*) INTO vResult FROM tblData WHERE demam = keteranganKolom1 AND sulit_bernafas = keteranganKolom2 AND diagnosa = keterangan;
          ELSE
            SELECT COUNT(*) INTO vResult FROM tblData WHERE demam = keteranganKolom1 AND diagnosa = keterangan;
          END IF;
        ELSEIF namaKolom1 = 'sakit_kepala' AND keteranganKolom1 IS NOT NULL THEN
          IF namaKolom2 = 'demam' AND keteranganKolom2 IS NOT NULL THEN
            SELECT COUNT(*) INTO vResult FROM tblData WHERE sakit_kepala = keteranganKolom1 AND demam = keteranganKolom2 AND diagnosa = keterangan;
          ELSEIF namaKolom2 = 'nyeri' AND keteranganKolom2 IS NOT NULL THEN
            SELECT COUNT(*) INTO vResult FROM tblData WHERE sakit_kepala = keteranganKolom1 AND nyeri = keteranganKolom2 AND diagnosa = keterangan;
          ELSEIF namaKolom2 = 'lemas' AND keteranganKolom2 IS NOT NULL THEN
            SELECT COUNT(*) INTO vResult FROM tblData WHERE sakit_kepala = keteranganKolom1 AND lemas = keteranganKolom2 AND diagnosa = keterangan;
          ELSEIF namaKolom2 = 'kelelahan' AND keteranganKolom2 IS NOT NULL THEN
            SELECT COUNT(*) INTO vResult FROM tblData WHERE sakit_kepala = keteranganKolom1 AND kelelahan = keteranganKolom2 AND diagnosa = keterangan;
          ELSEIF namaKolom2 = 'hidung_tersumbat' AND keteranganKolom2 IS NOT NULL THEN
            SELECT COUNT(*) INTO vResult FROM tblData WHERE sakit_kepala = keteranganKolom1 AND hidung_tersumbat = keteranganKolom2 AND diagnosa = keterangan;
          ELSEIF namaKolom2 = 'bersin' AND keteranganKolom2 IS NOT NULL THEN
            SELECT COUNT(*) INTO vResult FROM tblData WHERE sakit_kepala = keteranganKolom1 AND bersin = keteranganKolom2 AND diagnosa = keterangan;
          ELSEIF namaKolom2 = 'sakit_tenggorokan' AND keteranganKolom2 IS NOT NULL THEN
            SELECT COUNT(*) INTO vResult FROM tblData WHERE sakit_kepala = keteranganKolom1 AND sakit_tenggorokan = keteranganKolom2 AND diagnosa = keterangan;
          ELSEIF namaKolom2 = 'sulit_bernafas' AND keteranganKolom2 IS NOT NULL THEN
            SELECT COUNT(*) INTO vResult FROM tblData WHERE sakit_kepala = keteranganKolom1 AND sulit_bernafas = keteranganKolom2 AND diagnosa = keterangan;
          ELSE
            SELECT COUNT(*) INTO vResult FROM tblData WHERE sakit_kepala = keteranganKolom1 AND diagnosa = keterangan;
          END IF;
        ELSEIF namaKolom1 = 'nyeri' AND keteranganKolom1 IS NOT NULL THEN
          IF namaKolom2 = 'sakit_kepala' AND keteranganKolom2 IS NOT NULL THEN
            SELECT COUNT(*) INTO vResult FROM tblData WHERE nyeri = keteranganKolom1 AND sakit_kepala = keteranganKolom2 AND diagnosa = keterangan;
          ELSEIF namaKolom2 = 'demam' AND keteranganKolom2 IS NOT NULL THEN
            SELECT COUNT(*) INTO vResult FROM tblData WHERE nyeri = keteranganKolom1 AND demam = keteranganKolom2 AND diagnosa = keterangan;
          ELSEIF namaKolom2 = 'lemas' AND keteranganKolom2 IS NOT NULL THEN
            SELECT COUNT(*) INTO vResult FROM tblData WHERE nyeri = keteranganKolom1 AND lemas = keteranganKolom2 AND diagnosa = keterangan;
          ELSEIF namaKolom2 = 'kelelahan' AND keteranganKolom2 IS NOT NULL THEN
            SELECT COUNT(*) INTO vResult FROM tblData WHERE nyeri = keteranganKolom1 AND kelelahan = keteranganKolom2 AND diagnosa = keterangan;
          ELSEIF namaKolom2 = 'hidung_tersumbat' AND keteranganKolom2 IS NOT NULL THEN
            SELECT COUNT(*) INTO vResult FROM tblData WHERE nyeri = keteranganKolom1 AND hidung_tersumbat = keteranganKolom2 AND diagnosa = keterangan;
          ELSEIF namaKolom2 = 'bersin' AND keteranganKolom2 IS NOT NULL THEN
            SELECT COUNT(*) INTO vResult FROM tblData WHERE nyeri = keteranganKolom1 AND bersin = keteranganKolom2 AND diagnosa = keterangan;
          ELSEIF namaKolom2 = 'sakit_tenggorokan' AND keteranganKolom2 IS NOT NULL THEN
            SELECT COUNT(*) INTO vResult FROM tblData WHERE nyeri = keteranganKolom1 AND sakit_tenggorokan = keteranganKolom2 AND diagnosa = keterangan;
          ELSEIF namaKolom2 = 'sulit_bernafas' AND keteranganKolom2 IS NOT NULL THEN
            SELECT COUNT(*) INTO vResult FROM tblData WHERE nyeri = keteranganKolom1 AND sulit_bernafas = keteranganKolom2 AND diagnosa = keterangan;
          ELSE
            SELECT COUNT(*) INTO vResult FROM tblData WHERE nyeri = keteranganKolom1 AND diagnosa = keterangan;
          END IF;
        ELSEIF namaKolom1 = 'lemas' AND keteranganKolom1 IS NOT NULL THEN
          IF namaKolom2 = 'sakit_kepala' AND keteranganKolom2 IS NOT NULL THEN
            SELECT COUNT(*) INTO vResult FROM tblData WHERE lemas = keteranganKolom1 AND sakit_kepala = keteranganKolom2 AND diagnosa = keterangan;
          ELSEIF namaKolom2 = 'nyeri' AND keteranganKolom2 IS NOT NULL THEN
            SELECT COUNT(*) INTO vResult FROM tblData WHERE lemas = keteranganKolom1 AND nyeri = keteranganKolom2 AND diagnosa = keterangan;
          ELSEIF namaKolom2 = 'demam' AND keteranganKolom2 IS NOT NULL THEN
            SELECT COUNT(*) INTO vResult FROM tblData WHERE lemas = keteranganKolom1 AND demam = keteranganKolom2 AND diagnosa = keterangan;
          ELSEIF namaKolom2 = 'kelelahan' AND keteranganKolom2 IS NOT NULL THEN
            SELECT COUNT(*) INTO vResult FROM tblData WHERE lemas = keteranganKolom1 AND kelelahan = keteranganKolom2 AND diagnosa = keterangan;
          ELSEIF namaKolom2 = 'hidung_tersumbat' AND keteranganKolom2 IS NOT NULL THEN
            SELECT COUNT(*) INTO vResult FROM tblData WHERE lemas = keteranganKolom1 AND hidung_tersumbat = keteranganKolom2 AND diagnosa = keterangan;
          ELSEIF namaKolom2 = 'bersin' AND keteranganKolom2 IS NOT NULL THEN
            SELECT COUNT(*) INTO vResult FROM tblData WHERE lemas = keteranganKolom1 AND bersin = keteranganKolom2 AND diagnosa = keterangan;
          ELSEIF namaKolom2 = 'sakit_tenggorokan' AND keteranganKolom2 IS NOT NULL THEN
            SELECT COUNT(*) INTO vResult FROM tblData WHERE lemas = keteranganKolom1 AND sakit_tenggorokan = keteranganKolom2 AND diagnosa = keterangan;
          ELSEIF namaKolom2 = 'sulit_bernafas' AND keteranganKolom2 IS NOT NULL THEN
            SELECT COUNT(*) INTO vResult FROM tblData WHERE lemas = keteranganKolom1 AND sulit_bernafas = keteranganKolom2 AND diagnosa = keterangan;
          ELSE
            SELECT COUNT(*) INTO vResult FROM tblData WHERE lemas = keteranganKolom1 AND diagnosa = keterangan;
          END IF;
        ELSEIF namaKolom1 = 'kelelahan' AND keteranganKolom1 IS NOT NULL THEN
          IF namaKolom2 = 'sakit_kepala' AND keteranganKolom2 IS NOT NULL THEN
            SELECT COUNT(*) INTO vResult FROM tblData WHERE kelelahan = keteranganKolom1 AND sakit_kepala = keteranganKolom2 AND diagnosa = keterangan;
          ELSEIF namaKolom2 = 'nyeri' AND keteranganKolom2 IS NOT NULL THEN
            SELECT COUNT(*) INTO vResult FROM tblData WHERE kelelahan = keteranganKolom1 AND nyeri = keteranganKolom2 AND diagnosa = keterangan;
          ELSEIF namaKolom2 = 'lemas' AND keteranganKolom2 IS NOT NULL THEN
            SELECT COUNT(*) INTO vResult FROM tblData WHERE kelelahan = keteranganKolom1 AND lemas = keteranganKolom2 AND diagnosa = keterangan;
          ELSEIF namaKolom2 = 'demam' AND keteranganKolom2 IS NOT NULL THEN
            SELECT COUNT(*) INTO vResult FROM tblData WHERE kelelahan = keteranganKolom1 AND demam = keteranganKolom2 AND diagnosa = keterangan;
          ELSEIF namaKolom2 = 'hidung_tersumbat' AND keteranganKolom2 IS NOT NULL THEN
            SELECT COUNT(*) INTO vResult FROM tblData WHERE kelelahan = keteranganKolom1 AND hidung_tersumbat = keteranganKolom2 AND diagnosa = keterangan;
          ELSEIF namaKolom2 = 'bersin' AND keteranganKolom2 IS NOT NULL THEN
            SELECT COUNT(*) INTO vResult FROM tblData WHERE kelelahan = keteranganKolom1 AND bersin = keteranganKolom2 AND diagnosa = keterangan;
          ELSEIF namaKolom2 = 'sakit_tenggorokan' AND keteranganKolom2 IS NOT NULL THEN
            SELECT COUNT(*) INTO vResult FROM tblData WHERE kelelahan = keteranganKolom1 AND sakit_tenggorokan = keteranganKolom2 AND diagnosa = keterangan;
          ELSEIF namaKolom2 = 'sulit_bernafas' AND keteranganKolom2 IS NOT NULL THEN
            SELECT COUNT(*) INTO vResult FROM tblData WHERE kelelahan = keteranganKolom1 AND sulit_bernafas = keteranganKolom2 AND diagnosa = keterangan;
          ELSE
            SELECT COUNT(*) INTO vResult FROM tblData WHERE kelelahan = keteranganKolom1 AND diagnosa = keterangan;
          END IF;
        ELSEIF namaKolom1 = 'hidung_tersumbat' AND keteranganKolom1 IS NOT NULL THEN
          IF namaKolom2 = 'sakit_kepala' AND keteranganKolom2 IS NOT NULL THEN
            SELECT COUNT(*) INTO vResult FROM tblData WHERE hidung_tersumbat = keteranganKolom1 AND sakit_kepala = keteranganKolom2 AND diagnosa = keterangan;
          ELSEIF namaKolom2 = 'nyeri' AND keteranganKolom2 IS NOT NULL THEN
            SELECT COUNT(*) INTO vResult FROM tblData WHERE hidung_tersumbat = keteranganKolom1 AND nyeri = keteranganKolom2 AND diagnosa = keterangan;
          ELSEIF namaKolom2 = 'lemas' AND keteranganKolom2 IS NOT NULL THEN
            SELECT COUNT(*) INTO vResult FROM tblData WHERE hidung_tersumbat = keteranganKolom1 AND lemas = keteranganKolom2 AND diagnosa = keterangan;
          ELSEIF namaKolom2 = 'kelelahan' AND keteranganKolom2 IS NOT NULL THEN
            SELECT COUNT(*) INTO vResult FROM tblData WHERE hidung_tersumbat = keteranganKolom1 AND kelelahan = keteranganKolom2 AND diagnosa = keterangan;
          ELSEIF namaKolom2 = 'demam' AND keteranganKolom2 IS NOT NULL THEN
            SELECT COUNT(*) INTO vResult FROM tblData WHERE hidung_tersumbat = keteranganKolom1 AND demam = keteranganKolom2 AND diagnosa = keterangan;
          ELSEIF namaKolom2 = 'bersin' AND keteranganKolom2 IS NOT NULL THEN
            SELECT COUNT(*) INTO vResult FROM tblData WHERE hidung_tersumbat = keteranganKolom1 AND bersin = keteranganKolom2 AND diagnosa = keterangan;
          ELSEIF namaKolom2 = 'sakit_tenggorokan' AND keteranganKolom2 IS NOT NULL THEN
            SELECT COUNT(*) INTO vResult FROM tblData WHERE hidung_tersumbat = keteranganKolom1 AND sakit_tenggorokan = keteranganKolom2 AND diagnosa = keterangan;
          ELSEIF namaKolom2 = 'sulit_bernafas' AND keteranganKolom2 IS NOT NULL THEN
            SELECT COUNT(*) INTO vResult FROM tblData WHERE hidung_tersumbat = keteranganKolom1 AND sulit_bernafas = keteranganKolom2 AND diagnosa = keterangan;
          ELSE
            SELECT COUNT(*) INTO vResult FROM tblData WHERE hidung_tersumbat = keteranganKolom1 AND diagnosa = keterangan;
          END IF;
        ELSEIF namaKolom1 = 'bersin' AND keteranganKolom1 IS NOT NULL THEN
          IF namaKolom2 = 'sakit_kepala' AND keteranganKolom2 IS NOT NULL THEN
            SELECT COUNT(*) INTO vResult FROM tblData WHERE bersin = keteranganKolom1 AND sakit_kepala = keteranganKolom2 AND diagnosa = keterangan;
          ELSEIF namaKolom2 = 'nyeri' AND keteranganKolom2 IS NOT NULL THEN
            SELECT COUNT(*) INTO vResult FROM tblData WHERE bersin = keteranganKolom1 AND nyeri = keteranganKolom2 AND diagnosa = keterangan;
          ELSEIF namaKolom2 = 'lemas' AND keteranganKolom2 IS NOT NULL THEN
            SELECT COUNT(*) INTO vResult FROM tblData WHERE bersin = keteranganKolom1 AND lemas = keteranganKolom2 AND diagnosa = keterangan;
          ELSEIF namaKolom2 = 'kelelahan' AND keteranganKolom2 IS NOT NULL THEN
            SELECT COUNT(*) INTO vResult FROM tblData WHERE bersin = keteranganKolom1 AND kelelahan = keteranganKolom2 AND diagnosa = keterangan;
          ELSEIF namaKolom2 = 'hidung_tersumbat' AND keteranganKolom2 IS NOT NULL THEN
            SELECT COUNT(*) INTO vResult FROM tblData WHERE bersin = keteranganKolom1 AND hidung_tersumbat = keteranganKolom2 AND diagnosa = keterangan;
          ELSEIF namaKolom2 = 'demam' AND keteranganKolom2 IS NOT NULL THEN
            SELECT COUNT(*) INTO vResult FROM tblData WHERE bersin = keteranganKolom1 AND demam = keteranganKolom2 AND diagnosa = keterangan;
          ELSEIF namaKolom2 = 'sakit_tenggorokan' AND keteranganKolom2 IS NOT NULL THEN
            SELECT COUNT(*) INTO vResult FROM tblData WHERE bersin = keteranganKolom1 AND sakit_tenggorokan = keteranganKolom2 AND diagnosa = keterangan;
          ELSEIF namaKolom2 = 'sulit_bernafas' AND keteranganKolom2 IS NOT NULL THEN
            SELECT COUNT(*) INTO vResult FROM tblData WHERE bersin = keteranganKolom1 AND sulit_bernafas = keteranganKolom2 AND diagnosa = keterangan;
          ELSE
            SELECT COUNT(*) INTO vResult FROM tblData WHERE bersin = keteranganKolom1 AND diagnosa = keterangan;
          END IF;
        ELSEIF namaKolom1 = 'sakit_tenggorokan' AND keteranganKolom1 IS NOT NULL THEN
          IF namaKolom2 = 'sakit_kepala' AND keteranganKolom2 IS NOT NULL THEN
            SELECT COUNT(*) INTO vResult FROM tblData WHERE sakit_tenggorokan = keteranganKolom1 AND sakit_kepala = keteranganKolom2 AND diagnosa = keterangan;
          ELSEIF namaKolom2 = 'nyeri' AND keteranganKolom2 IS NOT NULL THEN
            SELECT COUNT(*) INTO vResult FROM tblData WHERE sakit_tenggorokan = keteranganKolom1 AND nyeri = keteranganKolom2 AND diagnosa = keterangan;
          ELSEIF namaKolom2 = 'lemas' AND keteranganKolom2 IS NOT NULL THEN
            SELECT COUNT(*) INTO vResult FROM tblData WHERE sakit_tenggorokan = keteranganKolom1 AND lemas = keteranganKolom2 AND diagnosa = keterangan;
          ELSEIF namaKolom2 = 'kelelahan' AND keteranganKolom2 IS NOT NULL THEN
            SELECT COUNT(*) INTO vResult FROM tblData WHERE sakit_tenggorokan = keteranganKolom1 AND kelelahan = keteranganKolom2 AND diagnosa = keterangan;
          ELSEIF namaKolom2 = 'hidung_tersumbat' AND keteranganKolom2 IS NOT NULL THEN
            SELECT COUNT(*) INTO vResult FROM tblData WHERE sakit_tenggorokan = keteranganKolom1 AND hidung_tersumbat = keteranganKolom2 AND diagnosa = keterangan;
          ELSEIF namaKolom2 = 'bersin' AND keteranganKolom2 IS NOT NULL THEN
            SELECT COUNT(*) INTO vResult FROM tblData WHERE sakit_tenggorokan = keteranganKolom1 AND bersin = keteranganKolom2 AND diagnosa = keterangan;
          ELSEIF namaKolom2 = 'demam' AND keteranganKolom2 IS NOT NULL THEN
            SELECT COUNT(*) INTO vResult FROM tblData WHERE sakit_tenggorokan = keteranganKolom1 AND demam = keteranganKolom2 AND diagnosa = keterangan;
          ELSEIF namaKolom2 = 'sulit_bernafas' AND keteranganKolom2 IS NOT NULL THEN
            SELECT COUNT(*) INTO vResult FROM tblData WHERE sakit_tenggorokan = keteranganKolom1 AND sulit_bernafas = keteranganKolom2 AND diagnosa = keterangan;
          ELSE
            SELECT COUNT(*) INTO vResult FROM tblData WHERE sakit_tenggorokan = keteranganKolom1 AND diagnosa = keterangan;
          END IF;
        ELSEIF namaKolom1 = 'sulit_bernafas' AND keteranganKolom1 IS NOT NULL THEN
          IF namaKolom2 = 'sakit_kepala' AND keteranganKolom2 IS NOT NULL THEN
            SELECT COUNT(*) INTO vResult FROM tblData WHERE sulit_bernafas = keteranganKolom1 AND sakit_kepala = keteranganKolom2 AND diagnosa = keterangan;
          ELSEIF namaKolom2 = 'nyeri' AND keteranganKolom2 IS NOT NULL THEN
            SELECT COUNT(*) INTO vResult FROM tblData WHERE sulit_bernafas = keteranganKolom1 AND nyeri = keteranganKolom2 AND diagnosa = keterangan;
          ELSEIF namaKolom2 = 'lemas' AND keteranganKolom2 IS NOT NULL THEN
            SELECT COUNT(*) INTO vResult FROM tblData WHERE sulit_bernafas = keteranganKolom1 AND lemas = keteranganKolom2 AND diagnosa = keterangan;
          ELSEIF namaKolom2 = 'kelelahan' AND keteranganKolom2 IS NOT NULL THEN
            SELECT COUNT(*) INTO vResult FROM tblData WHERE sulit_bernafas = keteranganKolom1 AND kelelahan = keteranganKolom2 AND diagnosa = keterangan;
          ELSEIF namaKolom2 = 'hidung_tersumbat' AND keteranganKolom2 IS NOT NULL THEN
            SELECT COUNT(*) INTO vResult FROM tblData WHERE sulit_bernafas = keteranganKolom1 AND hidung_tersumbat = keteranganKolom2 AND diagnosa = keterangan;
          ELSEIF namaKolom2 = 'bersin' AND keteranganKolom2 IS NOT NULL THEN
            SELECT COUNT(*) INTO vResult FROM tblData WHERE sulit_bernafas = keteranganKolom1 AND bersin = keteranganKolom2 AND diagnosa = keterangan;
          ELSEIF namaKolom2 = 'sakit_tenggorokan' AND keteranganKolom2 IS NOT NULL THEN
            SELECT COUNT(*) INTO vResult FROM tblData WHERE sulit_bernafas = keteranganKolom1 AND sakit_tenggorokan = keteranganKolom2 AND diagnosa = keterangan;
          ELSEIF namaKolom2 = 'demam' AND keteranganKolom2 IS NOT NULL THEN
            SELECT COUNT(*) INTO vResult FROM tblData WHERE sulit_bernafas = keteranganKolom1 AND demam = keteranganKolom2 AND diagnosa = keterangan;
          ELSE
            SELECT COUNT(*) INTO vResult FROM tblData WHERE sulit_bernafas = keteranganKolom1 AND diagnosa = keterangan;
          END IF;
        ELSE
          SELECT COUNT(*) INTO vResult FROM tblData WHERE diagnosa = keterangan;
        END IF;
      ELSE
        SELECT COUNT(*) INTO vResult FROM tblData;
      END IF;
      RETURN vResult;
    END ##
    DELIMITER ;

    DELIMITER ##
    CREATE FUNCTION sfHitungEntropy(demam INT, flu INT)
    RETURNS DECIMAL(8,4)
    BEGIN
      DECLARE vResult DECIMAL(8,4);
      SET vResult = (-(demam/(demam+flu)*LOG2(demam/(demam+flu)))) + (-(flu/(demam+flu)*LOG2(flu/(demam+flu))));
      RETURN vResult;
    END ##
    DELIMITER ;

    DELIMITER ##
    CREATE FUNCTION sfHitungGain(vEntropy DECIMAL(8,4), vTotalHitGain DECIMAL(8,4))
    RETURNS DECIMAL(8,4)
    BEGIN
      DECLARE vGain DECIMAL(8,4);
      SELECT vEntropy - vTotalHitGain INTO vGain;
      RETURN vGain;
    END ##
    DELIMITER ;

    DELIMITER ##
    CREATE PROCEDURE spHitung(vIterasi INT,vAtribut2 VARCHAR(25), vInformasi2 VARCHAR(25))
    BEGIN
      DECLARE vJumData, i INT DEFAULT 0;
      DECLARE vAtribut, vInformasi VARCHAR(25);
      DECLARE vTotalData INT;
      DECLARE vJumlahData, vJumlahDemam, vJumlahFlu INT;
      DECLARE vEntropy, vHit_Gain DECIMAL(8, 4);
      DECLARE cHitung CURSOR FOR
        SELECT atribut, informasi FROM tblHitung;

      SELECT COUNT(*) INTO vJumData FROM tblHitung;
      SELECT MAX(jumlahdata) INTO vTotalData FROM tblHitung WHERE iterasi = vIterasi;

      -- IF vIterasi = 1 THEN
      OPEN cHitung;
      WHILE i <> vJumData DO
        FETCH cHitung INTO vAtribut, vInformasi;
        IF vInformasi IS NOT NULL THEN
          SELECT sfHitungData(vAtribut,vInformasi,vAtribut2,vInformasi2,'Demam') INTO vJumlahDemam;
          SELECT sfHitungData(vAtribut,vInformasi,vAtribut2,vInformasi2,'Flu') INTO vJumlahFlu;
          SELECT vJumlahDemam + vJumlahFlu INTO vJumlahData;
          IF vJumlahDemam <> 0 AND vJumlahFlu <> 0 THEN
            SELECT sfHitungEntropy(vJumlahDemam,vJumlahFlu) INTO vEntropy;
          ELSE
            SET vEntropy = 0;
          END IF;
          SELECT (vJumlahData/vTotalData) * vEntropy INTO vHit_Gain;
          UPDATE tblHitung SET jumlahdata = vJumlahData, demam = vJumlahDemam, flu = vJumlahFlu, entropy = vEntropy, hit_gain = vHit_Gain WHERE atribut = vAtribut AND informasi = vInformasi AND gain IS NULL;
        END IF;
        SET i = i + 1;
      END WHILE;
      CLOSE cHitung;
    END ##
    DELIMITER ;

    DELIMITER ##
    CREATE PROCEDURE spHitungGain(vIterasi INT)
    BEGIN
      DECLARE vJumData, i INT DEFAULT 0;
      DECLARE vMain_Entropy DECIMAL(8,4); -- Entropy Keseluruhan
      DECLARE vTotalHitGain DECIMAL(8,4);
      DECLARE vGain DECIMAL(8,4);
      DECLARE vAtribut, vInformasi VARCHAR(25);
      DECLARE cHitung CURSOR FOR
        SELECT atribut
        FROM tblHitung
        WHERE iterasi = vIterasi AND informasi IS NOT NULL AND gain IS NULL
        GROUP BY atribut;
      SELECT COUNT(DISTINCT atribut) INTO vJumData
      FROM tblHitung
      WHERE iterasi = vIterasi AND informasi IS NOT NULL AND gain IS NULL;

      SELECT MAX(entropy) INTO vMain_Entropy
      FROM tblHitung
      WHERE iterasi = vIterasi AND gain IS NOT NULL;

      OPEN cHitung;
      WHILE i <> vJumData DO
        FETCH cHitung INTO vAtribut;
        SELECT SUM(hit_gain) INTO vTotalHitGain FROM tblHitung WHERE atribut = vAtribut AND iterasi = vIterasi AND gain IS NULL;
        SELECT sfHitungGain(vMain_Entropy,vTotalHitGain) INTO vGain;
        UPDATE tblHitung SET gain = vGain WHERE (gain IS NULL AND atribut = vAtribut) AND iterasi = vIterasi;
        SET i = i + 1;
      END WHILE;
      CLOSE cHitung;

    END ##
    DELIMITER ;

    DELIMITER ##
    CREATE PROCEDURE spMulai()
    BEGIN
      DECLARE vJumlahData, vJumlahFlu, vJumlahDemam INT;
      DECLARE vEntropy, vGain DECIMAL(8,4) DEFAULT 0;
      DECLARE vIterasi INT DEFAULT 1;
      DECLARE vLanjut VARCHAR(7) DEFAULT 'YA';

      SELECT MAX(gain) INTO vGain FROM tblHitung;
      SELECT MAX(entropy) INTO vEntropy FROM tblHitung;

      WHILE vLanjut = 'YA' DO
        -- Awal
        IF vGain IS NULL AND vEntropy IS NULL THEN

          SELECT COUNT(diagnosa) INTO vJumlahData FROM tblData;
          SELECT COUNT(diagnosa) INTO vJumlahDemam FROM tblData WHERE diagnosa = 'Demam';
          SELECT COUNT(diagnosa) INTO vJumlahFlu FROM tblData WHERE diagnosa = 'Flu';
          SELECT sfHitungEntropy(vJumlahDemam, vJumlahFlu) INTO vEntropy;
          SET vGain = 0;

          INSERT INTO tblHitung(atribut,jumlahdata,demam,flu,entropy,gain) VALUES ('Total Data',vJumlahData,vJumlahDemam,vJumlahFlu,vEntropy,vGain);

          INSERT INTO tblHitung(informasi)
            SELECT demam FROM tblData GROUP BY demam;
          UPDATE tblHitung SET atribut = 'demam' WHERE atribut IS NULL;

          INSERT INTO tblHitung(informasi)
            SELECT sakit_kepala FROM tblData GROUP BY sakit_kepala;
          UPDATE tblHitung SET atribut = 'sakit_kepala' WHERE atribut IS NULL;

          INSERT INTO tblHitung(informasi)
            SELECT nyeri FROM tblData GROUP BY nyeri;
          UPDATE tblHitung SET atribut = 'nyeri' WHERE atribut IS NULL;

          INSERT INTO tblHitung(informasi)
            SELECT lemas FROM tblData GROUP BY lemas;
          UPDATE tblHitung SET atribut = 'lemas' WHERE atribut IS NULL;

          INSERT INTO tblHitung(informasi)
            SELECT kelelahan FROM tblData GROUP BY kelelahan;
          UPDATE tblHitung SET atribut = 'kelelahan' WHERE atribut IS NULL;

          INSERT INTO tblHitung(informasi)
            SELECT hidung_tersumbat FROM tblData GROUP BY hidung_tersumbat;
          UPDATE tblHitung SET atribut = 'hidung_tersumbat' WHERE atribut IS NULL;

          INSERT INTO tblHitung(informasi)
            SELECT bersin FROM tblData GROUP BY bersin;
          UPDATE tblHitung SET atribut = 'bersin' WHERE atribut IS NULL;

          INSERT INTO tblHitung(informasi)
            SELECT sakit_tenggorokan FROM tblData GROUP BY sakit_tenggorokan;
          UPDATE tblHitung SET atribut = 'sakit_tenggorokan' WHERE atribut IS NULL;

          INSERT INTO tblHitung(informasi)
            SELECT sulit_bernafas FROM tblData GROUP BY sulit_bernafas;
          UPDATE tblHitung SET atribut = 'sulit_bernafas' WHERE atribut IS NULL;


          UPDATE tblHitung SET iterasi = vIterasi WHERE iterasi IS NULL;
          CALL spHitung(vIterasi,NULL,NULL);
          -- Hitung Gain
          CALL spHitungGain(vIterasi);

          SELECT MAX(gain) INTO vGain FROM tblHitung WHERE demam <> 0 AND flu <> 0;
          SET vLanjut = 'YA';
          SET vIterasi = vIterasi + 1;
        ELSE
          BEGIN
            DECLARE vJumData, i INT DEFAULT 0;
            DECLARE vAtribut, vInformasi VARCHAR(25);
            DECLARE vTotalData, vDemam, vFlu INT;
            DECLARE vEntropy DECIMAL(8,4);
            DECLARE cHitung CURSOR FOR
              SELECT atribut, informasi, jumlahdata, demam, flu, entropy
              FROM tblHitung
              WHERE gain = vGain AND (demam <> 0 AND flu <> 0);
            SELECT COUNT(*) INTO vJumData FROM tblHitung WHERE gain = vGain AND (demam <> 0 AND flu <> 0);

            IF vJumData <> 1 THEN
              OPEN cHitung;
              WHILE i <> vJumData DO
                FETCH cHitung INTO vAtribut, vInformasi, vTotalData, vDemam, vFlu, vEntropy;
                INSERT INTO tblHitung(atribut,jumlahdata,demam,flu,entropy,gain) VALUES (CONCAT(vAtribut,' ',vInformasi),vTotalData,vDemam,vFlu,vEntropy,0);
                INSERT INTO tblHitung(atribut,informasi)
                  SELECT atribut, informasi FROM tblHitung WHERE gain < vGain AND informasi IS NOT NULL;

                UPDATE tblHitung SET iterasi = vIterasi WHERE iterasi IS NULL;
                SELECT vAtribut, vInformasi;
                CALL spHitung(vIterasi,vAtribut,vInformasi);
                CALL spHitungGain(vIterasi);
                SET i = i + 1;
              END WHILE;
              CLOSE cHitung;
            END IF;

            SET vLanjut = 'TIDAK';
          END ;
        END IF;
      END WHILE;

    END ##
    DELIMITER ;

    CALL spMulai();

    SELECT * FROM tblData;
    SELECT * FROM tblHitung;
