DROP DATABASE IF EXISTS dbC45;
CREATE DATABASE dbC45;
USE dbC45;

CREATE TABLE tblC45
(
	nomor VARCHAR(20),
	demam VARCHAR(20),
	pusing VARCHAR(20),
	nyeri VARCHAR(20),
	lemas VARCHAR(20),
	kelelahan VARCHAR(20),
	hidung VARCHAR(20),
  bersin VARCHAR(20),
  tenggorokan VARCHAR(20),
  bernafas VARCHAR(20),
  diagnosa VARCHAR(20)
);

INSERT INTO tblC45 VALUES
("P1","Tidak","Ringan","Tidak","Tidak","Tidak","Ringan","Parah","Parah","Ringan","Demam"),
("P2","Parah","Parah","Parah","Parah","Parah","Tidak","Tidak","Parah","Parah","Flu"),
("P3","Parah","Parah","Ringan","Parah","Parah","Parah","Tidak","Parah","Parah","Flu"),
("P4","Tidak","Tidak","Tidak","Ringan","Tidak","Parah","Tidak","Ringan","Ringan","Demam"),
("P5","Parah","Parah","Ringan","Parah","Parah","Parah","Tidak","Parah","Parah","Flu"),
("P6","Tidak","Tidak","Tidak","Ringan","Tidak","Parah","Parah","Parah","Tidak","Demam"),
("P7","Parah","Parah","Parah","Parah","Parah","Tidak","Tidak","Tidak","Parah","Flu"),
("P8","Tidak","Tidak","Tidak","Tidak","Tidak","Parah","Parah","Tidak","Ringan","Demam"),
("P9","Tidak","Ringan","Ringan","Tidak","Tidak","Parah","Parah","Parah","Parah","Demam"),
("P10","Parah","Parah","Parah","Ringan","Ringan","Tidak","Parah","Tidak","Parah","Flu"),
("P11","Tidak","Tidak","Tidak","Ringan","Tidak","Parah","Ringan","Parah","Tidak","Demam"),
("P12","Parah","Ringan","Parah","Ringan","Parah","Tidak","Parah","Tidak","Ringan","Flu"),
('P13','Tidak','Tidak','Ringan','Ringan','Tidak','Parah','Parah','Parah','Tidak','Demam'),
('P14','Parah','Parah','Parah','Parah','Ringan','Tidak','Parah','Parah','Parah','Flu'),
('P15','Ringan','Tidak','Tidak','Ringan','Tidak','Parah','Tidak','Parah','Ringan','Demam'),
('P16','Tidak','Tidak','Tidak','Tidak','Tidak','Parah','Parah','Parah','Parah','Demam'),
('P17','Parah','Ringan','Parah','Ringan','Ringan','Tidak','Tidak','Tidak','Parah','Flu');

SELECT * FROM tblC45;

CREATE TABLE tblHitung
(
  iterasi int,
  atribut varchar(20),
  keterangan varchar(20),
  jumlah_data int,
  jmldemam int,
  jmlflu int,
  entropy decimal(8,4),
  gain decimal(8,4)
);

CREATE TABLE tblTemp
(
  iterasi int,
  atribut varchar(20),
  keterangan varchar(20),
  jumlah_data int,
  jmldemam int,
  jmlflu int,
  entropy decimal(8,4),
  gain decimal(8,4)
);

CREATE TABLE tblTree
(
  iterasi int,
  atribut varchar(20),
  keterangan varchar(20),
  jumlah_data int,
  jmldemam int,
  jmlflu int,
  entropy decimal(8,4),
  gain decimal(8,4)
);

