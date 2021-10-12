DROP DATABASE IF EXISTS dbc45;
CREATE DATABASE dbc45;
USE dbc45;

CREATE TABLE tblc45
(
nomor VARCHAR(5),
demam VARCHAR(20),
sakitkepala VARCHAR(20),
nyeri VARCHAR(20),
lemas VARCHAR(20),
kelelahan VARCHAR(20),
hidungtersumbat VARCHAR(20),
bersin VARCHAR(20),
sakittenggorokan VARCHAR(20),
sulitbernafas VARCHAR(20),
diagnosa VARCHAR(10)
);

insert into tblc45 values
('P1', 'tidak','ringan','tidak','tidak','tidak','ringan','parah','parah','ringan','demam'),
('P2', 'parah','parah','parah','parah','parah','tidak','tidak','parah','parah','flu'),
('P3', 'parah','parah','ringan','parah','parah','parah','tidak','parah','parah','flu'),
('P4', 'tidak','tidak','tidak','ringan','tidak','parah','tidak','ringan','ringan','demam'),
('P5', 'parah','parah','ringan','parah','parah','parah','tidak','parah','parah','flu'),
('P6', 'tidak','tidak','tidak','ringan','tidak','parah','parah','parah','tidak','demam'),
('P7', 'parah','parah','parah','parah','parah','tidak','tidak','tidak','parah','flu'),
('P8', 'tidak','tidak','tidak','tidak','tidak','parah','parah','tidak','ringan','demam'),
('P9', 'tidak','ringan','ringan','tidak','tidak','parah','parah','parah','parah','demam'),
('P10', 'parah','parah','parah','ringan','ringan','tidak','parah','tidak','parah','flu'),
('P11', 'tidak','tidak','tidak','ringan','tidak','parah','ringan','parah','tidak','demam'),
('P12', 'parah','ringan','parah','ringan','parah','tidak','parah','tidak','ringan','flu'),
('P13', 'tidak','tidak','ringan','ringan','tidak','parah','parah','parah','tidak','demam'),
('P14', 'parah','parah','parah','parah','ringan','tidak','parah','parah','parah','flu'),
('P15', 'ringan','tidak','tidak','ringan','tidak','parah','tidak','parah','ringan','demam'),
('P16', 'tidak','tidak','tidak','tidak','tidak','parah','parah','parah','parah','demam'),
('P17', 'parah','ringan','parah','ringan','ringan','tidak','tidak','tidak','parah','flu');
SELECT * FROM tblc45;

CREATE TABLE tblHitung
(
iterasike int,
atribut VARCHAR(20),
informasi VARCHAR(20),
jumlahdata INT,
diagnosaflu INT,
diagnosademam INT,
entropy DECIMAL(8,4),
gain decimal(8,4)
);


CREATE table tblBaru
(
atribut_MAX VARCHAR(20),
informasi_MAX VARCHAR(20)
); 

DELIMITER ##
CREATE PROCEDURE spJum()
BEGIN

SELECT COUNT(*) INTO @jumlahdata
FROM tblc45;
 
SELECT COUNT(*) INTO @diagnosademam
FROM tblc45
WHERE diagnosa = 'demam';
 
SELECT COUNT(*) INTO @diagnosaflu
FROM tblc45
WHERE diagnosa = 'flu';

SELECT (-(@diagnosademam/@jumlahdata) * log2(@diagnosademam/@jumlahdata)) +
 (-(@diagnosaflu/@jumlahdata) * log2(@diagnosaflu/@jumlahdata))
INTO @entropy ;
 
SELECT @jumlahdata AS jum_data,
@diagnosademam AS diagnosa_demam,
@diagnosaflu AS diagnosa_flu,
ROUND(@entropy, 4) AS ENTROPY;

set @i = 1; 
INSERT INTO tblHitung(iterasike,atribut, jumlahdata, diagnosaflu, diagnosademam, entropy) VALUES
(@i,'TOTAL DATA', @jumlahdata,@diagnosaflu,@diagnosademam,@entropy);

END ##
DELIMITER ;
-- CALL spJum();


