DROP DATABASE IF EXISTS UASDM18K10034;
CREATE DATABASE UASDM18K10034;
USE UASDM18K10034;

CREATE TABLE tblData(
	No INT,
	Demam VARCHAR(10),
	SakitKepala VARCHAR(10),
	Nyeri VARCHAR(10),
	Lemas VARCHAR(10),
	Kelelahan VARCHAR(10),
	HidungTersumbat VARCHAR(10),
	Bersin VARCHAR(10),
	SakitTenggorokan VARCHAR(10),
	SulitBernafas VARCHAR(10),
	Diagnosa VARCHAR(10)
);

insert into tblData values
	(1, 'Tidak', 'Ringan', 'Tidak', 'Tidak', 'Tidak', 'Ringan', 'Parah', 'Parah', 'Ringan', 'Demam'),
	(2, 'Parah', 'Parah', 'Parah', 'Parah', 'Parah', 'Tidak', 'Tidak', 'Parah', 'Parah', 'Flu'),
	(3, 'Parah', 'Parah', 'Parah', 'Parah', 'Parah', 'Parah', 'Tidak', 'Parah', 'Parah', 'Flu'),
	(4, 'Tidak', 'Tidak', 'Tidak', 'Ringan', 'Tidak', 'Parah', 'Tidak', 'Ringan', 'Ringan', 'Demam'),
	(5, 'Parah', 'Parah', 'Ringan', 'Parah', 'Parah', 'Parah', 'Tidak', 'Parah', 'Parah', 'Flu'),
	(6, 'Tidak', 'Tidak', 'Tidak', 'Ringan', 'Tidak', 'Parah', 'Parah', 'Parah', 'Tidak', 'Demam'),
	(7, 'Parah', 'Parah', 'Parah', 'Parah', 'Parah', 'Tidak', 'Tidak', 'Tidak', 'Parah', 'Flu'),
	(8, 'Tidak', 'Tidak', 'Tidak', 'Tidak', 'Tidak', 'Parah', 'Parah', 'Tidak', 'Ringan', 'Demam'),
	(9, 'Tidak', 'Ringan', 'Ringan', 'Tidak', 'Tidak', 'Parah', 'Parah', 'Parah', 'Parah', 'Demam'),
	(10, 'Parah', 'Parah', 'Parah', 'Ringan', 'Ringan', 'Tidak', 'Parah', 'Tidak', 'Parah', 'Flu'),
	(11, 'Tidak', 'Tidak', 'Tidak', 'Ringan', 'Tidak', 'Parah', 'Ringan', 'Parah', 'Tidak', 'Demam'),
	(12, 'Parah', 'Ringan', 'Parah', 'Ringan', 'Parah', 'Tidak', 'Parah', 'Tidak', 'Ringan', 'Flu'),
	(13, 'Tidak', 'Tidak', 'Ringan', 'Ringan', 'Tidak', 'Parah', 'Parah', 'Parah', 'Tidak', 'Demam'),
	(14, 'Parah', 'Parah', 'Parah', 'Parah', 'Ringan', 'Tidak', 'Parah', 'Parah', 'Parah', 'Flu'),
	(15, 'Ringan', 'Tidak', 'Tidak', 'Ringan', 'Tidak', 'Parah', 'Tidak', 'Parah', 'Ringan', 'Demam'),
	(16, 'Tidak', 'Tidak', 'Tidak', 'Tidak', 'Tidak', 'Parah', 'Parah', 'Parah', 'Parah', 'Demam'),
	(17, 'Parah', 'Ringan', 'Parah', 'Ringan', 'Ringan', 'Tidak', 'Tidak', 'Tidak', 'Parah', 'Flu');

CREATE TABLE tblHitung(
	Iterasi INT,
	Atribut VARCHAR(20),
	Informasi VARCHAR(20),
	JumlahData INT,
	Flu INT,
	Demam INT,
	Entropy DECIMAL(8,4),
	Gain DECIMAL(8,4)
);

CREATE TABLE tblUrutanLoop(
	Iterasi INT,
	Atribut varchar(20),
	Gain DECIMAL(8,4)
);