DELIMITER $$
CREATE PROCEDURE spGain(i int)
BEGIN
	DROP TABLE IF EXISTS tblTampung;
	CREATE TEMPORARY TABLE tblTampung
	(
	atribut VARCHAR(20),
	gain DECIMAL(8, 4)
	);

	INSERT INTO tblTampung(atribut, gain)
	SELECT atribut, @entropy -
	SUM((jumlah_data/@jumlahdata) * entropy) AS GAIN
	FROM tblTemp
	GROUP BY atribut;

	UPDATE tblTemp SET GAIN =
		(
		SELECT gain
		FROM tblTampung
		WHERE atribut = tblTemp.atribut AND iterasi=i
		);
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE spHitung(i int)
BEGIN
	DECLARE vMaxGain decimal(8,4);

	SELECT COUNT(*) INTO @jumlahdata
	FROM tblC45;
	SELECT COUNT(*) INTO @jmldemam
	FROM tblC45
	WHERE diagnosa = 'Demam';
	SELECT COUNT(*) INTO @jmlflu
	FROM tblC45
	WHERE diagnosa = 'Flu';
	SELECT (-(@jmldemam/@jumlahdata) * log2(@jmldemam/@jumlahdata))
	+
	(-(@jmlflu/@jumlahdata)*log2(@jmlflu/@jumlahdata))
	INTO @entropy;

	CALL spRegisterTree(i);

	SELECT atribut INTO @atribut FROM tblTree WHERE iterasi=i;
	SELECT keterangan INTO @keterangan FROM tblTree WHERE iterasi=i;
	SELECT jumlah_data INTO @jumlahdata FROM tblTree WHERE iterasi=i;
	SELECT jmldemam INTO @jmldemam FROM tblTree WHERE iterasi=i;
	SELECT jmlflu INTO @jmlflu FROM tblTree WHERE iterasi=i;
	SELECT entropy INTO @entropy FROM tblTree WHERE iterasi=i;

	SELECT @jumlahdata AS JUM_DATA,
	@jmldemam AS JUM_DEMAM,
	@jmlflu AS JUM_FLU,
	ROUND(@entropy, 4) AS ENTROPY;

	CALL spDeleteC45(i);

	SELECT * FROM tblC45;

	INSERT INTO tblTemp(keterangan, jumlah_data, jmldemam, jmlflu)
		select A.demam AS DEMAM, COUNT(*) AS JUMLAH_DATA,
		(select COUNT(*) from tblC45 AS B WHERE B.diagnosa = 'Demam' AND B.demam = A.demam) AS 'NO',
		(select COUNT(*) from tblC45 AS C WHERE C.diagnosa = 'Flu' AND C.demam = A.demam) AS 'YES'
		from tblC45 AS A GROUP BY A.demam;
	UPDATE tblTemp SET atribut = 'demam' WHERE atribut IS NULL;

	INSERT INTO tblTemp(keterangan, jumlah_data, jmldemam, jmlflu)
		select A.pusing AS PUSING, COUNT(*) AS JUMLAH_DATA,
		(select COUNT(*) from tblC45 AS B WHERE B.diagnosa = 'Demam' AND B.pusing = A.pusing) AS 'NO',
		(select COUNT(*) from tblC45 AS C WHERE C.diagnosa = 'Flu' AND C.pusing = A.pusing) AS 'YES'
		from tblC45 AS A GROUP BY A.pusing;
	UPDATE tblTemp SET atribut = 'PUSING' WHERE atribut IS NULL;

	INSERT INTO tblTemp(keterangan, jumlah_data, jmldemam, jmlflu)
		select A.nyeri AS NYERI, COUNT(*) AS JUMLAH_DATA,
		(select COUNT(*) from tblC45 AS B WHERE B.diagnosa = 'Demam' AND B.nyeri = A.nyeri) AS 'NO',
		(select COUNT(*) from tblC45 AS C WHERE C.diagnosa = 'Flu' AND C.nyeri = A.nyeri) AS 'YES'
		from tblC45 AS A GROUP BY A.nyeri;
	UPDATE tblTemp SET atribut = 'NYERI' WHERE atribut IS NULL;

	INSERT INTO tblTemp(keterangan, jumlah_data, jmldemam, jmlflu)
		select A.lemas AS LEMAS, COUNT(*) AS JUMLAH_DATA,
		(select COUNT(*) from tblC45 AS B WHERE B.diagnosa = 'Demam' AND B.lemas = A.lemas) AS 'NO',
		(select COUNT(*) from tblC45 AS C WHERE C.diagnosa = 'Flu' AND C.lemas = A.lemas) AS 'YES'
		from tblC45 AS A GROUP BY A.lemas;
	UPDATE tblTemp SET atribut = 'LEMAS' WHERE atribut IS NULL;

	INSERT INTO tblTemp(keterangan, jumlah_data, jmldemam, jmlflu)
		select A.kelelahan AS KELELAHAN, COUNT(*) AS JUMLAH_DATA,
		(select COUNT(*) from tblC45 AS B WHERE B.diagnosa = 'Demam' AND B.kelelahan = A.kelelahan) AS 'NO',
		(select COUNT(*) from tblC45 AS C WHERE C.diagnosa = 'Flu' AND C.kelelahan = A.kelelahan) AS 'YES'
		from tblC45 AS A GROUP BY A.kelelahan;
	UPDATE tblTemp SET atribut = 'KELELAHAN' WHERE atribut IS NULL;

	INSERT INTO tblTemp(keterangan, jumlah_data, jmldemam, jmlflu)
		select A.hidung AS HIDUNG_TERSUMBAT, COUNT(*) AS JUMLAH_DATA,
		(select COUNT(*) from tblC45 AS B WHERE B.diagnosa = 'Demam' AND B.hidung = A.hidung) AS 'NO',
		(select COUNT(*) from tblC45 AS C WHERE C.diagnosa = 'Flu' AND C.hidung = A.hidung) AS 'YES'
		from tblC45 AS A GROUP BY A.hidung;
	UPDATE tblTemp SET atribut = 'HIDUNG TERSUMBAT' WHERE atribut IS NULL;

	INSERT INTO tblTemp(keterangan, jumlah_data, jmldemam, jmlflu)
		select A.bersin AS BERSIN, COUNT(*) AS JUMLAH_DATA,
		(select COUNT(*) from tblC45 AS B WHERE B.diagnosa = 'Demam' AND B.bersin = A.bersin) AS 'NO',
		(select COUNT(*) from tblC45 AS C WHERE C.diagnosa = 'Flu' AND C.bersin = A.bersin) AS 'YES'
		from tblC45 AS A GROUP BY A.bersin;
	UPDATE tblTemp SET atribut = 'BERSIN' WHERE atribut IS NULL;

	INSERT INTO tblTemp(keterangan, jumlah_data, jmldemam, jmlflu)
		select A.tenggorokan AS SAKIT_TENGGOROKAN, COUNT(*) AS JUMLAH_DATA,
		(select COUNT(*) from tblC45 AS B WHERE B.diagnosa = 'Demam' AND B.tenggorokan = A.tenggorokan) AS 'NO',
		(select COUNT(*) from tblC45 AS C WHERE C.diagnosa = 'Flu' AND C.tenggorokan = A.tenggorokan) AS 'YES'
		from tblC45 AS A GROUP BY A.tenggorokan;
	UPDATE tblTemp SET atribut = 'SAKIT TENGGOROKAN' WHERE atribut IS NULL;

	INSERT INTO tblTemp(keterangan, jumlah_data, jmldemam, jmlflu)
		select A.bernafas AS SULIT_BERNAFAS, COUNT(*) AS JUMLAH_DATA,
		(select COUNT(*) from tblC45 AS B WHERE B.diagnosa = 'Demam' AND B.bernafas = A.bernafas) AS 'NO',
		(select COUNT(*) from tblC45 AS C WHERE C.diagnosa = 'Flu' AND C.bernafas = A.bernafas) AS 'YES'
		from tblC45 AS A GROUP BY A.bernafas;
	UPDATE tblTemp SET atribut = 'SULIT BERNAFAS' WHERE atribut IS NULL;

	UPDATE tblTemp SET iterasi = i WHERE iterasi IS NULL;
	UPDATE tblTemp SET entropy = (-(jmldemam/jumlah_data) * log2(jmldemam/jumlah_data)) + (-(jmlflu/jumlah_data) * log2(jmlflu/jumlah_data)) where jmldemam <> 0 and jmlflu <> 0;
	UPDATE tblTemp SET entropy = 0 WHERE entropy IS NULL;

	CALL spDeleteTemp(i);
	CALL spGain(i);
	CALL spRegisterHitung(i);

	/*SELECT * FROM tblTemp;*/
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE spDeleteC45(i int)
BEGIN