DELIMITER ##
CREATE PROCEDURE spIterasi(vIterasi INT)
BEGIN
    
    INSERT INTO tblHitung(informasi,atribut,iterasike) 
    SELECT DISTINCT(demam),'demam',vIterasi from tblc45;

    INSERT INTO tblHitung(informasi,atribut,iterasike) 
    SELECT DISTINCT(sakitkepala),'sakitkepala',1 from tblc45;

    INSERT INTO tblHitung(informasi,atribut,iterasike) 
    SELECT DISTINCT(nyeri),'nyeri',vIterasi from tblc45;

    INSERT INTO tblHitung(informasi,atribut,iterasike) 
    SELECT DISTINCT(lemas),'lemas',vIterasi from tblc45;

    INSERT INTO tblHitung(informasi,atribut,iterasike) 
    SELECT DISTINCT(kelelahan),'kelelahan',vIterasi from tblc45;

    INSERT INTO tblHitung(informasi,atribut,iterasike) 
    SELECT DISTINCT(hidungtersumbat),'hidungtersumbat',vIterasi from tblc45;    

    INSERT INTO tblHitung(informasi,atribut,iterasike) 
    SELECT DISTINCT(bersin),'bersin',vIterasi from tblc45;
    
    INSERT INTO tblHitung(informasi,atribut,iterasike) 
    SELECT DISTINCT(sakittenggorokan),'sakittenggorokan',vIterasi from tblc45;

    INSERT INTO tblHitung(informasi,atribut,iterasike) 
    SELECT DISTINCT(sulitbernafas),'sulitbernafas',vIterasi from tblc45;
    
    select * from tblHitung;                        
call spUpdate();
END##
DELIMITER ;



