DROP DATABASE IF EXISTS dbUAS;
CREATE DATABASE dbUAS;
USE dbUAS;

CREATE TABLE tblDiagnosis
(
    kolom1      VARCHAR(255),
    kolom2      VARCHAR(255),
    kolom3      VARCHAR(255),
    kolom4      VARCHAR(255),
    kolom5      VARCHAR(255),
    kolom6      VARCHAR(255),
    kolom7      VARCHAR(255),
    kolom8      VARCHAR(255),
    kolom9      VARCHAR(255),
    kolom10     VARCHAR(255),
    diagnosa    VARCHAR(255)
);

INSERT INTO tblDiagnosis VALUES
('P1', '1', '2', '1', '1', '1', '2', '3', '3', '2', 'Demam'),
('P2', '3', '3', '3', '3', '3', '1', '1', '3', '3', 'Flu'),
('P3', '3', '3', '2', '3', '3', '3', '1', '3', '3', 'Flu'),
('P4', '1', '1', '1', '2', '1', '3', '1', '2', '2', 'Demam'),
('P5', '3', '3', '2', '3', '3', '3', '1', '3', '3', 'Flu'),
('P6', '1', '1', '1', '2', '1', '3', '3', '3', '1', 'Demam'),
('P7', '3', '3', '3', '3', '3', '1', '1', '1', '3', 'Flu'),
('P8', '1', '1', '1', '1', '1', '3', '3', '1', '2', 'Demam'),
('P9', '1', '2', '2', '1', '1', '3', '3', '3', '3', 'Demam'),
('P10', '3', '3', '3', '2', '2', '1', '3', '1', '3', 'Flu'),
('P11', '1', '1', '1', '2', '1', '3', '2', '3', '1', 'Demam'),
('P12', '3', '2', '3', '2', '3', '1', '3', '1', '2', 'Flu'),
('P13', '1', '1', '2', '2', '1', '3', '3', '3', '1', 'Demam'),
('P14', '3', '3', '3', '3', '2', '1', '3', '3', '3', 'Flu'),
('P15', '2', '1', '1', '2', '1', '3', '1', '3', '2', 'Demam'),
('P16', '1', '1', '1', '1', '1', '3', '3', '3', '3', 'Demam'),
('P17', '3', '2', '3', '2', '2', '1', '1', '1', '3', 'Flu');

/*
    1 = Tidak
    2 = Ringan
    3 = Parah
*/

CREATE TABLE tblHitungan
(
    iterasi     VARCHAR(255),
    atribut     VARCHAR(255),
    informasi   VARCHAR(20),
    jumlahdata  INT NOT NULL,
    demam       INT NOT NULL,
    flu         INT NOT NULL,
    entropy     decimal(8,4) NOT NULL,
    gain        decimal(8,4) NOT NULL
);

SELECT * FROM tblDiagnosis;

