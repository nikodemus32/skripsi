DROP DATABASE IF EXISTS dbUas;
CREATE DATABASE dbUas;
USE dbUas;

CREATE TABLE tblUas(
    id VARCHAR(5),
    demam VARCHAR(20),
    sakit_kepala VARCHAR(20),
    nyeri VARCHAR(20),
    lemas VARCHAR(20),
    kelelahan VARCHAR(20),
    hidung_tersumbat VARCHAR(20),
    bersin VARCHAR(20),
    sakit_tenggorokan VARCHAR(20),
    sulit_bernafas VARCHAR(20),
    diagnosa VARCHAR(20)
    
);

INSERT INTO tblUas VALUES
('P1', 'Tidak', 'Ringan', 'Tidak', 'Tidak',  'Tidak', 'Ringan', 'Parah', 'Parah', 'Ringan', 'Demam'),
('P2', 'Parah', 'Parah', 'Parah', 'Parah',  'Parah', 'Tidak', 'Tidak', 'Parah', 'Parah', 'Flu'),
('P3', 'Parah', 'Parah', 'Ringan', 'Parah',  'Parah', 'Parah', 'Tidak', 'Parah', 'Parah', 'Flu'),
('P4', 'Tidak', 'Tidak', 'Tidak', 'Ringan',  'Tidak', 'Parah', 'Tidak', 'Ringan', 'Ringan', 'Demam'),
('P5', 'Parah', 'Parah', 'Ringan', 'Parah',  'Parah', 'Parah', 'Tidak', 'Parah', 'Parah', 'Flu'),
('P6', 'Tidak', 'Tidak', 'Tidak', 'Ringan',  'Tidak', 'Parah', 'Parah', 'Parah', 'Tidak', 'Demam'),
('P7', 'Parah', 'Parah', 'Parah', 'Parah',  'Parah', 'Tidak', 'Tidak', 'Tidak', 'Parah', 'Flu'),
('P8', 'Tidak', 'Tidak', 'Tidak', 'Tidak',  'Tidak', 'Parah', 'Parah', 'Tidak', 'Ringan', 'Demam'),
('P9', 'Tidak', 'Ringan', 'Ringan', 'Tidak',  'Tidak', 'Parah', 'Parah', 'Parah', 'Parah', 'Demam'),
('P10', 'Parah', 'Parah', 'Parah', 'Ringan',  'Ringan', 'Tidak', 'Parah', 'Tidak', 'Parah', 'Flu'),
('P11', 'Tidak', 'Tidak', 'Tidak', 'Ringan',  'Tidak', 'Parah', 'Ringan', 'Parah', 'Tidak', 'Demam'),
('P12', 'Parah', 'Ringan', 'Parah', 'Ringan',  'Parah', 'Tidak', 'Parah', 'Tidak', 'Ringan', 'Flu'),
('P13', 'Tidak', 'Tidak', 'Ringan', 'Ringan',  'Tidak', 'Parah', 'Parah', 'Parah', 'Tidak', 'Demam'),
('P14', 'Parah', 'Parah', 'Parah', 'Parah',  'Ringan', 'Tidak', 'Parah', 'Parah', 'Parah', 'Flu'),
('P15', 'Ringan', 'Tidak', 'Tidak', 'Ringan',  'Tidak', 'Parah', 'Tidak', 'Parah', 'Ringan', 'Demam'),
('P16', 'Tidak', 'Tidak', 'Tidak', 'Tidak',  'Tidak', 'Parah', 'Parah', 'Parah', 'Parah', 'Demam'),
('P17', 'Parah', 'Ringan', 'Parah', 'Ringan',  'Ringan', 'Tidak', 'Tidak', 'Tidak', 'Parah', 'Flu');

-- MEMBUAT TABEL HITUNGAN
CREATE TABLE tblHitung(
    iterasi INT,
    atribut VARCHAR(20),
    informasi VARCHAR(20),
    jumlahdata INT,
    demam INT,
    flu INT,
    entropy DECIMAL(8,4),
    gain DECIMAL(8,4)
);


CREATE TABLE tblPath(
	iterasi INT,
	atribut VARCHAR(20),
	informasi VARCHAR(20),
	gain DECIMAL(8,4)
);


