drop database if exists dbUASC45;
create database dbUASC45;
use dbUASC45;

create table tblC45
(
  no varchar(10),
  Demam varchar(10),
  Sakit_Kepala varchar(10),
  Nyeri varchar(10),
  Lemas varchar(10),
  Kelelahan varchar(10),
  Hidung_Tersumbat varchar(10),
  Bersin varchar(10),
  Sakit_Tenggorokan varchar(10),
  Sulit_Bernafas varchar(10),
  Diagnosa varchar(10)
);

insert into tblC45 VALUES
('P1', 'Tidak', 'Ringan', 'Tidak', 'Tidak', 'Tidak', 'Ringan', 'Parah', 'Parah', 'Ringan', 'Demam'),
('P2', 'Parah', 'Parah', 'Parah', 'Parah', 'Parah', 'Tidak', 'Tidak', 'Parah', 'Parah', 'Flu'),
('P3', 'Parah', 'Parah', 'Ringan', 'Parah', 'Parah', 'Parah', 'Tidak', 'Parah', 'Parah', 'Flu'),
('P4', 'Tidak', 'Tidak', 'Tidak', 'Ringan', 'Tidak', 'Parah', 'Tidak', 'Ringan', 'Ringan', 'Demam'),
('P5', 'Parah', 'Parah', 'Ringan', 'Parah', 'Parah', 'Parah', 'Tidak', 'Parah', 'Parah', 'Flu'),
('P6', 'Tidak', 'Tidak', 'Tidak', 'Ringan', 'Tidak', 'Parah', 'Parah', 'Parah', 'Tidak', 'Demam'),
('P7', 'Parah', 'Parah', 'Parah', 'Parah', 'Parah', 'Tidak', 'Tidak', 'Tidak', 'Parah', 'Flu'),
('P8', 'Tidak', 'Tidak', 'Tidak', 'Tidak', 'Tidak', 'Parah', 'Parah', 'Tidak', 'Ringan', 'Demam'),
('P9', 'Tidak', 'Ringan', 'Ringan', 'Tidak', 'Tidak', 'Parah', 'Parah', 'Parah', 'Parah', 'Demam'),
('P10', 'Parah', 'Parah', 'Parah', 'Ringan', 'Ringan', 'Tidak', 'Parah', 'Tidak', 'Parah', 'Flu'),
('P11', 'Tidak', 'Tidak', 'Tidak', 'Ringan', 'Tidak', 'Parah', 'Ringan', 'Parah', 'Tidak', 'Demam'),
('P12', 'Parah', 'Ringan', 'Parah', 'Ringan', 'Parah', 'Tidak', 'Parah', 'Tidak', 'Ringan', 'Flu'),
('P13', 'Tidak', 'Tidak', 'Ringan', 'Ringan', 'Tidak', 'Parah', 'Parah', 'Parah', 'Tidak', 'Demam'),
('P14', 'Parah', 'Parah', 'Parah', 'Parah', 'Ringan', 'Tidak', 'Parah', 'Parah', 'Parah', 'Flu'),
('P15', 'Ringan', 'Tidak', 'Tidak', 'Ringan', 'Tidak', 'Parah', 'Tidak', 'Parah', 'Ringan', 'Demam'),
('P16', 'Tidak', 'Tidak', 'Tidak', 'Tidak', 'Tidak', 'Parah', 'Parah', 'Parah', 'Parah', 'Demam'),
('P17', 'Parah', 'Ringan', 'Parah', 'Ringan', 'Ringan', 'Tidak', 'Tidak', 'Tidak', 'Parah', 'Flu');
select * from tblC45;

create table tblHitung
  (
    atribut VARCHAR(20),
    informasi VARCHAR(20),
    jumlahdata INT,
    diagnosa_demam INT,
    diagnosa_flu INT,
    entropy DECIMAL(8,4),
    gain DECIMAL(8,4)
  );

  desc tblHitung;

  select count(*) into @jumlahdata
  from tblC45;

  select count(*) into @diagnosa_demam
  from tblC45
  where Diagnosa = 'Demam';

  select count(*) into @diagnosa_flu
  from tblC45
  where Diagnosa = 'Flu';