CREATE TABLE tblTree(
  	Iterasi INT,
  	Demam varchar(20),
	SakitKepala varchar(20),
	Nyeri varchar(20),
	Lemas varchar(20),
	Kelelahan varchar(20),
	HidungTersumbat varchar(20),
	Bersin varchar(20),
	SakitTenggorokan varchar(20),
	SulitBernafas varchar(20),
  	Diagnosa varchar(20)
);

INSERT INTO tblTree(Iterasi, Diagnosa) VALUES (0, "Diteruskan");

DELIMITER $$
CREATE PROCEDURE spInsertTblHitung(pIterasi int)
BEGIN
	DECLARE i, vJumlahTblData INT DEFAULT 0;
	DECLARE pJumlahData, pFlu, pDemam INT;

	IF pIterasi>=1 THEN
	DELETE FROM tblTree WHERE Iterasi=0;
	SET pJumlahData=(SELECT COUNT(*) FROM vwTblData);
	SET pFlu=(SELECT COUNT(*) FROM vwTblData WHERE  Diagnosa = 'Flu');
	SET pDemam=(SELECT COUNT(*) FROM vwTblData WHERE  Diagnosa = 'Demam');

	INSERT INTO tblHitung(Atribut, JumlahData, Flu, Demam, Entropy)
	VALUES('',pJumlahData ,pFlu ,pDemam, ( -(pFlu/pJumlahData) * log2(pFlu/pJumlahData) ) + ( -(pDemam/pJumlahData) * log2(pDemam/pJumlahData) ));

	INSERT INTO tblHitung(Informasi, Iterasi, Atribut, JumlahData, Flu, Demam)
	SELECT DISTINCT(A.Demam), pIterasi, 'Demam', (SELECT COUNT(*) FROM vwTblData WHERE  Demam = A.Demam), (SELECT COUNT(*) FROM vwTblData WHERE  Demam = A.Demam AND Diagnosa = 'Flu'), (SELECT COUNT(*) FROM vwTblData WHERE  Demam = A.Demam AND Diagnosa = 'Demam') FROM vwTblData AS A ORDER BY A.Demam;

	INSERT INTO tblHitung(Informasi, Iterasi, Atribut, JumlahData, Flu, Demam)
	SELECT DISTINCT(A.SakitKepala), pIterasi, 'SakitKepala', (SELECT COUNT(*) FROM vwTblData WHERE  SakitKepala = A.SakitKepala), (SELECT COUNT(*) FROM vwTblData WHERE  SakitKepala = A.SakitKepala AND Diagnosa = 'Flu'), (SELECT COUNT(*) FROM vwTblData WHERE  SakitKepala = A.SakitKepala AND Diagnosa = 'Demam') FROM vwTblData AS A ORDER BY A.SakitKepala;

	INSERT INTO tblHitung(Informasi, Iterasi, Atribut,  JumlahData, Flu, Demam)
	SELECT DISTINCT(A.Nyeri), pIterasi, 'Nyeri', (SELECT COUNT(*) FROM vwTblData WHERE  Nyeri = A.Nyeri), (SELECT COUNT(*) FROM vwTblData WHERE  Nyeri = A.Nyeri AND Diagnosa = 'Flu'), (SELECT COUNT(*) FROM vwTblData WHERE  Nyeri = A.Nyeri AND Diagnosa = 'Demam') FROM vwTblData AS A ORDER BY A.Nyeri;

 	INSERT INTO tblHitung(Informasi, Iterasi, Atribut,  JumlahData, Flu, Demam)
	SELECT DISTINCT(A.Lemas), pIterasi, 'Lemas', (SELECT COUNT(*) FROM vwTblData WHERE  Lemas = A.Lemas), (SELECT COUNT(*) FROM vwTblData WHERE  Lemas = A.Lemas AND Diagnosa = 'Flu'), (SELECT COUNT(*) FROM vwTblData WHERE  Lemas = A.Lemas AND Diagnosa = 'Demam') FROM vwTblData AS A ORDER BY A.Lemas;

	INSERT INTO tblHitung(Informasi, Iterasi, Atribut,  JumlahData, Flu, Demam)
	SELECT DISTINCT(A.Kelelahan), pIterasi, 'Kelelahan', (SELECT COUNT(*) FROM vwTblData WHERE  Kelelahan = A.Kelelahan), (SELECT COUNT(*) FROM vwTblData WHERE  Kelelahan = A.Kelelahan AND Diagnosa = 'Flu'), (SELECT COUNT(*) FROM vwTblData WHERE  Kelelahan = A.Kelelahan AND Diagnosa = 'Demam') FROM vwTblData AS A ORDER BY A.Kelelahan;

	INSERT INTO tblHitung(Informasi, Iterasi, Atribut,  JumlahData, Flu, Demam)
	SELECT DISTINCT(A.HidungTersumbat), pIterasi, 'HidungTersumbat', (SELECT COUNT(*) FROM vwTblData WHERE  HidungTersumbat = A.HidungTersumbat), (SELECT COUNT(*) FROM vwTblData WHERE  HidungTersumbat = A.HidungTersumbat AND Diagnosa = 'Flu'), (SELECT COUNT(*) FROM vwTblData WHERE  HidungTersumbat = A.HidungTersumbat AND Diagnosa = 'Demam') FROM vwTblData AS A ORDER BY A.HidungTersumbat;
	
	INSERT INTO tblHitung(Informasi, Iterasi, Atribut,  JumlahData, Flu, Demam)
	SELECT DISTINCT(A.Bersin), pIterasi, 'Bersin', (SELECT COUNT(*) FROM vwTblData WHERE  Bersin = A.Bersin), (SELECT COUNT(*) FROM vwTblData WHERE  Bersin = A.Bersin AND Diagnosa = 'Flu'), (SELECT COUNT(*) FROM vwTblData WHERE  Bersin = A.Bersin AND Diagnosa = 'Demam') FROM vwTblData AS A ORDER BY A.Bersin;

	INSERT INTO tblHitung(Informasi, Iterasi, Atribut,  JumlahData, Flu, Demam)
	SELECT DISTINCT(A.SakitTenggorokan), pIterasi, 'SakitTenggorokan', (SELECT COUNT(*) FROM vwTblData WHERE  SakitTenggorokan = A.SakitTenggorokan), (SELECT COUNT(*) FROM vwTblData WHERE  SakitTenggorokan = A.SakitTenggorokan AND Diagnosa = 'Flu'), (SELECT COUNT(*) FROM vwTblData WHERE  SakitTenggorokan = A.SakitTenggorokan AND Diagnosa = 'Demam') FROM vwTblData AS A ORDER BY A.SakitTenggorokan;
	
	INSERT INTO tblHitung(Informasi, Iterasi, Atribut,  JumlahData, Flu, Demam)
	SELECT DISTINCT(A.SulitBernafas), pIterasi, 'SulitBernafas', (SELECT COUNT(*) FROM vwTblData WHERE  SulitBernafas = A.SulitBernafas), (SELECT COUNT(*) FROM vwTblData WHERE  SulitBernafas = A.SulitBernafas AND Diagnosa = 'Flu'), (SELECT COUNT(*) FROM vwTblData WHERE  SulitBernafas = A.SulitBernafas AND Diagnosa = 'Demam') FROM vwTblData AS A ORDER BY A.SulitBernafas;

	ELSEIF pIterasi>1 THEN
	SET pJumlahData=(SELECT COUNT(*) FROM vwTblData); SET pFlu=(SELECT COUNT(*) FROM vwTblData WHERE  Diagnosa = 'Flu'); SET pDemam=(SELECT COUNT(*) FROM vwTblData WHERE  Diagnosa = 'Demam');
	END IF;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE spEntropy(pIterasi INT)
