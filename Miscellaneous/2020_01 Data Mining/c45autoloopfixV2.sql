/*
  NIKODEMUS GALIH CANDRA WICAKSONO
  DATA D:/Galih/Unika Soegijapranata/Data Mining
  Last modified: Friday, 08 January 2021 19:13
*/
DROP DATABASE IF EXISTS c45autoloop;
CREATE DATABASE c45autoloop;
USE c45autoloop;

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


/*Testing data*/
-- INSERT INTO tblData VALUES(15,"Sunny", "Mild", "Normal", "True", "No");
-- 	INSERT INTO tblData VALUES(16,"Sunny", "Mild", "Normal", "False", "No");
	-- SELECT * FROM tblData;

	CREATE TABLE tblDataDiolah(
		nourut INT,
		outlook VARCHAR(10),
		temperature VARCHAR(10),
		humadity VARCHAR(10),
		windy VARCHAR(10),
		play VARCHAR(10)
	);

CREATE TABLE tblHitung(
	iterasi INT,
	atribut VARCHAR(20),
	informasi VARCHAR(100),
	jumlahdata INT,
	playno INT,
	playyes INT,
	entropy DECIMAL(8,4),
	gain DECIMAL(8,4)
);


CREATE TABLE tblHitungSementara(
	iterasi INT,
	atribut VARCHAR(20),
	informasi VARCHAR(20),
	jumlahdata INT,
	playno INT,
	playyes INT,
	entropy DECIMAL(8,4),
  splitgain DECIMAL(8,4),
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
  -- INSERT INTO tblTree(iterasi, play) VALUES (0, "lanjut");
  INSERT INTO tblTree VALUES (0, "","","",'',"lanjut");
  -- SELECT * FROM tblTree;

/*spRunning menjalankan autoloopingc45 berdasarkan tblTree per iterasi
	Default tblTree iterasi=0 play="lanjut"(dihapus saat insert iterasi 1)
	supaya autoloopingc45 berjalan sendiri.
	autoloopingc45 berhenti saat jumlah play="lanjut"
	pada iterasi paling terakhir adalah 0
	*/
DELIMITER $$
CREATE PROCEDURE spRunning()
	BEGIN
	DECLARE vIterasi, vLoop INT DEFAULT 0;
	DECLARE vJumlahLanjut INT DEFAULT 1;

	WHILE vJumlahLanjut <> 0 DO
		SELECT vIterasi+1 AS looping;

		/*menjalankan loooping iterasi, dibuat procedure karena membutuhkan
		cursor yang berubah-ubah didalam whilenya*/
		call spLooping(vIterasi);

		SET vIterasi=(SELECT max(iterasi) FROM tblTree);

		SELECT COUNT(*) INTO vJumlahLanjut FROM tblTree WHERE play='lanjut' and iterasi=(SELECT max(iterasi) FROM tblTree);

		SELECT vIterasi as loopKe, vJumlahLanjut as JumlahLanjut;

		SELECT "" AS "-------------------------------------------------------------------------------------------------------------------";

	END WHILE;

	END $$
	DELIMITER ;


/*spLooping cursor tblTree saat iterasi=pIterasi
	jika play="lanjut" maka akan menjalankan "proses autolooping iterasi"

	"proses autolooping iterasi"
	1. copy tblData ke vwTblData
	2. Delete vwTblData sesuai Fetch tblTree
	3. Data vwTblData diolah dan
			di Insert ke tblHitungSementara
			kemudian dihitung entropy
	4. Delete tblHitungSementara yang merupakan kriteria filter
	5. Hitung gain dari data tblHitungSementara
			kemudian dimasukkan ke tblGain.
			gain tblHitungSementara diupdate
			disesuaikan dengan data tblGain.
	6. tblHitungSementara sudah selesai, di insert ke tblHitung
	7. Cursor tblHitungSementara dengan gain tertinggi
			kemudian di insert ke tblTree iterasi setelahnya
	8. kembali ke 1 untuk autoloppingiterasi berikutnya
	*/
DELIMITER $$
CREATE PROCEDURE spLooping(pIterasi INT)
	BEGIN
	DECLARE vIterasi, vJumlahData, i INT DEFAULT 0;
	DECLARE vOutlook, vTemperature, vHumadity, vWindy, vPlay varchar(20);

	DECLARE cTblTree CURSOR FOR SELECT * FROM tblTree WHERE iterasi=pIterasi;
	SELECT COUNT(*) INTO vJumlahData FROM TblTree WHERE iterasi=pIterasi;


		OPEN cTblTree;
			WHILE i <> vJumlahData DO
				FETCH cTblTree INTO vIterasi, vOutlook, vTemperature, vHumadity, vWindy, vPlay;
				IF vPlay='lanjut' THEN
					TRUNCATE TABLE tblDataDiolah;
					INSERT INTO tblDataDiolah
						SELECT * FROM tblData;
					call spDelete(vIterasi, vOutlook, vTemperature, vHumadity, vWindy, vPlay);
					SELECT * FROM vwTblData;
					call spInsertTblHitungSementara(pIterasi);
					call spDeleteTblHitungSementara(vIterasi, vOutlook, vTemperature, vHumadity, vWindy, vPlay);
					call spGain(pIterasi);
					call spInsertTblHitung(vIterasi, vOutlook, vTemperature, vHumadity, vWindy, vPlay);
					SELECT * FROM tblHitungSementara;
					SELECT * FROM tblGain;
					call spInsertTblTree(vIterasi, vOutlook, vTemperature, vHumadity, vWindy, vPlay);
					SELECT * FROM tblHitung;
					SELECT * FROM tblTree;
				END IF; /*END FROM IF vPlay='lanjut'*/
			SET i=i+1;
			END WHILE;
		CLOSE cTblTree;
	END $$
	DELIMITER ;

/*spDelete memfilter vwTblData*/
DELIMITER $$
CREATE PROCEDURE spDelete(pIterasi INT, pOutlook varchar(20), pTemperature varchar(20),
													pHumadity varchar(20), pWindy varchar(20), pPlay varchar(20))
	BEGIN
		IF pOutlook IS NULL THEN
			DELETE FROM vwTblData WHERE outlook != pOutlook;
		END IF;
		IF pTemperature IS NULL THEN
			DELETE FROM vwTblData WHERE temperature != pTemperature ;
		END IF;
		IF pHumadity IS NULL THEN
			DELETE FROM vwTblData WHERE humadity != pHumadity ;
		END IF;
		IF pWindy IS NULL THEN
			DELETE FROM vwTblData WHERE windy != pWindy ;
		END IF;
	END $$
	DELIMITER ;

/*spInsertTblHitungSementara dijalankan setelah spDelete(vwTblData sudah difilter)
	mentruncate tblHitungSementara sebelum kemudian mengisi
		atribut, informasi, jumlahdata, jumlahplayno, jumlahplayyes, entropy.
		setelahnya akan mengisi slitgain dan gain pada proses spGain.
*/
DELIMITER $$
CREATE PROCEDURE spInsertTblHitungSementara(pIterasi INT)
  BEGIN
  DECLARE i, vJumlahTblData INT DEFAULT 0;
	DECLARE pJumlahData, pPlayno, pPlayyes INT;

  SET pIterasi=pIterasi+1;
  TRUNCATE TABLE tblHitungSementara;
	/*Mengolah untuk totaldata dari vwTblData*/
  INSERT INTO tblHitungSementara(jumlahdata, playno, playyes)
  	VALUES(
			(SELECT COUNT(*) FROM vwTblData),
			(SELECT COUNT(*) FROM vwTblData WHERE  play = 'No'),
			(SELECT COUNT(*) FROM vwTblData WHERE  play = 'Yes')
		);
	/*Mengolah data Outlook dari vwTblData*/
  INSERT INTO tblHitungSementara(informasi, iterasi, atribut,  jumlahdata, playno, playyes)
  	SELECT DISTINCT(A.outlook), pIterasi, 'Outlook',
			(SELECT COUNT(*) FROM vwTblData WHERE  outlook = A.outlook),
			(SELECT COUNT(*) FROM vwTblData WHERE  outlook = A.outlook AND play = 'No'),
			(SELECT COUNT(*) FROM vwTblData WHERE  outlook = A.outlook AND play = 'Yes')
		FROM vwTblData AS A
		ORDER BY A.outlook;
	/*Mengolah data Temperature dari vwTblData*/
  INSERT INTO tblHitungSementara(informasi, iterasi, atribut,  jumlahdata, playno, playyes)
  	SELECT DISTINCT(A.temperature), pIterasi, 'Temperature',
			(SELECT COUNT(*) FROM vwTblData WHERE  temperature = A.temperature),
			(SELECT COUNT(*) FROM vwTblData WHERE  temperature = A.temperature AND play = 'No'),
			(SELECT COUNT(*) FROM vwTblData WHERE  temperature = A.temperature AND play = 'Yes')
		FROM vwTblData AS A
		ORDER BY A.temperature;
	/*Mengolah data Humadity dari vwTblData*/
  INSERT INTO tblHitungSementara(informasi, iterasi, atribut,  jumlahdata, playno, playyes)
  	SELECT DISTINCT(A.humadity), pIterasi, 'Humadity',
			(SELECT COUNT(*) FROM vwTblData WHERE  humadity = A.humadity),
			(SELECT COUNT(*) FROM vwTblData WHERE  humadity = A.humadity AND play = 'No'),
			(SELECT COUNT(*) FROM vwTblData WHERE  humadity = A.humadity AND play = 'Yes')
		FROM vwTblData AS A
		ORDER BY A.humadity;
	/*Mengolah data Windy dari vwTblData*/
  INSERT INTO tblHitungSementara(informasi, iterasi, atribut,  jumlahdata, playno, playyes)
	  SELECT DISTINCT(A.windy), pIterasi, 'Windy',
			(SELECT COUNT(*) FROM vwTblData WHERE  windy = A.windy),
			(SELECT COUNT(*) FROM vwTblData WHERE  windy = A.windy AND play = 'No'),
			(SELECT COUNT(*) FROM vwTblData WHERE  windy = A.windy AND play = 'Yes')
		FROM vwTblData AS A
		ORDER BY A.windy;
	/*Mengupdate entropy tblHitungSementara*/
  UPDATE tblHitungSementara
		SET entropy=(-(playno/jumlahdata) * log2(playno/jumlahdata)) +
								(-(playyes/jumlahdata) * log2(playyes/jumlahdata));
  UPDATE tblHitungSementara SET entropy=0 WHERE entropy IS NULL;
	/*splitgain adalah
			jumlahdata per informasi/jumlahdata pada 1 vwTblData
			*entropy per informasi
	*/
  UPDATE tblHitungSementara SET splitgain=((jumlahdata/(SELECT jumlahdata FROM tblHitungSementara WHERE iterasi IS NULL))*entropy);
  UPDATE tblHitungSementara SET splitgain=0 WHERE splitgain IS NULL;
  -- SELECT * FROM tblHitungSementara;
  END $$
  DELIMITER ;

/*spDeleteTblHitungSementara untuk mendelete data di tblHitungSementara
yang merupakan kriteria filter(tblTree yang terisi)
contoh:iterasi 1 humadity high, maka iterasi 2 akan dihapus
			selain humadity high. Dan saat di Insert ke tblHitungSementara,
			humadity high akan terolah ke tblHitungSementara dan diproses.
			Karena itu dihapus setelah spInsertTblHitungSementara
*/
DELIMITER $$
CREATE PROCEDURE spDeleteTblHitungSementara(pIterasi INT, pOutlook varchar(20), pTemperature varchar(20),
													pHumadity varchar(20), pWindy varchar(20), pPlay varchar(20))
	BEGIN
		IF pOutlook!="" THEN
			DELETE FROM tblHitungSementara WHERE atribut = "Outlook";
		END IF;
		IF pTemperature!="" THEN
			DELETE FROM tblHitungSementara WHERE atribut = "Temperature" ;
		END IF;
		IF pHumadity!="" THEN
			DELETE FROM tblHitungSementara WHERE atribut = "Humadity" ;
		END IF;
		IF pWindy!="" THEN
			DELETE FROM tblHitungSementara WHERE atribut = "Windy" ;
		END IF;
	END $$
	DELIMITER ;

/*spGain menghitung gain dari tblHitungSementara
	di masukkan ke tblGain,
	kemudian diupdate tblHitungSementara
	diupdate disesuaikan tblGain,(tblHitungSementara selesai)
	tblHitungSementara di insert ke tblHitung
*/
DELIMITER $$
CREATE PROCEDURE spGain(pIterasi INT)
  BEGIN
    SET pIterasi=pIterasi+1;
    DROP TABLE IF EXISTS tblGain;
    CREATE TABLE tblGain(
      atribut varchar(20),
      gain DECIMAL(8,4)
    );
    INSERT INTO tblGain
    SELECT atribut, ROUND((SELECT entropy FROM tblHitungSementara WHERE iterasi IS NULL)-sum(splitgain),4)
    FROM tblHitungSementara
    GROUP BY atribut;
    /*DELETE baris atas(total)*/
    DELETE FROM tblGain WHERE atribut IS NULL;
    -- SELECT * FROM tblGain;
    /*Hasil tblGain di update ke tblHitung Sementara*/
    UPDATE tblHitungSementara SET gain=(SELECT gain FROM tblGain WHERE atribut='outlook') WHERE atribut='outlook';
    UPDATE tblHitungSementara SET gain=(SELECT gain FROM tblGain WHERE atribut='humadity') WHERE atribut='humadity';
    UPDATE tblHitungSementara SET gain=(SELECT gain FROM tblGain WHERE atribut='temperature') WHERE atribut='temperature';
    UPDATE tblHitungSementara SET gain=(SELECT gain FROM tblGain WHERE atribut='windy') WHERE atribut='windy';
    /*Mendefaultkan tblHitungSementara baris atas(total)*/
    UPDATE tblHitungSementara set splitgain=0 WHERE iterasi is NULL;
    UPDATE tblHitungSementara set gain=0 WHERE iterasi is NULL;
    UPDATE tblHitungSementara set informasi='' WHERE iterasi is NULL;
    UPDATE tblHitungSementara set atribut='' WHERE iterasi is NULL;
    UPDATE tblHitungSementara set iterasi=pIterasi WHERE iterasi is NULL;
  END $$
  DELIMITER ;


/*spInsertTblHitung untuk menginsert hasil tblHitungSementara yang sudah jadi,
sekaligus mengubah atribut dan informasi yang ="",
sehingga tahu total datanya dan apa saja yang di filter dan lebih mudah dibaca
*/
DELIMITER $$
CREATE PROCEDURE spInsertTblHitung(pIterasi INT, pOutlook varchar(20), pTemperature varchar(20),
                          pHumadity varchar(20), pWindy varchar(20), pPlay varchar(20))
  BEGIN
	DECLARE vIterasi, vJumlahData, vPlayno, vPlayyes, i, vJumlahTblHitungSementara INT DEFAULT 0;
	DECLARE vConcatInformasi varchar(100) DEFAULT "  ";
	DECLARE vAtribut, vInformasi varchar(20);
	DECLARE vEntropy, vGain DECIMAL(8,4);

	DECLARE cTblHitungSementara CURSOR FOR
					SELECT iterasi, atribut, informasi, jumlahdata, playno, playyes, entropy, gain
					FROM tblHitungSementara;
	SELECT COUNT(*) INTO vJumlahTblHitungSementara FROM tblHitungSementara;

	IF pOutlook!="" THEN
		SET vConcatInformasi=CONCAT(vConcatInformasi, pOutlook, ", ");
	END IF;

	IF pTemperature!="" THEN
		SET vConcatInformasi=CONCAT(vConcatInformasi, pTemperature, ", ");
	END IF;

	IF pHumadity!="" THEN
		SET vConcatInformasi=CONCAT(vConcatInformasi, pHumadity, ", ");
	END IF;

	IF pWindy!="" THEN
		SET vConcatInformasi=CONCAT(vConcatInformasi, pWindy, ", ");
	END IF;

	SET vConcatInformasi=SUBSTRING(vConcatInformasi, 1, LENGTH(vConcatInformasi)-2);

	OPEN cTblHitungSementara;

		WHILE i <> vJumlahTblHitungSementara DO
			FETCH cTblHitungSementara INTO vIterasi, vAtribut, vInformasi, vJumlahData, vPlayno, vPlayyes, vEntropy, vGain;
				IF vAtribut = "" THEN
					INSERT INTO tblHitung VALUES
						(vIterasi, "  Filter :", vConcatInformasi, vJumlahData, vPlayno, vPlayyes, vEntropy, vGain);
				ELSE
					INSERT INTO tblHitung VALUES
						(vIterasi, vAtribut, vInformasi, vJumlahData, vPlayno, vPlayyes, vEntropy, vGain);
				END IF;
			SET i=i+1;
		END WHILE;
	CLOSE cTblHitungSementara;
	END $$
	DELIMITER ;

/*spInsertTblTree berisi parameter dari tblTree yang sedang diproses(perbaris dengan cursor)
kemudian akan insert tblTree untuk iterasi berikutnya dengan isi parameter tadi
dan tambahan pada kolom tblTree yang sesuai atribut tblHitungSementara
dengan kriteria gain tertinggi di tblHitungSementara,
tambahannya berisi informasi dari tblHitungSementara.
*/
DELIMITER $$
CREATE PROCEDURE spInsertTblTree(pIterasi INT, pOutlook varchar(20), pTemperature varchar(20),
                          pHumadity varchar(20), pWindy varchar(20), pPlay varchar(20))
  BEGIN
    DECLARE vIterasi, vJumlahData, vPlayno, vPlayyes, vJumlahTblHitungSementara, i INT DEFAULT 0;
    DECLARE vAtribut, vInformasi varchar(20);
    DECLARE vEntropy, vSplitGain, vGain DECIMAL(8,4);
    DECLARE cTblHitungSementara CURSOR FOR SELECT * FROM tblHitungSementara WHERE gain=(SELECT max(gain) FROM tblHitungSementara);
    SELECT COUNT(*) INTO vJumlahTblHitungSementara FROM  tblHitungSementara WHERE gain=(SELECT max(gain) FROM tblHitungSementara);
    SET pIterasi=pIterasi+1;
    OPEN cTblHitungSementara;
    WHILE i <> vJumlahTblHitungSementara and vJumlahTblHitungSementara != 0 DO
	    FETCH cTblHitungSementara INTO vIterasi, vAtribut, vInformasi, vJumlahData, vPlayno, vPlayyes, vEntropy, vSplitGain, vGain;
			IF vJumlahData = 0 THEN
				INSERT INTO tblTree VALUES(vIterasi, pOutlook, pTemperature, pHumadity, pWindy, '    No Data');
			ELSE
	      IF vAtribut='Outlook' THEN
	        IF vJumlahData=vPlayno THEN
	          INSERT INTO tblTree VALUES(vIterasi, vInformasi, pTemperature, pHumadity, pWindy, '         NO');
	        ELSEIF vJumlahData=vPlayyes THEN
	          INSERT INTO tblTree VALUES(vIterasi, vInformasi, pTemperature, pHumadity, pWindy, '        YES');
	        ELSE
	          INSERT INTO tblTree VALUES(vIterasi, vInformasi, pTemperature, pHumadity, pWindy, 'lanjut');
	        END IF;
	      END IF;
	      IF vAtribut='Temperature' THEN
	        IF vJumlahData=vPlayno THEN
	          INSERT INTO tblTree VALUES(vIterasi, pOutlook, vInformasi, pHumadity, pWindy, '         NO');
	        ELSEIF vJumlahData=vPlayyes THEN
	          INSERT INTO tblTree VALUES(vIterasi, pOutlook, vInformasi, pHumadity, pWindy, '        YES');
	        ELSE
	          INSERT INTO tblTree VALUES(vIterasi, pOutlook, vInformasi, pHumadity, pWindy, 'lanjut');
	        END IF;
	      END IF;
	      IF vAtribut='Humadity' THEN
	        IF vJumlahData=vPlayno THEN
	          INSERT INTO tblTree VALUES(vIterasi, pOutlook, pTemperature, vInformasi, pWindy, '         NO');
	        ELSEIF vJumlahData=vPlayyes THEN
	          INSERT INTO tblTree VALUES(vIterasi, pOutlook, pTemperature, vInformasi, pWindy, '        YES');
	        ELSE
	          INSERT INTO tblTree VALUES(vIterasi, pOutlook, pTemperature, vInformasi, pWindy, 'lanjut');
	        END IF;
	      END IF;
	      IF vAtribut='Windy' THEN
	        IF vJumlahData=vPlayno THEN
	          INSERT INTO tblTree VALUES(vIterasi, pOutlook, pTemperature, pHumadity, vInformasi, '         NO');
	        ELSEIF vJumlahData=vPlayyes THEN
	          INSERT INTO tblTree VALUES(vIterasi, pOutlook, pTemperature, pHumadity, vInformasi, '        YES');
	        ELSE
	          INSERT INTO tblTree VALUES(vIterasi, pOutlook, pTemperature, pHumadity, vInformasi, 'lanjut');
	        END IF;
	      END IF;
			END IF; /* END FROM IF vJumlahData = 0*/

			/*Menghilangkan baris 1(iterasi=0 play="lanjut")
				karena hanya digunakan untuk menjalankan autolooping awal*/
	    DELETE FROM tblTree WHERE iterasi=0;
	    SET i=i+1;
    END WHILE;
    CLOSE cTblHitungSementara;

		-- SELECT "spInsertTblTreeClear" AS "insert";
		-- SELECT * FROM tblTree;
  END $$
  DELIMITER ;

call spRunning();

SELECT "|  ______         _____ ______    ________  __    __  ________  ________     ______  __      _______  ________  ______   | |
| | |   ___|       / _  ||   ___|  |   __   ||  |  |  ||___  ___||   ___  |   |   ___||  |    |   ____||   __   ||  __  )  | |
| | |  |     ___  / /_| ||  |__    |  |__|  ||  |  |  |   |  |   |  |   | |   |  |    |  |    |  |____ |  |__|  || |_/ /   | |
| | |  |    |___|/___   ||___  \\   |   __   ||  |  |  |   |  |   |  |   | |   |  |    |  |    |   ____||   __   ||     \\   | |
| | |  |___          |  | ___)  |  |  |  |  ||  |__|  |   |  |   |  |___| |   |  |___ |  |___ |  |____ |  |  |  ||  |\\  \\  | |
| | |______|         |__||_____/   |__|  |__||________|   |__|   |________|   |______||______||_______||__|  |__||__| \__\\ | |
| |                                                                                                                        |" as "-";
