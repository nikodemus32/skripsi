DROP DATABASE IF EXISTS uasdbc45;
  CREATE DATABASE uasdbc45;
  USE uasdbc45;

CREATE TABLE tblData(
  idpasien varchar(3),
  demam varchar(30),
  sakitkepala varchar(30),
  nyeri varchar(30),
  lemas varchar(30),
  kelelahan varchar(30),
  hidungtersumbat varchar(30),
  bersin varchar(30),
  sakittenggorokan varchar(30),
  sulitbernafas varchar(30),
  diagnosa varchar(30)
);

INSERT INTO tblData VALUES
("P1", "Tidak", "Ringan", "Tidak","Tidak","Tidak","Ringan","Parah","Parah","Ringan","Demam"),
("P2", "Parah", "Parah", "Parah","Parah","Parah","Tidak","Tidak","Parah","Parah","Flu"),
("P3", "Parah", "Parah", "Ringan","Parah","Parah","Parah","Tidak","Parah","Parah","Flu"),
("P4", "Tidak", "Tidak", "Tidak","Ringan","Tidak","Parah","Tidak","Ringan","Ringan","Demam"),
("P5", "Parah", "Parah", "Ringan","Parah","Parah","Parah","Tidak","Parah","Parah","Flu"),
("P6" , "Tidak", "Tidak", "Tidak","Ringan","Tidak","Parah","Parah","Parah","Tidak","Demam"),
("P7", "Parah", "Parah", "Parah","Parah","Parah","Tidak","Tidak","Tidak","Parah","Flu"),
("P8", "Tidak", "Tidak", "Tidak","Tidak","Tidak","Parah","Parah","Tidak","Ringan","Demam"),
("P9", "Tidak", "Ringan", "Ringan","Tidak","Tidak","Parah","Parah","Parah","Parah","Demam"),
("P10", "Parah", "Parah", "Parah","Ringan","Ringan","Tidak","Parah","Tidak","Parah","Flu"),
("P11", "Tidak", "Tidak", "Tidak","Ringan","Tidak","Parah","Ringan","Parah","Tidak","Demam"),
("P12", "Parah", "Ringan", "Parah","Ringan","Parah","Tidak","Parah","Tidak","Ringan","Flu"),
("P13", "Tidak", "Tidak", "Ringan","Ringan","Tidak","Parah","Parah","Parah","Tidak","Demam"),
("P14", "Parah", "Parah", "Parah","Parah","Ringan","Tidak","Parah","Parah","Parah","Flu"),
("P15", "Ringan", "Tidak", "Tidak","Ringan","Tidak","Parah","Tidak","Parah","Ringan","Demam"),
("P16", "Tidak", "Tidak", "Tidak","Tidak","Tidak","Parah","Parah","Parah","Parah","Demam"),
("P17", "Parah", "Ringan", "Parah","Ringan","Ringan","Tidak","Tidak","Tidak","Parah","Flu");

-- INSERT INTO tblData VALUES
--   ("P18","Tidak","Ringan","Tidak","Tidak","Tidak","Ringan","Parah","Parah","Ringan","Flu"),
--   ("P19","Parah","Parah","Parah","Parah","Parah","Tidak","Tidak","Parah","Parah","Demam");
-- SELECT * FROM tblData;

CREATE TABLE tblOlahan(
  idpasien varchar(3),
  demam varchar(30),
  sakitkepala varchar(30),
  nyeri varchar(30),
  lemas varchar(30),
  kelelahan varchar(30),
  hidungtersumbat varchar(30),
  bersin varchar(30),
  sakittenggorokan varchar(30),
  sulitbernafas varchar(30),
  diagnosa varchar(30)
);

CREATE TABLE tblHitung(
	iterasi INT,
	atribut varchar(30),
	informasi VARCHAR(255),
	jumlahdata INT,
	diagnosaflu INT,
	diagnosademam INT,
	entropy DECIMAL(8,4),
	gain DECIMAL(8,4),
  status varchar(30)
);