BEGIN
	UPDATE tblHitung SET Entropy= ( -(Flu/JumlahData) * log2(Flu/JumlahData) ) + ( -(Demam/JumlahData) * log2(Demam/JumlahData) );
	UPDATE tblHitung SET Entropy =0 WHERE Entropy is null and
		(Atribut='Demam' or Atribut='SakitKepala'
		or Atribut='Nyeri' or Atribut='Lemas' or Atribut='Kelelahan' or Atribut='HidungTersumbat' or Atribut='Bersin' or Atribut='SakitTenggorokan' or Atribut='SulitBernafas');
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE spGain(pIterasi INT)
BEGIN
	DECLARE i, vJumlahTblHitung, vFlu, vDemam, vIterasi INT DEFAULT 0;
	DECLARE vAtribut, vInformasi varchar(20) DEFAULT '';
	DECLARE vJumlahData, vEntropy DECIMAL(8,4);
	DECLARE cTblHitung CURSOR FOR SELECT Iterasi, Atribut, Informasi, JumlahData, Flu, Demam, Entropy FROM tblHitung;
	SELECT COUNT(*) INTO vJumlahTblHitung FROM tblHitung;
	SELECT JumlahData INTO @totalData FROM tblHitung WHERE Gain IS NULL LIMIT 1;
	SELECT Entropy INTO @Entropy FROM tblHitung where Gain IS NULL LIMIT 1;
	SELECT @totaldata as tot, @Entropy as ent;

	OPEN cTblHitung;
	WHILE i<> vJumlahTblHitung DO
	FETCH cTblHitung INTO vIterasi, vAtribut, vInformasi, vJumlahData, vFlu, vDemam, vEntropy;
		UPDATE tblHitung SET Gain =((vJumlahData/@totaldata)*vEntropy) WHERE Gain IS NULL
		 and Iterasi=pIterasi and Atribut=vAtribut AND JumlahData=vJumlahData AND Flu=vFlu AND Demam=vDemam and Entropy=vEntropy;
	SET i=i+1;
	END WHILE;
	CLOSE cTblHitung;
