-- Elisabet Stefanny V C
-- 18K10031
DROP DATABASE IF EXISTS dbUAS;
CREATE DATABASE dbUAS;
USE dbUAS;
  CREATE TABLE tblData (
    pasien VARCHAR(10),
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
    gain DECIMAL(8,4)
  );

  CREATE TABLE tblTemporary (
    iterasi INT,
    atribut VARCHAR(25),
    hitung_Gain DECIMAL(8,4)
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
    CREATE FUNCTION sfHitungData(vAtribut VARCHAR(25),vInformasi VARCHAR(25),keterangan VARCHAR(25))
    RETURNS INT
    BEGIN
      DECLARE vResult INT;
      IF vAtribut IS NOT NULL THEN
        IF vAtribut = 'demam' AND vInformasi IS NOT NULL THEN
          SELECT COUNT(*) INTO vResult FROM tblData WHERE demam = vInformasi AND diagnosa = keterangan;
        ELSEIF vAtribut = 'sakit_kepala' AND vInformasi IS NOT NULL THEN
          SELECT COUNT(*) INTO vResult FROM tblData WHERE sakit_kepala = vInformasi AND diagnosa = keterangan;
        ELSEIF vAtribut = 'nyeri' AND vInformasi IS NOT NULL THEN
          SELECT COUNT(*) INTO vResult FROM tblData WHERE nyeri = vInformasi AND diagnosa = keterangan;
        ELSEIF vAtribut = 'lemas' AND vInformasi IS NOT NULL THEN
          SELECT COUNT(*) INTO vResult FROM tblData WHERE lemas = vInformasi AND diagnosa = keterangan;
        ELSEIF vAtribut = 'kelelahan' AND vInformasi IS NOT NULL THEN
          SELECT COUNT(*) INTO vResult FROM tblData WHERE kelelahan = vInformasi AND diagnosa = keterangan;
        ELSEIF vAtribut = 'hidung_tersumbat' AND vInformasi IS NOT NULL THEN
          SELECT COUNT(*) INTO vResult FROM tblData WHERE hidung_tersumbat = vInformasi AND diagnosa = keterangan;
        ELSEIF vAtribut = 'bersin' AND vInformasi IS NOT NULL THEN
          SELECT COUNT(*) INTO vResult FROM tblData WHERE bersin = vInformasi AND diagnosa = keterangan;
        ELSEIF vAtribut = 'sakit_tenggorokan' AND vInformasi IS NOT NULL THEN
          SELECT COUNT(*) INTO vResult FROM tblData WHERE sakit_tenggorokan = vInformasi AND diagnosa = keterangan;
        ELSEIF vAtribut = 'sulit_bernafas' AND vInformasi IS NOT NULL THEN
          SELECT COUNT(*) INTO vResult FROM tblData WHERE sulit_bernafas = vInformasi AND diagnosa = keterangan;
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
    CREATE FUNCTION sfHitungEntropy(vDemam INT, vFlu INT)
    RETURNS DECIMAL(8,4)
    BEGIN
      DECLARE vHasil DECIMAL(8,4);
      SET vHasil = (-(vDemam/(vDemam+vFlu)*LOG2(vDemam/(vDemam+vFlu)))) + (-(vFlu/(vDemam+vFlu)*LOG2(vFlu/(vDemam+vFlu))));
      RETURN vHasil;
    END ##
    DELIMITER ;

    DELIMITER ##
    CREATE FUNCTION sfHitungGain(vEntropy DECIMAL(8,4), vSum DECIMAL(8,4))
    RETURNS DECIMAL(8,4)
    BEGIN
      DECLARE vGain DECIMAL(8,4);
      SELECT vEntropy - vSum INTO vGain;
      RETURN vGain;
    END ##
    DELIMITER ;

    DELIMITER ##
    CREATE PROCEDURE spAwal()
    BEGIN
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
    END ##
    DELIMITER ;

    DELIMITER ##
    CREATE PROCEDURE spHitung()
    BEGIN
      DECLARE vJumlahData, vJumlahFlu, vJumlahDemam INT;
      DECLARE vEntropy, vGain DECIMAL(8,4) DEFAULT 0;
      DECLARE vIterasi INT DEFAULT 1;
      SELECT MAX(gain) INTO vGain FROM tblHitung;
      SELECT MAX(entropy) INTO vEntropy FROM tblHitung;
      SELECT COUNT(diagnosa) INTO vJumlahData FROM tblData;
      SELECT COUNT(diagnosa) INTO vJumlahDemam FROM tblData WHERE diagnosa = 'Demam';
      SELECT COUNT(diagnosa) INTO vJumlahFlu FROM tblData WHERE diagnosa = 'Flu';
      SELECT sfHitungEntropy(vJumlahDemam, vJumlahFlu) INTO vEntropy;
      SET vGain = 0;

      INSERT INTO tblHitung(atribut,jumlahdata,demam,flu,entropy,gain) VALUES ('Total Data',vJumlahData,vJumlahDemam,vJumlahFlu,vEntropy,vGain);

      CALL spAwal();

      UPDATE tblHitung SET iterasi = vIterasi WHERE iterasi IS NULL;
      BEGIN
        DECLARE vJumData, i INT DEFAULT 0;
        DECLARE vAtribut, vInformasi VARCHAR(25);
        DECLARE vTotalData INT;
        DECLARE vJumlahData, vJumlahDemam, vJumlahFlu INT;
        DECLARE vEntropy, vHitungGain DECIMAL(8, 4);
        DECLARE cHitung CURSOR FOR
          SELECT atribut, informasi FROM tblHitung;

        SELECT COUNT(*) INTO vJumData FROM tblHitung;
        SELECT MAX(jumlahdata) INTO vTotalData FROM tblHitung WHERE iterasi = vIterasi;

        OPEN cHitung;
        WHILE i <> vJumData DO
          FETCH cHitung INTO vAtribut, vInformasi;
          IF vInformasi IS NOT NULL THEN
            SELECT sfHitungData(vAtribut,vInformasi,'Demam') INTO vJumlahDemam;
            SELECT sfHitungData(vAtribut,vInformasi,'Flu') INTO vJumlahFlu;
            SELECT vJumlahDemam + vJumlahFlu INTO vJumlahData;
            IF vJumlahDemam <> 0 AND vJumlahFlu <> 0 THEN
              SELECT sfHitungEntropy(vJumlahDemam,vJumlahFlu) INTO vEntropy;
            ELSE
              SET vEntropy = 0;
            END IF;
            SELECT (vJumlahData/vTotalData) * vEntropy INTO vHitungGain;
            UPDATE tblHitung SET jumlahdata = vJumlahData, demam = vJumlahDemam, flu = vJumlahFlu, entropy = vEntropy
            WHERE atribut = vAtribut AND informasi = vInformasi AND gain IS NULL;
            INSERT INTO tblTemporary VALUES (vIterasi,vAtribut,vHitungGain);
          END IF;
          SET i = i + 1;
        END WHILE;
        CLOSE cHitung;
      END ;

      BEGIN
        DECLARE vJumData, i INT DEFAULT 0;
        DECLARE vMain_Entropy DECIMAL(8,4);
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
          SELECT SUM(hitung_Gain) INTO vTotalHitGain FROM tblTemporary WHERE atribut = vAtribut AND iterasi = vIterasi;
          SELECT sfHitungGain(vMain_Entropy,vTotalHitGain) INTO vGain;
          UPDATE tblHitung SET gain = vGain WHERE (gain IS NULL AND atribut = vAtribut) AND iterasi = vIterasi;
          SET i = i + 1;
        END WHILE;
        CLOSE cHitung;
      END ;
    END ##
    DELIMITER ;

    CALL spHitung();

    SELECT * FROM tblData;
    SELECT * FROM tblHitung;