CREATE TABLE tblStruktur(
  iterasi INT,
  demam varchar(30),
	sakitkepala varchar(30),
	nyeri varchar(30),
	lemas varchar(30),
  kelelahan varchar(30),
  hidungtersumbat varchar(30),
  bersin varchar(30),
  sakittenggorokan varchar(30),
  sulitbernafas varchar(30),
  diagnosa varchar(30)
  );

INSERT INTO tblStruktur(iterasi, diagnosa) VALUES (0,"lanjut");

SELECT * FROM tblStruktur;

DELIMITER $$
CREATE PROCEDURE spLoop()
	BEGIN
	DECLARE vIterasi INT DEFAULT 0;
	DECLARE vLanjut INT DEFAULT 1;

	WHILE vLanjut <> 0  DO

		SELECT vIterasi+1 AS looping;

		call spLoopIterasi(vIterasi);

		SET vIterasi=(SELECT max(iterasi) FROM tblStruktur);
    SET vLanjut= sfHitungLanjut();

	END WHILE;

	END $$
	DELIMITER ;


DELIMITER $$
CREATE FUNCTION sfHitungLanjut()
  RETURNS INT
    BEGIN
      DECLARE hasil INT;

      SET hasil = (SELECT COUNT(*) FROM tblStruktur
      WHERE diagnosa='lanjut' AND iterasi=(SELECT max(iterasi) FROM tblStruktur));
      RETURN hasil;

    END $$
  DELIMITER ;

DELIMITER $$
CREATE PROCEDURE spLoopIterasi(pIterasi INT)
  BEGIN
    DECLARE vIterasi, vJumlahData, i INT DEFAULT 0;
    DECLARE vDemam, vSakitKepala, vNyeri, vLemas, vKelelahan, vHidungTersumbat,vBersin, vSakitTenggorokan, vSulitBernafas, vDiagnosa varchar(30);

    DECLARE ctblStruktur CURSOR FOR SELECT * FROM tblStruktur WHERE iterasi=pIterasi;
  	SELECT COUNT(*) INTO vJumlahData FROM tblStruktur WHERE iterasi=pIterasi;

    OPEN ctblStruktur;
      WHILE i <> vJumlahData DO
        FETCH ctblStruktur INTO vIterasi, vDemam, vSakitKepala, vNyeri, vLemas, vKelelahan, vHidungTersumbat,vBersin, vSakitTenggorokan, vSulitBernafas, vDiagnosa;

          IF vDiagnosa="lanjut" THEN

            TRUNCATE TABLE tblOlahan;
            INSERT INTO tblOlahan SELECT * FROM tblData;

  					call spDeleteTblOlahan(vIterasi, vDemam, vSakitKepala, vNyeri, vLemas, vKelelahan, vHidungTersumbat,vBersin, vSakitTenggorokan, vSulitBernafas, vDiagnosa);
  					SELECT * FROM tblOlahan;

  					call spInsertTblHitung(pIterasi);
  					call spDeleteTblHitungDiproses(vIterasi, vDemam, vSakitKepala, vNyeri, vLemas, vKelelahan, vHidungTersumbat,vBersin, vSakitTenggorokan, vSulitBernafas, vDiagnosa);
  					call spGain(pIterasi);
  					SELECT * FROM tblGain;

  					call spInsertTblStruktur(vIterasi, vDemam, vSakitKepala, vNyeri, vLemas, vKelelahan, vHidungTersumbat, vBersin, vSakitTenggorokan, vSulitBernafas, vDiagnosa);
            UPDATE tblHitung SET status="Selesai" WHERE status != "Selesai";
  					SELECT * FROM tblHitung;
  					SELECT * FROM tblStruktur;

          END IF;

        SET i=+1;

      END WHILE;
    CLOSE ctblStruktur;

  END $$
  DELIMITER ;