END $$
DELIMITER ;

CREATE TABLE tblGain(
	Iterasi INT,
	Atribut varchar(20),
	Gain DECIMAL(8,4)
);

DELIMITER $$
CREATE PROCEDURE spUpdateGain(pIterasi INT)
BEGIN
	DECLARE i INT DEFAULT 0;
	TRUNCATE TABLE tblGain;
	INSERT INTO tblGain(Atribut, Iterasi, Gain)
	SELECT Atribut, pIterasi, ROUND(@Entropy-sum(Gain),4) FROM tblHitung
		WHERE Gain IS NOT NULL AND Iterasi=pIterasi
		GROUP BY Atribut;
	UPDATE tblHitung SET Gain=(SELECT Gain FROM tblGain WHERE Atribut='Demam') WHERE Atribut='Demam' and Iterasi=pIterasi;
	UPDATE tblHitung SET Gain=(SELECT Gain FROM tblGain WHERE Atribut='SakitKepala') WHERE Atribut='SakitKepala' and Iterasi=pIterasi;
	UPDATE tblHitung SET Gain=(SELECT Gain FROM tblGain WHERE Atribut='Nyeri') WHERE Atribut='Nyeri' and Iterasi=pIterasi;
	UPDATE tblHitung SET Gain=(SELECT Gain FROM tblGain WHERE Atribut='Lemas') WHERE Atribut='Lemas' and Iterasi=pIterasi;
	UPDATE tblHitung SET Gain=(SELECT Gain FROM tblGain WHERE Atribut='Kelelahan') WHERE Atribut='Kelelahan' and Iterasi=pIterasi;
	UPDATE tblHitung SET Gain=(SELECT Gain FROM tblGain WHERE Atribut='HidungTersumbat') WHERE Atribut='HidungTersumbat' and Iterasi=pIterasi;
	UPDATE tblHitung SET Gain=(SELECT Gain FROM tblGain WHERE Atribut='Bersin') WHERE Atribut='Bersin' and Iterasi=pIterasi;
	UPDATE tblHitung SET Gain=(SELECT Gain FROM tblGain WHERE Atribut='SakitTenggorokan') WHERE Atribut='SakitTenggorokan' and Iterasi=pIterasi;
	UPDATE tblHitung SET Gain=(SELECT Gain FROM tblGain WHERE Atribut='SulitBernafas') WHERE Atribut='SulitBernafas' and Iterasi=pIterasi;
	SELECT * FROM tblHitung;
	SELECT * FROM tblGain;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE spInsertTblTree(pIterasi INT)
