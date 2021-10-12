DROP DATABASE IF EXISTS 18k10082_c45loop;
CREATE DATABASE 18k10082_c45loop;
USE 18k10082_c45loop;

CREATE TABLE tblData(
	nourut INT,
	outlook VARCHAR(10),
	temperature VARCHAR(10),
	humadity VARCHAR(10),
	windy VARCHAR(10),
	play VARCHAR(10)
);

load data local infile "dbC45.csv"
into table tblData
fields terminated by ";"
enclosed by ''''
ignore 1 lines;

-- SELECT * FROM tblData;

CREATE TABLE tblHitung(
	iterasi INT,
	atribut VARCHAR(20),
	informasi VARCHAR(20),
	jumlahdata INT,
	playno INT,
	playyes INT,
	entropy DECIMAL(8,4),
	gain DECIMAL(8,4)
);

-- CREATE TABLE tblTree(
--   iterasi INT,
--   atribut varchar(20),
--   informasi varchar(20),
--   play varchar(20)
-- );
CREATE TABLE tblUrutanLoop(
	iterasi INT,
	atribut varchar(20),
	gain DECIMAL(8,4)
);

CREATE TABLE tblTree(
  iterasi INT,
  outlook varchar(20),
	temperature varchar(20),
	humadity varchar(20),
	windy varchar(20),
  play varchar(20)
);

INSERT INTO tblTree(iterasi, play) VALUES (0, "lanjut");
-- SELECT * FROM tblTree;
/*
LANGKAH-LANGKAH nggak jadi nggak jadi ngak jadi nggak jadi
1. DELETE tblData yang ada di tblTree
2. INSERT tblData ke tblHitung, hitung entropy dan hitung gain
3. Gain terbesar insert atribut ke tblTREE beserta informasi,
    jika jumlah = no maka play ='no', jika jumlah = yes maka play 'yes',
    jika tidak maka play 'lanjut'
4. looping berhenti jika tblTree tidak ada yang play 'lanjut'

*/

/*
LANGKAH LANGKAH
1. copy TblData ke vwTblData sebelum menjalankan looping
2. Cek jumlah play=lanjut di tblTree
3. Delete vwTblData yang tblTree tidak null
4. Input ke tblHitung dari vwTblData
5. Membuat tblGain, Dapet Gain Tertinggi
6. Update gain tblHitung
7. Cursor tblHitung untuk update tblTree dengan isi "informasi"
 		yang atributTblHitung=atributTblGain dan
*/
-- CREATE TABLE tblHitung(
-- 	iterasi INT,
-- 	atribut VARCHAR(20),
-- 	informasi VARCHAR(20),
-- 	jumlahdata INT,
-- 	playno INT,
-- 	playyes INT,
-- 	entropy DECIMAL(8,4),
-- 	gain DECIMAL(8,4)
-- );
-- CREATE VIEW vwTblData as
-- SELECT * FROM tblData;

DELIMITER $$
CREATE PROCEDURE spInsertTblHitung(pIterasi int)
BEGIN
	DECLARE i, vJumlahTblData INT DEFAULT 0;
	-- SET pIterasi=1;
	DECLARE pJumlahData, pPlayno, pPlayyes INT;

	IF pIterasi>=1 THEN
	DELETE FROM tblTree WHERE iterasi=0;
	SET pJumlahData=(SELECT COUNT(*) FROM vwTblData);
	SET pPlayno=(SELECT COUNT(*) FROM vwTblData WHERE  play = 'No');
	SET pPlayyes=(SELECT COUNT(*) FROM vwTblData WHERE  play = 'Yes');

	INSERT INTO tblHitung(atribut,  jumlahdata, playno, playyes,entropy)
	VALUES('',pJumlahData ,pPlayno ,pPlayyes, ( -(pPlayno/pJumlahData) * log2(pPlayno/pJumlahData) ) + ( -(pPlayyes/pJumlahData) * log2(pPlayyes/pJumlahData) ));

	INSERT INTO tblHitung(informasi, iterasi, atribut,  jumlahdata, playno, playyes)
	SELECT DISTINCT(A.outlook), pIterasi, 'Outlook', (SELECT COUNT(*) FROM vwTblData WHERE  outlook = A.outlook), (SELECT COUNT(*) FROM vwTblData WHERE  outlook = A.outlook AND play = 'No'), (SELECT COUNT(*) FROM vwTblData WHERE  outlook = A.outlook AND play = 'Yes') FROM vwTblData AS A ORDER BY A.outlook;

	INSERT INTO tblHitung(informasi, iterasi, atribut,  jumlahdata, playno, playyes)
	SELECT DISTINCT(A.temperature), pIterasi, 'Temperature', (SELECT COUNT(*) FROM vwTblData WHERE  temperature = A.temperature), (SELECT COUNT(*) FROM vwTblData WHERE  temperature = A.temperature AND play = 'No'), (SELECT COUNT(*) FROM vwTblData WHERE  temperature = A.temperature AND play = 'Yes') FROM vwTblData AS A ORDER BY A.temperature;

	INSERT INTO tblHitung(informasi, iterasi, atribut,  jumlahdata, playno, playyes)
	SELECT DISTINCT(A.humadity), pIterasi, 'Humadity', (SELECT COUNT(*) FROM vwTblData WHERE  humadity = A.humadity), (SELECT COUNT(*) FROM vwTblData WHERE  humadity = A.humadity AND play = 'No'), (SELECT COUNT(*) FROM vwTblData WHERE  humadity = A.humadity AND play = 'Yes') FROM vwTblData AS A ORDER BY A.humadity;

 	INSERT INTO tblHitung(informasi, iterasi, atribut,  jumlahdata, playno, playyes)
	SELECT DISTINCT(A.windy), pIterasi, 'Windy', (SELECT COUNT(*) FROM vwTblData WHERE  windy = A.windy), (SELECT COUNT(*) FROM vwTblData WHERE  windy = A.windy AND play = 'No'), (SELECT COUNT(*) FROM vwTblData WHERE  windy = A.windy AND play = 'Yes') FROM vwTblData AS A ORDER BY A.windy;

	ELSEIF pIterasi>1 THEN

	SET pJumlahData=(SELECT COUNT(*) FROM vwTblData); SET pPlayno=(SELECT COUNT(*) FROM vwTblData WHERE  play = 'No'); SET pPlayyes=(SELECT COUNT(*) FROM vwTblData WHERE  play = 'Yes');

	END IF;

END $$
DELIMITER ;

-- DELIMITER $$
-- CREATE PROCEDURE spEntropy()
-- BEGIN
-- 	DECLARE i, pJumlahTblHitung, pJumlahData, pPlayno,pPlayyes, pIterasi INT DEFAULT 0;
-- 	DECLARE pAtribut, pInformasi varchar(20) DEFAULT '';
--
-- 	DECLARE cTblHitung CURSOR FOR SELECT iterasi, atribut, informasi, jumlahdata, playno, playyes FROM tblHitung;
-- 	SELECT COUNT(*) INTO pJumlahTblHitung FROM tblHitung;
--
-- 	OPEN cTblHitung;
-- 	WHILE i<> pJumlahTblHitung DO
-- 	FETCH cTblHitung INTO pIterasi, pAtribut, pInformasi, pJumlahData, pPlayno, pPlayyes;
--
-- 		UPDATE tblHitung SET entropy= ( -(pPlayno/pJumlahData) * log2(pPlayno/pJumlahData) ) + ( -(pPlayyes/pJumlahData) * log2(pPlayyes/pJumlahData) )
-- 		WHERE iterasi=pIterasi AND atribut=pAtribut AND informasi=pInformasi;
-- 	SET i=i+1;
-- 	END WHILE;
-- 	CLOSE cTblHitung;
--
-- 	UPDATE tblHitung SET entropy =0 WHERE entropy is null and (atribut='outlook' or atribut='Temperature' or atribut='Humadity' or atribut='Windy');
--
-- END $$
-- DELIMITER ;

DELIMITER $$
CREATE PROCEDURE spEntropy(pIterasi INT)
BEGIN
	UPDATE tblHitung SET entropy= ( -(pPlayno/pJumlahData) * log2(pPlayno/pJumlahData) ) + ( -(pPlayyes/pJumlahData) * log2(pPlayyes/pJumlahData) )
		WHERE iterasi=pIterasi AND atribut=pAtribut AND informasi=pInformasi;

	UPDATE tblHitung SET entropy =0 WHERE entropy is null and
		(atribut='outlook' or atribut='Temperature'
		or atribut='Humadity' or atribut='Windy');

END $$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE spGain(pIterasi INT)
BEGIN
	DECLARE i, vJumlahTblHitung, vPlayno, vPlayyes, vIterasi INT DEFAULT 0;
	DECLARE vAtribut, vInformasi varchar(20) DEFAULT '';
	DECLARE vJumlahData, vEntropy DECIMAL(8,4);
	-- DECLARE @totalData, @entropy DECIMAL(8,4);
	DECLARE cTblHitung CURSOR FOR SELECT iterasi, atribut, informasi, jumlahdata, playno, playyes, entropy FROM tblHitung;
	SELECT COUNT(*) INTO vJumlahTblHitung FROM tblHitung;

	SELECT jumlahdata INTO @totalData FROM tblHitung WHERE gain IS NULL LIMIT 1;
	SELECT entropy INTO @entropy FROM tblHitung where gain IS NULL LIMIT 1;
	SELECT @totaldata as tot, @entropy as ent;

	OPEN cTblHitung;
	WHILE i<> vJumlahTblHitung DO
	FETCH cTblHitung INTO vIterasi, vAtribut, vInformasi, vJumlahData, vPlayno, vPlayyes, vEntropy;
		UPDATE tblHitung SET gain =((vJumlahData/@totaldata)*vEntropy) WHERE gain IS NULL
		 and iterasi=pIterasi and atribut=vAtribut AND jumlahdata=vJumlahData AND playno=vPlayno AND playyes=vPlayyes and entropy=vEntropy;
		-- SELECT gain FROM tblHitung;
		-- SELECT pJumlahData as jmlh, @totaldata as totaljmlh, pEntropy as ent, @entropy as totEnt, (pJumlahData/@jumlahData)*pEntropy as gain;
	SET i=i+1;
	END WHILE;
	CLOSE cTblHitung;

END $$
DELIMITER ;

CREATE TABLE tblGain(
	iterasi INT,
	atribut varchar(20),
	gain DECIMAL(8,4)
);

-- DELIMITER $$
-- CREATE PROCEDURE spUpdateGain(pIterasi INT)
-- BEGIN
-- 	DECLARE i INT DEFAULT 0;
-- 	TRUNCATE TABLE tblGain;
-- 	INSERT INTO tblGain(atribut, iterasi, gain)
-- 	SELECT atribut, pIterasi, ROUND(@entropy-sum(gain),4) FROM tblHitung
-- 		WHERE gain IS NOT NULL AND iterasi=pIterasi
-- 		GROUP BY atribut;
--
-- 	UPDATE tblHitung SET gain=(SELECT gain FROM tblGain WHERE atribut='outlook') WHERE atribut='outlook' and iterasi=pIterasi;
-- 	UPDATE tblHitung SET gain=(SELECT gain FROM tblGain WHERE atribut='humadity') WHERE atribut='humadity' and iterasi=pIterasi;
-- 	UPDATE tblHitung SET gain=(SELECT gain FROM tblGain WHERE atribut='temperature') WHERE atribut='temperature' and iterasi=pIterasi;
-- 	UPDATE tblHitung SET gain=(SELECT gain FROM tblGain WHERE atribut='windy') WHERE atribut='windy' and iterasi=pIterasi;
-- 	DELETE FROM tblGain WHERE atribut='';
-- 	SELECT * FROM tblHitung;
-- 	SELECT * FROM tblGain;
--
-- END $$
-- DELIMITER ;

DELIMITER $$
CREATE PROCEDURE spUpdateGain(pIterasi INT)
BEGIN
	DECLARE i INT DEFAULT 0;
	TRUNCATE TABLE tblGain;
	INSERT INTO tblGain(atribut, iterasi, gain)
	SELECT atribut, pIterasi, ROUND(@entropy-sum(gain),4) FROM tblHitung
		WHERE gain IS NOT NULL AND iterasi=pIterasi
		GROUP BY atribut;

	UPDATE tblHitung SET gain=(SELECT gain FROM tblGain WHERE atribut='outlook') WHERE atribut='outlook' and iterasi=pIterasi;
	UPDATE tblHitung SET gain=(SELECT gain FROM tblGain WHERE atribut='humadity') WHERE atribut='humadity' and iterasi=pIterasi;
	UPDATE tblHitung SET gain=(SELECT gain FROM tblGain WHERE atribut='temperature') WHERE atribut='temperature' and iterasi=pIterasi;
	UPDATE tblHitung SET gain=(SELECT gain FROM tblGain WHERE atribut='windy') WHERE atribut='windy' and iterasi=pIterasi;
	-- DELETE FROM tblGain WHERE atribut='';
	SELECT * FROM tblHitung;
	SELECT * FROM tblGain;

END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE spInsertTblTree(pIterasi INT)
BEGIN
	DECLARE i,  vIterasi, vJumlahData, vPlayno, vPlayyes, vLooping INT DEFAULT 0;
	DECLARE vAtribut, vInformasi varchar(20);
	DECLARE vGain DECIMAL(8,4);

	DECLARE cTblHitung CURSOR FOR
		SELECT iterasi, atribut, informasi, jumlahdata, playno, playyes, gain
		FROM tblHitung WHERE gain=(SELECT max(gain) FROM tblGain) and iterasi=pIterasi;
	SELECT COUNT(*) INTO vLooping FROM tblHitung where gain=(SELECT max(gain) FROM tblGain) and iterasi=pIterasi;

	OPEN cTblHitung;
	WHILE i<>vLooping DO
		FETCH cTblHitung INTO vIterasi, vAtribut, vInformasi, vJumlahData, vPlayno, vPlayyes, vGain;
				IF vAtribut="Outlook" THEN
					IF vJumlahData=vPlayno THEN
						INSERT INTO tblTree VALUES(pIterasi,vInformasi,"","","NO");
					ELSEIF vJumlahData=vPlayyes THEN
						INSERT INTO tblTree VALUES(pIterasi,vInformasi,"","","","YES");
					ELSE
						INSERT INTO tblTree VALUES(pIterasi,vInformasi,"","","","lanjut");
					END IF;
				END IF;

				IF vAtribut="Temperature" THEN
					IF vJumlahData=vPlayno THEN
						INSERT INTO tblTree VALUES(pIterasi,"",vInformasi,"","","NO");
					ELSEIF vJumlahData=vPlayyes THEN
						INSERT INTO tblTree VALUES(pIterasi,"",vInformasi,"","","YES");
					ELSE
						INSERT INTO tblTree VALUES(pIterasi,"",vInformasi,"","","lanjut");
					END IF;
				END IF;

				IF vAtribut="Humadity" THEN
					IF vJumlahData=vPlayno THEN
						INSERT INTO tblTree VALUES(pIterasi,"","",vInformasi,"","NO");
					ELSEIF vJumlahData=vPlayyes THEN
						INSERT INTO tblTree VALUES(pIterasi,"","",vInformasi,"","YES");
					ELSE
						INSERT INTO tblTree VALUES(pIterasi,"","",vInformasi,"","lanjut");
					END IF;
				END IF;

				IF vAtribut="Windy" THEN
					IF vJumlahData=vPlayno THEN
						INSERT INTO tblTree VALUES(pIterasi,"","","",vInformasi,"NO");
					ELSEIF vJumlahData=vPlayyes THEN
						INSERT INTO tblTree VALUES(pIterasi,"","","",vInformasi,"YES");
					ELSE
						INSERT INTO tblTree VALUES(pIterasi,"","","",vInformasi,"lanjut");
					END IF;
				END IF;
		SET i=i+1;
	END WHILE;
	CLOSE cTblHitung;

	-- UPDATE tblHitung SET iterasi=pIterasi WHERE iterasi IS NULL;
	-- UPDATE tblHitung SET atribut='' WHERE atribut  IS NULL;
	-- UPDATE tblHitung SET informasi='' WHERE informasi IS NULL;
	-- UPDATE tblHitung SET entropy=0 WHERE entropy IS NULL;
	-- UPDATE tblHitung SET gain=0 WHERE gain IS NULL;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE spLooping()
BEGIN
DECLARE jumlahLanjut INT default 1;
DECLARE vIterasiTblT, vJumlahDataTblT, loopingKe INT default 0;

DECLARE vOutlookTblT, vTemperatureTblT, vHumadityTblT, vWindyTblT, vPlayTblT varchar(20);

DECLARE cTblTree CURSOR FOR SELECT * FROM tblTree WHERE iterasi=loopingKe;
SELECT COUNT(*) INTO vJumlahDataTblT FROM tblTree WHERE iterasi=loopingKe;
-- SELECT * FROM tblHitung;
-- SELECT * FROM tblGain;
-- SELECT * FROM tblTree;

WHILE jumlahLanjut <> 0 AND loopingKe < 5 DO /*While untuk berhenti auto looping*/


DROP VIEW IF EXISTS vwTblData;
CREATE VIEW vwTblData as
SELECT * FROM tblData;
SELECT * FROM vwTblData;

SET loopingKe=loopingKe+1;
call spInsertTblHitung(loopingKe);
-- UPDATE tblHitung SET iterasi=1 WHERE iterasi is NULL;
-- UPDATE tblHitung SET informasi='' WHERE informasi IS NULL;
call spEntropy(loopingKe);
-- UPDATE tblHitung SET entropy= ( -(playno/jumlahdata) * log2(playno/jumlahdata) ) + ( -(playyes/jumlahdata) * log2(playyes/jumlahdata));
-- UPDATE tblHitung SET entropy = 0 WHERE entropy IS NULL;
call spGain(loopingKe);
call spUpdateGain(loopingKe);
call spInsertTblTree(loopingKe);

UPDATE tblHitung SET iterasi=loopingKe WHERE iterasi IS NULL;
UPDATE tblHitung SET atribut='' WHERE atribut  IS NULL;
UPDATE tblHitung SET informasi='' WHERE informasi IS NULL;
UPDATE tblHitung SET entropy=0 WHERE entropy IS NULL;
UPDATE tblHitung SET gain=0 WHERE gain IS NULL;

SELECT * FROM tblHitung;
SELECT * FROM tblGain;
SELECT * FROM tblTree;

SELECT loopingKe as loopingke;

SET jumlahLanjut=(SELECT COUNT(*) FROM tblTree WHERE iterasi=loopingKe AND play='lanjut');
SELECT jumlahLanjut as lanjut;
END WHILE;
END $$
DELIMITER ;

CALL spLooping;
