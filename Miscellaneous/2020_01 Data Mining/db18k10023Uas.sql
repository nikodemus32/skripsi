/*Lady Viona  18.K1.0023*/

DROP DATABASE IF EXISTS dbUas;
CREATE DATABASE dbUas;
USE dbUas;

CREATE TABLE tblSakit
(
    pasien varchar(20),
    demam varchar(20),
    sakitkepala varchar(20),
    nyeri varchar(20),
    lemas varchar(20),
    kelelahan varchar(20),
    hidungtersumbat varchar(20),
    bersin varchar(20),
    sakittenggorokan varchar(20),
    sulitbernafas varchar(20),
    diagnosa varchar(20)
);

insert INTO tblSakit values
('P1', 'Tidak','Ringan','Tidak','Tidak','Tidak', 'Ringan', 'Parah', 'Parah', 'Ringan', 'Demam'),
('P2', 'Parah','Parah','Parah','Parah','Parah', 'Tidak', 'Tidak', 'Parah', 'Parah', 'Flu'),
('P3', 'Parah','Parah','Ringan','Parah','Parah', 'Parah', 'Tidak', 'Parah', 'Parah', 'Flu'),
('P4', 'Tidak','Tidak','Tidak','Ringan','Tidak', 'Parah', 'Tidak', 'Ringan', 'Ringan', 'Demam'),
('P5', 'Parah','Parah','Ringan','Parah','Parah', 'Parah', 'Tidak', 'Parah', 'Parah', 'Flu'),
('P6', 'Tidak','Tidak','Tidak','Ringan','Tidak', 'Parah', 'Parah', 'Parah', 'Tidak', 'Demam'),
('P7', 'Parah','Parah','Parah','Parah','Parah', 'Tidak', 'Tidak', 'Tidak', 'Parah', 'Flu'),
('P8', 'Tidak','Tidak','Tidak','Tidak','Tidak', 'Parah', 'Parah', 'Tidak', 'Ringan', 'Demam'),
('P9', 'Tidak','Ringan','Ringan','Tidak','Tidak', 'Parah', 'Parah', 'Parah', 'Parah', 'Demam'),
('P10', 'Parah','Parah','Parah','Ringan','Ringan', 'Tidak', 'Parah', 'Tidak', 'Parah', 'Flu'),
('P11', 'Tidak','Tidak','Tidak','Ringan','Tidak', 'Parah', 'Ringan', 'Parah', 'Tidak', 'Demam'),
('P12', 'Parah','Ringan','Parah','Ringan','Parah', 'Tidak', 'Parah', 'Tidak', 'Ringan', 'Flu'),
('P13', 'Tidak','Tidak','Ringan','Ringan','Tidak', 'Parah', 'Parah', 'Parah', 'Tidak', 'Demam'),
('P14', 'Parah','Parah','Parah','Parah','Ringan', 'Tidak', 'Parah', 'Parah', 'Parah', 'Flu'),
('P15', 'Ringan','Tidak','Tidak','Ringan','Tidak', 'Parah', 'Tidak', 'Parah', 'Ringan', 'Demam'),
('P16', 'Tidak','Tidak','Tidak','Tidak','Tidak', 'Parah', 'Parah', 'Parah', 'Parah', 'Demam'),
('P17', 'Parah','Ringan','Parah','Ringan','Ringan', 'Tidak', 'Tidak', 'Tidak', 'Parah', 'Flu');

SELECT * FROM tblSakit;
CREATE table tblsatu
(
atribut VARCHAR(20),
informasi VARCHAR(20)
);

CREATE TABLE tblHitung
(
  iterasi int,
  atribut VARCHAR(20),
  informasi VARCHAR(20),
  jumlahdata INT,
  flu int,
  demam int,
  entropy DECIMAL(8,4),
  gain DECIMAL(8,4)
);

DELIMITER $$
CREATE PROCEDURE spData()
BEGIN

  SELECT COUNT(*) INTO @jumlahdata
  FROM tblSakit;

  SELECT COUNT(*) INTO @flu
  FROM tblSakit
  WHERE diagnosa = 'flu';

  SELECT COUNT(*) INTO @demam
  FROM tblSakit
  WHERE diagnosa = 'demam';

  SELECT (-(@flu/@jumlahdata) * log2(@flu/@jumlahdata))+
  (-(@demam/@jumlahdata)*log2(@demam/@jumlahdata))
  INTO @entropy;

  SELECT @jumlahdata AS JUM_DATA,
  @flu AS DIAGNOSA_FLU,
  @demam AS DIAGNOSA_DEMAM,
  ROUND(@entropy, 4) AS ENTROPY;

  set @iterasi = 1;
  INSERT INTO tblHitung(iterasi, atribut, jumlahdata, flu, demam, entropy) VALUES
  (@iterasi, 'TOTAL DATA', @jumlahdata, @flu, @demam, @entropy);