BEGIN
	DECLARE i,  vIterasi, vJumlahData, vFlu, vDemam, vLooping INT DEFAULT 0;
	DECLARE vAtribut, vInformasi varchar(20);
	DECLARE vGain DECIMAL(8,4);
	DECLARE cTblHitung CURSOR FOR
		SELECT Iterasi, Atribut, Informasi, JumlahData, Flu, Demam, Gain
		FROM tblHitung WHERE Gain=(SELECT max(Gain) FROM tblGain) and Iterasi=pIterasi;
	SELECT COUNT(*) INTO vLooping FROM tblHitung where Gain=(SELECT max(Gain) FROM tblGain) and Iterasi=pIterasi;

	OPEN cTblHitung;
	WHILE i<>vLooping DO
		FETCH cTblHitung INTO vIterasi, vAtribut, vInformasi, vJumlahData, vFlu, vDemam, vGain;
				IF vAtribut="Demam" THEN
					IF vJumlahData=vFlu THEN
						INSERT INTO tblTree VALUES(pIterasi,vInformasi,"","","","","","","","","Flu");
					ELSEIF vJumlahData=vDemam THEN
						INSERT INTO tblTree VALUES(pIterasi,vInformasi,"","","","","","","","","Demam");
					ELSE
						INSERT INTO tblTree VALUES(pIterasi,vInformasi,"","","","","","","","","Diteruskan");
					END IF;
				END IF;

				IF vAtribut="SakitKepala" THEN
					IF vJumlahData=vFlu THEN
						INSERT INTO tblTree VALUES(pIterasi,"",vInformasi,"","","","","","","","Flu");
					ELSEIF vJumlahData=vDemam THEN
						INSERT INTO tblTree VALUES(pIterasi,"",vInformasi,"","","","","","","","Demam");
					ELSE
						INSERT INTO tblTree VALUES(pIterasi,"",vInformasi,"","","","","","","","Diteruskan");
					END IF;
				END IF;

				IF vAtribut="Nyeri" THEN
					IF vJumlahData=vFlu THEN
						INSERT INTO tblTree VALUES(pIterasi,"","",vInformasi,"","","","","","","Flu");
					ELSEIF vJumlahData=vDemam THEN
						INSERT INTO tblTree VALUES(pIterasi,"","",vInformasi,"","","","","","","Demam");
					ELSE
						INSERT INTO tblTree VALUES(pIterasi,"","",vInformasi,"","","","","","","Diteruskan");
					END IF;
				END IF;

				IF vAtribut="Lemas" THEN
					IF vJumlahData=vFlu THEN
						INSERT INTO tblTree VALUES(pIterasi,"","","",vInformasi,"","","","","","Flu");
					ELSEIF vJumlahData=vDemam THEN
						INSERT INTO tblTree VALUES(pIterasi,"","","",vInformasi,"","","","","","Demam");
					ELSE
						INSERT INTO tblTree VALUES(pIterasi,"","","",vInformasi,"","","","","","Diteruskan");
					END IF;
				END IF;

				IF vAtribut="Kelelahan" THEN
					IF vJumlahData=vFlu THEN
						INSERT INTO tblTree VALUES(pIterasi,"","","","",vInformasi,"","","","","Flu");
					ELSEIF vJumlahData=vDemam THEN
						INSERT INTO tblTree VALUES(pIterasi,"","","","",vInformasi,"","","","","Demam");
					ELSE
						INSERT INTO tblTree VALUES(pIterasi,"","","","",vInformasi,"","","","","Diteruskan");
					END IF;
				END IF;

				IF vAtribut="HidungTersumbat" THEN
					IF vJumlahData=vFlu THEN
						INSERT INTO tblTree VALUES(pIterasi,"","","","","",vInformasi,"","","","Flu");
					ELSEIF vJumlahData=vDemam THEN
						INSERT INTO tblTree VALUES(pIterasi,"","","","","",vInformasi,"","","","Demam");
					ELSE
						INSERT INTO tblTree VALUES(pIterasi,"","","","","",vInformasi,"","","","Diteruskan");
					END IF;
				END IF;

				IF vAtribut="Bersin" THEN
					IF vJumlahData=vFlu THEN
						INSERT INTO tblTree VALUES(pIterasi,"","","","","","",vInformasi,"","","Flu");
					ELSEIF vJumlahData=vDemam THEN
						INSERT INTO tblTree VALUES(pIterasi,"","","","","","",vInformasi,"","","Demam");
					ELSE
						INSERT INTO tblTree VALUES(pIterasi,"","","","","","",vInformasi,"","","Diteruskan");
					END IF;
				END IF;

				IF vAtribut="SakitTenggorokan" THEN
					IF vJumlahData=vFlu THEN
						INSERT INTO tblTree VALUES(pIterasi,"","","","","","","",vInformasi,"","Flu");
					ELSEIF vJumlahData=vDemam THEN
						INSERT INTO tblTree VALUES(pIterasi,"","","","","","","",vInformasi,"","Demam");
					ELSE
						INSERT INTO tblTree VALUES(pIterasi,"","","","","","","",vInformasi,"","Diteruskan");
					END IF;
				END IF;

				IF vAtribut="SulitBernafas" THEN
					IF vJumlahData=vFlu THEN
						INSERT INTO tblTree VALUES(pIterasi,"","","","","","","","",vInformasi,"Flu");
					ELSEIF vJumlahData=vDemam THEN
						INSERT INTO tblTree VALUES(pIterasi,"","","","","","","","",vInformasi,"Demam");
					ELSE
						INSERT INTO tblTree VALUES(pIterasi,"","","","","","","","",vInformasi,"Diteruskan");
					END IF;
				END IF;
		SET i=i+1;
	END WHILE;
	CLOSE cTblHitung;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE spLooping()
