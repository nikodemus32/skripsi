/*LANGKAH 1: siapkan database dan data2 nya*/
DROP DATABASE IF EXISTS dbC45revisi;
CREATE DATABASE dbC45revisi;
USE dbC45revisi;

CREATE TABLE tblHasil
(
iterasi INT,
atribut VARCHAR(20),
informasi VARCHAR(20),
gain DECIMAL(8, 4)
);

CREATE TABLE tblData
(
iterasi INT,
nourut VARCHAR(3),
demam VARCHAR(10),
sakitkepala VARCHAR(10),
nyeri VARCHAR(10),
lemas VARCHAR(10),
kelelahan VARCHAR(10),
hidungtersumbat VARCHAR(10),
bersin VARCHAR(10),
sakittenggorokan VARCHAR(10),
sulitbernafas VARCHAR(10),
diagnosa VARCHAR(10)
);

CREATE TABLE tblC45
(
nourut VARCHAR(3),
demam VARCHAR(10),
sakitkepala VARCHAR(10),
nyeri VARCHAR(10),
lemas VARCHAR(10),
kelelahan VARCHAR(10),
hidungtersumbat VARCHAR(10),
bersin VARCHAR(10),
sakittenggorokan VARCHAR(10),
sulitbernafas VARCHAR(10),
diagnosa VARCHAR(10)
);

insert into tblC45 values
('P1',	'Tidak', 'Ringan', 'Tidak',	'Tidak', 'Tidak', 'Ringan', 'Parah', 'Parah', 'Ringan',	'Demam'),
('P2',	'Parah', 'Parah', 'Parah', 'Parah',	'Parah', 'Tidak', 'Tidak', 'Parah',	'Parah', 'Flu'),
('P3',	'Parah', 'Parah', 'Ringan', 'Parah', 'Parah', 'Parah', 'Tidak', 'Parah', 'Parah', 'Flu'),
('P4',	'Tidak', 'Tidak', 'Tidak', 'Ringan', 'Tidak', 'Parah', 'Tidak', 'Ringan', 'Ringan', 'Demam'),
('P5',	'Parah', 'Parah', 'Ringan', 'Parah', 'Parah', 'Parah', 'Tidak', 'Parah', 'Parah', 'Flu'),
('P6',	'Tidak', 'Tidak', 'Tidak', 'Ringan', 'Tidak', 'Parah', 'Parah', 'Parah', 'Tidak', 'Demam'),
('P7',	'Parah', 'Parah', 'Parah', 'Parah',	'Parah', 'Tidak', 'Tidak', 'Tidak',	'Parah', 'Flu'),
('P8',	'Tidak', 'Tidak', 'Tidak', 'Tidak',	'Tidak', 'Parah', 'Parah', 'Tidak',	'Ringan', 'Demam'),
('P9',	'Tidak', 'Ringan',	'Ringan', 'Tidak', 'Tidak',	'Parah', 'Parah', 'Parah',	'Parah', 'Demam'),
('P10',	'Parah', 'Parah', 'Parah',	'Ringan', 'Ringan',	'Tidak', 'Parah', 'Tidak', 'Parah', 'Flu'),
('P11',	'Tidak', 'Tidak', 'Tidak',	'Ringan', 'Tidak', 'Parah', 'Ringan', 'Parah',	'Tidak', 'Demam'),
('P12',	'Parah', 'Ringan',	'Parah', 'Ringan', 'Parah', 'Tidak', 'Parah', 'Tidak', 'Ringan', 'Flu'),
('P13',	'Tidak', 'Tidak', 'Ringan', 'Ringan', 'Tidak', 'Parah', 'Parah', 'Parah', 'Tidak', 'Demam'),
('P14',	'Parah', 'Parah', 'Parah', 'Parah', 'Ringan', 'Tidak', 'Parah', 'Parah', 'Parah', 'Flu'),
('P15',	'Ringan', 'Tidak', 'Tidak', 'Ringan', 'Tidak', 'Parah', 'Tidak', 'Parah', 'Ringan', 'Demam'),
('P16',	'Tidak', 'Tidak', 'Tidak', 'Tidak', 'Tidak', 'Parah', 'Parah', 'Parah', 'Parah', 'Demam'),
('P17',	'Parah', 'Ringan', 'Parah', 'Ringan', 'Ringan', 'Tidak', 'Tidak', 'Tidak', 'Parah', 'Flu');

/*
load data local infile "uasC45.csv"
into table tblC45
fields terminated by ";"
enclosed by ''''
ignore 1 lines;*/
select * from tblC45;

CREATE TABLE tblHitung
(
iterasi INT,
atribut VARCHAR(20),
informasi VARCHAR(20),
jumlahdata INT,
jumdemam INT,
jumflu INT,
entropy DECIMAL(8,4),
gain DECIMAL(8,4)
);