select (-(@diagnosa_demam/@jumlahdata) * log2(@diagnosa_demam/@jumlahdata))
+
(-(@diagnosa_flu/@jumlahdata)*log2(@diagnosa_flu/@jumlahdata))
INTO @entropy;

select @jumlahdata AS JUM_DATA,
@diagnosa_demam AS Sakit_Demam,
@diagnosa_flu AS Sakit_Flu,
ROUND(@entropy, 4) AS ENTROPY;

insert into tblHitung(atribut, jumlahdata, diagnosa_demam, diagnosa_flu, entropy) VALUES
('TOTAL DATA interasi 1', @jumlahdata, @diagnosa_demam, @diagnosa_flu, @entropy);

select * from tblHitung;

/*Demam*/
insert into tblHitung(informasi, jumlahdata, diagnosa_demam, diagnosa_flu)
	select A.Demam AS DEMAM, COUNT(*) AS JUMLAH_DATA,
	(
		select COUNT(*)
		from tblC45 AS B
		where B.Diagnosa = 'Demam' AND B.Demam = A.Demam
  ) AS 'DEMAM',

	(
		select COUNT(*)
		from tblC45 AS C
		where C.Diagnosa = 'Flu' AND C.Demam = A.Demam
  ) AS 'FLU'
	 from tblC45 AS A
	 GROUP BY A.Demam;

update tblHitung SET atribut = 'DEMAM' where atribut is NULL;

/*Sakit Kepala*/
insert into tblHitung(informasi, jumlahdata, diagnosa_demam, diagnosa_flu)
	select A.Sakit_Kepala AS SAKITKEPALA, COUNT(*) AS JUMLAH_DATA,
	(
		select COUNT(*)
		from tblC45 AS B
		where B.Diagnosa = 'Demam' AND B.Sakit_Kepala = A.Sakit_Kepala
  ) AS 'DEMAM',

	(
		select COUNT(*)
		from tblC45 AS C
		where C.Diagnosa = 'Flu' AND C.Sakit_Kepala = A.Sakit_Kepala
  ) AS 'FLU'
	 from tblC45 AS A
	 GROUP BY A.Sakit_Kepala;

update tblHitung SET atribut = 'SAKITKEPALA' where atribut is NULL;

/*Nyeri*/
insert into tblHitung(informasi, jumlahdata, diagnosa_demam, diagnosa_flu)
	select A.Nyeri AS NYERI, COUNT(*) AS JUMLAH_DATA,
	(
		select COUNT(*)
		from tblC45 AS B
		where B.Diagnosa = 'Demam' AND B.Nyeri = A.Nyeri
  ) AS 'DEMAM',

	(
		select COUNT(*)
		from tblC45 AS C
		where C.Diagnosa = 'Flu' AND C.Nyeri = A.Nyeri
  ) AS 'FLU'
	 from tblC45 AS A
	 GROUP BY A.Nyeri;

update tblHitung SET atribut = 'NYERI' where atribut is NULL;
/*Lemas*/
insert into tblHitung(informasi, jumlahdata, diagnosa_demam, diagnosa_flu)
	select A.Lemas AS LEMAS, COUNT(*) AS JUMLAH_DATA,
	(
		select COUNT(*)
		from tblC45 AS B
		where B.Diagnosa = 'Demam' AND B.Lemas = A.Lemas
  ) AS 'DEMAM',

	(
		select COUNT(*)
		from tblC45 AS C
		where C.Diagnosa = 'Flu' AND C.Lemas = A.Lemas
  ) AS 'FLU'
	 from tblC45 AS A
	 GROUP BY A.Lemas;

update tblHitung SET atribut = 'LEMAS' where atribut is NULL;
/*kelelahan*/
insert into tblHitung(informasi, jumlahdata, diagnosa_demam, diagnosa_flu)
	select A.Kelelahan AS KELELAHAN, COUNT(*) AS JUMLAH_DATA,
	(
		select COUNT(*)
		from tblC45 AS B
		where B.Diagnosa = 'Demam' AND B.Kelelahan = A.Kelelahan
  ) AS 'DEMAM',

	(
		select COUNT(*)
		from tblC45 AS C
		where C.Diagnosa = 'Flu' AND C.Kelelahan = A.Kelelahan
  ) AS 'FLU'
	 from tblC45 AS A
	 GROUP BY A.Kelelahan;

