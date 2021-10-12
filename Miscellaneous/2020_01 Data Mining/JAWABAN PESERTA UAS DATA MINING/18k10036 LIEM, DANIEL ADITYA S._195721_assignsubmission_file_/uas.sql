DROP DATABASE IF EXISTS DBC45;
CREATE DATABASE DBC45;
USE DBC45;

/*
Nama : Liem Daniel Aditya Santoso
NIM : 18K10036
Uas C45 Diagnosa
*/


-- Tabel data nya
CREATE TABLE tblC45(
	nourut VARCHAR(20),
	demam VARCHAR(10),
	sakitkepala VARCHAR(10),
	nyeri VARCHAR(10),
	lemas VARCHAR(10),
	kelelahan VARCHAR(10),
	hidungtersumbat VARCHAR(10),
	bersin VARCHAR(10),
	sakittenggorokan VARCHAR(10),
	sulitbernafas VARCHAR(10),
	diagnosa VARCHAR(10)
);

INSERT INTO tblC45 VALUES
('P1', 'Tidak',	'Ringan', 'Tidak',	'Tidak', 	'Tidak', 'Ringan',	'Parah',	'Parah',	'Ringan',	'Demam'),
('P2', 'Parah',	'Parah', 'Parah',	'Parah', 	'Parah', 'Tidak',	'Tidak',	'Parah',	'Parah',	'Flu'),
('P3', 'Parah',	'Parah', 'Ringan',	'Parah', 	'Parah', 'Parah',	'Tidak',	'Parah',	'Parah',	'Flu'),
('P4', 'Tidak',	'Tidak', 'Tidak',	'Ringan', 	'Tidak', 'Parah',	'Tidak',	'Ringan',	'Ringan',	'Demam'),
('P5', 'Parah',	'Parah', 'Ringan',	'Parah', 	'Parah', 'Parah',	'Tidak',	'Parah',	'Parah',	'Flu'),
('P6', 'Tidak',	'Tidak', 'Tidak',	'Ringan', 	'Tidak', 'Parah',	'Parah',	'Parah',	'Tidak',	'Demam'),
('P7', 'Parah',	'Parah', 'Parah',	'Parah', 	'Parah', 'Tidak',	'Tidak',	'Tidak',	'Parah',	'Flu'),
('P8', 'Tidak',	'Tidak', 'Tidak',	'Tidak', 	'Tidak', 'Parah',	'Parah',	'Tidak',	'Ringan',	'Demam'),
('P9', 'Tidak',	'Ringan', 'Ringan',	'Tidak', 	'Tidak', 'Parah',	'Parah',	'Parah',	'Parah',	'Demam'),
('P10', 'Parah', 'Parah', 'Parah',	'Ringan', 	'Ringan', 'Tidak',	'Parah',	'Tidak',	'Parah',	'Flu'),
('P11', 'Tidak', 'Tidak', 'Tidak',	'Ringan', 	'Tidak', 'Parah',	'Ringan',	'Parah',	'Tidak',	'Demam'),
('P12', 'Parah', 'Ringan', 'Parah',	'Ringan', 	'Parah', 'Tidak',	'Parah',	'Tidak',	'Ringan',	'Flu'),
('P13', 'Tidak', 'Tidak', 'Ringan',	'Ringan', 	'Tidak', 'Parah',	'Parah',	'Parah',	'Tidak',	'Demam'),
('P14', 'Parah', 'Parah', 'Parah',	'Parah', 	'Ringan', 'Tidak',	'Parah',	'Parah',	'Parah',	'Flu'),
('P15', 'Ringan', 'Tidak', 'Tidak',	'Ringan', 	'Tidak', 'Parah',	'Tidak',	'Parah',	'Ringan',	'Demam'),
('P16', 'Tidak', 'Tidak', 'Tidak',	'Tidak', 	'Tidak', 'Parah',	'Parah',	'Parah',	'Parah',	'Demam'),
('P17', 'Parah', 'Ringan', 'Parah',	'Ringan', 	'Ringan', 'Tidak',	'Tidak',	'Tidak',	'Parah',	'Flu');


-- SELECT * FROM tblC45;

-- UNTUK TABEL HITUNGAN 
CREATE TABLE tblHitung(
	iterasi VARCHAR(20),
	atribut VARCHAR(20),
	informasi VARCHAR(20),
	jumlahdata INT,
	diagnosaflu INT,
	diagnosademam INT,
	entropy DECIMAL(8,4),
	gain DECIMAL(8,4)
);