DELIMITER $$
CREATE PROCEDURE spDeleteTblOlahan(pIterasi INT, pDemam varchar(30), pSakitKepala varchar(30), pNyeri varchar(30), pLemas varchar(30), pKelelahan varchar(30),
                          pHidungTersumbat varchar(30), pBersin varchar(30), pSakitTenggorokan varchar(30), pSulitBernafas varchar(30), pDiagnosa varchar(30))
  BEGIN

      IF pDemam IS NOT NULL THEN DELETE FROM tblOlahan WHERE demam!=pDemam; END IF;
      IF pSakitKepala IS NOT NULL THEN DELETE FROM tblOlahan WHERE sakitkepala!=pSakitKepala; END IF;
      IF pNyeri IS NOT NULL THEN DELETE FROM tblOlahan WHERE nyeri!=pNyeri; END IF;
      IF pLemas IS NOT NULL THEN DELETE FROM tblOlahan WHERE lemas!=pLemas; END IF;
      IF pKelelahan IS NOT NULL THEN DELETE FROM tblOlahan WHERE kelelahan!=pKelelahan; END IF;
      IF pHidungTersumbat IS NOT NULL THEN DELETE FROM tblOlahan WHERE hidungtersumbat!=pHidungTersumbat; END IF;
      IF pBersin IS NOT NULL THEN DELETE FROM tblOlahan WHERE bersin!=pBersin; END IF;
      IF pSakitTenggorokan IS NOT NULL THEN DELETE FROM tblOlahan WHERE sakittenggorokan!=pSakitTenggorokan; END IF;
      IF pSulitBernafas IS NOT NULL THEN DELETE FROM tblOlahan WHERE sulitbernafas!=pSulitBernafas; END IF;

  END $$
  DELIMITER ;

