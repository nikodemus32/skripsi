drop database if exists dbuasc45;
create database dbuasc45;
	use dbuasc45;

	create table tbldiagnosa(
		pasien varchar(3),
		flu varchar(10),
		demam varchar(10),
		nyeri varchar(10),
		lemas varchar(10),
		kelelahan varchar(10),
		hidungtrsmbt varchar(10),
		bersin varchar(10),
		sakittenggorokan varchar(10),
		sltbernafas varchar(10),
		diagnosa varchar(10)
		);

	create table tblHitung
		(
			atribut varchar(20),
			informasi varchar(20),
			jumlah int,
			demam int,
			flu int,
			entropy decimal(8,4),
			gain decimal(8,4)
		);

	create table tblHitung1
		(
			iterasi int,
			atribut varchar(20),
			informasi varchar(20),
			jumlah int,
			demam int,
			flu int,
			entropy decimal(8,4),
			gain decimal(8,4)
		);
		


	insert into tbldiagnosa values
		('P1','Tidak',	'Ringan',	'Tidak', 'Tidak',	'Tidak',	'Ringan',	'Parah',	'Parah',	'Ringan',	'Demam'),
		('P2','Parah',	'Parah',	'Parah',	'Parah',	'Parah',	'Tidak',	'Tidak',	'Parah',	'Parah',	'Flu'),
		('P3','Parah',	'Parah',	'Ringan',	'Parah',	'Parah',	'Parah',	'Tidak',	'Parah',	'Parah',	'Flu'),
		('P4','Tidak',	'Tidak',	'Tidak',	'Ringan',	'Tidak',	'Parah',	'Tidak',	'Ringan',	'Ringan',	'Demam'),
		('P5','Parah',	'Parah',	'Ringan',	'Parah',	'Parah',	'Parah',	'Tidak',	'Parah',	'Parah',	'Flu'),
		('P6','Tidak',	'Tidak',	'Tidak',	'Ringan',	'Tidak',	'Parah',	'Parah',	'Parah',	'Tidak',	'Demam'),
		('P7','Parah',	'Parah',	'Parah',	'Parah',	'Parah',	'Tidak',	'Tidak',	'Tidak',	'Parah',	'Flu'),
		('P8','Tidak',	'Tidak',	'Tidak',	'Tidak',	'Tidak',	'Parah',	'Parah',	'Tidak',	'Ringan',	'Demam'),
		('P9','Tidak',	'Ringan',	'Ringan',	'Tidak',    'Tidak',	'Parah',	'Parah',	'Parah',	'Parah',	'Demam'),
		('P10','Parah',	'Parah',	'Parah',	'Ringan',	'Ringan',	'Tidak',	'Parah',	'Tidak',	'Parah',	'Flu'),
		('P11','Tidak',	'Tidak',	'Tidak',	'Ringan',	'Tidak',	'Parah',	'Ringan',	'Parah',	'Tidak',	'Demam'),
		('P12','Parah',	'Ringan',	'Parah',	'Ringan',	'Parah',	'Tidak',	'Parah',	'Tidak',	'Ringan',	'Flu'),
		('P13','Tidak',	'Tidak',	'Ringan',	'Ringan',	'Tidak',	'Parah',	'Parah',	'Parah',	'Tidak',	'Demam'),
		('P14','Parah',	'Parah',	'Parah',	'Parah',	'Ringan',	'Tidak',	'Parah',	'Parah',	'Parah',	'Flu'),
		('P15','Ringan',	'Tidak',	'Tidak',	'Ringan',	'Tidak',	'Parah',	'Tidak',	'Parah',	'Ringan',	'Demam'),
		('P16','Tidak',	'Tidak',	'Tidak',	'Tidak',	'Tidak',	'Parah',	'Parah',	'Parah',	'Parah',	'Demam'),
		('P17','Parah',	'Ringan',	'Parah',	'Ringan',	'Ringan',	'Tidak',	'Tidak',	'Tidak',	'Parah',	'Flu');
	
	select * from tbldiagnosa;

		select @jumlahdata := count(*)
		from tbldiagnosa;

		select @demam := count(*)
		from tbldiagnosa
		where diagnosa = "Demam";

		select @flu := count(*)
		from tbldiagnosa
		where diagnosa = 'Flu';

		delimiter $$
		create function sfEntrophy(jumlahdata int, demam int, flu int)
		returns decimal(8,4)
		begin
			declare i decimal(8,4);
			set i = (-(demam/jumlahdata) * log2(demam/jumlahdata)) + (-(flu/jumlahdata) * log2(flu/jumlahdata));
			return (abs(i));
		end $$
		delimiter ;

		select @entropy := (-(@demam/@jumlahdata) * 
			log2(@demam/@jumlahdata))  +
			(-(@flu/@jumlahdata)*log2(@flu/@jumlahdata))
			as entropy;

		select @jumlahdata as Jum_Data,
		@demam as Diagnosa_demam,
		@flu as diagnosa_flu,
		ROUND(@entropy, 4) as entropy;


		insert into tblHitung(atribut, jumlah, demam, flu, entropy) VALUES
			("Total Data", @jumlahdata, @demam, @flu, @entropy);
		

		select * from tblHitung;

		/*langkah 3 lakukan proses untuk setiap atribut*/
		/*flu*/
		insert into tblHitung(informasi, jumlah, demam, flu)
			select a.flu, count(*) as Jumlah_Data,
				(
					SELECT COUNT(*)
					from tbldiagnosa as b
					where b.diagnosa='Demam' AND b.flu = a.flu
				) as 'demam',
				(
					SELECT COUNT(*)
					from tbldiagnosa as c 
					where c.diagnosa='Flu' AND c.flu = a.flu
				) as 'flu'
			from tbldiagnosa as a
			group by a.flu;

			update tblHitung set atribut = "flu" where atribut is NULL;


			/*demam*/
			insert into tblHitung(informasi, jumlah, demam, flu)
			select a.demam, count(*) as Jumlah_Data,
				(
					SELECT COUNT(*)
					from tbldiagnosa as b
					where b.diagnosa='Demam' AND b.demam = a.demam
				) as 'demam',
				(
					SELECT COUNT(*)
					from tbldiagnosa as c 
					where c.diagnosa='Flu' AND c.demam = a.demam
				) as 'flu'
			from tbldiagnosa as a
			group by a.demam;

			update tblHitung set atribut = "demam" where atribut is NULL;

		/*nyeri*/
		insert into tblHitung(informasi, jumlah, demam, flu)
			select a.nyeri, count(*) as Jumlah_Data,
				(
					SELECT COUNT(*)
					from tbldiagnosa as b
					where b.diagnosa='Demam' AND b.nyeri = a.nyeri
				) as 'demam',
				(
					SELECT COUNT(*)
					from tbldiagnosa as c 
					where c.diagnosa='Flu' AND c.nyeri = a.nyeri
				) as 'flu'
			from tbldiagnosa as a
			group by a.nyeri;

			update tblHitung set atribut = "nyeri" where atribut is NULL;

		/*lemas*/		
		insert into tblHitung(informasi, jumlah, demam, flu)
			select a.lemas, count(*) as Jumlah_Data,
				(
					SELECT COUNT(*)
					from tbldiagnosa as b
					where b.diagnosa='Demam' AND b.lemas = a.lemas
				) as 'demam',
				(
					SELECT COUNT(*)
					from tbldiagnosa as c 
					where c.diagnosa='Flu' AND c.lemas = a.lemas
				) as 'flu'
			from tbldiagnosa as a
			group by a.lemas;

			update tblHitung set atribut = "lemas" where atribut is NULL;

		/*kelelahan*/
		insert into tblHitung(informasi, jumlah, demam, flu)
			select a.kelelahan, count(*) as Jumlah_Data,
				(
					SELECT COUNT(*)
					from tbldiagnosa as b
					where b.diagnosa='Demam' AND b.kelelahan = a.kelelahan
				) as 'demam',
				(
					SELECT COUNT(*)
					from tbldiagnosa as c 
					where c.diagnosa='Flu' AND c.kelelahan = a.kelelahan
				) as 'flu'
			from tbldiagnosa as a
			group by a.kelelahan;

			update tblHitung set atribut = "kelelahan" where atribut is NULL;

		/*hidungtrsmbt*/
		insert into tblHitung(informasi, jumlah, demam, flu)
			select a.hidungtrsmbt, count(*) as Jumlah_Data,
				(
					SELECT COUNT(*)
					from tbldiagnosa as b
					where b.diagnosa='Demam' AND b.hidungtrsmbt = a.hidungtrsmbt
				) as 'demam',
				(
					SELECT COUNT(*)
					from tbldiagnosa as c 
					where c.diagnosa='Flu' AND c.hidungtrsmbt = a.hidungtrsmbt
				) as 'flu'
			from tbldiagnosa as a
			group by a.hidungtrsmbt;

			update tblHitung set atribut = "hidungtrsmbt" where atribut is NULL;

		/*bersin*/
		insert into tblHitung(informasi, jumlah, demam, flu)
			select a.bersin, count(*) as Jumlah_Data,
				(
					SELECT COUNT(*)
					from tbldiagnosa as b
					where b.diagnosa='Demam' AND b.bersin = a.bersin
				) as 'demam',
				(
					SELECT COUNT(*)
					from tbldiagnosa as c 
					where c.diagnosa='Flu' AND c.bersin = a.bersin
				) as 'flu'
			from tbldiagnosa as a
			group by a.bersin;

			update tblHitung set atribut = "bersin" where atribut is NULL;

		/*sakittenggorokan*/
		insert into tblHitung(informasi, jumlah, demam, flu)
			select a.sakittenggorokan, count(*) as Jumlah_Data,
				(
					SELECT COUNT(*)
					from tbldiagnosa as b
					where b.diagnosa='Demam' AND b.sakittenggorokan = a.sakittenggorokan
				) as 'demam',
				(
					SELECT COUNT(*)
					from tbldiagnosa as c 
					where c.diagnosa='Flu' AND c.sakittenggorokan = a.sakittenggorokan
				) as 'flu'
			from tbldiagnosa as a
			group by a.sakittenggorokan;

			update tblHitung set atribut = "sakittenggorokan" where atribut is NULL;

		/*sltbernafas*/
		insert into tblHitung(informasi, jumlah, demam, flu)
			select a.sltbernafas, count(*) as Jumlah_Data,
				(
					SELECT COUNT(*)
					from tbldiagnosa as b
					where b.diagnosa='Demam' AND b.sltbernafas = a.sltbernafas
				) as 'demam',
				(
					SELECT COUNT(*)
					from tbldiagnosa as c 
					where c.diagnosa='Flu' AND c.sltbernafas = a.sltbernafas
				) as 'flu'
			from tbldiagnosa as a
			group by a.sltbernafas;

			update tblHitung set atribut = "sltbernafas" where atribut is NULL;

			update tblHitung set entropy = sfEntrophy(jumlah,demam,flu);

			update tblHitung set entropy = 0 Where entropy is NULL;

			select * from tblHitung;

			drop table if exists tblTampung;
			create temporary table tblTampung
				(
					atribut varchar(20),
					gain double
				);

			insert into tblTampung(atribut, gain)
			select atribut, @entropy - 
			SUM((jumlah/@jumlahdata) * entropy) as Gain
			from tblHitung
			group by atribut;

			update tblHitung set gain =
				(
					select gain
					from tblTampung
					where atribut = tblHitung.atribut
				);

			select * from tblHitung;

			drop table if exists tblTampung2;
			create temporary table tblTampung2
				(
					
					atribut varchar(20),
					informasi varchar(20),
					jumlah int,
					demam int,
					flu int,
					entropy decimal(8,4),
					gain decimal(8,4)
				);
			insert into tblTampung2
				(select * from tblHitung where gain = (select max(gain) from tblHitung));

			select * from tblTampung2;
			select atribut into @atributgain from tblTampung2 where jumlah = (select max(jumlah) from tblTampung2);
			select informasi into @informasigain from tblTampung2 where jumlah = (select max(jumlah) from tblTampung2);
			select @atributgain, @informasigain;

			drop table if exists tblTampung3;
			create temporary table tblTampung3
				(
					atribut varchar(20),
					informasi varchar(20),
					jumlah int,
					demam int,
					flu int,
					entropy decimal(8,4),
					gain decimal(8,4)
				);

			select * from tbldiagnosa where kelelahan = @informasigain;

		select @jumlahdatalelah := count(*)
		from tbldiagnosa where kelelahan = @informasigain;

		select @demamlelah := count(*)
		from tbldiagnosa
		where diagnosa = "Demam" and kelelahan = @informasigain;

		select @flulelah := count(*)
		from tbldiagnosa
		where diagnosa = 'Flu' and kelelahan = @informasigain;

		select @entropy1 := 0
			as entropy1;

		insert into tblHitung1(iterasi,atribut,informasi,jumlah,demam,flu,entropy) values
			(1,@atributgain, @informasigain,@jumlahdatalelah,@demamlelah,@flulelah,sfEntrophy(@jumlahdatalelah,@demamlelah,@flulelah));

		update tblHitung1 set entropy = 0 where entropy is NULL;

		insert into tblHitung1(informasi, jumlah, demam, flu)
			select a.flu, count(*) as Jumlah_Data,
				(
					SELECT COUNT(*)
					from tbldiagnosa as b
					where b.diagnosa='Demam' AND b.flu = a.flu
				) as 'demam',
				(
					SELECT COUNT(*)
					from tbldiagnosa as c 
					where c.diagnosa='Flu' AND c.flu = a.flu
				) as 'flu'
			from tbldiagnosa as a
			where a.kelelahan = @informasigain
			group by a.flu;

			update tblHitung1 set atribut = "flu" where atribut is NULL;

		/*demam*/
			insert into tblHitung1(informasi, jumlah, demam, flu)
			select a.demam, count(*) as Jumlah_Data,
				(
					SELECT COUNT(*)
					from tbldiagnosa as b
					where b.diagnosa='Demam' AND b.demam = a.demam
				) as 'demam',
				(
					SELECT COUNT(*)
					from tbldiagnosa as c 
					where c.diagnosa='Flu' AND c.demam = a.demam
				) as 'flu'
			from tbldiagnosa as a
			where a.kelelahan = @informasigain
			group by a.demam;

			update tblHitung1 set atribut = "demam" where atribut is NULL;

		/*nyeri*/
		insert into tblHitung1(informasi, jumlah, demam, flu)
			select a.nyeri, count(*) as Jumlah_Data,
				(
					SELECT COUNT(*)
					from tbldiagnosa as b
					where b.diagnosa='Demam' AND b.nyeri = a.nyeri
				) as 'demam',
				(
					SELECT COUNT(*)
					from tbldiagnosa as c 
					where c.diagnosa='Flu' AND c.nyeri = a.nyeri
				) as 'flu'
			from tbldiagnosa as a
			where a.kelelahan = @informasigain
			group by a.nyeri;

			update tblHitung1 set atribut = "nyeri" where atribut is NULL;

		/*lemas*/		
		insert into tblHitung1(informasi, jumlah, demam, flu)
			select a.lemas, count(*) as Jumlah_Data,
				(
					SELECT COUNT(*)
					from tbldiagnosa as b
					where b.diagnosa='Demam' AND b.lemas = a.lemas
				) as 'demam',
				(
					SELECT COUNT(*)
					from tbldiagnosa as c 
					where c.diagnosa='Flu' AND c.lemas = a.lemas
				) as 'flu'
			from tbldiagnosa as a
			where a.kelelahan = @informasigain
			group by a.lemas;

			update tblHitung1 set atribut = "lemas" where atribut is NULL;

		/*hidungtrsmbt*/
		insert into tblHitung1(informasi, jumlah, demam, flu)
			select a.hidungtrsmbt, count(*) as Jumlah_Data,
				(
					SELECT COUNT(*)
					from tbldiagnosa as b
					where b.diagnosa='Demam' AND b.hidungtrsmbt = a.hidungtrsmbt
				) as 'demam',
				(
					SELECT COUNT(*)
					from tbldiagnosa as c 
					where c.diagnosa='Flu' AND c.hidungtrsmbt = a.hidungtrsmbt
				) as 'flu'
			from tbldiagnosa as a
			where a.kelelahan = @informasigain
			group by a.hidungtrsmbt;

			update tblHitung1 set atribut = "hidungtrsmbt" where atribut is NULL;

		/*bersin*/
		insert into tblHitung1(informasi, jumlah, demam, flu)
			select a.bersin, count(*) as Jumlah_Data,
				(
					SELECT COUNT(*)
					from tbldiagnosa as b
					where b.diagnosa='Demam' AND b.bersin = a.bersin
				) as 'demam',
				(
					SELECT COUNT(*)
					from tbldiagnosa as c 
					where c.diagnosa='Flu' AND c.bersin = a.bersin
				) as 'flu'
			from tbldiagnosa as a
			where a.kelelahan = @informasigain
			group by a.bersin;

			update tblHitung1 set atribut = "bersin" where atribut is NULL;

		/*sakittenggorokan*/
		insert into tblHitung1(informasi, jumlah, demam, flu)
			select a.sakittenggorokan, count(*) as Jumlah_Data,
				(
					SELECT COUNT(*)
					from tbldiagnosa as b
					where b.diagnosa='Demam' AND b.sakittenggorokan = a.sakittenggorokan
				) as 'demam',
				(
					SELECT COUNT(*)
					from tbldiagnosa as c 
					where c.diagnosa='Flu' AND c.sakittenggorokan = a.sakittenggorokan
				) as 'flu'
			from tbldiagnosa as a
			where a.kelelahan = @informasigain
			group by a.sakittenggorokan;

			update tblHitung1 set atribut = "sakittenggorokan" where atribut is NULL;

		/*sltbernafas*/
		insert into tblHitung1(informasi, jumlah, demam, flu)
			select a.sltbernafas, count(*) as Jumlah_Data,
				(
					SELECT COUNT(*)
					from tbldiagnosa as b
					where b.diagnosa='Demam' AND b.sltbernafas = a.sltbernafas
				) as 'demam',
				(
					SELECT COUNT(*)
					from tbldiagnosa as c 
					where c.diagnosa='Flu' AND c.sltbernafas = a.sltbernafas
				) as 'flu'
			from tbldiagnosa as a
			where a.kelelahan = @informasigain
			group by a.sltbernafas;

			update tblHitung1 set atribut = "sltbernafas" where atribut is NULL;

			update tblHitung1 set entropy = sfEntrophy(jumlah,demam,flu);

			update tblHitung1 set entropy = 0 Where entropy is NULL;

			update tblHitung1 set iterasi = 1 where iterasi is null;

			delete from tblTampung;

			insert into tblTampung(atribut, gain)
			select atribut, abs(@entropylelah - 
			SUM((jumlah/@jumlahdatalelah) * entropy)) as Gain
			from tblHitung1
			group by atribut;

			select * from tblTampung;

			update tblHitung1 set gain =
				(
					select gain
					from tblTampung
					where atribut = tblHitung1.atribut
				);

			

		select * from tblHitung;
		select * from tblHitung1;

		





		