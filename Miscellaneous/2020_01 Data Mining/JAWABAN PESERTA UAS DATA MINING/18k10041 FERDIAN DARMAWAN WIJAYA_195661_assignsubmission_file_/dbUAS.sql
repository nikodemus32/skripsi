drop database if exists dbUAS;
create database dbUAS;
use dbUAS;

create table tblpenyakit(
    Pasien varchar(50),
    Deman varchar(10),
    Sakit_kepala varchar(10),
    Nyeri varchar(10),
    Lemas varchar(10),
    Kelelahan varchar(10),
    Hidung_tersumbat varchar(10),
    Bersin varchar(10),
    Sakit_tenggorokan varchar(10),
    Sulit_nafas varchar(10),
    Diagnosa varchar(10)
);

insert into tblPenyakit values
  ("P1", "Tidak", "Ringan", "Tidak", "Tidak", "Tidak", "Ringan", "Parah", "Parah", "Ringan", "Demam"),
  ("P2", "Parah", "Parah", "Parah", "Parah", "Parah", "Tidak", "Tidak", "Parah", "Parah", "Flu"),
  ("P3", "Parah", "Parah", "Ringan", "Parah", "Parah", "Parah", "Tidak", "Parah", "Parah", "Flu"),
  ("P4", "Tidak", "Tidak", "Tidak", "Ringan", "Tidak", "Parah", "Tidak", "Ringan", "Ringan", "Demam"),
  ("P5", "Parah", "Parah", "Ringan", "Parah", "Parah", "Parah", "Tidak", "Parah", "Parah", "Flu"),
  ("P6", "Tidak", "Tidak", "Tidak", "Ringan", "Tidak", "Parah", "Parah", "Parah", "Tidak", "Demam"),
  ("P7", "Parah", "Parah", "Parah", "Parah", "Parah", "Tidak", "Tidak", "Tidak", "Parah", "Flu"),
  ("P8", "Tidak", "Tidak", "Tidak", "Tidak", "Tidak", "Parah", "Parah", "Tidak", "Ringan", "Demam"),
  ("P9", "Tidak", "Ringan", "Ringan", "Tidak", "Tidak", "Parah", "Parah", "Parah", "Parah", "Demam"),
  ("P10", "Parah", "Parah", "Parah", "Ringan", "Ringan", "Tidak", "Parah", "Tidak", "Parah", "Flu"),
  ("P11", "Tidak", "Tidak", "Tidak", "Ringan", "Tidak", "Parah", "Ringan", "Parah", "Tidak", "Demam"),
  ("P12", "Parah", "Ringan", "Parah", "Ringan", "Parah", "Tidak", "Parah", "Tidak", "Ringan", "Flu"),
  ("P13", "Tidak", "Tidak", "Ringan", "Ringan", "Tidak", "Parah", "Parah", "Parah", "Tidak", "Demam"),
  ("P14", "Parah", "Parah", "Parah", "Parah", "Ringan", "Tidak", "Parah", "Parah", "Parah", "Flu"),
  ("P15", "Ringan", "Tidak", "Tidak", "Ringan", "Tidak", "Parah", "Tidak", "Parah", "Ringan", "Demam"),
  ("P16", "Tidak", "Tidak", "Tidak", "Tidak", "Tidak", "Parah", "Parah", "Parah", "Parah", "Demam"),
  ("P17", "Parah", "Ringan", "Parah", "Ringan", "Ringan", "Tidak", "Tidak", "Tidak", "Parah", "Flu");

create table tblcount(
  atribut varchar(20),
  informasi varchar(20),
  jumlahdata int,
  demam int,
  flu int,
  entropy decimal(8,4),
  gain decimal(8,4)
);

desc tblcount;

select count(*) into @jumlahdata from tblpenyakit;

select count(*) into @demam from tblpenyakit where diagnosa ='denan';

select count(*) into @flu from tblpenyakit where diagnosa ='flu';

