drop database if exists dbUAS;
create database dbUAS;
use dbUAS;

CREATE TABLE tblPasien
(
    pasien VARCHAR(20),
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

insert into tblPasien VALUES
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
("P13","Tidak","Tidak","Ringan","Ringan","Tidak","Parah","Parah","Parah","Tidak","Demam"),
("P14","Parah","Parah","Parah","Parah","Ringan","Tidak","Parah","Parah","Parah","Flu"),
("P15","Ringan","Tidak","Tidak","Ringan","Tidak","Parah","Tidak","Parah","Ringan","Demam"),
("P16","Tidak","Tidak","Tidak","Tidak","Tidak","Parah","Parah","Parah","Parah","Demam"),
("P17","Parah","Ringan","Parah","Ringan","Ringan","Tidak","Tidak","Tidak","Parah","Flu");

SELECT * FROM tblPasien;

/*LANGKAH 2*/
create table tblHitung
(
    atribut varchar(20),
    jumlahdata int,
    diagnosademam VARCHAR(20),
    diagnosaflu VARCHAR(20),
    entropy decimal(8,4),
    gain DECIMAL(8,4),
    gain_terbesar DECIMAL(8,4)
);

create table tblGejala
(
    Hasil VARCHAR(20),
    Gejalanya VARCHAR(20),
    Diagnosa VARCHAR(20)
);

desc tblHitung; 
DESC tblGejala;

select COUNT(*) into @jumlahdata
from tblPasien;

select COUNT(*) into @diagnosademam
from tblPasien
where diagnosa = "Demam";

select COUNT(*) into @diagnosaflu
from tblPasien
where diagnosa = "Flu";

SELECT (-(@diagnosademam/@jumlahdata) * log2(@diagnosademam/@jumlahdata)) 
+ (-(@diagnosaflu/@jumlahdata) * log2(@diagnosaflu/@jumlahdata))
into @entropy;

select @jumlahdata AS JumlahData,
@diagnosademam AS Demam,
@diagnosaflu AS Flu,
ROUND(@entropy, 4) as Entropy;

INSERT into tblHitung(atribut, jumlahdata, diagnosademam, diagnosaflu, entropy) VALUES 
("TOTAL DATA", @jumlahdata, @diagnosademam, @diagnosaflu, @entropy);

SELECT * FROM tblHitung;

/*menghitung entropy*/
UPDATE tblHitung SET entropy = (-(diagnosademam/jumlahdata) * log2(diagnosademam/jumlahdata))
+
(-(diagnosaflu/jumlahdata) * log2(diagnosaflu/jumlahdata));

UPDATE tblHitung SET entropy = 0 WHERE entropy is null;

select * from tblHitung;

/*menghitung nilai gain*/
DROP table if exists tblTampung;
CREATE TEMPORARY TABLE tblTampung
(
    atribut VARCHAR(20),
    gain DECIMAL(8,4),
    gain_terbesar DECIMAL(8,4)
);

INSERT into tblTampung(atribut, gain, gain_terbesar)
SELECT atribut, @entropy - SUM((jumlahdata/@jumlahdata) * entropy) AS Gain,  @entropy - SUM((jumlahdata/@jumlahdata) * entropy) AS gain_terbesar
FROM tblHitung
group by atribut;

UPDATE tblHitung SET GAIN = 
(
    SELECT gain
    from tblTampung
    where atribut = tblHitung.atribut
);

UPDATE tblHitung SET gain_terbesar = 
(
    SELECT gain_terbesar
    from tblTampung
    where atribut = tblHitung.atribut and @diagnosademam != 0 OR @diagnosaflu != 0
);
SELECT * FROM tblHitung;

DELIMITER ##
CREATE PROCEDURE spInsertDiagnosa(vHasil VARCHAR(20), vKeadaan VARCHAR(20), VDiagnosa VARCHAR(20))
BEGIN   
    DECLARE i INT DEFAULT 1;
    DECLARE X INT DEFAULT 0;
    DECLARE Y INT DEFAULT 0;

    while i <= vHasil DO
        SET X = FLOOR(RAND(vKeadaan));
        SET Y = FLOOR(RAND(VDiagnosa));
        INSERT INTO tblGejala VALUES (i, X, Y);
        SET i = i + 1;
    end WHILE;

    SELECT * FROM tblGejala;
END ##
DELIMITER ;

CALL spInsertDiagnosa("P1", "Parah", "Demam");