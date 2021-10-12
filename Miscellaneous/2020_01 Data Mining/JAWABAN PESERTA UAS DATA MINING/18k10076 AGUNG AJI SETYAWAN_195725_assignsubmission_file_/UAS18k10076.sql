drop database if exists UASpakmarlon;
create database UASpakmarlon;
use UASpakmarlon;

create table tbldataC45
(
no varchar(10),
demam varchar(10),
sakitkepala varchar(10),
nyeri varchar(10),
lemas varchar(10),
kelelahan varchar(10),
hidungtersumbat varchar(10),
bersin varchar(10),
sakittenggorokan varchar(10),
sulitbernafas varchar(10),
diagnosa varchar(10)
);

insert into tbldataC45 values
('P1',	'Tidak',	'Ringan',	'Tidak',	'Tidak',	'Tidak',	'Ringan',	'Parah',	'Parah',	'Ringan',	'Demam'),
('P2',	'Parah',	'Parah',	'Parah',	'Parah',	'Parah',	'Tidak',	'Tidak',	'Parah',	'Parah',	'Flu'),
('P3',	'Parah',	'Parah',	'Ringan',	'Parah',	'Parah',	'Parah',	'Tidak',	'Parah',	'Parah',	'Flu'),
('P4',	'Tidak',	'Tidak',	'Tidak',	'Ringan',	'Tidak',	'Parah',	'Tidak',	'Ringan',	'Ringan',	'Demam'),
('P5',	'Parah',	'Parah',	'Ringan',	'Parah',	'Parah',	'Parah',	'Tidak',	'Parah',	'Parah',	'Flu'),
('P6',	'Tidak',	'Tidak',	'Tidak',	'Ringan',	'Tidak',	'Parah',	'Parah',	'Parah',	'Tidak',	'Demam'),
('P7',	'Parah',	'Parah',	'Parah',	'Parah',	'Parah',	'Tidak',	'Tidak',	'Tidak',	'Parah',	'Flu'),
('P8',	'Tidak',	'Tidak',	'Tidak',	'Tidak',	'Tidak',	'Parah',	'Parah',	'Tidak',	'Ringan',	'Demam'),
('P9',	'Tidak',	'Ringan',	'Ringan',	'Tidak',	'Tidak',	'Parah',	'Parah',	'Parah',	'Parah',	'Demam'),
('P10',	'Parah',	'Parah',	'Parah',	'Ringan',	'Ringan',	'Tidak',	'Parah',	'Tidak',	'Parah',	'Flu'),
('P11',	'Tidak',	'Tidak',	'Tidak',	'Ringan',	'Tidak',	'Parah',	'Ringan',	'Parah',	'Tidak',	'Demam'),
('P12',	'Parah',	'Ringan',	'Parah',	'Ringan',	'Parah',	'Tidak',	'Parah',	'Tidak',	'Ringan',	'Flu'),
('P13',	'Tidak',	'Tidak',	'Ringan',	'Ringan',	'Tidak',	'Parah',	'Parah',	'Parah',	'Tidak',	'Demam'),
('P14',	'Parah',	'Parah',	'Parah',	'Parah',	'Ringan',	'Tidak',	'Parah',	'Parah',	'Parah',	'Flu'),
('P15',	'Ringan',	'Tidak',	'Tidak',	'Ringan',	'Tidak',	'Parah',	'Tidak',	'Parah',	'Ringan',	'Demam'),
('P16',	'Tidak',	'Tidak',	'Tidak',	'Tidak',	'Tidak',	'Parah',	'Parah',	'Parah',	'Parah',	'Demam'),
('P17',	'Parah',	'Ringan',	'Parah',	'Ringan',	'Ringan',	'Tidak',	'Tidak',	'Tidak',	'Parah',	'Flu');

select * from tbldataC45;

create table tblhitungan
(
attribut varchar(20),
informasi varchar(20),
jumlahdata int,
demam int,
flu int,
entropy decimal(8,4),
gain decimal(8,4)
);

desc tblhitungan;

select count(*) into @jumlahdata
from tbldataC45;

select count(*) into @demam
from tbldataC45
where diagnosa = 'demam';

select count(*) into @flu
from tbldataC45
where diagnosa = 'flu';
select (-(@demam/@jumlahdata) * log2(@demam/@jumlahdata))
+
(-(@flu/@jumlahdata)*log2(@flu/@jumlahdata))
into @entropy;

select @jumlahdata as JML_DATA,
@demam as DEMAM,
@flu as FLU,
round(@entropy, 4) as ENTROPY;

insert into tblhitungan(attribut, jumlahdata, demam, flu, entropy) values
('total data', @jumlahdata, @demam, @flu, @entropy);

select * from tblhitungan;