CREATE TABLE tblKolom(
	iterasi INT,
	id VARCHAR(5),
    demam VARCHAR(20),
    sakit_kepala VARCHAR(20),
    nyeri VARCHAR(20),
    lemas VARCHAR(20),
    kelelahan VARCHAR(20),
    hidung_tersumbat VARCHAR(20),
    bersin VARCHAR(20),
    sakit_tenggorokan VARCHAR(20),
    sulit_bernafas VARCHAR(20),
    diagnosa VARCHAR(20)
);

-- TABEL GAIN
CREATE TABLE tblGain(
	iterasi INT,
	atribut VARCHAR(20),
	gain DECIMAL(8,4)
);

SELECT * FROM tblUas;

-- LOOPING PROCEDURE
DELIMITER ^^
CREATE PROCEDURE spLoop()
BEGIN
	
	
	DECLARE vLoop, vStop INT DEFAULT 1;

	WHILE vStop = 1 DO

		
		CALL spEntropy(vLoop);
		CALL spHitungEntropy(vLoop);
		SET vLoop = vLoop + 1;
		SET vStop = spCheck(vLoop);
		SELECT * FROM tblKolom;
		SELECT * FROM tblHitung;
		SELECT * FROM tblPath;
	END WHILE;

END^^
DELIMITER ;

-- Membuat Memindahkan data dari tblUas ke tblKolom, Menghapus Data yang tidak diinginkan, Menghitung Diagnosa
DELIMITER &&
CREATE PROCEDURE spEntropy(pLoop INT)
BEGIN
    INSERT INTO tblKolom
    SELECT  pLoop,  
            id,
            demam,
            sakit_kepala,
            nyeri, 
            lemas,
            kelelahan,
            hidung_tersumbat,
            bersin,
            sakit_tenggorokan,
            sulit_bernafas,
            diagnosa 
    FROM tblUas;

    CALL spDelete(pLoop);

    CALL spHitungDiagnosa(pLoop);

END &&
DELIMITER ;

-- Prosedur untuk menghapus data yang tidak sesuai dengan GAIN tertinggi di iterasi ke 2 dan seterusnya
DELIMITER && 
CREATE PROCEDURE spDelete(pLoop INT)
BEGIN
    -- Data dari tblKolom
    DECLARE i_kolom, vJumDataKolom, vIterasiKolom INT DEFAULT 0;
    DECLARE vIdKolom, vDemamKolom, vSakitKepalaKolom, vNyeriKolom, vLemasKolom, vKelelahanKolom, vHidungTersumbatKolom, vBersinKolom, vSakitTenggorokanKolom, vSulitBernafasKolom, vDiagnosaKolom VARCHAR(20); 
    -- DATA DARI TBLPATH
    DECLARE vIterasiPath, i_path, vJumDataPath INT DEFAULT 0;
    DECLARE vAtributPath, vInformasiPath VARCHAR(20);

    -- CURSOR CURSOR YANG DIPAKAI
    DECLARE cPath CURSOR FOR SELECT iterasi, atribut, informasi FROM tblPath;
    DECLARE cKolom CURSOR FOR SELECT * FROM tblKolom;
    SELECT COUNT(*) INTO vJumDataKolom FROM tblKolom WHERE iterasi=pLoop;
    SELECT COUNT(*) INTO vJumDataPath FROM tblPath;

    OPEN cKolom;
        WHILE i_kolom <> vJumDataKolom DO
            FETCH cKolom INTO vIterasiKolom, vIdKolom, vDemamKolom, vSakitKepalaKolom, vNyeriKolom, vLemasKolom, vKelelahanKolom, vHidungTersumbatKolom, vBersinKolom, vSakitTenggorokanKolom, vSulitBernafasKolom, vDiagnosaKolom;

            SET i_path=0;

            OPEN cPath;
                WHILE i_path <> vJumDataPath DO
                    FETCH cPath INTO vIterasiPath, vAtributPath, vInformasiPath;

                    IF vAtributPath = 'demam' THEN
                        IF vDemamKolom <> vInformasiPath THEN
                            DELETE FROM tblKolom WHERE iterasi=pLoop AND id=vIdKolom;
                        END IF;
                    ELSEIF vAtributPath = 'sakit_kepala' THEN
                        IF vSakitKepalaKolom <> vInformasiPath THEN
                            DELETE FROM tblKolom WHERE iterasi=pLoop AND id=vIdKolom;
                        END IF;

                     ELSEIF vAtributPath = 'nyeri' THEN
                        IF vNyeriKolom <> vInformasiPath THEN
                            DELETE FROM tblKolom WHERE iterasi=pLoop AND id=vIdKolom;
                        END IF;

                     ELSEIF vAtributPath = 'lemas' THEN
                        IF vLemasKolom <> vInformasiPath THEN
                            DELETE FROM tblKolom WHERE iterasi=pLoop AND id=vIdKolom;
                        END IF;
                    
                     ELSEIF vAtributPath = 'kelelahan' THEN
                        IF vKelelahanKolom <> vInformasiPath THEN
                            DELETE FROM tblKolom WHERE iterasi=pLoop AND id=vIdKolom;
                        END IF;
                    
                     ELSEIF vAtributPath = 'hidung_tersumbat' THEN
                        IF vHidungTersumbatKolom <> vInformasiPath THEN
                            DELETE FROM tblKolom WHERE iterasi=pLoop AND id=vIdKolom;
                        END IF;

                     ELSEIF vAtributPath = 'bersin' THEN
                        IF vBersinKolom <> vInformasiPath THEN
                            DELETE FROM tblKolom WHERE iterasi=pLoop AND id=vIdKolom;
                        END IF;

                     ELSEIF vAtributPath = 'sakit_tenggorokan' THEN
                        IF vSakitTenggorokanKolom <> vInformasiPath THEN
                            DELETE FROM tblKolom WHERE iterasi=pLoop AND id=vIdKolom;
                        END IF;

                     ELSEIF vAtributPath = 'sulit_bernafas' THEN
                        IF vSulitBernafasKolom <> vInformasiPath THEN
                            DELETE FROM tblKolom WHERE iterasi=pLoop AND id=vIdKolom;
                        END IF;
                    END IF;

                    SET i_path = i_path + 1;
                END WHILE;
            CLOSE cPath;
            SET i_kolom = i_kolom + 1;
        END WHILE;
    CLOSE cKolom;