DELIMITER $$
CREATE PROCEDURE spInsertTblHitung(pIterasi INT)
  BEGIN
    DECLARE i, vJumlahTblData INT DEFAULT 0;
    DECLARE pJumlahData, pDiagnosaFlu, pDiagnosaDemam INT;

    SET pIterasi=pIterasi+1;

    INSERT INTO tblHitung(jumlahdata, diagnosaflu, diagnosademam, status)
    VALUES( (SELECT COUNT(*) FROM tblOlahan), (SELECT COUNT(*) FROM tblOlahan WHERE diagnosa = 'Flu'),
			(SELECT COUNT(*) FROM tblOlahan WHERE diagnosa = 'Demam'), "Proses" );

    /*demam dari tblOlahan*/
    INSERT INTO tblHitung(informasi, iterasi, atribut,  jumlahdata, diagnosaflu, diagnosademam, status)
      SELECT DISTINCT(A.demam), pIterasi, 'Demam', (SELECT COUNT(*) FROM tblOlahan WHERE demam = A.demam), (SELECT COUNT(*) FROM tblOlahan WHERE demam = A.demam AND diagnosa = 'Flu'),
        (SELECT COUNT(*) FROM tblOlahan WHERE demam = A.demam AND diagnosa = 'Demam'), "Proses"
      FROM tblOlahan AS A ORDER BY A.demam;

    /*sakitkepala dari tblOlahan*/
    INSERT INTO tblHitung(informasi, iterasi, atribut,  jumlahdata, diagnosaflu, diagnosademam, status)
      SELECT DISTINCT(A.sakitkepala), pIterasi, 'Sakit kepala', (SELECT COUNT(*) FROM tblOlahan WHERE sakitkepala= A.sakitkepala),
        (SELECT COUNT(*) FROM tblOlahan WHERE sakitkepala= A.sakitkepala AND diagnosa = 'Flu'), (SELECT COUNT(*) FROM tblOlahan WHERE sakitkepala= A.sakitkepala AND diagnosa = 'Demam'), "Proses"
      FROM tblOlahan AS A ORDER BY A.sakitkepala;

    /*nyeri dari tblOlahan*/
    INSERT INTO tblHitung(informasi, iterasi, atribut,  jumlahdata, diagnosaflu, diagnosademam, status)
      SELECT DISTINCT(A.nyeri), pIterasi, 'Nyeri', (SELECT COUNT(*) FROM tblOlahan WHERE nyeri = A.nyeri),
        (SELECT COUNT(*) FROM tblOlahan WHERE nyeri = A.nyeri AND diagnosa = 'Flu'), (SELECT COUNT(*) FROM tblOlahan WHERE nyeri = A.nyeri AND diagnosa = 'Demam'), "Proses"
      FROM tblOlahan AS A ORDER BY A.nyeri;

    /*lemas dari tblOlahan*/
    INSERT INTO tblHitung(informasi, iterasi, atribut,  jumlahdata, diagnosaflu, diagnosademam, status)
      SELECT DISTINCT(A.lemas), pIterasi, 'Lemas', (SELECT COUNT(*) FROM tblOlahan WHERE lemas = A.lemas),
        (SELECT COUNT(*) FROM tblOlahan WHERE lemas = A.lemas AND diagnosa = 'Flu'), (SELECT COUNT(*) FROM tblOlahan WHERE lemas = A.lemas AND diagnosa = 'Demam'), "Proses"
      FROM tblOlahan AS A ORDER BY A.lemas;

    /*kelelahan dari tblOlahan*/
    INSERT INTO tblHitung(informasi, iterasi, atribut,  jumlahdata, diagnosaflu, diagnosademam, status)
      SELECT DISTINCT(A.kelelahan), pIterasi, 'Kelelahan', (SELECT COUNT(*) FROM tblOlahan WHERE kelelahan = A.kelelahan),
        (SELECT COUNT(*) FROM tblOlahan WHERE kelelahan = A.kelelahan AND diagnosa = 'Flu'), (SELECT COUNT(*) FROM tblOlahan WHERE kelelahan = A.kelelahan AND diagnosa = 'Demam'), "Proses"
      FROM tblOlahan AS A ORDER BY A.kelelahan;

    /*hidungtersumbat dari tblOlahan*/
    INSERT INTO tblHitung(informasi, iterasi, atribut,  jumlahdata, diagnosaflu, diagnosademam, status)
      SELECT DISTINCT(A.hidungtersumbat), pIterasi, 'Hidung Tersumbat', (SELECT COUNT(*) FROM tblOlahan WHERE hidungtersumbat = A.hidungtersumbat),
        (SELECT COUNT(*) FROM tblOlahan WHERE hidungtersumbat = A.hidungtersumbat AND diagnosa = 'Flu'), (SELECT COUNT(*) FROM tblOlahan WHERE hidungtersumbat = A.hidungtersumbat AND diagnosa = 'Demam'), "Proses"
      FROM tblOlahan AS A ORDER BY A.hidungtersumbat;

    /*bersin dari tblOlahan*/
    INSERT INTO tblHitung(informasi, iterasi, atribut,  jumlahdata, diagnosaflu, diagnosademam, status)
      SELECT DISTINCT(A.bersin), pIterasi, 'Bersin', (SELECT COUNT(*) FROM tblOlahan WHERE bersin = A.bersin),
        (SELECT COUNT(*) FROM tblOlahan WHERE bersin = A.bersin AND diagnosa = 'Flu'), (SELECT COUNT(*) FROM tblOlahan WHERE bersin = A.bersin AND diagnosa = 'Demam'), "Proses"
      FROM tblOlahan AS A ORDER BY A.bersin;

    /*sakittenggorokan dari tblOlahan*/
    INSERT INTO tblHitung(informasi, iterasi, atribut,  jumlahdata, diagnosaflu, diagnosademam, status)
      SELECT DISTINCT(A.sakittenggorokan), pIterasi, 'Sakit Tenggorokan', (SELECT COUNT(*) FROM tblOlahan WHERE sakittenggorokan = A.sakittenggorokan),
        (SELECT COUNT(*) FROM tblOlahan WHERE sakittenggorokan  = A.sakittenggorokan AND diagnosa = 'Flu'), (SELECT COUNT(*) FROM tblOlahan WHERE sakittenggorokan  = A.sakittenggorokan AND diagnosa = 'Demam'), "Proses"
      FROM tblOlahan AS A ORDER BY A.sakittenggorokan;

    /*sulitbernafas dari tblOlahan*/
    INSERT INTO tblHitung(informasi, iterasi, atribut,  jumlahdata, diagnosaflu, diagnosademam, status)
      SELECT DISTINCT(A.sulitbernafas), pIterasi, 'Sulit Bernafas', (SELECT COUNT(*) FROM tblOlahan WHERE sulitbernafas = A.sulitbernafas),
        (SELECT COUNT(*) FROM tblOlahan WHERE sulitbernafas = A.sulitbernafas AND diagnosa = 'Flu'), (SELECT COUNT(*) FROM tblOlahan WHERE sulitbernafas = A.sulitbernafas AND diagnosa = 'Demam'), "Proses"
      FROM tblOlahan AS A ORDER BY A.sulitbernafas;

    /*Entropy tblHitung*/
    UPDATE tblHitung
      SET entropy=(-(diagnosaflu/jumlahdata) * log2(diagnosaflu/jumlahdata)) + (-(diagnosademam/jumlahdata) * log2(diagnosademam/jumlahdata))
      WHERE (diagnosaflu != 0 or diagnosademam != 0) AND status="Proses";
    UPDATE tblHitung SET entropy=0 WHERE entropy IS NULL AND status="Proses";

    -- SELECT * FROM tblHitung;

  END $$
  DELIMITER ;