CREATE TABLE tblGain
(
iterasi INT,
atribut VARCHAR(20),
gain DECIMAL(8, 4)
);

/*Masukkan tbl C45 ke dalam tblData*/

DELIMITER $$
CREATE PROCEDURE spEntropy(loopcount INT)
BEGIN
	select loopcount as 'Looping';
	insert into tblData 
		select loopcount, 
		nourut,
		demam,
		sakitkepala,
		nyeri,
		lemas,
		kelelahan,
		hidungtersumbat, 
		bersin, 
		sakittenggorokan, 
		sulitbernafas, 
		diagnosa from tblC45;
	select * from tblData;

	call spFilter(loopcount);
	call spHitung(loopcount);
END $$
DELIMITER ;

/*Untuk memfilter mana yang tidak digunakan pada iterasi selanjutnya*/
DELIMITER $$
CREATE PROCEDURE spFilter(loopcount INT)
BEGIN

	declare viterasi1, vIterasi2 int;
	declare vNourut, vDemam, vSakitkepala, vNyeri, vLemas, vKelelahan, vHidungtersumbat, vBersin, vSakittenggorokan, vSulitbernafas, vDiagnosa, vAtribut, vInformasi varchar(50);
	declare i, j, vJumData, vJumData2 int default 0;

	declare cData cursor for select * from tblData;
	declare cHasil cursor for select iterasi, atribut, informasi from tblHasil;
	select count(*) into vJumData from tblData where iterasi=loopcount;
	select count(*) into vJumData2 from tblHasil;

	open cData;
	while i <> vJumData do 
	fetch cData into viterasi1, vNourut, vDemam, vSakitkepala, vNyeri, vLemas, vKelelahan, vHidungtersumbat, vBersin, vSakittenggorokan, vSulitbernafas, vDiagnosa;
	set j=0;
		open cHasil;
		while j <> vJumData2 do 
		fetch cHasil into vIterasi2, vAtribut, vInformasi;
			if vAtribut = 'Demam' then
				if vDemam != vInformasi then
					delete from tblData where iterasi=loopcount and nourut=vNourut;
				end if;
			elseif vAtribut = 'Sakit Kepala' then
				if vSakitkepala != vInformasi then
					delete from tblData where iterasi=loopcount and nourut=vNourut;
				end if;
			elseif vAtribut = 'Nyeri' then
				if vNyeri != vInformasi then
					delete from tblData where iterasi=loopcount and nourut=vNourut;
				end if;
			elseif vAtribut = 'Lemas' then
				if vLemas != vInformasi then
					delete from tblData where iterasi=loopcount and nourut=vNourut;
				end if;
			elseif vAtribut = 'Kelelahan' then
				if vKelelahan != vInformasi then
					delete from tblData where iterasi=loopcount and nourut=vNourut;
				end if;
			elseif vAtribut = 'Hidung Tersumbat' then
				if vHidungtersumbat != vInformasi then
					delete from tblData where iterasi=loopcount and nourut=vNourut;
				end if;
			elseif vAtribut = 'Bersin' then
				if vBersin != vInformasi then
					delete from tblData where iterasi=loopcount and nourut=vNourut;
				end if;
			elseif vAtribut = 'Sakit Tenggorokan' then
				if vSakittenggorokan != vInformasi then
					delete from tblData where iterasi=loopcount and nourut=vNourut;
				end if;
			elseif vAtribut = 'Sulit Bernafas' then
				if vSulitbernafas != vInformasi then
					delete from tblData where iterasi=loopcount and nourut=vNourut;
				end if;
			end if;
		set j:=j+1;
		end while;
		close cHasil;

	set i:=i+1;
	end while;
	close cData;

END $$
DELIMITER ;