BEGIN
DECLARE jumlahLanjut INT default 1;
DECLARE vIterasiTblT, vJumlahDataTblT, Pengulangan INT default 0;

DECLARE vDemamTblT, vSakitKepalaTblT, vNyeriTblT, vLemasTblT, vKelelahanTblT, vHidungTersumbatTblT, vBersinTblT, vSakitTenggorokanTblT, vSulitBernafasTblT, vDiagnosaTblT varchar(20);

DECLARE cTblTree CURSOR FOR SELECT * FROM tblTree WHERE Iterasi=Pengulangan;
SELECT COUNT(*) INTO vJumlahDataTblT FROM tblTree WHERE Iterasi=Pengulangan;

WHILE jumlahLanjut <> 0 AND Pengulangan < 5 DO

DROP VIEW IF EXISTS vwTblData;
CREATE VIEW vwTblData as SELECT * FROM tblData;
SELECT * FROM vwTblData;

SET Pengulangan=Pengulangan+1;
call spInsertTblHitung(Pengulangan);
call spEntropy(Pengulangan);
call spGain(Pengulangan);
call spUpdateGain(Pengulangan);
call spInsertTblTree(Pengulangan);

UPDATE tblHitung SET Iterasi=Pengulangan WHERE Iterasi IS NULL;
UPDATE tblHitung SET Atribut='' WHERE Atribut  IS NULL;
UPDATE tblHitung SET Informasi='' WHERE Informasi IS NULL;
UPDATE tblHitung SET Entropy=0 WHERE Entropy IS NULL;
UPDATE tblHitung SET Gain=0 WHERE Gain IS NULL;

SELECT * FROM tblHitung;
SELECT * FROM tblGain;
SELECT * FROM tblTree;
SELECT Pengulangan as Pengulangan;
SET jumlahLanjut=(SELECT COUNT(*) FROM tblTree WHERE Iterasi=Pengulangan AND Diagnosa='Diteruskan');
SELECT jumlahLanjut as Diteruskan;
END WHILE;
END $$
DELIMITER ;

CALL spLooping;