update tblHitung SET atribut = 'KELELAHAN' where atribut is NULL;
/*hidung tersumbat*/
insert into tblHitung(informasi, jumlahdata, diagnosa_demam, diagnosa_flu)
	select A.Hidung_Tersumbat AS HIDUNGTERSUMBAT, COUNT(*) AS JUMLAH_DATA,
	(
		select COUNT(*)
		from tblC45 AS B
		where B.Diagnosa = 'Demam' AND B.Hidung_Tersumbat = A.Hidung_Tersumbat
  ) AS 'DEMAM',

	(
		select COUNT(*)
		from tblC45 AS C
		where C.Diagnosa = 'Flu' AND C.Hidung_Tersumbat = A.Hidung_Tersumbat
  ) AS 'FLU'
	 from tblC45 AS A
	 GROUP BY A.Hidung_Tersumbat;

update tblHitung SET atribut = 'HIDUNGTERSUMBAT' where atribut is NULL;
/*bersin*/
insert into tblHitung(informasi, jumlahdata, diagnosa_demam, diagnosa_flu)
	select A.Bersin AS BERSIN, COUNT(*) AS JUMLAH_DATA,
	(
		select COUNT(*)
		from tblC45 AS B
		where B.Diagnosa = 'Demam' AND B.Bersin = A.Bersin
  ) AS 'DEMAM',

	(
		select COUNT(*)
		from tblC45 AS C
		where C.Diagnosa = 'Flu' AND C.Bersin = A.Bersin
  ) AS 'FLU'
	 from tblC45 AS A
	 GROUP BY A.Bersin;

update tblHitung SET atribut = 'BERSIN' where atribut is NULL;
/*sakit tenggorokan*/
insert into tblHitung(informasi, jumlahdata, diagnosa_demam, diagnosa_flu)
	select A.Sakit_Tenggorokan AS SAKITTENGGOROKAN, COUNT(*) AS JUMLAH_DATA,
	(
		select COUNT(*)
		from tblC45 AS B
		where B.Diagnosa = 'Demam' AND B.Sakit_Tenggorokan = A.Sakit_Tenggorokan
  ) AS 'DEMAM',

	(
		select COUNT(*)
		from tblC45 AS C
		where C.Diagnosa = 'Flu' AND C.Sakit_Tenggorokan = A.Sakit_Tenggorokan
  ) AS 'FLU'
	 from tblC45 AS A
	 GROUP BY A.Sakit_Tenggorokan;

update tblHitung SET atribut = 'SAKITTENGGOROKAN' where atribut is NULL;
/*sulit bernafas*/
insert into tblHitung(informasi, jumlahdata, diagnosa_demam, diagnosa_flu)
	select A.Sulit_Bernafas AS SULITBERNAFAS, COUNT(*) AS JUMLAH_DATA,
	(
		select COUNT(*)
		from tblC45 AS B
		where B.Diagnosa = 'Demam' AND B.Sulit_Bernafas = A.Sulit_Bernafas
  ) AS 'DEMAM',

	(
		select COUNT(*)
		from tblC45 AS C
		where C.Diagnosa = 'Flu' AND C.Sulit_Bernafas = A.Sulit_Bernafas
  ) AS 'FLU'
	 from tblC45 AS A
	 GROUP BY A.Sulit_Bernafas;

update tblHitung SET atribut = 'SULITBERNAFAS' where atribut is NULL;

/*menghitung entropy*/
update tblHitung SET entropy = (-(diagnosa_demam/jumlahdata) * log2(diagnosa_demam/jumlahdata))
+
(-(diagnosa_flu/jumlahdata) * log2(diagnosa_flu/jumlahdata));

update tblHItung SET entropy = 0 where entropy is NULL;
select * from tblHitung;

/*menghitung gain*/
drop table if exists tblTampung;
create temporary table tblTampung
(
atribut VARCHAR(20),
gain DECIMAL(9, 4)
);

insert into tblTampung(atribut, gain)
select atribut, @entropy -
SUM((jumlahdata/@jumlahdata) * entropy) AS GAIN
from tblHitung
GROUP BY atribut;

select * from tblTampung;

update tblHitung SET GAIN =
	(
	select gain
	from tblTampung
	where atribut = tblHitung.atribut
	);

select * from tblHitung;