DELIMITER ##
CREATE PROCEDURE spUpdate()
BEGIN
    DECLARE vJumData1 INT;
    DECLARE j int DEFAULT 0;
    DECLARE vatribut, vinformasi VARCHAR(20);
    DECLARE viterasike, vjumlahdata, vdiagnosaflu, vdiagnosademam INT;
    DECLARE ventropy DECIMAL(8,4);
    DECLARE vgain DOUBLE; 

        DECLARE cHitung cursor for SELECT * FROM tblHitung;
        SELECT COUNT(*) into vJumData1 from tblHitung;

    open cHitung;
        WHILE j <> vJumData1 do
        FETCH cHitung INTO viterasike, vatribut, vinformasi, vjumlahdata, vdiagnosaflu, vdiagnosademam, ventropy, vgain;

            IF vatribut = 'demam' THEN
                UPDATE tblHitung SET jumlahdata = (select count(*) from tblc45 where demam = informasi)
                where atribut = vatribut and iterasike = viterasike;
            ELSEIF vatribut = 'sakitkepala' THEN
                UPDATE tblHitung SET jumlahdata = (select count(*) from tblc45 where sakitkepala = informasi)
                where atribut = vatribut and iterasike = viterasike;
                ELSEIF vatribut = 'nyeri' THEN
                    UPDATE tblHitung SET jumlahdata = (select count(*) from tblc45 where nyeri = informasi)
                    where atribut = vatribut and iterasike = viterasike;
                    ELSEIF vatribut = 'lemas' THEN
                        UPDATE tblHitung SET jumlahdata = (select count(*) from tblc45 where lemas = informasi)
                        where atribut = vatribut and iterasike = viterasike;
                        ELSEIF vatribut = 'kelelahan' THEN
                            UPDATE tblHitung SET jumlahdata = (select count(*) from tblc45 where kelelahan = informasi)
                            where atribut = vatribut and iterasike = viterasike;
                            ELSEIF vatribut = 'hidungtersumbat' THEN
                                UPDATE tblHitung SET jumlahdata = (select count(*) from tblc45 where hidungtersumbat = informasi)
                                where atribut = vatribut and iterasike = viterasike;
                                ELSEIF vatribut = 'bersin' THEN
                                    UPDATE tblHitung SET jumlahdata = (select count(*) from tblc45 where bersin = informasi)
                                    where atribut = vatribut and iterasike = viterasike;
                                    ELSEIF vatribut = 'sakittenggorokan' THEN
                                        UPDATE tblHitung SET jumlahdata = (select count(*) from tblc45 where sakittenggorokan = informasi)
                                        where atribut = vatribut and iterasike = viterasike;
                                        ELSEIF vatribut = 'sulitbernafas' THEN
                                            UPDATE tblHitung SET jumlahdata = (select count(*) from tblc45 where sulitbernafas = informasi)
                                            where atribut = vatribut and iterasike = viterasike;

            END IF;

            IF vatribut = 'demam' THEN
                UPDATE tblHitung SET diagnosademam = (select count(*) from tblc45 where demam = informasi and diagnosa = 'demam')
                where atribut = vatribut and iterasike = viterasike;
            ELSEIF vatribut = 'sakitkepala' THEN
                UPDATE tblHitung SET diagnosademam = (select count(*) from tblc45 where sakitkepala = informasi and diagnosa = 'demam')
                where atribut = vatribut and iterasike = viterasike;
                ELSEIF vatribut = 'nyeri' THEN
                    UPDATE tblHitung SET diagnosademam = (select count(*) from tblc45 where nyeri = informasi and diagnosa = 'demam')
                    where atribut = vatribut and iterasike = viterasike;
                    ELSEIF vatribut = 'lemas' THEN
                        UPDATE tblHitung SET diagnosademam = (select count(*) from tblc45 where lemas = informasi and diagnosa = 'demam')
                        where atribut = vatribut and iterasike = viterasike;
                        ELSEIF vatribut = 'kelelahan' THEN
                            UPDATE tblHitung SET diagnosademam = (select count(*) from tblc45 where kelelahan = informasi and diagnosa = 'demam')
                            where atribut = vatribut and iterasike = viterasike;
                            ELSEIF vatribut = 'hidungtersumbat' THEN
                                UPDATE tblHitung SET diagnosademam = (select count(*) from tblc45 where hidungtersumbat = informasi and diagnosa = 'demam')
                                where atribut = vatribut and iterasike = viterasike;
                                ELSEIF vatribut = 'bersin' THEN
                                    UPDATE tblHitung SET diagnosademam = (select count(*) from tblc45 where bersin = informasi and diagnosa = 'demam')
                                    where atribut = vatribut and iterasike = viterasike;
                                    ELSEIF vatribut = 'sakittenggorokan' THEN
                                        UPDATE tblHitung SET diagnosademam = (select count(*) from tblc45 where sakittenggorokan = informasi and diagnosa = 'demam')
                                        where atribut = vatribut and iterasike = viterasike;
                                        ELSEIF vatribut = 'sulitbernafas' THEN
                                            UPDATE tblHitung SET diagnosademam = (select count(*) from tblc45 where sulitbernafas = informasi and diagnosa = 'demam')
                                            where atribut = vatribut and iterasike = viterasike;

            END IF;

            IF vatribut = 'demam' THEN
                UPDATE tblHitung SET diagnosaflu = (select count(*) from tblc45 where demam = informasi and diagnosa = 'flu')
                where atribut = vatribut and iterasike = viterasike;
            ELSEIF vatribut = 'sakitkepala' THEN
                UPDATE tblHitung SET diagnosaflu = (select count(*) from tblc45 where sakitkepala = informasi and diagnosa = 'flu')
                where atribut = vatribut and iterasike = viterasike;
                ELSEIF vatribut = 'nyeri' THEN
                    UPDATE tblHitung SET diagnosaflu = (select count(*) from tblc45 where nyeri = informasi and diagnosa = 'flu')
                    where atribut = vatribut and iterasike = viterasike;
                    ELSEIF vatribut = 'lemas' THEN
                        UPDATE tblHitung SET diagnosaflu = (select count(*) from tblc45 where lemas = informasi and diagnosa = 'flu')
                        where atribut = vatribut and iterasike = viterasike;
                        ELSEIF vatribut = 'kelelahan' THEN
                            UPDATE tblHitung SET diagnosaflu = (select count(*) from tblc45 where kelelahan = informasi and diagnosa = 'flu')
                            where atribut = vatribut and iterasike = viterasike;
                            ELSEIF vatribut = 'hidungtersumbat' THEN
                                UPDATE tblHitung SET diagnosaflu = (select count(*) from tblc45 where hidungtersumbat = informasi and diagnosa = 'flu')
                                where atribut = vatribut and iterasike = viterasike;
                                ELSEIF vatribut = 'bersin' THEN
                                    UPDATE tblHitung SET diagnosaflu = (select count(*) from tblc45 where bersin = informasi and diagnosa = 'flu')
                                    where atribut = vatribut and iterasike = viterasike;
                                    ELSEIF vatribut = 'sakittenggorokan' THEN
                                        UPDATE tblHitung SET diagnosaflu = (select count(*) from tblc45 where sakittenggorokan = informasi and diagnosa = 'flu')
                                        where atribut = vatribut and iterasike = viterasike;
                                        ELSEIF vatribut = 'sulitbernafas' THEN
                                            UPDATE tblHitung SET diagnosaflu = (select count(*) from tblc45 where sulitbernafas = informasi and diagnosa = 'flu')
                                            where atribut = vatribut and iterasike = viterasike;

            END IF;
        
        SET j = j + 1;
        END WHILE;
    CLOSE cHitung;
    SELECT * FROM tblHitung;