/*langkah 3: melakukan proses untuk setiap attribut*/
/*outlook*/
insert into tblhitungan(informasi, jumlahdata, demam, flu)
	select  A.DEMAM as DEMAM, count(*) as jumlah_data,
		(
			select count(*)
			from tbldataC45 as B
			where B.DIAGNOSA = 'demam' and B.DEMAM = A.DEMAM
		) as 'DEMAM',
		
		(
			select count(*)
			from tbldataC45 as C
			where C.DIAGNOSA = 'flu' and C.DEMAM = A.DEMAM
		) as 'FLU'
		from tbldataC45 as A
		group by A.DEMAM;
		
		update tblhitungan set attribut = 'DEMAM' where attribut is null;
		
		/*temperature*/
		insert into tblhitungan(informasi, jumlahdata, demam, flu)
			select A.SAKITKEPALA as SAKITKEPALA, count(*) as jumlah_data,
				(
					select count(*)
					from tbldataC45 as B
					where B.DIAGNOSA = 'demam' and B.SAKITKEPALA = A.SAKITKEPALA
				) as 'DEMAM',
				
				(
					select count(*)
					from tbldataC45 as C
					where C.DIAGNOSA = 'demam' and C.SAKITKEPALA = A.SAKITKEPALA
				) as 'FLU'
				from tbldataC45 as A
				group by A.SAKITKEPALA;

update tblhitungan set attribut = 'SAKIT KEPALA' where attribut is null;

/*humadity*/
insert into tblhitungan(informasi, jumlahdata, demam, flu)
	select A.NYERI as NYERI, count(*) as jumlah_data,
		(
			select count(*)
			from tbldataC45 as B
			where B.DIAGNOSA = 'demam' and B.NYERI = A.NYERI
		) as 'DEMAM',
		
		(
			select count(*)
			from tbldataC45 as C
			where C.DIAGNOSA = 'flu' and C.NYERI = A.NYERI
		) as 'FLU'
		from tbldataC45 as A
		group by A.NYERI;

update tblhitungan set attribut = 'NYERI' where attribut is null;

/*windy*/
insert into tblhitungan(informasi, jumlahdata, demam, flu)
	select A.LEMAS as WINDY, count(*) as jumlah_data,
		(
			select count(*)
			from tbldataC45 as B
			where B.DIAGNOSA =  'demam' and  B.LEMAS = A.LEMAS
		) as 'DEMAM',
		
		(
			select count(*)
			from tbldataC45 as C
			where C.DIAGNOSA = 'flu' and C.LEMAS = A.LEMAS
		) as 'FLU'
		from tbldataC45 as A
		group by A.LEMAS;
		
update tblhitungan set attribut = 'LEMAS' where attribut is null;

insert into tblhitungan(informasi, jumlahdata, demam, flu)
	select A.KELELAHAN as KELELAHAN, count(*) as jumlah_data,
		(
			select count(*)
			from tbldataC45 as B
			where B.DIAGNOSA = 'demam' and B.KELELAHAN = A.KELELAHAN
		) as 'DEMAM',
		
		(
			select count(*)
			from tbldataC45 as C
			where C.DIAGNOSA = 'flu' and C.KELELAHAN = A.KELELAHAN
		) as 'FLU'
		from tbldataC45 as A
		group by A.KELELAHAN;

update tblhitungan set attribut = 'KELELAHAN' where attribut is null;

/*windy*/
insert into tblhitungan(informasi, jumlahdata, demam, flu)
	select A.HIDUNGTERSUMBAT as HIDUNGTERSUMBAT, count(*) as jumlah_data,
		(
			select count(*)
			from tbldataC45 as B
			where B.DIAGNOSA = 'DEMAM' and B.HIDUNGTERSUMBAT = A.HIDUNGTERSUMBAT
		) as 'DEMAM',
		
		(
			select count(*)
			from tbldataC45 as C
			where C.DIAGNOSA = 'FLU' and C.HIDUNGTERSUMBAT = A.HIDUNGTERSUMBAT
		) as 'FLU'
		from tbldataC45 as A
		group by A.HIDUNGTERSUMBAT;
		
update tblhitungan set attribut = 'HIDUNGTERSUMBAT' where attribut is null;

/*windy*/
insert into tblhitungan(informasi, jumlahdata, demam, flu)
	select A.BERSIN as BERSIN, count(*) as jumlah_data,
		(
			select count(*)
			from tbldataC45 as B
			where B.DIAGNOSA = 'demam' and B.BERSIN = A.BERSIN
		) as 'DEMAM',
		
		(
			select count(*)
			from tbldataC45 as C
			where C.DIAGNOSA = 'flu' and C.BERSIN = A.BERSIN
		) as 'FLU'
		from tbldataC45 as A 
		group by A.BERSIN;
		
update tblhitungan set attribut = 'BERSIN' where attribut is null;

/*windy*/
insert into tblhitungan(informasi, jumlahdata, demam, flu)
	select A.SAKITTENGGOROKAN as  SAKITTENGGOROKAN, count(*) as jumlah_data,
		(
			select count(*)
			from tbldataC45 as B 
			where B.DIAGNOSA = 'DEMAM' and B.SAKITTENGGOROKAN = A.SAKITTENGGOROKAN
		) as 'DEMAM',
		
		(
			select count(*)
			from tbldataC45 as C
			where C.DIAGNOSA = 'flu' and C.SAKITTENGGOROKAN = A.SAKITTENGGOROKAN
		) as 'FLU'
		from tbldataC45 as A
		group by A.SAKITTENGGOROKAN;

				