DELIMITER ##
CREATE PROCEDURE spC45()
BEGIN

    DECLARE iterasi_n INT DEFAULT 1;
    DECLARE n INT DEFAULT 0;

    DECLARE i INT DEFAULT 1;
    DECLARE jumlaholahdata INT DEFAULT 0;
    DECLARE vIterasi, vAtribut VARCHAR(255) DEFAULT ''; 
    DECLARE vInformasi VARCHAR(20) DEFAULT '';
    DECLARE vJumlahdata, vDemam, vFlu INT DEFAULT 0;
    DECLARE vEntropy, vGain decimal(8,4);
    
    DECLARE cAmbilData CURSOR FOR
    SELECT * FROM tblHitungan WHERE iterasi = CONCAT('Iterasi ', iterasi_n) AND atribut like 'kolom%';

    SELECT COUNT(*) INTO @jumlahdata FROM tblDiagnosis;
    SELECT COUNT(*) INTO @demam FROM tblDiagnosis WHERE diagnosa = 'DEMAM';
    SELECT COUNT(*) INTO @flu FROM tblDiagnosis WHERE diagnosa = 'FLU';
    SELECT (-(@demam/@jumlahdata) * log2(@demam/@jumlahdata)) + (-(@flu/@jumlahdata) * log2(@flu/@jumlahdata)) INTO @entropy;
    
    SELECT @jumlahdata AS "Total Data", @demam AS 'Demam', @flu AS 'Flu', ROUND(@entropy,4) AS 'Entropy';

    INSERT INTO tblHitungan(iterasi, atribut, jumlahdata, demam, flu, entropy) VALUES (CONCAT('Iterasi ', iterasi_n), 'TOTAL DATA', @jumlahdata, @demam, @flu, @entropy);

    SET @informasi_n:=1;
    SET @atribut_n:=2;
    SELECT DISTINCT COUNT(COLUMN_NAME) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'tblDiagnosis' AND COLUMN_NAME NOT LIKE '%kolom1%' AND COLUMN_NAME NOT LIKE '%diagnosa%' INTO @jumlahkolom;    

    hitungc45:LOOP
    IF n = 1 THEN LEAVE hitungc45;
    END IF;
    
        WHILE @atribut_n < @jumlahkolom+3 DO

            CASE
            
                WHEN @atribut_n = 2 THEN
                SET @informasi_n:=1;

                    WHILE @informasi_n <= 3 DO
                    INSERT INTO tblHitungan(atribut, informasi, jumlahdata, demam, flu)
                            
                        SELECT 
                        CONCAT('kolom',@atribut_n), 
                        @informasi_n, 
                        COUNT(*), 
                        (SELECT COUNT(kolom2) FROM tblDiagnosis WHERE diagnosa = 'Demam' AND kolom2 = @informasi_n),
                        
                        (SELECT COUNT(kolom2) FROM tblDiagnosis WHERE diagnosa = 'Flu' AND kolom2 = @informasi_n) 
                        
                        FROM tblDiagnosis 
                        WHERE kolom2 = @informasi_n;
                        
                        SET @informasi_n:= @informasi_n+1;
                    END WHILE;
                
                SET @atribut_n = @atribut_n + 1;

                WHEN @atribut_n = 3 THEN
                SET @informasi_n:=1;

                    WHILE @informasi_n <= 3 DO
                    INSERT INTO tblHitungan(atribut, informasi, jumlahdata, demam, flu)
                            
                        SELECT 
                        CONCAT('kolom',@atribut_n), 
                        @informasi_n, 
                        COUNT(*), 
                        (SELECT COUNT(kolom3) FROM tblDiagnosis WHERE diagnosa = 'Demam' AND kolom3 = @informasi_n),
                        
                        (SELECT COUNT(kolom3) FROM tblDiagnosis WHERE diagnosa = 'Flu' AND kolom3 = @informasi_n) 
                        
                        FROM tblDiagnosis 
                        WHERE kolom3 = @informasi_n;
                        
                        SET @informasi_n:= @informasi_n+1;
                    END WHILE;
                
                SET @atribut_n = @atribut_n + 1;

                WHEN @atribut_n = 4 THEN
                SET @informasi_n:=1;

                    WHILE @informasi_n <= 3 DO
                    INSERT INTO tblHitungan(atribut, informasi, jumlahdata, demam, flu)
                            
                        SELECT 
                        CONCAT('kolom',@atribut_n), 
                        @informasi_n, 
                        COUNT(*), 
                        (SELECT COUNT(kolom4) FROM tblDiagnosis WHERE diagnosa = 'Demam' AND kolom4 = @informasi_n),
                        
                        (SELECT COUNT(kolom4) FROM tblDiagnosis WHERE diagnosa = 'Flu' AND kolom4 = @informasi_n) 
                        
                        FROM tblDiagnosis 
                        WHERE kolom4 = @informasi_n;
                        
                        SET @informasi_n:= @informasi_n+1;
                    END WHILE;
                
                SET @atribut_n = @atribut_n + 1;

                WHEN @atribut_n = 5 THEN
                SET @informasi_n:=1;

                    WHILE @informasi_n <= 3 DO
                    INSERT INTO tblHitungan(atribut, informasi, jumlahdata, demam, flu)
                            
                        SELECT 
                        CONCAT('kolom',@atribut_n), 
                        @informasi_n, 
                        COUNT(*), 
                        (SELECT COUNT(kolom5) FROM tblDiagnosis WHERE diagnosa = 'Demam' AND kolom5 = @informasi_n),
                        
                        (SELECT COUNT(kolom5) FROM tblDiagnosis WHERE diagnosa = 'Flu' AND kolom5 = @informasi_n) 
                        
                        FROM tblDiagnosis 
                        WHERE kolom5 = @informasi_n;
                        
                        SET @informasi_n:= @informasi_n+1;
                    END WHILE;
                
                SET @atribut_n = @atribut_n + 1;

                WHEN @atribut_n = 6 THEN
                SET @informasi_n:=1;

                    WHILE @informasi_n <= 3 DO
                    INSERT INTO tblHitungan(atribut, informasi, jumlahdata, demam, flu)
                            
                        SELECT 
                        CONCAT('kolom',@atribut_n), 
                        @informasi_n, 
                        COUNT(*), 
                        (SELECT COUNT(kolom6) FROM tblDiagnosis WHERE diagnosa = 'Demam' AND kolom6 = @informasi_n),
                        
                        (SELECT COUNT(kolom6) FROM tblDiagnosis WHERE diagnosa = 'Flu' AND kolom6 = @informasi_n) 
                        
                        FROM tblDiagnosis 
                        WHERE kolom6 = @informasi_n;
                        
                        SET @informasi_n:= @informasi_n+1;
                    END WHILE;
                
                SET @atribut_n = @atribut_n + 1;

                WHEN @atribut_n = 7 THEN
                SET @informasi_n:=1;

                    WHILE @informasi_n <= 3 DO
                    INSERT INTO tblHitungan(atribut, informasi, jumlahdata, demam, flu)
                            
                        SELECT 
                        CONCAT('kolom',@atribut_n), 
                        @informasi_n, 
                        COUNT(*), 
                        (SELECT COUNT(kolom7) FROM tblDiagnosis WHERE diagnosa = 'Demam' AND kolom7 = @informasi_n),
                        
                        (SELECT COUNT(kolom7) FROM tblDiagnosis WHERE diagnosa = 'Flu' AND kolom7 = @informasi_n) 
                        
                        FROM tblDiagnosis 
                        WHERE kolom7 = @informasi_n;
                        
                        SET @informasi_n:= @informasi_n+1;
                    END WHILE;
                
                SET @atribut_n = @atribut_n + 1;

                WHEN @atribut_n = 8 THEN
                SET @informasi_n:=1;

                    WHILE @informasi_n <= 3 DO
                    INSERT INTO tblHitungan(atribut, informasi, jumlahdata, demam, flu)
                            
                        SELECT 
                        CONCAT('kolom',@atribut_n), 
                        @informasi_n, 
                        COUNT(*), 
                        (SELECT COUNT(kolom8) FROM tblDiagnosis WHERE diagnosa = 'Demam' AND kolom8 = @informasi_n),
                        
                        (SELECT COUNT(kolom8) FROM tblDiagnosis WHERE diagnosa = 'Flu' AND kolom8 = @informasi_n) 
                        
                        FROM tblDiagnosis 
                        WHERE kolom8 = @informasi_n;
                        
                        SET @informasi_n:= @informasi_n+1;
                    END WHILE;
                
                SET @atribut_n = @atribut_n + 1;

                WHEN @atribut_n = 9 THEN
                SET @informasi_n:=1;

                    WHILE @informasi_n <= 3 DO
                    INSERT INTO tblHitungan(atribut, informasi, jumlahdata, demam, flu)
                            
                        SELECT 
                        CONCAT('kolom',@atribut_n), 
                        @informasi_n, 
                        COUNT(*), 
                        (SELECT COUNT(kolom9) FROM tblDiagnosis WHERE diagnosa = 'Demam' AND kolom9 = @informasi_n),
                        
                        (SELECT COUNT(kolom9) FROM tblDiagnosis WHERE diagnosa = 'Flu' AND kolom9 = @informasi_n) 
                        
                        FROM tblDiagnosis 
                        WHERE kolom9 = @informasi_n;
                        
                        SET @informasi_n:= @informasi_n+1;
                    END WHILE;
                
                SET @atribut_n = @atribut_n + 1;

                WHEN @atribut_n = 10 THEN
                SET @informasi_n:=1;

                    WHILE @informasi_n <= 3 DO
                    INSERT INTO tblHitungan(atribut, informasi, jumlahdata, demam, flu)
                            
                        SELECT 
                        CONCAT('kolom',@atribut_n), 
                        @informasi_n, 
                        COUNT(*), 
                        (SELECT COUNT(kolom10) FROM tblDiagnosis WHERE diagnosa = 'Demam' AND kolom10 = @informasi_n),
                        
                        (SELECT COUNT(kolom10) FROM tblDiagnosis WHERE diagnosa = 'Flu' AND kolom10 = @informasi_n) 
                        
                        FROM tblDiagnosis 
                        WHERE kolom10 = @informasi_n;
                        
                        SET @informasi_n:= @informasi_n+1;
                    END WHILE;
                
                SET @atribut_n = @atribut_n + 1;

                ELSE
                SET @atribut_n = @atribut_n + 1;    
            
            END CASE;
        END WHILE;

        UPDATE tblHitungan SET iterasi = CONCAT('Iterasi ', iterasi_n) WHERE iterasi IS NULL;

        UPDATE tblHitungan SET entropy = (-(demam/jumlahdata) * log2(demam/jumlahdata)) + (-(demam/jumlahdata) * log2(demam/jumlahdata)) WHERE iterasi = CONCAT('Iterasi ', iterasi_n);
        
        DROP TABLE IF EXISTS tblTampung;
        CREATE TEMPORARY TABLE tblTampung
        (
            atribut VARCHAR(20),
            gain decimal(8,4)
        );

        INSERT INTO tblTampung(atribut, gain)
        SELECT atribut, @entropy - SUM((jumlahdata/@jumlahdata) * entropy) AS GAIN FROM tblHitungan WHERE iterasi = CONCAT('Iterasi ', iterasi_n) AND atribut LIKE 'kolom%' GROUP BY atribut;

        SELECT * FROM tblTampung;

        UPDATE tblHitungan SET GAIN =
            (
                SELECT gain
                FROM tblTampung
                WHERE atribut = tblHitungan.atribut
            ) WHERE iterasi = CONCAT('Iterasi ', iterasi_n);

        SELECT COUNT(*) FROM tblHitungan WHERE iterasi = CONCAT('Iterasi ', iterasi_n) and atribut like 'kolom%' INTO jumlaholahdata;

        OPEN cAmbilData;
        FETCH cAmbilData INTO vIterasi, vAtribut, vInformasi, vJumlahData, vDemam, vFlu, vEntropy, vGain;

            IF vGain = (SELECT MAX(gain) from tblHitungan) AND (vDemam = 0 OR vFlu = 0) AND (vDemam > 0 AND vFlu > 0) THEN

                SET iterasi_n = iterasi_n + 1;

                SELECT jumlahdata INTO @jumlahdata FROM tblHitungan WHERE gain = (SELECT MAX(gain) from tblHitungan) AND jumlahdata = (SELECT MAX(jumlahdata) from tblHitungan WHERE gain = (SELECT MAX(gain) from tblHitungan));
                
                SELECT demam INTO @demam FROM tblHitungan WHERE gain = (SELECT MAX(gain) from tblHitungan) 
                AND jumlahdata = (SELECT MAX(jumlahdata) from tblHitungan);
                
                SELECT flu INTO @flu FROM tblHitungan WHERE gain = (SELECT MAX(gain) from tblHitungan) 
                AND jumlahdata = (SELECT MAX(jumlahdata) from tblHitungan);

                SELECT atribut FROM tblHitungan WHERE gain = (SELECT MAX(gain) from tblHitungan) AND jumlahdata = (SELECT MAX(jumlahdata) from tblHitungan WHERE gain = (SELECT MAX(gain) from tblHitungan)) INTO @atribut_concat;
                SELECT informasi FROM tblHitungan WHERE gain = (SELECT MAX(gain) from tblHitungan) AND jumlahdata = (SELECT MAX(jumlahdata) from tblHitungan WHERE gain = (SELECT MAX(gain) from tblHitungan)) INTO @informasi_concat;
                
                SELECT (-(@demam/@jumlahdata) * log2(@demam/@jumlahdata)) + (-(@flu/@jumlahdata) * log2(@flu/@jumlahdata)) INTO @entropy;

                SELECT @jumlahdata AS "Total Data", @demam AS 'Demam', @flu AS 'Flu', ROUND(@entropy,4) AS 'Entropy';

                INSERT INTO tblHitungan(iterasi, atribut, jumlahdata, demam, flu, entropy) VALUES (CONCAT('Iterasi ', iterasi_n), CONCAT(UPPER(@atribut_concat), " - " ,@informasi_concat), @jumlahdata, @demam, @flu, @entropy);

            ELSE

                SET n=1;

            END IF;

        CLOSE cAmbilData;

    END LOOP hitungc45;
    
    UPDATE tblHitungan SET informasi = 'Tidak' WHERE informasi = '1';
    UPDATE tblHitungan SET informasi = 'Ringan' WHERE informasi = '2';
    UPDATE tblHitungan SET informasi = 'Parah' WHERE informasi = '3';

    SELECT * FROM tblHitungan;

END
##
DELIMITER ;

CALL spC45();

/*

Kesimpulan : 

Hanya berhenti di iterasi 1 saja. Dikarenakan selain nilai gain tertinggi dari 
kedua atribut berbeda sama (yaitu kolom 2 dan 6), masing-masing terindikasi flu 
dan demam tidak ada yang keduanya >0

Hasil Diagnosa menunjukkan bahwa diagnosa demam (kolom [2]) 
jika informasinya tidak dan ringan maka pasti terindikasi demam, 
jika informasinya parah maka pasti terindikasi flu

Untuk diagnosa kelelahan (kolom [6]) 
jika informasinya tidak maka pasti terindikasi demam, 
jika informasinya ringan dan parah maka pasti terindikasi flu

*/