END ##
DELIMITER ; 
-- call spIterasi();

DELIMITER ##
CREATE PROCEDURE spEntropy()
BEGIN
            UPDATE tblHitung set entropy = (-(diagnosademam/jumlahdata) * log2(diagnosademam/jumlahdata)) +
            (-(diagnosaflu/jumlahdata) * log2(diagnosaflu/jumlahdata));

            UPDATE tblHitung set entropy = 0 where entropy is NULL;

    SELECT * FROM tblHitung;
END ##
DELIMITER ;
-- CALL spEntropy();


DELIMITER ##
CREATE PROCEDURE spGain()
BEGIN

    DROP TABLE IF EXISTS tblTampung;
    CREATE TEMPORARY table tblTampung
    (
    atribut VARCHAR(20), 
    gain decimal(8,4)
    ); 
    INSERT INTO tblTampung(atribut, gain)
    SELECT atribut, @entropy - SUM((jumlahdata/@jumlahdata) * entropy) AS GAIN
    FROM tblHitung
    GROUP BY atribut;
 
    SELECT * FROM tblTampung;
 
    UPDATE tblHitung SET GAIN =
	(
	    SELECT gain
	    FROM tblTampung 
	    WHERE atribut = tblHitung.atribut
	);
    SELECT * FROM tblHitung;

END ##
DELIMITER ;
-- call spGain();

DELIMITER ##
CREATE PROCEDURE spMax()
BEGIN

    SELECT atribut INTO @atribut
    FROM tblHitung
    WHERE gain = (SELECT MAX(gain) from tblHitung ) AND diagnosaflu != 0 and diagnosademam != 0;
 
    SELECT informasi INTO @informasi
    FROM tblHitung
    WHERE gain = (SELECT MAX(gain) from tblHitung ) AND diagnosaflu != 0 and diagnosademam != 0;
 
    INSERT INTO tblBaru(atribut_MAX, informasi_MAX) VALUES (@atribut, @informasi);
    
    -- UPDATE tblBaru set atribut = 'TIDAK ADA' where atribut is NULL;
    -- UPDATE tblBaru set informasi = 'TIDAK ADA' where informasi is NULL;

    SELECT * FROM tblBaru;
    SELECT * FROM tblHitung;
END ##
DELIMITER ;
-- CALL spMax();

DELIMITER ##
Create FUNCTION funcstop()
RETURNS INT
BEGIN
    DECLARE vLanjut ,vHitung int default 0;
    SELECT COUNT(*) INTO vHitung from tblHitung 
    where gain = (select max(gain) from tblHitung) and diagnosaflu != 0 and diagnosademam != 0;
    if vHitung = 0 then
        set vLanjut = 1;
    end if;
    return vLanjut;
END ##
DELIMITER ;


DELIMITER ##
CREATE PROCEDURE spLooping()
BEGIN
    DECLARE i int default 1; 
    DECLARE vLanjut int default 0; 
    while vLanjut = 0 do
        CALL spJum();
        CALL spIterasi(i);     
        CALL spEntropy();
        CALL spGain();
        CALL spMax();
        SET vLanjut = funcstop();
    end while;
END ##
DELIMITER ;
CALL spLooping();
