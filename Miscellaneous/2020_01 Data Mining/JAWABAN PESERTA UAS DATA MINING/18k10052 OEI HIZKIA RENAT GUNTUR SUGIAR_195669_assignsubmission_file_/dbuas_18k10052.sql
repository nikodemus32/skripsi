DROP DATABASE IF EXISTS dbuas_18k10052;
CREATE DATABASE dbuas_18k10052;
USE dbuas_18k10052;

CREATE TABLE tblC45(
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

INSERT INTO tblC45 VALUES
('P1', 'Tidak', 'Ringan', 'Tidak', 'Tidak', 'Tidak', 'Ringan', 'Parah', 'Parah', 'Ringan', 'Demam'),
('P2', 'Parah', 'Parah', 'Parah', 'Parah', 'Parah', 'Tidak', 'Tidak', 'Parah', 'Parah', 'Flu'),
('P3', 'Parah', 'Parah', 'Ringan', 'Parah', 'Parah', 'Parah', 'Tidak', 'Parah', 'Parah', 'Flu'),
('P4', 'Tidak', 'Tidak', 'Tidak', 'Ringan', 'Tidak', 'Parah', 'Tidak', 'Ringan', 'Ringan', 'Demam'),
('P5', 'Parah', 'Parah', 'Ringan', 'Parah', 'Parah', 'Parah', 'Tidak', 'Parah', 'Parah', 'Flu'),
('P6', 'Tidak', 'Tidak', 'Tidak', 'Ringan', 'Tidak', 'Parah', 'Parah', 'Parah', 'Tidak', 'Demam'),
('P7', 'Parah', 'Parah', 'Parah', 'Parah', 'Parah', 'Tidak', 'Tidak', 'Tidak', 'Parah', 'Flu'),
('P8', 'Tidak', 'Tidak', 'Tidak', 'Tidak', 'Tidak', 'Parah', 'Parah', 'Tida', 'Ringan', 'Demam'),
('P9', 'Tidak', 'Ringan', 'Ringan', 'Tidak', 'Tidak', 'Parah', 'Parah', 'Parah', 'Parah', 'Demam'),
('P10', 'Parah', 'Parah', 'Parah', 'Ringan', 'Ringan', 'Tidak', 'Parah', 'Tidak', 'Parah', 'Flu'),
('P11', 'Tidak', 'Tidak', 'Tidak', 'Ringan', 'Tidak', 'Parah', 'Ringan', 'Parah', 'Tidak', 'Demam'),
('P12', 'Parah', 'Ringan', 'Parah', 'Ringan', 'Parah', 'Tidak', 'Parah', 'Tidak', 'Ringan', 'Flu'),
('P13', 'Tidak', 'Tidak', 'Ringan', 'Ringan', 'Tidak', 'Parah', 'Parah', 'Parah', 'Tidak', 'Demam'),
('P14', 'Parah', 'Parah', 'Parah', 'Parah', 'Ringan', 'Tidak', 'Parah', 'Parah', 'Parah','Flu'),
('P15', 'Ringan', 'Tidak', 'Tidak', 'Ringan', 'Tidak', 'Parah', 'Tidak', 'Parah', 'Ringan', 'Demam'),
('P16', 'Tidak', 'Tidak', 'Tidak', 'Tidak', 'Tidak', 'Parah', 'Parah', 'Parah', 'Parah', 'Demam'),
('P17', 'Parah', 'Ringan', 'Parah', 'Ringan', 'Ringan', 'Tidak', 'Tidak', 'Tidak', 'Parah', 'Flu');

CREATE TABLE tblTampung(
	iterasi INT,
	atribut VARCHAR(20),
	informasi VARCHAR(20),
	gain DECIMAL(8,4)
);


CREATE TABLE tblOutput(
    iterasi INT,
    atribut VARCHAR(20),
    informasi VARCHAR(20),
    jumlahdata INT,
    demam INT,
    flu INT,
    entropy DECIMAL(8,4),
    gain DECIMAL(8,4)
);

CREATE TABLE tblHasil(
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


CREATE TABLE tblGain(
	iterasi INT,
	atribut VARCHAR(20),
	gain DECIMAL(8,4)
);

SELECT * FROM tblC45;

-- Membuat Memindahkan data dari tblC45 ke tblHasil
DELIMITER $$
CREATE PROCEDURE spEntropy(iterasi INT)
BEGIN
    INSERT INTO tblHasil
    SELECT  iterasi,id,demam,sakit_kepala,nyeri,lemas,kelelahan,hidung_tersumbat,bersin,sakit_tenggorokan,sulit_bernafas,diagnosa 
    FROM tblC45;
    CALL spDelete(iterasi);
    CALL spDiagnosa(iterasi);
END $$
DELIMITER ;


-- gain
DELIMITER $$
CREATE PROCEDURE spGain(iterasi INT)
BEGIN
	DECLARE vEntropy DECIMAL(8,4);
	DECLARE vJumlahData, vJumlahGain INT DEFAULT 0;
	SELECT jumlahdata INTO vJumlahData FROM tblOutput WHERE iterasi = iterasi LIMIT 1;
	SELECT entropy INTO vEntropy FROM tblOutput WHERE iterasi = iterasi LIMIT 1;
	INSERT INTO tblGain(iterasi, atribut, gain)
	SELECT iterasi,
		   atribut,
		   ROUND(ABS(vEntropy - SUM((jumlahdata/vJumlahData) * entropy)), 4) AS ENTROPY
	FROM tblOutput
	WHERE iterasi = iterasi
	GROUP BY atribut;
	UPDATE tblOutput SET gain = 
	(
		SELECT gain
		FROM tblGain
		WHERE atribut = tblOutput.atribut
		AND iterasi = iterasi
	)
	WHERE iterasi = iterasi;
	SELECT MAX(gain) INTO @gainsementara FROM tblGain WHERE iterasi = iterasi;
	INSERT INTO tblTampung(iterasi, atribut, informasi, gain)
	SELECT iterasi, atribut, informasi, gain
	FROM tblOutput
	WHERE gain = @gainsementara AND
		iterasi = iterasi AND
		demam != 0 AND
		flu != 0;
	SELECT COUNT(*) INTO vJumlahGain FROM tblTampung WHERE iterasi = iterasi;
	IF vJumlahGain < 1 THEN
		INSERT INTO tblTampung(iterasi, atribut, informasi, gain)
		SELECT iterasi, atribut, 'No', gain
		FROM tblOutput
		WHERE gain = @gainsementara AND
			iterasi = iterasi
		LIMIT 1;		
	END IF;
END $$
DELIMITER ;


-- diagnosa 
DELIMITER $$
CREATE PROCEDURE spDiagnosa(iterasi INT)
BEGIN
    DECLARE vAtribut VARCHAR(20) DEFAULT '';
    DECLARE vDiagnosaDemam, vDiagnosaFlu INT DEFAULT 0;

    DECLARE vI_sementara, vJumdata_sementara, i_sementara INT DEFAULT 0;
    DECLARE vAtribut_sementara, vInformasi VARCHAR(20);

    DECLARE cSementara CURSOR FOR SELECT atribut, informasi FROM tblTampung;
    SELECT COUNT(*) INTO vJumdata_sementara FROM tblTampung;

    IF iterasi = 1 THEN
        SET vAtribut='';
        SELECT COUNT(*) INTO vDiagnosaDemam FROM tblHasil
        WHERE diagnosa='Demam';
        SELECT COUNT(*) INTO vDiagnosaFlu FROM tblHasil
        WHERE diagnosa='Flu';

        INSERT INTO tblOutput(iterasi, atribut, jumlahdata, demam, flu) VALUES (iterasi, vAtribut, vDiagnosaDemam+vDiagnosaFlu, vDiagnosaDemam, vDiagnosaFlu);
    ELSEIF iterasi > 1 THEN
        SET vAtribut='';
        SELECT COUNT(*) INTO vDiagnosaDemam FROM tblHasil
        WHERE diagnosa='Demam' AND iterasi=iterasi;
        SELECT COUNT(*) INTO vDiagnosaFlu FROM tblHasil
        WHERE diagnosa='Flu' AND iterasi=iterasi;

        INSERT INTO tblOutput(iterasi, atribut, jumlahdata, demam, flu) VALUES (iterasi, vAtribut, vDiagnosaDemam+vDiagnosaFlu, vDiagnosaDemam, vDiagnosaFlu);
    END IF;

    INSERT INTO tblOutput(informasi, iterasi, atribut, jumlahdata,demam, flu)
		SELECT DISTINCT(A.demam), iterasi, 'Demam', (SELECT COUNT(*) FROM tblHasil WHERE iterasi = iterasi AND demam = A.demam),
        (SELECT COUNT(*) FROM tblHasil WHERE iterasi = iterasi AND demam = A.demam AND diagnosa = 'Demam'), 
        (SELECT COUNT(*) FROM tblHasil WHERE iterasi = iterasi AND demam = A.demam AND diagnosa = 'Flu') 
        FROM tblHasil AS A WHERE iterasi = iterasi;

    INSERT INTO tblOutput(informasi, iterasi, atribut, jumlahdata,demam, flu)
		SELECT DISTINCT(A.sakit_kepala), iterasi, 'Sakit Kepala', (SELECT COUNT(*) FROM tblHasil WHERE iterasi = iterasi AND sakit_kepala = A.sakit_kepala), 
        (SELECT COUNT(*) FROM tblHasil WHERE iterasi = iterasi AND sakit_kepala = A.sakit_kepala AND diagnosa = 'Demam'), 
        (SELECT COUNT(*) FROM tblHasil WHERE iterasi = iterasi AND sakit_kepala = A.sakit_kepala AND diagnosa = 'Flu') 
        FROM tblHasil AS A WHERE iterasi = iterasi;

    INSERT INTO tblOutput(informasi, iterasi, atribut, jumlahdata,demam, flu)
		SELECT DISTINCT(A.nyeri), iterasi, 'Nyeri', (SELECT COUNT(*) FROM tblHasil WHERE iterasi = iterasi AND nyeri = A.nyeri), 
        (SELECT COUNT(*) FROM tblHasil WHERE iterasi = iterasi AND nyeri = A.nyeri AND diagnosa = 'Demam'), 
        (SELECT COUNT(*) FROM tblHasil WHERE iterasi = iterasi AND nyeri = A.nyeri AND diagnosa = 'Flu') 
        FROM tblHasil AS A WHERE iterasi = iterasi;
    
    INSERT INTO tblOutput(informasi, iterasi, atribut, jumlahdata,demam, flu)
		SELECT DISTINCT(A.lemas), iterasi, 'Lemas', (SELECT COUNT(*) FROM tblHasil WHERE iterasi = iterasi AND lemas = A.lemas), 
        (SELECT COUNT(*) FROM tblHasil WHERE iterasi = iterasi AND lemas = A.lemas AND diagnosa = 'Demam'), 
        (SELECT COUNT(*) FROM tblHasil WHERE iterasi = iterasi AND lemas = A.lemas AND diagnosa = 'Flu') 
        FROM tblHasil AS A WHERE iterasi = iterasi;
    
    INSERT INTO tblOutput(informasi, iterasi, atribut, jumlahdata,demam, flu)
		SELECT DISTINCT(A.kelelahan), iterasi, 'Kelelahan', (SELECT COUNT(*) FROM tblHasil WHERE iterasi = iterasi AND kelelahan = A.kelelahan), 
        (SELECT COUNT(*) FROM tblHasil WHERE iterasi = iterasi AND kelelahan = A.kelelahan AND diagnosa = 'Demam'), 
        (SELECT COUNT(*) FROM tblHasil WHERE iterasi = iterasi AND kelelahan = A.kelelahan AND diagnosa = 'Flu') 
        FROM tblHasil AS A WHERE iterasi = iterasi;

    INSERT INTO tblOutput(informasi, iterasi, atribut, jumlahdata,demam, flu)
		SELECT DISTINCT(A.hidung_tersumbat), iterasi, 'Hidung Tersumbat', 
        (SELECT COUNT(*) FROM tblHasil WHERE iterasi = iterasi AND hidung_tersumbat = A.hidung_tersumbat), 
        (SELECT COUNT(*) FROM tblHasil WHERE iterasi = iterasi AND hidung_tersumbat = A.hidung_tersumbat AND diagnosa = 'Demam'), 
        (SELECT COUNT(*) FROM tblHasil WHERE iterasi = iterasi AND hidung_tersumbat = A.hidung_tersumbat AND diagnosa = 'Flu') 
        FROM tblHasil AS A WHERE iterasi = iterasi;

    INSERT INTO tblOutput(informasi, iterasi, atribut, jumlahdata,demam, flu)
		SELECT DISTINCT(A.bersin), iterasi, 'Bersin', 
        (SELECT COUNT(*) FROM tblHasil WHERE iterasi = iterasi AND bersin = A.bersin), 
        (SELECT COUNT(*) FROM tblHasil WHERE iterasi = iterasi AND bersin = A.bersin AND diagnosa = 'Demam'), 
        (SELECT COUNT(*) FROM tblHasil WHERE iterasi = iterasi AND bersin = A.bersin AND diagnosa = 'Flu') 
        FROM tblHasil AS A WHERE iterasi = iterasi;

    INSERT INTO tblOutput(informasi, iterasi, atribut, jumlahdata,demam, flu)
		SELECT DISTINCT(A.sakit_tenggorokan), iterasi, 'Sakit Tenggorokan', 
        (SELECT COUNT(*) FROM tblHasil WHERE iterasi = iterasi AND sakit_tenggorokan = A.sakit_tenggorokan), 
        (SELECT COUNT(*) FROM tblHasil WHERE iterasi = iterasi AND sakit_tenggorokan = A.sakit_tenggorokan AND diagnosa = 'Demam'), 
        (SELECT COUNT(*) FROM tblHasil WHERE iterasi = iterasi AND sakit_tenggorokan = A.sakit_tenggorokan AND diagnosa = 'Flu') 
        FROM tblHasil AS A WHERE iterasi = iterasi;

    INSERT INTO tblOutput(informasi, iterasi, atribut, jumlahdata,demam, flu)
		SELECT DISTINCT(A.sulit_bernafas), iterasi, 'Sulit Bernafas', 
        (SELECT COUNT(*) FROM tblHasil WHERE iterasi = iterasi AND sulit_bernafas = A.sulit_bernafas), 
        (SELECT COUNT(*) FROM tblHasil WHERE iterasi = iterasi AND sulit_bernafas = A.sulit_bernafas AND diagnosa = 'Demam'), 
        (SELECT COUNT(*) FROM tblHasil WHERE iterasi = iterasi AND sulit_bernafas = A.sulit_bernafas AND diagnosa = 'Flu') 
        FROM tblHasil AS A WHERE iterasi = iterasi;

    OPEN cSementara;
        WHILE i_sementara != vJumdata_sementara DO
            FETCH cSementara INTO vAtribut_sementara, vInformasi;
            DELETE FROM tblOutput WHERE iterasi = iterasi AND atribut = vAtribut_sementara;
            SET i_sementara = i_sementara +1;
        END WHILE;
    CLOSE cSementara;
END $$
DELIMITER ;

-- entropy
DELIMITER $$
CREATE PROCEDURE spJumEntropy(iterasi INT)
BEGIN
	UPDATE tblOutput SET entropy = ( -(demam/jumlahdata) * log2(demam/jumlahdata) ) + ( -(flu/jumlahdata) * log2(flu/jumlahdata) );
	UPDATE tblOutput SET entropy = 0 WHERE entropy IS NULL;
	CALL spGain(iterasi);
END $$
DELIMITER ;

-- Prosedur untuk menghapus data yang tidak sesuai dengan GAIN tertinggi
DELIMITER $$
CREATE PROCEDURE spDelete(iterasi INT)
BEGIN
    
    DECLARE i, vJumdata_Hasil, vIterasi_Hasil INT DEFAULT 0;
    DECLARE vId, vDemam, vSakit_kepala, vNyeri, vLemas, vKelelahan, vHidung_tersumbat, vBersin, vSakit_tenggorokan, vSulit_bernafas, vDiagnosa VARCHAR(20); 
    DECLARE vI_sementara, i_sementara, vJumdata_sementara INT DEFAULT 0;
    DECLARE vAtribut_sementara, vInformasiPath VARCHAR(20);

    DECLARE cSementara CURSOR FOR SELECT iterasi, atribut, informasi FROM tblTampung;
    DECLARE cKolom CURSOR FOR SELECT * FROM tblHasil;
    SELECT COUNT(*) INTO vJumdata_Hasil FROM tblHasil WHERE iterasi=iterasi;
    SELECT COUNT(*) INTO vJumdata_sementara FROM tblTampung;

    OPEN cKolom;
        WHILE i != vJumdata_Hasil DO
            FETCH cKolom INTO vIterasi_Hasil, vId, vDemam, vSakit_kepala, vNyeri, vLemas, vKelelahan, vHidung_tersumbat, vBersin, vSakit_tenggorokan, vSulit_bernafas, vDiagnosa;
            SET i_sementara=0;
            OPEN cSementara;
                WHILE i_sementara != vJumdata_sementara DO
                    FETCH cSementara INTO vI_sementara, vAtribut_sementara, vInformasiPath;
                    IF vAtribut_sementara = 'demam' THEN
                        IF vDemam != vInformasiPath THEN
                            DELETE FROM tblHasil WHERE iterasi=iterasi AND id=vId;
                        END IF;
                    ELSEIF vAtribut_sementara = 'sakit_kepala' THEN
                        IF vSakit_kepala != vInformasiPath THEN
                            DELETE FROM tblHasil WHERE iterasi=iterasi AND id=vId;
                        END IF;

                     ELSEIF vAtribut_sementara = 'nyeri' THEN
                        IF vNyeri != vInformasiPath THEN
                            DELETE FROM tblHasil WHERE iterasi=iterasi AND id=vId;
                        END IF;
                     ELSEIF vAtribut_sementara = 'lemas' THEN
                        IF vLemas != vInformasiPath THEN
                            DELETE FROM tblHasil WHERE iterasi=iterasi AND id=vId;
                        END IF;
                     ELSEIF vAtribut_sementara = 'kelelahan' THEN
                        IF vKelelahan != vInformasiPath THEN
                            DELETE FROM tblHasil WHERE iterasi=iterasi AND id=vId;
                        END IF;
                     ELSEIF vAtribut_sementara = 'hidung_tersumbat' THEN
                        IF vHidung_tersumbat != vInformasiPath THEN
                            DELETE FROM tblHasil WHERE iterasi=iterasi AND id=vId;
                        END IF;
                     ELSEIF vAtribut_sementara = 'bersin' THEN
                        IF vBersin != vInformasiPath THEN
                            DELETE FROM tblHasil WHERE iterasi=iterasi AND id=vId;
                        END IF;
                     ELSEIF vAtribut_sementara = 'sakit_tenggorokan' THEN
                        IF vSakit_tenggorokan != vInformasiPath THEN
                            DELETE FROM tblHasil WHERE iterasi=iterasi AND id=vId;
                        END IF;
                     ELSEIF vAtribut_sementara = 'sulit_bernafas' THEN
                        IF vSulit_bernafas != vInformasiPath THEN
                            DELETE FROM tblHasil WHERE iterasi=iterasi AND id=vId;
                        END IF;
                    END IF;
                    SET i_sementara = i_sementara + 1;
                END WHILE;
            CLOSE cSementara;
            SET i = i + 1;
        END WHILE;
    CLOSE cKolom;

END $$
DELIMITER ;

-- cek iterasi
DELIMITER $$
CREATE FUNCTION spCek(iterasi INT)
RETURNS INT
BEGIN
	DECLARE vCekSelesai, vIterasireturn INT DEFAULT 0;
	SET vIterasireturn = 1;
	SELECT COUNT(informasi) INTO vCekSelesai FROM tblTampung WHERE informasi = 'No';
	IF vCekSelesai != 0 THEN
		SET vIterasireturn = 2;
	END IF;
	RETURN (vIterasireturn);
END $$
DELIMITER ;

-- iterasi
DELIMITER $$
CREATE PROCEDURE spIterasi()
BEGIN
	DECLARE vIterasi, vStop INT DEFAULT 1;
	WHILE vStop = 1 DO
		CALL spEntropy(vIterasi);
		CALL spJumEntropy(vIterasi);
		SET vIterasi = vIterasi + 1;
		SET vStop = spCek(vIterasi);
		SELECT * FROM tblHasil;
		SELECT * FROM tblOutput;
		SELECT * FROM tblTampung;
	END WHILE;
END $$
DELIMITER ;

CALL spIterasi();