DELIMITER $$
CREATE PROCEDURE spDeleteTblHitungDiproses(pIterasi INT, pDemam varchar(30), pSakitKepala varchar(30), pNyeri varchar(30), pLemas varchar(30), pKelelahan varchar(30),
                                  pHidungTersumbat varchar(30), pBersin varchar(30), pSakitTenggorokan varchar(30), pSulitBernafas varchar(30), pDiagnosa varchar(30))
  BEGIN

    IF pDemam IS NOT NULL THEN DELETE FROM tblHitung WHERE atribut="Demam" AND status="Proses"; END IF;
    IF pSakitKepala IS NOT NULL THEN DELETE FROM tblHitung WHERE atribut="Sakit kepala" AND status="Proses"; END IF;
    IF pNyeri IS NOT NULL THEN DELETE FROM tblHitung WHERE atribut="Nyeri" AND status="Proses"; END IF;
    IF pLemas IS NOT NULL THEN DELETE FROM tblHitung WHERE atribut="Lemas" AND status="Proses"; END IF;
    IF pKelelahan IS NOT NULL THEN DELETE FROM tblHitung WHERE atribut="Kelelahan"  AND status="Proses"; END IF;
    IF pHidungTersumbat IS NOT NULL THEN DELETE FROM tblHitung WHERE atribut="Hidung Tersumbat" AND status="Proses"; END IF;
    IF pBersin IS NOT NULL THEN DELETE FROM tblHitung WHERE atribut="Bersin" AND status="Proses"; END IF;
    IF pSakitTenggorokan IS NOT NULL THEN DELETE FROM tblHitung WHERE atribut="Sakit Tenggorokan" AND status="Proses"; END IF;
    IF pSulitBernafas IS NOT NULL THEN DELETE FROM tblHitung WHERE  atribut="Sulit Bernafas" AND status="Proses"; END IF;

  END $$
  DELIMITER ;

