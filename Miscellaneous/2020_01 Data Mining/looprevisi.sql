DROP DATABASE IF EXISTS DBC45;
CREATE DATABASE DBC45;
USE DBC45;

-- INI FILE YANG ASLI YANG SUDAH DI APPROVE

CREATE TABLE tblC45(
	nourut INT,
	outlook VARCHAR(10),
	temperature VARCHAR(10),
	humadity VARCHAR(10),
	windy VARCHAR(10),
	play VARCHAR(10)
);

load data local infile "dbC45.csv"
into table tblC45
fields terminated by ";"
enclosed by ''''
ignore 1 lines;

-- SELECT * FROM tblC45;

-- UNTUK TABEL HITUNGAN
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

-- UNTUK MELIHAT JALUR NYA
CREATE TABLE tblPath(
	iterasi INT,
	atribut VARCHAR(20),
	informasi VARCHAR(20),
	gain DECIMAL(8,4)
);

-- UNTUK MENEMUKAN PATH NYA
CREATE TABLE tblKolom(
	iterasi INT,
	nourut INT,
	outlook VARCHAR(10),
	temperature VARCHAR(10),
	humadity VARCHAR(10),
	windy VARCHAR(10),
	play VARCHAR(10)
);

-- TABEL GAIN
CREATE TABLE tblGain(
	iterasi INT,
	atribut VARCHAR(20),
	gain DECIMAL(8,4)
);

/*
ORET ORET AN

STEP PERTAMA :
	1.1 MEMASUKKAN SEMUA DATA KE TBLKOLOM DENGAN ITUNGAN ITERASSI SESUAI ITERASI NYA
	1.2 MENGHAPUS DATA YANG TIDAK SESUAI DENGAN YANG ADA DI TBL PATH
	1.3 HITUNG PLAYYES DAN PLAYNO DARI TBLKOLOM DI ITERASI TERSEBUT
	1.4 MEMINDAHKAN DATA DARI TBLKOLOM KE TBLHITUNG LALU HITUNG LALU HITUNG ENTROPY DAN JUGA GAIN NYA

STEP KEDUA :
	2.1 GAIN TERTINGGI MASUK TBLPATH

*/


-- PROCEDURE UNTUK HITUNG ENTROPY
DELIMITER &&
CREATE PROCEDURE spEntropy(pLoop INT)
BEGIN

	SELECT pLoop AS 'LOOP-KE';

	-- STEP 1.1
	INSERT INTO tblKolom
	SELECT pLoop,
		   nourut,
		   outlook,
		   temperature,
		   humadity,
		   windy,
		   play
	FROM tblC45;

	-- STEP 1.2
	CALL spEliminasi(pLoop);

	-- STEP 1.3
	CALL spHitungPlay(pLoop);

END&&
DELIMITER ;


-- PROCEDURE ELIMINASI UNTUK MENGELIMINASI SEMUA YANG ADA DI TABEL KOLOM DENGAN ELIMINATOR TBLPATH
DELIMITER ^^
CREATE PROCEDURE spEliminasi(pLoop INT)
BEGIN

	-- CURSOR TBLPATH
	DECLARE vIterasiPath, vLoopPath, vJumlahDataPath INT DEFAULT 0;
	DECLARE vAtributPath VARCHAR(20);

	-- CURSOR TBLKOLOM
	DECLARE vLoopKolom, vJumlahDataKolom, vIterasiKolom, vNoUrutKolom INT DEFAULT 0;
	DECLARE vOutlookKolom, vTemperatureKolom, vHumadityKolom, vWindyKolom, vPlayKolom, vInformasiKolom VARCHAR(50);

	DECLARE cPath CURSOR FOR SELECT iterasi, atribut, informasi FROM tblPath;
	DECLARE cKolom CURSOR FOR SELECT * FROM tblKolom;
	SELECT COUNT(*) INTO vJumlahDataPath FROM tblPath;
	SELECT COUNT(*) INTO vJumlahDataKolom FROM tblKolom WHERE iterasi = pLoop;

	OPEN cKolom;

		WHILE vLoopKolom < vJumlahDataKolom DO

			FETCH cKolom INTO vIterasiKolom, vNoUrutKolom, vOutlookKolom, vTemperatureKolom, vHumadityKolom, vWindyKolom, vPlayKolom;
			SET vLoopPath = 0;

			OPEN cPath;

				WHILE vLoopPath < vJumlahDataPath DO

					FETCH cPath INTO vIterasiPath, vAtributPath, vInformasiKolom;

						-- CEK ATRIBUT DI TBLPATH APAKAH ITU HUMADITY ATAU YANG LAIN NYA

						IF vAtributPath = 'humadity' THEN

							IF vHumadityKolom <> vInformasiKolom  THEN

								DELETE FROM tblKolom WHERE iterasi = pLoop AND nourut = vNoUrutKolom;
							END IF;

						ELSEIF vAtributPath = 'outlook' THEN

							IF vOutlookKolom <> vInformasiKolom  THEN

								DELETE FROM tblKolom WHERE iterasi = pLoop AND nourut = vNoUrutKolom;
							END IF;

						ELSEIF vAtributPath = 'temperature' THEN

							IF vTemperatureKolom <> vInformasiKolom  THEN

								DELETE FROM tblKolom WHERE iterasi = pLoop AND nourut = vNoUrutKolom;
							END IF;

						ELSEIF vAtributPath = 'windy' THEN

							IF vWindyKolom <> vInformasiKolom  THEN

								DELETE FROM tblKolom WHERE iterasi = pLoop AND nourut = vNoUrutKolom;

							END IF;


						END IF;

					SET vLoopPath = vLoopPath + 1;

				END WHILE;

			CLOSE cPath;

			SET vLoopKolom = vLoopKolom + 1;

		END WHILE;

	CLOSE cKolom;

END^^
DELIMITER ;

-- HITUNG TOTAL PLAY DAN MASUKAN KE TBLHITUNG
DELIMITER ^^
CREATE PROCEDURE spHitungPlay(pLoop INT)
BEGIN

		DECLARE vAtribut VARCHAR(20) DEFAULT '';
		DECLARE vPlayyes, vPlayno INT DEFAULT 0;

		-- DECLARE CURSOR NYA
		DECLARE vIterasiPath, vJumlahDataPath, vLoopPath INT DEFAULT 0;
		DECLARE vAtributPath, vInformasi VARCHAR(20);

		DECLARE cPath CURSOR FOR SELECT atribut, informasi FROM tblPath;
		SELECT COUNT(*) INTO vJumlahDataPath FROM tblPath;

		-- JIKA MASIH ITERASI PERTAMA DIA NGITUNG SEMUA DATA
		IF pLoop = 1 THEN

			SET vAtribut = '';
			SELECT COUNT(*) INTO vPlayno FROM tblKolom WHERE play = 'No';
			SELECT COUNT(*) INTO vPlayyes FROM tblKolom WHERE play = 'Yes';

			INSERT INTO tblHitung(iterasi, atribut, jumlahdata, playno, playyes) VALUES(pLoop, vAtribut, vPlayyes+vPlayno, vPlayno, vPlayyes);

		-- JIKA LOOP SESUDAH 1 MAKA AKAN MENGAMBIL ATRIBUT DARI LOOP - 1 ATAU DARI LOOP SEBELUMNYA
		ELSEIF pLoop > 1 THEN

			SELECT atribut FROM tblPath WHERE iterasi = (pLoop - 1);
			SELECT COUNT(*) INTO vPlayno FROM tblKolom WHERE play = 'No' AND iterasi = pLoop;
			SELECT COUNT(*) INTO vPlayyes FROM tblKolom WHERE play = 'Yes' AND iterasi = pLoop;

			INSERT INTO tblHitung(iterasi, atribut, jumlahdata, playno, playyes) VALUES(pLoop, vAtribut, vPlayyes+vPlayno, vPlayno, vPlayyes);

		END IF;

		-- HITUNG PLAY NYA
		INSERT INTO tblHitung(informasi, iterasi, atribut, jumlahdata,playno, playyes)
		SELECT DISTINCT(A.outlook), pLoop, 'Outlook',
						(SELECT COUNT(*)
							FROM tblKolom
							WHERE iterasi = pLoop AND outlook = A.outlook),
						(SELECT COUNT(*)
							FROM tblKolom
							WHERE iterasi = pLoop AND outlook = A.outlook AND play = 'No'),
						(SELECT COUNT(*)
							FROM tblKolom
						 	WHERE iterasi = pLoop AND outlook = A.outlook AND play = 'Yes')
		FROM tblKolom AS A WHERE iterasi = pLoop;

		INSERT INTO tblHitung(informasi, iterasi, atribut, jumlahdata,playno, playyes)
		SELECT DISTINCT(A.temperature), pLoop, 'Temperature', (SELECT COUNT(*) FROM tblKolom WHERE iterasi = pLoop AND temperature = A.temperature), (SELECT COUNT(*) FROM tblKolom WHERE iterasi = pLoop AND temperature = A.temperature AND play = 'No'), (SELECT COUNT(*) FROM tblKolom WHERE iterasi = pLoop AND temperature = A.temperature AND play = 'Yes') FROM tblKolom AS A WHERE iterasi = pLoop;

		INSERT INTO tblHitung(informasi, iterasi, atribut, jumlahdata,playno, playyes)
		SELECT DISTINCT(A.windy), pLoop, 'Windy', (SELECT COUNT(*) FROM tblKolom WHERE iterasi = pLoop AND windy = A.windy), (SELECT COUNT(*) FROM tblKolom WHERE iterasi = pLoop AND windy = A.windy AND play = 'No'), (SELECT COUNT(*) FROM tblKolom WHERE iterasi = pLoop AND windy = A.windy AND play = 'Yes') FROM tblKolom AS A WHERE iterasi = pLoop;

		INSERT INTO tblHitung(informasi, iterasi, atribut, jumlahdata,playno, playyes)
		SELECT DISTINCT(A.humadity), pLoop, 'Humadity', (SELECT COUNT(*) FROM tblKolom WHERE iterasi = pLoop AND humadity = A.humadity), (SELECT COUNT(*) FROM tblKolom WHERE iterasi = pLoop AND humadity = A.humadity AND play = 'No'), (SELECT COUNT(*) FROM tblKolom WHERE iterasi = pLoop AND humadity = A.humadity AND play = 'Yes') FROM tblKolom AS A WHERE iterasi = pLoop;


		-- MENYELEKSI SEMUA DATA YANG DI MASUKKAN KE TBLHITUNG JIKA KOLOM ITU SUDAH DIAMBIL DI TBLPATH
		OPEN cPath;

			WHILE vLoopPath < vJumlahDataPath DO

				FETCH cPath INTO vAtributPath, vInformasi;

					DELETE FROM tblHitung WHERE iterasi = pLoop AND atribut = vAtributPath;

				SET vLoopPath = vLoopPath + 1;

			END WHILE;

		CLOSE cPath;



END^^
DELIMITER ;

-- PROCEDURE UNTUK MENGHITUNG GAIN
DELIMITER ^^
CREATE PROCEDURE spGain(pLoop INT)
BEGIN

	DECLARE vEntropy DECIMAL(8,4);
	DECLARE vJumlahData, vJumlahGain INT DEFAULT 0;

	SELECT jumlahdata INTO vJumlahData FROM tblHitung WHERE iterasi = pLoop LIMIT 1;
	SELECT entropy INTO vEntropy FROM tblHitung WHERE iterasi = pLoop LIMIT 1;

	INSERT INTO tblGain(iterasi, atribut, gain)
	SELECT pLoop,
		   atribut,
		   ROUND(ABS(vEntropy - SUM((jumlahdata/vJumlahData) * entropy)), 4) AS ENTROPY
	FROM tblHitung
	WHERE iterasi = pLoop
	GROUP BY atribut;

	UPDATE tblHitung SET gain =
	(
		SELECT gain
		FROM tblGain
		WHERE atribut = tblHitung.atribut
		AND iterasi = pLoop
	)
	WHERE iterasi = pLoop;

	SELECT MAX(gain) INTO @gainsementara FROM tblGain WHERE iterasi = pLoop;

	SELECT @gainsementara AS GAIN;

	INSERT INTO tblPath(iterasi, atribut, informasi, gain)
	SELECT iterasi, atribut, informasi, gain
	FROM tblHitung
	WHERE gain = @gainsementara AND
		iterasi = pLoop AND
		playno != 0 AND
		playyes != 0;

	SELECT COUNT(*) INTO vJumlahGain FROM tblPath WHERE iterasi = pLoop;

	IF vJumlahGain < 1 THEN

		INSERT INTO tblPath(iterasi, atribut, informasi, gain)
		SELECT iterasi, atribut, 'Finish', gain
		FROM tblHitung
		WHERE gain = @gainsementara AND
			iterasi = pLoop
		LIMIT 1;

	END IF;



END^^
DELIMITER ;


-- STEP KEDUA
DELIMITER ^^
CREATE PROCEDURE spHitungEntropy(pLoop INT)
BEGIN

	-- HITUNG ENTROPY
	UPDATE tblHitung SET entropy = ( -(playno/jumlahdata) * log2(playno/jumlahdata) ) + ( -(playyes/jumlahdata) * log2(playyes/jumlahdata) );

	UPDATE tblHitung SET entropy = 0 WHERE entropy IS NULL;

	-- HITUNG GAIN
	CALL spGain(pLoop);

END^^
DELIMITER ;


-- STEP KETIGA
DELIMITER ^^
CREATE FUNCTION spCheck(pLoop INT)
RETURNS INT
BEGIN

	DECLARE vLoopEks, vLoopReturn INT DEFAULT 0;
	SET vLoopReturn = 1;

	SELECT COUNT(informasi) INTO vLoopEks FROM tblPath WHERE informasi = 'Finish';

	IF vLoopEks <> 0 THEN

		SET vLoopReturn = 2;

	END IF;

	RETURN (vLoopReturn);

END^^
DELIMITER ;


-- PROCEDURE INTI
DELIMITER ^^
CREATE PROCEDURE spLoop()
BEGIN

	-- DECLARE VARIABEL UNTUK LOOP
	DECLARE vLoop, vStop INT DEFAULT 1;

	WHILE vStop = 1 DO

		-- STEP PERTAMA
			CALL spEntropy(vLoop);
			SELECT * FROM tblHitung;
		-- STEP KEDUA
			CALL spHitungEntropy(vLoop);

		-- LOOPING
			SET vLoop = vLoop + 1;

		-- STEP KETIGA : NGECEK APAKAH LOOP AKAN JALAN ATAU TIDAK
			SET vStop = spCheck(vLoop);

		-- SELECT * FROM tblC45;
		SELECT * FROM tblKolom;
		SELECT * FROM tblGain;
		SELECT * FROM tblHitung;
		SELECT * FROM tblPath;


	END WHILE;

	SELECT 'AHH MANTABB , AKHIRNYA SELESAI' AS 'C-45';

END^^
DELIMITER ;

CALL spLoop();