select (-(@demam/@jumlahdata)* log2(@demam/@jumlahdata))
+
(-(@flu/@jumlahdata)* log2 (@flu/@jumlahdata)) into @entropy;

select @entropy;

select @jumlahdata as jumlahdata,
@demam as demam,
@flu as flu,
round(@entropy,4) as entropy;

insert into tblcount(atribute, jumlahdata, demam, flu, entropy)
values
('TOTAL DATA', @jumlahdata, @demam, @flu, @entropy);

insert into tblcount(informasi, jumlahdata, demam, flu)
    select A.Deman as demam, count(*) as jumlah_data,
    (
        select count(*)
        from tblpenyakit as B
        where B.diagnosa = 'demam' and B.deman=A.deman
    ) as 'demam',
    (
        select count(*)
        from tblpenyakit as C
        where C.diagnosa = 'flu' and C.deman=A.deman
    ) as 'flu'
    from tblpenyakit AS A
    group by A.deman;

update tblcount set atribute= 'Demam'
where atribute is NULL;

insert into tblcount(informasi, jumlahdata, demam, flu)
    select A.Sakit_kepala as sakit_kepala, count(*) as jumlah_data,
    (
        select count(*)
        from tblpenyakit as B
        where B.diagnosa = 'demam' and B.sakit_kepala=A.sakit_kepala
    ) as 'demam',
    (
        select count(*)
        from tblpenyakit as C
        where C.diagnosa = 'flu' and C.sakit_kepala=A.sakit_kepala
    ) as 'flu'
    from tblpenyakit AS A
    group by A.Sakit_kepala;

update tblcount set atribute= 'Sakit_kepala'
where atribute is NULL;

insert into tblcount(informasi, jumlahdata, demam, flu)
    select A.Nyeri as nyeri, count(*) as jumlah_data,
    (
        select count(*)
        from tblpenyakit as B
        where B.diagnosa = 'demam' and B.nyeri=A.nyeri
    ) as 'demam',
    (
        select count(*)
        from tblpenyakit as C
        where C.diagnosa = 'flu' and C.nyeri=A.nyeri
    ) as 'flu'
    from tblpenyakit AS A
    group by A.nyeri;

update tblcount set atribute= 'Nyeri'
where atribute is NULL;

insert into tblcount(informasi, jumlahdata, demam, flu)
    select A.Lemas as lemas, count(*) as jumlah_data,
    (
        select count(*)
        from tblpenyakit as B
        where B.diagnosa = 'demam' and B.lemas=A.lemas
    ) as 'demam',
    (
        select count(*)
        from tblpenyakit as C
        where C.diagnosa = 'flu' and C.lemas=A.lemas
    ) as 'flu'
    from tblpenyakit AS A
    group by A.lemas;

update tblcount set atribute= 'Lemas'
where atribute is NULL;

insert into tblcount(informasi, jumlahdata, demam, flu)
    select A.Kelelahan as kelelahan, count(*) as jumlah_data,
    (
        select count(*)
        from tblpenyakit as B
        where B.diagnosa = 'demam' and B.kelelahan=A.kelelahan
    ) as 'demam',
    (
        select count(*)
        from tblpenyakit as C
        where C.diagnosa = 'flu' and C.kelelahan=A.kelelahan
    ) as 'flu'
    from tblpenyakit AS A
    group by A.kelelahan;

update tblcount set atribute= 'Kelelahan'
where atribute is NULL;

DROP TABLE IF EXISTS tblTampung;
CREATE TEMPORARY TABLE tblTampung
(
atribut VARCHAR(20),
gain DECIMAL(8, 4)
);

INSERT INTO tblTampung(atribut, gain)
SELECT atribut, @entropy -
SUM((jumlahdata/@jumlahdata) * entropy) AS GAIN
FROM tblCount
GROUP BY atribut;

SELECT * FROM tblTampung;

UPDATE tblCount SET GAIN =
	(
	SELECT gain
	FROM tblTampung
	WHERE atribut = tblCount.atribut
	);

SELECT * FROM tblCount;