-- UNTUK MELIHAT JALUR NYA DAN JUGA UNTUK MENYELEKSI DATA NYA
CREATE TABLE tblPath(
	iterasi INT,
	atribut VARCHAR(20),
	informasi VARCHAR(20),
	gain DECIMAL(8,4)
);

-- UNTUK MENEMUKAN PATH NYA 
CREATE TABLE tblKolom(
	iterasi INT,
	nourut VARCHAR(20),
	demam VARCHAR(10),
	sakitkepala VARCHAR(10),
	nyeri VARCHAR(10),
	lemas VARCHAR(10),
	kelelahan VARCHAR(10),
	hidungtersumbat VARCHAR(10),
	bersin VARCHAR(10),
	sakittenggorokan VARCHAR(10),
	sulitbernafas VARCHAR(10),
	diagnosa VARCHAR(10)
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
	1.3 HITUNG diagnosademam DAN  diagnosaflu DARI TBLKOLOM DI ITERASI TERSEBUT
	1.4 MEMINDAHKAN DATA DARI TBLKOLOM KE TBLHITUNG LALU HITUNG LALU HITUNG ENTROPY DAN JUGA GAIN NYA

STEP KEDUA :
	2.1 GAIN TERTINGGI MASUK TBLPATH 

STEP KETIGA :
	3.1 Mengecek apakah ada informasi yang sama dengan finish

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
		   demam,
		   sakitkepala,
		   nyeri,
		   lemas,
		   kelelahan,
		   hidungtersumbat,
		   bersin,
		   sakittenggorokan,
		   sulitbernafas,
		   diagnosa
	FROM tblC45;

	-- STEP 1.2
	CALL spEliminasi(pLoop);

	-- STEP 1.3
	CALL spHitungdiagnosa(pLoop);
	
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
	DECLARE vdemamKolom, vsakitkepalaKolom, vnyeriKolom, vlemasKolom, vKelelahan, vHidungtersumbat, vBersin, vSakittenggorokan, vSulitbernafas, vdiagnosaKolom, vInformasiKolom VARCHAR(50);

	DECLARE cPath CURSOR FOR SELECT iterasi, atribut, informasi FROM tblPath;
	DECLARE cKolom CURSOR FOR SELECT * FROM tblKolom;
	SELECT COUNT(*) INTO vJumlahDataPath FROM tblPath;
	SELECT COUNT(*) INTO vJumlahDataKolom FROM tblKolom WHERE iterasi = pLoop;

	OPEN cKolom;

		WHILE vLoopKolom < vJumlahDataKolom DO

			FETCH cKolom INTO vIterasiKolom, vNoUrutKolom, vdemamKolom, vsakitkepalaKolom, vnyeriKolom, vlemasKolom, vKelelahan, vHidungtersumbat, vBersin, vSakittenggorokan, vSulitbernafas, vdiagnosaKolom;
			SET vLoopPath = 0;

			OPEN cPath;

				WHILE vLoopPath < vJumlahDataPath DO

					FETCH cPath INTO vIterasiPath, vAtributPath, vInformasiKolom;

						-- CEK ATRIBUT DI TBLPATH APAKAH ITU nyeri ATAU YANG LAIN NYA
							-- Kalau nyeri lalu akan saling mencocokan kolom informasi nya secara sendiri

						IF vAtributPath = 'nyeri' THEN

							IF vnyeriKolom <> vInformasiKolom  THEN

								DELETE FROM tblKolom WHERE iterasi = pLoop AND nourut = vNoUrutKolom;

							END IF;

						ELSEIF vAtributPath = 'demam' THEN

							IF vdemamKolom <> vInformasiKolom  THEN

								DELETE FROM tblKolom WHERE iterasi = pLoop AND nourut = vNoUrutKolom;

							END IF;

						ELSEIF vAtributPath = 'sakitkepala' THEN

							IF vsakitkepalaKolom <> vInformasiKolom  THEN

								DELETE FROM tblKolom WHERE iterasi = pLoop AND nourut = vNoUrutKolom;

							END IF;

						ELSEIF vAtributPath = 'lemas' THEN

							IF vlemasKolom <> vInformasiKolom  THEN

								DELETE FROM tblKolom WHERE iterasi = pLoop AND nourut = vNoUrutKolom;

							END IF;

						ELSEIF vAtributPath = 'kelelahan' THEN

							IF vKelelahan <> vInformasiKolom  THEN

								DELETE FROM tblKolom WHERE iterasi = pLoop AND nourut = vNoUrutKolom;

							END IF;

						ELSEIF vAtributPath = 'hidungtersumbat' THEN

							IF vHidungtersumbat <> vInformasiKolom  THEN

								DELETE FROM tblKolom WHERE iterasi = pLoop AND nourut = vNoUrutKolom;

							END IF;

						ELSEIF vAtributPath = 'bersin' THEN

							IF vBersin <> vInformasiKolom  THEN

								DELETE FROM tblKolom WHERE iterasi = pLoop AND nourut = vNoUrutKolom;

							END IF;

						ELSEIF vAtributPath = 'sakittenggorokan' THEN

							IF vSakittenggorokan <> vInformasiKolom  THEN

								DELETE FROM tblKolom WHERE iterasi = pLoop AND nourut = vNoUrutKolom;

							END IF;

						ELSEIF vAtributPath = 'sulitbernafas' THEN

							IF vSulitbernafas <> vInformasiKolom  THEN

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

-- HITUNG TOTAL diagnosa DAN MASUKAN KE TBLHITUNG
DELIMITER ^^
CREATE PROCEDURE spHitungdiagnosa(pLoop INT)
BEGIN
		
		DECLARE vAtribut VARCHAR(20) DEFAULT '';
		DECLARE vDiagnosaDemam, vDiagnosaFlu INT DEFAULT 0;

		-- DECLARE CURSOR NYA
		DECLARE vIterasiPath, vJumlahDataPath, vLoopPath INT DEFAULT 0;
		DECLARE vAtributPath, vInformasi VARCHAR(20);

		DECLARE cPath CURSOR FOR SELECT atribut, informasi FROM tblPath;
		SELECT COUNT(*) INTO vJumlahDataPath FROM tblPath;

		-- JIKA MASIH ITERASI PERTAMA DIA NGITUNG SEMUA DATA
		IF pLoop = 1 THEN 

			SET vAtribut = '';
			SELECT COUNT(*) INTO vDiagnosaFlu FROM tblKolom WHERE diagnosa = 'Flu';
			SELECT COUNT(*) INTO vDiagnosaDemam FROM tblKolom WHERE diagnosa = 'Demam';

			INSERT INTO tblHitung(iterasi, atribut, jumlahdata,  diagnosaflu, diagnosademam) VALUES(pLoop, vAtribut, vDiagnosaDemam+vDiagnosaFlu, vDiagnosaFlu, vDiagnosaDemam);
		
		-- JIKA LOOP SESUDAH 1 MAKA AKAN MENGAMBIL ATRIBUT DARI LOOP - 1 ATAU DARI LOOP SEBELUMNYA
		ELSEIF pLoop > 1 THEN

			SET vAtribut = '';
			SELECT COUNT(*) INTO vDiagnosaFlu FROM tblKolom WHERE diagnosa = 'Flu' AND iterasi = pLoop;
			SELECT COUNT(*) INTO vDiagnosaDemam FROM tblKolom WHERE diagnosa = 'Demam' AND iterasi = pLoop;		

			INSERT INTO tblHitung(iterasi, atribut, jumlahdata,  diagnosaflu, diagnosademam) VALUES(pLoop, vAtribut, vDiagnosaDemam+vDiagnosaFlu, vDiagnosaFlu, vDiagnosaDemam);

		END IF;

		-- HITUNG diagnosa NYA
		INSERT INTO tblHitung(informasi, iterasi, atribut, jumlahdata, diagnosaflu, diagnosademam)
		SELECT DISTINCT(A.demam), pLoop, 'demam', (SELECT COUNT(*) FROM tblKolom WHERE iterasi = pLoop AND demam = A.demam), (SELECT COUNT(*) FROM tblKolom WHERE iterasi = pLoop AND demam = A.demam AND diagnosa = 'Flu'), (SELECT COUNT(*) FROM tblKolom WHERE iterasi = pLoop AND demam = A.demam AND diagnosa = 'Demam') FROM tblKolom AS A WHERE iterasi = pLoop;

		INSERT INTO tblHitung(informasi, iterasi, atribut, jumlahdata, diagnosaflu, diagnosademam)
		SELECT DISTINCT(A.sakitkepala), pLoop, 'sakitkepala', (SELECT COUNT(*) FROM tblKolom WHERE iterasi = pLoop AND sakitkepala = A.sakitkepala), (SELECT COUNT(*) FROM tblKolom WHERE iterasi = pLoop AND sakitkepala = A.sakitkepala AND diagnosa = 'Flu'), (SELECT COUNT(*) FROM tblKolom WHERE iterasi = pLoop AND sakitkepala = A.sakitkepala AND diagnosa = 'Demam') FROM tblKolom AS A WHERE iterasi = pLoop;

		INSERT INTO tblHitung(informasi, iterasi, atribut, jumlahdata, diagnosaflu, diagnosademam)
		SELECT DISTINCT(A.lemas), pLoop, 'lemas', (SELECT COUNT(*) FROM tblKolom WHERE iterasi = pLoop AND lemas = A.lemas), (SELECT COUNT(*) FROM tblKolom WHERE iterasi = pLoop AND lemas = A.lemas AND diagnosa = 'Flu'), (SELECT COUNT(*) FROM tblKolom WHERE iterasi = pLoop AND lemas = A.lemas AND diagnosa = 'Demam') FROM tblKolom AS A WHERE iterasi = pLoop;

		INSERT INTO tblHitung(informasi, iterasi, atribut, jumlahdata, diagnosaflu, diagnosademam)
		SELECT DISTINCT(A.nyeri), pLoop, 'nyeri', (SELECT COUNT(*) FROM tblKolom WHERE iterasi = pLoop AND nyeri = A.nyeri), (SELECT COUNT(*) FROM tblKolom WHERE iterasi = pLoop AND nyeri = A.nyeri AND diagnosa = 'Flu'), (SELECT COUNT(*) FROM tblKolom WHERE iterasi = pLoop AND nyeri = A.nyeri AND diagnosa = 'Demam') FROM tblKolom AS A WHERE iterasi = pLoop;

		INSERT INTO tblHitung(informasi, iterasi, atribut, jumlahdata, diagnosaflu, diagnosademam)
		SELECT DISTINCT(A.kelelahan), pLoop, 'kelelahan', (SELECT COUNT(*) FROM tblKolom WHERE iterasi = pLoop AND kelelahan = A.kelelahan), (SELECT COUNT(*) FROM tblKolom WHERE iterasi = pLoop AND kelelahan = A.kelelahan AND diagnosa = 'Flu'), (SELECT COUNT(*) FROM tblKolom WHERE iterasi = pLoop AND kelelahan = A.kelelahan AND diagnosa = 'Demam') FROM tblKolom AS A WHERE iterasi = pLoop;

		INSERT INTO tblHitung(informasi, iterasi, atribut, jumlahdata, diagnosaflu, diagnosademam)
		SELECT DISTINCT(A.hidungtersumbat), pLoop, 'hidungtersumbat', (SELECT COUNT(*) FROM tblKolom WHERE iterasi = pLoop AND hidungtersumbat = A.hidungtersumbat), (SELECT COUNT(*) FROM tblKolom WHERE iterasi = pLoop AND hidungtersumbat = A.hidungtersumbat AND diagnosa = 'Flu'), (SELECT COUNT(*) FROM tblKolom WHERE iterasi = pLoop AND hidungtersumbat = A.hidungtersumbat AND diagnosa = 'Demam') FROM tblKolom AS A WHERE iterasi = pLoop;

		INSERT INTO tblHitung(informasi, iterasi, atribut, jumlahdata, diagnosaflu, diagnosademam)
		SELECT DISTINCT(A.bersin), pLoop, 'bersin', (SELECT COUNT(*) FROM tblKolom WHERE iterasi = pLoop AND bersin = A.bersin), (SELECT COUNT(*) FROM tblKolom WHERE iterasi = pLoop AND bersin = A.bersin AND diagnosa = 'Flu'), (SELECT COUNT(*) FROM tblKolom WHERE iterasi = pLoop AND bersin = A.bersin AND diagnosa = 'Demam') FROM tblKolom AS A WHERE iterasi = pLoop;

		INSERT INTO tblHitung(informasi, iterasi, atribut, jumlahdata, diagnosaflu, diagnosademam)
		SELECT DISTINCT(A.sakittenggorokan), pLoop, 'sakittenggorokan', (SELECT COUNT(*) FROM tblKolom WHERE iterasi = pLoop AND sakittenggorokan = A.sakittenggorokan), (SELECT COUNT(*) FROM tblKolom WHERE iterasi = pLoop AND sakittenggorokan = A.sakittenggorokan AND diagnosa = 'Flu'), (SELECT COUNT(*) FROM tblKolom WHERE iterasi = pLoop AND sakittenggorokan = A.sakittenggorokan AND diagnosa = 'Demam') FROM tblKolom AS A WHERE iterasi = pLoop;

		INSERT INTO tblHitung(informasi, iterasi, atribut, jumlahdata, diagnosaflu, diagnosademam)
		SELECT DISTINCT(A.sulitbernafas), pLoop, 'sulitbernafas', (SELECT COUNT(*) FROM tblKolom WHERE iterasi = pLoop AND sulitbernafas = A.sulitbernafas), (SELECT COUNT(*) FROM tblKolom WHERE iterasi = pLoop AND sulitbernafas = A.sulitbernafas AND diagnosa = 'Flu'), (SELECT COUNT(*) FROM tblKolom WHERE iterasi = pLoop AND sulitbernafas = A.sulitbernafas AND diagnosa = 'Demam') FROM tblKolom AS A WHERE iterasi = pLoop;


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

-- STEP KEDUA : MENGHITUNG ENTROPY NYA
DELIMITER ^^
CREATE PROCEDURE spHitungEntropy(pLoop INT)
BEGIN
	
	-- HITUNG ENTROPY
	UPDATE tblHitung SET entropy = ( -( diagnosaflu/jumlahdata) * log2( diagnosaflu/jumlahdata) ) + ( -(diagnosademam/jumlahdata) * log2(diagnosademam/jumlahdata) );

	UPDATE tblHitung SET entropy = 0 WHERE entropy IS NULL;

	-- HITUNG GAIN
	CALL spGain(pLoop);

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

	-- NILAI ABSOLUT KARENA TERKADANG ADA NILAI YANG MINUS

	UPDATE tblHitung SET gain = 
	(
		SELECT gain
		FROM tblGain
		WHERE atribut = tblHitung.atribut
		AND iterasi = pLoop
	)
	WHERE iterasi = pLoop;

	-- GET DATA GAIN TERTINGGI DARI ITERASI KE - 
	SELECT MAX(gain) INTO @gainsementara FROM tblGain WHERE iterasi = pLoop;

	-- MEMASUKKAN DATA KE TBLPATH DENGAN KONDISI DIAGNOSAFLU DAN DIAGNOSADEMAM NYA TIDAK SAMA DENGAN 0
	INSERT INTO tblPath(iterasi, atribut, informasi, gain)
	SELECT iterasi, atribut, informasi, gain
	FROM tblHitung	
	WHERE gain = @gainsementara AND
		iterasi = pLoop AND
		diagnosaflu != 0 AND
		diagnosademam != 0;

	-- MENGHITUNG APAKAH ADA DATA YANG SUDAH MASUK KE TBLPATH , DENGAN MENCARI DATA DENGAN ITERASI KE ploop
	SELECT COUNT(*) INTO vJumlahGain FROM tblPath WHERE iterasi = pLoop;

	-- JIKA HASIL HITUNGAN DIATAS TADI LEBIH KECIL DARI 0 MAKA TIDAK ADA DATA YANG MASUK ALIAS SEMUA INFORMASI MEMILIKI DIAGNOSA 0
	-- MAKA AKAN DITULIS DI INFORMASI NYA FINISH YANG MENANDAKAN SELESAI LOOP
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




-- STEP KETIGA
DELIMITER ^^
CREATE FUNCTION spCheck(pLoop INT)
RETURNS INT
BEGIN

	DECLARE vLoopEks, vLoopReturn INT DEFAULT 0;
	SET vLoopReturn = 1;

	-- MENCARI APAKAH ADA DATA DI KOLOM INFORMASI YANG BERISI FINISH
	SELECT COUNT(informasi) INTO vLoopEks FROM tblPath WHERE informasi = 'Finish';

	IF vLoopEks <> 0 THEN

		-- UNTUK DI SET KE VSTOP
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

	SELECT 'Liem, Daniel Aditya Santoso' AS 'NAMA', '18K10036' AS 'NIM';

	WHILE vStop = 1 DO

		-- STEP PERTAMA
			CALL spEntropy(vLoop);

		-- STEP KEDUA
			CALL spHitungEntropy(vLoop);

		-- LOOPING
			SET vLoop = vLoop + 1;

		-- STEP KETIGA
			SET vStop = spCheck(vLoop);

		-- SELECT * FROM tblC45;
		SELECT * FROM tblKolom;
		SELECT * FROM tblGain;
		SELECT * FROM tblHitung;
		SELECT * FROM tblPath;
		

	END WHILE;

	SELECT 'C-45 SUDAH SELESAI' AS 'UAS DATA MINING';

END^^
DELIMITER ;

CALL spLoop();