DELIMITER $$
CREATE PROCEDURE spGain(pIterasi INT)
  BEGIN
    SET pIterasi=pIterasi+1;

    DROP TABLE IF EXISTS tblGain;
    CREATE TABLE tblGain(
      atribut varchar(30),
      gain DECIMAL(8,4)
    );

    UPDATE tblHitung
      SET gain=((jumlahdata/(SELECT jumlahdata FROM tblHitung WHERE iterasi IS NULL))
                    *entropy)
      WHERE jumlahdata !=0;

    INSERT INTO tblGain
    SELECT atribut, ROUND((SELECT entropy FROM tblHitung WHERE iterasi IS NULL AND status="Proses")-sum(gain),4)
    FROM tblHitung
    WHERE status="Proses"
    GROUP BY atribut;

    DELETE FROM tblGain WHERE atribut IS NULL;

    UPDATE tblHitung SET gain=(SELECT gain FROM tblGain WHERE atribut='Demam') WHERE atribut='Demam' AND status="Proses";
    UPDATE tblHitung SET gain=(SELECT gain FROM tblGain WHERE atribut='Sakit kepala') WHERE atribut='Sakit kepala' AND status="Proses";
    UPDATE tblHitung SET gain=(SELECT gain FROM tblGain WHERE atribut='Nyeri') WHERE atribut='Nyeri' AND status="Proses";
    UPDATE tblHitung SET gain=(SELECT gain FROM tblGain WHERE atribut='Lemas') WHERE atribut='Lemas' AND status="Proses";
    UPDATE tblHitung SET gain=(SELECT gain FROM tblGain WHERE atribut='Kelelahan') WHERE atribut='Kelelahan' AND status="Proses";
    UPDATE tblHitung SET gain=(SELECT gain FROM tblGain WHERE atribut='Hidung Tersumbat') WHERE atribut='Hidung Tersumbat' AND status="Proses";
    UPDATE tblHitung SET gain=(SELECT gain FROM tblGain WHERE atribut='Bersin') WHERE atribut='Bersin' AND status="Proses";
    UPDATE tblHitung SET gain=(SELECT gain FROM tblGain WHERE atribut='Sakit Tenggorokan') WHERE atribut='Sakit Tenggorokan' AND status="Proses";
    UPDATE tblHitung SET gain=(SELECT gain FROM tblGain WHERE atribut='Sulit Bernafas') WHERE atribut='Sulit Bernafas' AND status="Proses";

    UPDATE tblHitung set gain=0 WHERE iterasi is NULL;
    UPDATE tblHitung set informasi='' WHERE iterasi is NULL;
    UPDATE tblHitung set atribut='' WHERE iterasi is NULL;
    UPDATE tblHitung set iterasi=pIterasi WHERE iterasi is NULL;

  END $$
  DELIMITER ;