/*Menghitung dan memasukkannya dalam tblHitung*/
DELIMITER $$
CREATE PROCEDURE spHitung(loopcount INT)
BEGIN

	declare vAtribut, vInformasi, vAtribut2 varchar(50);
	declare vDemam, vFlu, i, vJumData int default 0;
	
	declare cPlay cursor for select atribut, informasi from tblHasil;
	select count(*) into vJumData from tblHasil;

	if loopcount = 1 then 
		set vAtribut = 'TOTAL DATA';
		select count(*) into vDemam from tblData where diagnosa = 'Demam';
		select count(*) into vFlu from tblData where diagnosa = 'Flu';
		insert into tblHitung (iterasi, atribut, jumlahdata, jumdemam, jumflu) values (loopcount, vAtribut, vDemam+vFlu, vDemam, vFlu);
	elseif loopcount > 1 then 
		set vAtribut = 'TOTAL DATA';
		select count(*) into vDemam from tblData where diagnosa = 'Demam' and iterasi=loopcount;
		select count(*) into vFlu from tblData where diagnosa = 'Flu' and iterasi=loopcount;
		insert into tblHitung (iterasi, atribut, jumlahdata, jumdemam, jumflu) values (loopcount, vAtribut, vDemam+vFlu, vDemam, vFlu);
	end if;


	insert into tblHitung(iterasi, atribut, informasi, jumlahdata, jumdemam, jumflu)
		select distinct loopcount, 'Demam', (A.demam), 
			(select COUNT(*) from tblData
				where iterasi = loopcount AND demam = A.demam),
			(select COUNT(*) from tblData
				where iterasi = loopcount AND demam = A.demam AND diagnosa = 'Demam'),
			(select COUNT(*) from tblData
			 	where iterasi = loopcount AND demam = A.demam AND diagnosa = 'Flu')
		from tblData as A where iterasi = loopcount;

	insert into tblHitung(iterasi, atribut, informasi, jumlahdata, jumdemam, jumflu)
		select distinct loopcount, 'Sakit Kepala', (A.sakitkepala), 
			(select COUNT(*) from tblData
				where iterasi = loopcount AND sakitkepala = A.sakitkepala),
			(select COUNT(*) from tblData
				where iterasi = loopcount AND sakitkepala = A.sakitkepala AND diagnosa = 'Demam'),
			(select COUNT(*) from tblData
			 	where iterasi = loopcount AND sakitkepala = A.sakitkepala AND diagnosa = 'Flu')
		from tblData as A where iterasi = loopcount;

	insert into tblHitung(iterasi, atribut, informasi, jumlahdata, jumdemam, jumflu)
		select distinct loopcount, 'Nyeri', (A.nyeri),
			(select COUNT(*) from tblData
				where iterasi = loopcount AND nyeri = A.nyeri),
			(select COUNT(*) from tblData
				where iterasi = loopcount AND nyeri = A.nyeri AND diagnosa = 'Demam'),
			(select COUNT(*) from tblData
			 	where iterasi = loopcount AND nyeri = A.nyeri AND diagnosa = 'Flu')
		from tblData as A where iterasi = loopcount;

	insert into tblHitung(iterasi, atribut, informasi, jumlahdata, jumdemam, jumflu)
		select distinct loopcount, 'Lemas', (A.lemas), 
			(select COUNT(*) from tblData
				where iterasi = loopcount AND lemas = A.lemas),
			(select COUNT(*) from tblData
				where iterasi = loopcount AND lemas = A.lemas AND diagnosa = 'Demam'),
			(select COUNT(*) from tblData
			 	where iterasi = loopcount AND lemas = A.lemas AND diagnosa = 'Flu')
		from tblData as A where iterasi = loopcount;

	insert into tblHitung(iterasi, atribut, informasi, jumlahdata, jumdemam, jumflu)
		select distinct loopcount, 'Kelelahan', (A.kelelahan), 
			(select COUNT(*) from tblData
				where iterasi = loopcount AND kelelahan = A.kelelahan),
			(select COUNT(*) from tblData
				where iterasi = loopcount AND kelelahan = A.kelelahan AND diagnosa = 'Demam'),
			(select COUNT(*) from tblData
			 	where iterasi = loopcount AND kelelahan = A.kelelahan AND diagnosa = 'Flu')
		from tblData as A where iterasi = loopcount;

	insert into tblHitung(iterasi, atribut, informasi, jumlahdata, jumdemam, jumflu)
		select distinct loopcount, 'Hidung Tersumbat', (A.hidungtersumbat), 
			(select COUNT(*) from tblData
				where iterasi = loopcount AND hidungtersumbat = A.hidungtersumbat),
			(select COUNT(*) from tblData
				where iterasi = loopcount AND hidungtersumbat = A.hidungtersumbat AND diagnosa = 'Demam'),
			(select COUNT(*) from tblData
			 	where iterasi = loopcount AND hidungtersumbat = A.hidungtersumbat AND diagnosa = 'Flu')
		from tblData as A where iterasi = loopcount;

	insert into tblHitung(iterasi, atribut, informasi, jumlahdata, jumdemam, jumflu)
		select distinct loopcount, 'Bersin', (A.bersin), 
			(select COUNT(*) from tblData
				where iterasi = loopcount AND bersin = A.bersin),
			(select COUNT(*) from tblData
				where iterasi = loopcount AND bersin = A.bersin AND diagnosa = 'Demam'),
			(select COUNT(*) from tblData
			 	where iterasi = loopcount AND bersin = A.bersin AND diagnosa = 'Flu')
		from tblData as A where iterasi = loopcount;

	insert into tblHitung(iterasi, atribut, informasi, jumlahdata, jumdemam, jumflu)
		select distinct loopcount, 'Sakit Tenggorokan', (A.sakittenggorokan), 
			(select COUNT(*) from tblData
				where iterasi = loopcount AND sakittenggorokan = A.sakittenggorokan),
			(select COUNT(*) from tblData
				where iterasi = loopcount AND sakittenggorokan = A.sakittenggorokan AND diagnosa = 'Demam'),
			(select COUNT(*) from tblData
			 	where iterasi = loopcount AND sakittenggorokan = A.sakittenggorokan AND diagnosa = 'Flu')
		from tblData as A where iterasi = loopcount;

	insert into tblHitung(iterasi, atribut, informasi, jumlahdata, jumdemam, jumflu)
		select distinct loopcount, 'Sulit Bernafas', (A.sulitbernafas), 
			(select COUNT(*) from tblData
				where iterasi = loopcount AND sulitbernafas = A.sulitbernafas),
			(select COUNT(*) from tblData
				where iterasi = loopcount AND sulitbernafas = A.sulitbernafas AND diagnosa = 'Demam'),
			(select COUNT(*) from tblData
			 	where iterasi = loopcount AND sulitbernafas = A.sulitbernafas AND diagnosa = 'Flu')
		from tblData as A where iterasi = loopcount;


	open cPlay;
		while i <> vJumData do
		fetch cPlay into vAtribut2, vInformasi;
			delete from tblHitung where iterasi = loopcount and atribut = vAtribut2;
		set i=i+1;
		end while;
	close cPlay;