END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE spRegisterTree(i int)
BEGIN
DECLARE vMaxGain decimal(8,4);
SELECT MAX(gain) INTO vMaxGain FROM tblTemp2;

if i = 1 THEN
	INSERT INTO tblTree(iterasi, atribut, jumlah_data, jmldemam, jmlflu, entropy) VALUES
	 (i, 'TOTAL DATA', @jumlahdata, @jmldemam, @jmlflu, @entropy);
	INSERT INTO tblTemp(atribut, jumlah_data, jmldemam, jmlflu, entropy) VALUES
 	('TOTAL DATA', @jumlahdata, @jmldemam, @jmlflu, @entropy);
ELSE
	INSERT INTO tblTree(atribut, keterangan, jumlah_data, jmldemam, jmlflu, entropy, gain)
		SELECT atribut, keterangan, jumlah_data, jmldemam, jmlflu, entropy, gain
		FROM tblTemp2 WHERE gain = vMaxGain AND iterasi = i-1 AND keterangan='Ringan' AND atribut='Demam';
	UPDATE tblTree SET iterasi = i WHERE iterasi IS NULL;
END if;

SELECT * FROM tblTree;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE spRegisterHitung(i int)
BEGIN
	DROP TABLE IF EXISTS tblTemp2;
	CREATE TEMPORARY TABLE tblTemp2
	(
		iterasi int,
	  atribut varchar(20),
	  keterangan varchar(20),
	  jumlah_data int,
	  jmldemam int,
	  jmlflu int,
	  entropy decimal(8,4),
	  gain decimal(8,4)
	);
	INSERT INTO tblTemp2
		SELECT * FROM tblTemp WHERE iterasi = i;
	INSERT INTO tblHitung
		SELECT * FROM tblTemp2;
	SELECT * FROM tblHitung;
	SELECT * FROM tblTemp2;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE spDeleteTemp(i int)
BEGIN
	IF i=2 THEN
		DELETE FROM tblTemp WHERE atribut = 'DEMAM' AND iterasi=i;
	END IF;
END $$
DELIMITER ;

/*ITERATIONS AUTOMATE*/

DELIMITER $$
CREATE PROCEDURE spAutomate()
BEGIN
DECLARE i int;
SET i=1;
	WHILE i<3 DO
		SELECT CONCAT("iterasi ke: ", i) AS "Status";
		CALL spHitung(i);
		SET i=i+1;
	END WHILE;
END $$
DELIMITER ;

CALL spAutomate();