DELIMITER $$
CREATE PROCEDURE spInsertTblStruktur(pIterasi INT, pDemam varchar(30), pSakitKepala varchar(30), pNyeri varchar(30), pLemas varchar(30), pKelelahan varchar(30),
                            pHidungTersumbat varchar(30), pBersin varchar(30),pSakitTenggorokan varchar(30), pSulitBernafas varchar(30), pDiagnosa varchar(30))
  BEGIN
    DECLARE vIterasi, vJumlahData, vDiagnosaFlu, vDiagnosaDemam, vJumlahTblHitung, i INT DEFAULT 0;
    DECLARE vAtribut, vInformasi varchar(255);
    DECLARE vEntropy, vSplitGain, vGain DECIMAL(8,4);

    DECLARE cTblHitung CURSOR FOR SELECT * FROM tblHitung WHERE gain=(SELECT max(gain) FROM tblHitung WHERE status="Proses") and status="Proses";
    SELECT COUNT(*) INTO vJumlahTblHitung FROM  tblHitung WHERE gain=(SELECT max(gain) FROM tblHitung WHERE status="Proses") and status="Proses";
    SET pIterasi=pIterasi+1;

    OPEN cTblHitung;
    WHILE i <> vJumlahTblHitung DO
	    FETCH cTblHitung INTO vIterasi, vAtribut, vInformasi, vJumlahData, vDiagnosaFlu, vDiagnosaDemam, vEntropy, vSplitGain, vGain;
			IF vJumlahData = 0 THEN
				INSERT INTO tblStruktur VALUES(vIterasi,pDemam, pSakitKepala, pNyeri,pLemas, pKelelahan,pHidungTersumbat, pBersin, pSakitTenggorokan, pSulitBernafas, 'Zero Data');
			ELSE
	      IF vAtribut='Demam' THEN
	        IF vJumlahData=vDiagnosaFlu THEN INSERT INTO tblStruktur VALUES(vIterasi,vInformasi, pSakitKepala, pNyeri,pLemas, pKelelahan,pHidungTersumbat, pBersin, pSakitTenggorokan, pSulitBernafas, 'FLU');
	        ELSEIF vJumlahData=vDiagnosaDemam THEN INSERT INTO tblStruktur VALUES(vIterasi,vInformasi, pSakitKepala, pNyeri,pLemas, pKelelahan,pHidungTersumbat, pBersin, pSakitTenggorokan, pSulitBernafas, 'DEMAM');
	        ELSE INSERT INTO tblStruktur VALUES(vIterasi,vInformasi, pSakitKepala, pNyeri,pLemas, pKelelahan,pHidungTersumbat, pBersin, pSakitTenggorokan, pSulitBernafas, 'lanjut');
	        END IF;
	      END IF;
        IF vAtribut='Sakit kepala' THEN
	        IF vJumlahData=vDiagnosaFlu THEN INSERT INTO tblStruktur VALUES(vIterasi,pDemam, vInformasi, pNyeri,pLemas, pKelelahan,pHidungTersumbat, pBersin, pSakitTenggorokan, pSulitBernafas, 'FLU');
	        ELSEIF vJumlahData=vDiagnosaDemam THEN INSERT INTO tblStruktur VALUES(vIterasi,pDemam, vInformasi, pNyeri,pLemas, pKelelahan,pHidungTersumbat, pBersin, pSakitTenggorokan, pSulitBernafas, 'DEMAM');
	        ELSE INSERT INTO tblStruktur VALUES(vIterasi,pDemam, vInformasi, pNyeri,pLemas, pKelelahan,pHidungTersumbat, pBersin, pSakitTenggorokan, pSulitBernafas, 'lanjut');
	        END IF;
	      END IF;
        IF vAtribut='Nyeri' THEN
	        IF vJumlahData=vDiagnosaFlu THEN INSERT INTO tblStruktur VALUES(vIterasi,pDemam, pSakitKepala, vInformasi,pLemas, pKelelahan,pHidungTersumbat, pBersin, pSakitTenggorokan, pSulitBernafas, 'FLU');
	        ELSEIF vJumlahData=vDiagnosaDemam THEN INSERT INTO tblStruktur VALUES(vIterasi,pDemam, pSakitKepala, vInformasi,pLemas, pKelelahan,pHidungTersumbat, pBersin, pSakitTenggorokan, pSulitBernafas, 'DEMAM');
	        ELSE INSERT INTO tblStruktur VALUES(vIterasi,pDemam, pSakitKepala, vInformasi,pLemas, pKelelahan,pHidungTersumbat, pBersin, pSakitTenggorokan, pSulitBernafas, 'lanjut');
	        END IF;
	      END IF;
        IF vAtribut='Lemas' THEN
	        IF vJumlahData=vDiagnosaFlu THEN INSERT INTO tblStruktur VALUES(vIterasi,pDemam, pSakitKepala, pNyeri,vInformasi, pKelelahan,pHidungTersumbat, pBersin, pSakitTenggorokan, pSulitBernafas, 'FLU');
	        ELSEIF vJumlahData=vDiagnosaDemam THEN INSERT INTO tblStruktur VALUES(vIterasi,pDemam, pSakitKepala, pNyeri,vInformasi, pKelelahan,pHidungTersumbat, pBersin, pSakitTenggorokan, pSulitBernafas, 'DEMAM');
	        ELSE INSERT INTO tblStruktur VALUES(vIterasi,pDemam, pSakitKepala, pNyeri,vInformasi, pKelelahan,pHidungTersumbat, pBersin, pSakitTenggorokan, pSulitBernafas, 'lanjut');
	        END IF;
	      END IF;
        IF vAtribut='Kelelahan' THEN
	        IF vJumlahData=vDiagnosaFlu THEN INSERT INTO tblStruktur VALUES(vIterasi,pDemam, pSakitKepala, pNyeri,pLemas, vInformasi,pHidungTersumbat, pBersin, pSakitTenggorokan, pSulitBernafas, 'FLU');
	        ELSEIF vJumlahData=vDiagnosaDemam THEN INSERT INTO tblStruktur VALUES(vIterasi,pDemam, pSakitKepala, pNyeri,pLemas, vInformasi,pHidungTersumbat, pBersin, pSakitTenggorokan, pSulitBernafas, 'DEMAM');
	        ELSE INSERT INTO tblStruktur VALUES(vIterasi,pDemam, pSakitKepala, pNyeri,pLemas, vInformasi,pHidungTersumbat, pBersin, pSakitTenggorokan, pSulitBernafas, 'lanjut');
	        END IF;
	      END IF;
        IF vAtribut='Hidung Tersumbat' THEN
	        IF vJumlahData=vDiagnosaFlu THEN INSERT INTO tblStruktur VALUES(vIterasi,pDemam, pSakitKepala, pNyeri,pLemas, pKelelahan,vInformasi, pBersin, pSakitTenggorokan, pSulitBernafas, 'FLU');
	        ELSEIF vJumlahData=vDiagnosaDemam THEN INSERT INTO tblStruktur VALUES(vIterasi,pDemam, pSakitKepala, pNyeri,pLemas, pKelelahan,vInformasi, pBersin, pSakitTenggorokan, pSulitBernafas, 'DEMAM');
	        ELSE INSERT INTO tblStruktur VALUES(vIterasi,pDemam, pSakitKepala, pNyeri,pLemas, pKelelahan,vInformasi, pBersin, pSakitTenggorokan, pSulitBernafas, 'lanjut');
	        END IF;
	      END IF;
        IF vAtribut='Bersin' THEN
	        IF vJumlahData=vDiagnosaFlu THEN INSERT INTO tblStruktur VALUES(vIterasi,pDemam, pSakitKepala, pNyeri,pLemas, pKelelahan,pHidungTersumbat, vInformasi, pSakitTenggorokan, pSulitBernafas, 'FLU');
	        ELSEIF vJumlahData=vDiagnosaDemam THEN INSERT INTO tblStruktur VALUES(vIterasi,pDemam, pSakitKepala, pNyeri,pLemas, pKelelahan,pHidungTersumbat, vInformasi, pSakitTenggorokan, pSulitBernafas, 'DEMAM');
	        ELSE INSERT INTO tblStruktur VALUES(vIterasi,pDemam, pSakitKepala, pNyeri,pLemas, pKelelahan,pHidungTersumbat, vInformasi, pSakitTenggorokan, pSulitBernafas, 'lanjut');
	        END IF;
	      END IF;
        IF vAtribut='Sakit Tenggorokan' THEN
	        IF vJumlahData=vDiagnosaFlu THEN INSERT INTO tblStruktur VALUES(vIterasi,pDemam, pSakitKepala, pNyeri,pLemas, pKelelahan,pHidungTersumbat, pBersin, vInformasi, pSulitBernafas, 'FLU');
	        ELSEIF vJumlahData=vDiagnosaDemam THEN INSERT INTO tblStruktur VALUES(vIterasi,pDemam, pSakitKepala, pNyeri,pLemas, pKelelahan,pHidungTersumbat, pBersin, vInformasi, pSulitBernafas, 'DEMAM');
	        ELSE INSERT INTO tblStruktur VALUES(vIterasi,pDemam, pSakitKepala, pNyeri,pLemas, pKelelahan,pHidungTersumbat, pBersin, vInformasi, pSulitBernafas, 'lanjut');
	        END IF;
	      END IF;
        IF vAtribut='Sulit Bernafas' THEN
	        IF vJumlahData=vDiagnosaFlu THEN INSERT INTO tblStruktur VALUES(vIterasi,pDemam, pSakitKepala, pNyeri,pLemas, pKelelahan,pHidungTersumbat, pBersin, pSakitTenggorokan, vInformasi, 'FLU');
	        ELSEIF vJumlahData=vDiagnosaDemam THEN INSERT INTO tblStruktur VALUES(vIterasi,pDemam, pSakitKepala, pNyeri,pLemas, pKelelahan,pHidungTersumbat, pBersin, pSakitTenggorokan, vInformasi, 'DEMAM');
	        ELSE INSERT INTO tblStruktur VALUES(vIterasi,pDemam, pSakitKepala, pNyeri,pLemas, pKelelahan,pHidungTersumbat, pBersin, pSakitTenggorokan, vInformasi, 'lanjut');
	        END IF;
	      END IF;
      END IF;

	    DELETE FROM tblStruktur WHERE iterasi=0;
	    SET i=i+1;
    END WHILE;
    CLOSE cTblHitung;

  END $$
  DELIMITER ;

call spLoop();