END $$
DELIMITER ;
-- CALL spData();

DELIMITER $$
CREATE PROCEDURE spIterasi()
BEGIN
    insert into tblHitung(informasi, jumlahdata, flu, demam)
    select A.demam as DEMAM, COUNT(*) as JUMLAH_DATA,
        (
          select count(*)
          from tblSakit as B
          where B.diagnosa='flu' and B.demam = A.demam
        ) as FLU,
        (
          select count(*)
          from tblSakit as C
          where C.diagnosa='demam' and C.demam = A.demam
        ) as DEMAM
        from tblSakit as A
        group by A.demam
        order by A.demam asc;
        update tblHitung set atribut = 'DEMAM' where atribut is NULL;
        update tblHitung SET iterasi = 1 WHERE iterasi IS NULL;
  select * from tblHitung;

  /*SAKIT KEPALA*/
  insert into tblHitung(informasi, jumlahdata, flu, demam)
  select A.sakitkepala as SAKITKEPALA, COUNT(*) as JUMLAH_DATA,
        (
          select count(*)
          from tblSakit as B
          where B.diagnosa='flu' and B.sakitkepala = A.sakitkepala
        ) as FLU,
        (
          select count(*)
          from tblSakit as C
          where C.diagnosa='demam' and C.sakitkepala = A.sakitkepala
        ) as DEMAM
        from tblSakit as A
        group by A.sakitkepala
        order by A.sakitkepala asc;
  update tblHitung set atribut = 'SAKITKEPALA' where atribut is NULL;
  update tblHitung SET iterasi = 1 WHERE iterasi IS NULL;
  select * from tblHitung;

  insert into tblHitung(informasi, jumlahdata, flu, demam)
  select A.nyeri as NYERI, COUNT(*) as JUMLAH_DATA,
        (
          select count(*)
          from tblSakit as B
          where B.diagnosa='flu' and B.nyeri = A.nyeri
        ) as FLU,
        (
          select count(*)
          from tblSakit as C
          where C.diagnosa='demam' and C.nyeri = A.nyeri
        ) as DEMAM
        from tblSakit as A
        group by A.nyeri
        order by A.nyeri asc;
  update tblHitung set atribut = 'NYERI' where atribut is NULL;
  update tblHitung SET iterasi = 1 WHERE iterasi IS NULL;
  select * from tblHitung;

  insert into tblHitung(informasi, jumlahdata, flu, demam)
  select A.lemas as LEMAS, COUNT(*) as JUMLAH_DATA,
        (
          select count(*)
          from tblSakit as B
          where B.diagnosa='flu' and B.lemas = A.lemas
        ) as FLU,
        (
          select count(*)
          from tblSakit as C
          where C.diagnosa='demam' and C.lemas = A.lemas
        ) as DEMAM
        from tblSakit as A
        group by A.lemas
        order by A.lemas asc;
  update tblHitung set atribut = 'LEMAS' where atribut is NULL;
  update tblHitung SET iterasi = 1 WHERE iterasi IS NULL;
  select * from tblHitung;

  insert into tblHitung(informasi, jumlahdata, flu, demam)
  select A.kelelahan as KELELAHAN, COUNT(*) as JUMLAH_DATA,
        (
          select count(*)
          from tblSakit as B
          where B.diagnosa='flu' and B.kelelahan = A.kelelahan
        ) as FLU,
        (
          select count(*)
          from tblSakit as C
          where C.diagnosa='demam' and C.kelelahan = A.kelelahan
        ) as DEMAM
        from tblSakit as A
        group by A.kelelahan
        order by A.kelelahan asc;
  update tblHitung set atribut = 'KELELAHAN' where atribut is NULL;
  update tblHitung SET iterasi = 1 WHERE iterasi IS NULL;
  select * from tblHitung;

  insert into tblHitung(informasi, jumlahdata, flu, demam)
  select A.hidungtersumbat as HIDUNG_TERSUMBAT, COUNT(*) as JUMLAH_DATA,
        (
          select count(*)
          from tblSakit as B
          where B.diagnosa='flu' and B.hidungtersumbat = A.hidungtersumbat
        ) as FLU,
        (
          select count(*)
          from tblSakit as C
          where C.diagnosa='demam' and C.hidungtersumbat = A.hidungtersumbat
        ) as DEMAM
        from tblSakit as A
        group by A.hidungtersumbat
        order by A.hidungtersumbat asc;
  update tblHitung set atribut = 'HIDUNG_TERSUMBAT' where atribut is NULL;
  update tblHitung SET iterasi = 1 WHERE iterasi IS NULL;
  select * from tblHitung;

  insert into tblHitung(informasi, jumlahdata, flu, demam)
  select A.bersin as HIDUNG_TERSUMBAT, COUNT(*) as JUMLAH_DATA,
        (
          select count(*)
          from tblSakit as B
          where B.diagnosa='flu' and B.bersin = A.bersin
        ) as FLU,
        (
          select count(*)
          from tblSakit as C
          where C.diagnosa='demam' and C.bersin = A.bersin
        ) as DEMAM
        from tblSakit as A
        group by A.bersin
        order by A.bersin asc;
  update tblHitung set atribut = 'BERSIN' where atribut is NULL;
  update tblHitung SET iterasi = 1 WHERE iterasi IS NULL;
  select * from tblHitung;

  insert into tblHitung(informasi, jumlahdata, flu, demam)
  select A.sakittenggorokan as SAKIT_TENGGOROKAN, COUNT(*) as JUMLAH_DATA,
        (
          select count(*)
          from tblSakit as B
          where B.diagnosa='flu' and B.sakittenggorokan = A.sakittenggorokan
        ) as FLU,
        (
          select count(*)
          from tblSakit as C
          where C.diagnosa='demam' and C.sakittenggorokan = A.sakittenggorokan
        ) as DEMAM
        from tblSakit as A
        group by A.sakittenggorokan
        order by A.sakittenggorokan asc;
  update tblHitung set atribut = 'SAKIT_TENGGOROKAN' where atribut is NULL;
  update tblHitung SET iterasi = 1 WHERE iterasi IS NULL;
  select * from tblHitung;

  insert into tblHitung(informasi, jumlahdata, flu, demam)
  select A.sulitbernafas as SULIT_BERNAFAS, COUNT(*) as JUMLAH_DATA,
        (
          select count(*)
          from tblSakit as B
          where B.diagnosa='flu' and B.sulitbernafas = A.sulitbernafas
        ) as FLU,
        (
          select count(*)
          from tblSakit as C
          where C.diagnosa='demam' and C.sulitbernafas = A.sulitbernafas
        ) as DEMAM
        from tblSakit as A
        group by A.sulitbernafas
        order by A.sulitbernafas asc;
  update tblHitung set atribut = 'SULIT_BERNAFAS' where atribut is NULL;
  update tblHitung SET iterasi = 1 WHERE iterasi IS NULL;
  select * from tblHitung;