END &&
DELIMITER ;

DELIMITER &&
CREATE PROCEDURE spHitungDiagnosa(pLoop INT)
BEGIN
    DECLARE vAtribut VARCHAR(20) DEFAULT '';
    DECLARE vDiagnosaDemam, vDiagnosaFlu INT DEFAULT 0;

    DECLARE vIterasiPath, vJumDataPath, i_path INT DEFAULT 0;
    DECLARE vAtributPath, vInformasi VARCHAR(20);

    DECLARE cPath CURSOR FOR SELECT atribut, informasi FROM tblPath;
    SELECT COUNT(*) INTO vJumDataPath FROM tblPath;

    IF pLoop = 1 THEN
        SET vAtribut='';
        SELECT COUNT(*) INTO vDiagnosaDemam FROM tblKolom
        WHERE diagnosa='Demam';
        SELECT COUNT(*) INTO vDiagnosaFlu FROM tblKolom
        WHERE diagnosa='Flu';

        INSERT INTO tblHitung(iterasi, atribut, jumlahdata, demam, flu) VALUES (pLoop, vAtribut, vDiagnosaDemam+vDiagnosaFlu, vDiagnosaDemam, vDiagnosaFlu);
    ELSEIF pLoop > 1 THEN
        SET vAtribut='';
        SELECT COUNT(*) INTO vDiagnosaDemam FROM tblKolom
        WHERE diagnosa='Demam' AND iterasi=pLoop;
        SELECT COUNT(*) INTO vDiagnosaFlu FROM tblKolom
        WHERE diagnosa='Flu' AND iterasi=pLoop;

        INSERT INTO tblHitung(iterasi, atribut, jumlahdata, demam, flu) VALUES (pLoop, vAtribut, vDiagnosaDemam+vDiagnosaFlu, vDiagnosaDemam, vDiagnosaFlu);
    END IF;

    INSERT INTO tblHitung(informasi, iterasi, atribut, jumlahdata,demam, flu)
		SELECT DISTINCT(A.demam), pLoop, 'Demam', (SELECT COUNT(*) FROM tblKolom WHERE iterasi = pLoop AND demam = A.demam), (SELECT COUNT(*) FROM tblKolom WHERE iterasi = pLoop AND demam = A.demam AND diagnosa = 'Demam'), (SELECT COUNT(*) FROM tblKolom WHERE iterasi = pLoop AND demam = A.demam AND diagnosa = 'Flu') FROM tblKolom AS A WHERE iterasi = pLoop;

    INSERT INTO tblHitung(informasi, iterasi, atribut, jumlahdata,demam, flu)
		SELECT DISTINCT(A.sakit_kepala), pLoop, 'Sakit Kepala', (SELECT COUNT(*) FROM tblKolom WHERE iterasi = pLoop AND sakit_kepala = A.sakit_kepala), (SELECT COUNT(*) FROM tblKolom WHERE iterasi = pLoop AND sakit_kepala = A.sakit_kepala AND diagnosa = 'Demam'), (SELECT COUNT(*) FROM tblKolom WHERE iterasi = pLoop AND sakit_kepala = A.sakit_kepala AND diagnosa = 'Flu') FROM tblKolom AS A WHERE iterasi = pLoop;

    INSERT INTO tblHitung(informasi, iterasi, atribut, jumlahdata,demam, flu)
		SELECT DISTINCT(A.nyeri), pLoop, 'Nyeri', (SELECT COUNT(*) FROM tblKolom WHERE iterasi = pLoop AND nyeri = A.nyeri), (SELECT COUNT(*) FROM tblKolom WHERE iterasi = pLoop AND nyeri = A.nyeri AND diagnosa = 'Demam'), (SELECT COUNT(*) FROM tblKolom WHERE iterasi = pLoop AND nyeri = A.nyeri AND diagnosa = 'Flu') FROM tblKolom AS A WHERE iterasi = pLoop;
    
    INSERT INTO tblHitung(informasi, iterasi, atribut, jumlahdata,demam, flu)
		SELECT DISTINCT(A.lemas), pLoop, 'Lemas', (SELECT COUNT(*) FROM tblKolom WHERE iterasi = pLoop AND lemas = A.lemas), (SELECT COUNT(*) FROM tblKolom WHERE iterasi = pLoop AND lemas = A.lemas AND diagnosa = 'Demam'), (SELECT COUNT(*) FROM tblKolom WHERE iterasi = pLoop AND lemas = A.lemas AND diagnosa = 'Flu') FROM tblKolom AS A WHERE iterasi = pLoop;
    
    INSERT INTO tblHitung(informasi, iterasi, atribut, jumlahdata,demam, flu)
		SELECT DISTINCT(A.kelelahan), pLoop, 'Kelelahan', (SELECT COUNT(*) FROM tblKolom WHERE iterasi = pLoop AND kelelahan = A.kelelahan), (SELECT COUNT(*) FROM tblKolom WHERE iterasi = pLoop AND kelelahan = A.kelelahan AND diagnosa = 'Demam'), (SELECT COUNT(*) FROM tblKolom WHERE iterasi = pLoop AND kelelahan = A.kelelahan AND diagnosa = 'Flu') FROM tblKolom AS A WHERE iterasi = pLoop;

    INSERT INTO tblHitung(informasi, iterasi, atribut, jumlahdata,demam, flu)
		SELECT DISTINCT(A.hidung_tersumbat), pLoop, 'Hidung Tersumbat', (SELECT COUNT(*) FROM tblKolom WHERE iterasi = pLoop AND hidung_tersumbat = A.hidung_tersumbat), (SELECT COUNT(*) FROM tblKolom WHERE iterasi = pLoop AND hidung_tersumbat = A.hidung_tersumbat AND diagnosa = 'Demam'), (SELECT COUNT(*) FROM tblKolom WHERE iterasi = pLoop AND hidung_tersumbat = A.hidung_tersumbat AND diagnosa = 'Flu') FROM tblKolom AS A WHERE iterasi = pLoop;

    INSERT INTO tblHitung(informasi, iterasi, atribut, jumlahdata,demam, flu)
		SELECT DISTINCT(A.bersin), pLoop, 'Bersin', (SELECT COUNT(*) FROM tblKolom WHERE iterasi = pLoop AND bersin = A.bersin), (SELECT COUNT(*) FROM tblKolom WHERE iterasi = pLoop AND bersin = A.bersin AND diagnosa = 'Demam'), (SELECT COUNT(*) FROM tblKolom WHERE iterasi = pLoop AND bersin = A.bersin AND diagnosa = 'Flu') FROM tblKolom AS A WHERE iterasi = pLoop;

    INSERT INTO tblHitung(informasi, iterasi, atribut, jumlahdata,demam, flu)
		SELECT DISTINCT(A.sakit_tenggorokan), pLoop, 'Sakit Tenggorokan', (SELECT COUNT(*) FROM tblKolom WHERE iterasi = pLoop AND sakit_tenggorokan = A.sakit_tenggorokan), (SELECT COUNT(*) FROM tblKolom WHERE iterasi = pLoop AND sakit_tenggorokan = A.sakit_tenggorokan AND diagnosa = 'Demam'), (SELECT COUNT(*) FROM tblKolom WHERE iterasi = pLoop AND sakit_tenggorokan = A.sakit_tenggorokan AND diagnosa = 'Flu') FROM tblKolom AS A WHERE iterasi = pLoop;

    INSERT INTO tblHitung(informasi, iterasi, atribut, jumlahdata,demam, flu)
		SELECT DISTINCT(A.sulit_bernafas), pLoop, 'Sulit Bernafas', (SELECT COUNT(*) FROM tblKolom WHERE iterasi = pLoop AND sulit_bernafas = A.sulit_bernafas), (SELECT COUNT(*) FROM tblKolom WHERE iterasi = pLoop AND sulit_bernafas = A.sulit_bernafas AND diagnosa = 'Demam'), (SELECT COUNT(*) FROM tblKolom WHERE iterasi = pLoop AND sulit_bernafas = A.sulit_bernafas AND diagnosa = 'Flu') FROM tblKolom AS A WHERE iterasi = pLoop;

    OPEN cPath;
        WHILE i_path <> vJumDataPath DO
            FETCH cPath INTO vAtributPath, vInformasi;

            DELETE FROM tblHitung WHERE iterasi = pLoop AND atribut = vAtributPath;

            SET i_path = i_path +1;
        END WHILE;
    CLOSE cPath;