END $$
DELIMITER ;

/*Menghitung entrophy*/
DELIMITER $$
CREATE PROCEDURE spEntropy2(loopcount INT)
BEGIN

	update tblHitung set entropy = (-(jumdemam/jumlahdata)*log2(jumdemam/jumlahdata)) + (-(jumflu/jumlahdata)*log2(jumflu/jumlahdata)) WHERE jumdemam != 0 AND jumflu != 0;
	update tblHitung set entropy = 0 where entropy IS NULL;

	call spGain(loopcount);

	select * from tblData;
	select * from tblHitung;
	select * from tblGain;

END $$
DELIMITER ;

/*Menghitung gain dan memasukkan hasil max(gain) dalam tblHasil*/
DELIMITER $$
CREATE PROCEDURE spGain(loopcount INT)
BEGIN

	declare vEntropy decimal(8,4);
	declare vJumData, vJumGain int default 0;

	select jumlahdata into vJumData from tblHitung where iterasi = loopcount LIMIT 1;
	select entropy into vEntropy from tblHitung where iterasi = loopcount LIMIT 1;	

	insert into tblGain(iterasi, atribut, gain)
	select loopcount, atribut, ROUND(ABS(vEntropy - SUM((jumlahdata/vJumData) * entropy)), 4) AS ENTROPY
	from tblHitung 
	where iterasi = loopcount
	group by atribut;

	update tblGain set gain = 0 where gain = NULL;

	update tblHitung set gain =
	(
		select gain
		from tblGain
		where atribut = tblHitung.atribut
		and iterasi = loopcount
	)
	where iterasi = loopcount;

	select MAX(gain) into @gain from tblGain where iterasi = loopcount;

	select @gain AS GAIN;

	insert into tblHasil(iterasi, atribut, informasi, gain)
	select iterasi, atribut, informasi, gain
	from tblHitung
	where gain = @gain and iterasi = loopcount and jumdemam != 0 and jumflu != 0;

	select count(*) into vJumGain from tblHasil where iterasi=loopcount;

	insert into tblHasil(iterasi, atribut, informasi, gain)
	select iterasi, atribut, informasi, gain
	from tblHitung
	where gain = @gain and iterasi = loopcount;

	if vJumGain < 1 then
		insert into tblHasil(iterasi, atribut, informasi, gain)
		select loopcount, 'Last', 'Selesai', gain
		from tblHitung
		where gain = @gain and iterasi = loopcount
		LIMIT 1;	
	end if;


END $$
DELIMITER ;


/*Untuk mengecek kalah sudah last berhenti*/
DELIMITER $$
CREATE FUNCTION spCek(loopcount INT)
RETURNS INT
BEGIN

	declare vSelesai, stop INT DEFAULT 0;
	SET stop = 1;

	select COUNT(informasi) into vSelesai from tblHasil where informasi = 'Selesai';

	if vSelesai != 0 THEN
		set stop = 2;
	end if;

	RETURN(stop);

END $$
DELIMITER ;

/*Looping untuk running*/
DELIMITER $$
CREATE PROCEDURE spRun()
BEGIN

	declare i, j INT DEFAULT 1;

	while j = 1 do

		call spEntropy(i);
		call spEntropy2(i);

		set i = i + 1;

		set j = spCek(i);

		select * from tblHasil;

	end while;

END$$
DELIMITER ;

CALL spRun();