END $$
DELIMITER ;
-- CALL spIterasi();

DELIMITER $$
CREATE PROCEDURE spHitEntrop()
BEGIN
    update tblHitung SET entropy =
    (-(flu/jumlahdata)*log2(flu/jumlahdata)) +
    (-(demam/jumlahdata)*log2(demam/jumlahdata))
    where demam !=0 and flu!=0;

    update tblHitung SET entropy = 0 WHERE entropy IS NULL;

    select * from tblHitung;

END $$
DELIMITER ;
-- CALL spHitEntrop();


DELIMITER $$
CREATE PROCEDURE spHitG()
BEGIN

    DROP TABLE IF EXISTS tblTampung;
    CREATE TEMPORARY table tblTampung
    (
    atribut VARCHAR(20),
    gain double
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
  select * from tblHitung;

END $$
DELIMITER ;
-- CALL spHitG();

DELIMITER $$
CREATE PROCEDURE spNew()
BEGIN

    SELECT atribut INTO @dataatribut
    FROM tblHitung
    WHERE gain = (SELECT MAX(gain) from tblHitung )
    AND flu != 0 AND demam != 0;

    SELECT informasi INTO @datainformasi
    FROM tblHitung
    WHERE gain = (SELECT MAX(gain) from tblHitung )
    AND flu != 0 AND demam != 0;

    SELECT @dataatribut as at, @datainformasi as inf;

    INSERT INTO tblsatu(atribut, informasi)
    VALUES (@dataatribut, @datainformasi);
    SELECT * FROM tblsatu;

END $$
DELIMITER ;
-- CALL spNew();

DELIMITER $$
CREATE PROCEDURE spLooping()
BEGIN
    DECLARE i int default 0;
    DECLARE vStop INT default 1;

    while vStop <> 0 do
        CALL spData();
        CALL spIterasi();
        CALL spHitEntrop();
        CALL spHitG();
        CALL spNew();
        IF (SELECT COUNT(*) FROM tblsatu) is null or (SELECT COUNT(*) FROM tblsatu) =0 THEN
          SET vStop=0;
        END IF;
    end while;
END $$
DELIMITER ;
CALL spLooping();