END &&
DELIMITER ;


DELIMITER ^^
CREATE PROCEDURE spHitungEntropy(pLoop INT)
BEGIN
	
	
	UPDATE tblHitung SET entropy = ( -(demam/jumlahdata) * log2(demam/jumlahdata) ) + ( -(flu/jumlahdata) * log2(flu/jumlahdata) );

	UPDATE tblHitung SET entropy = 0 WHERE entropy IS NULL;

	-- HITUNG GAIN
	CALL spGain(pLoop);

END^^
DELIMITER ;

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

	INSERT INTO tblPath(iterasi, atribut, informasi, gain)
	SELECT iterasi, atribut, informasi, gain
	FROM tblHitung
	WHERE gain = @gainsementara AND
		iterasi = pLoop AND
		demam != 0 AND
		flu != 0;

	SELECT COUNT(*) INTO vJumlahGain FROM tblPath WHERE iterasi = pLoop;

	IF vJumlahGain < 1 THEN

		INSERT INTO tblPath(iterasi, atribut, informasi, gain)
		SELECT iterasi, atribut, 'Selesai', gain
		FROM tblHitung
		WHERE gain = @gainsementara AND
			iterasi = pLoop
		LIMIT 1;		

	END IF;

END^^
DELIMITER ;

DELIMITER ^^
CREATE FUNCTION spCheck(pLoop INT)
RETURNS INT
BEGIN

	DECLARE vCekSelesai, vLoopReturn INT DEFAULT 0;
	SET vLoopReturn = 1;

	SELECT COUNT(informasi) INTO vCekSelesai FROM tblPath WHERE informasi = 'Selesai';

	IF vCekSelesai <> 0 THEN

		SET vLoopReturn = 2;

	END IF;

	RETURN (vLoopReturn);

END^^
DELIMITER ;

-- CALL spEntropy(1);
-- CALL spHitungEntropy(1);
-- SELECT * FROM tblKolom;
-- SELECT * FROM tblHitung;
-- SELECT * FROM tblPath;

CALL spLoop();

-- Hanya sampai Iterasi pertama