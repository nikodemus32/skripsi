DROP DATABASE IF EXISTS UAS;
CREATE DATABASE UAS;
USE UAS;

CREATE TABLE tblData(
	nourut VARCHAR(10),
	demam VARCHAR(10),
	sakit_kepala VARCHAR(10),
	nyeri VARCHAR(10),
	lemas VARCHAR(10),
	kelelahan VARCHAR(10),
	hidung_tersumbat VARCHAR(10),
	bersin VARCHAR(10),
	sakit_tenggorokan VARCHAR(10),
	sulit_bernafas VARCHAR(10), 
	diagnosa VARCHAR(10)
);


INSERT INTO tblData VALUES
('P1', 'Tidak',    'Ringan', 'Tidak',    'Tidak',     'Tidak', 'Ringan',    'Parah',    'Parah',    'Ringan',    'Demam'),
('P2', 'Parah',    'Parah', 'Parah',    'Parah',     'Parah', 'Tidak',    'Tidak',    'Parah',    'Parah',    'Flu'),
('P3', 'Parah',    'Parah', 'Ringan',    'Parah',     'Parah', 'Parah',    'Tidak',    'Parah',    'Parah',    'Flu'),
('P4', 'Tidak',    'Tidak', 'Tidak',    'Ringan',     'Tidak', 'Parah',    'Tidak',    'Ringan',    'Ringan',    'Demam'),
('P5', 'Parah',    'Parah', 'Ringan',    'Parah',     'Parah', 'Parah',    'Tidak',    'Parah',    'Parah',    'Flu'),
('P6', 'Tidak',    'Tidak', 'Tidak',    'Ringan',     'Tidak', 'Parah',    'Parah',    'Parah',    'Tidak',    'Demam'),
('P7', 'Parah',    'Parah', 'Parah',    'Parah',     'Parah', 'Tidak',    'Tidak',    'Tidak',    'Parah',    'Flu'),
('P8', 'Tidak',    'Tidak', 'Tidak',    'Tidak',     'Tidak', 'Parah',    'Parah',    'Tidak',    'Ringan',    'Demam'),
('P9', 'Tidak',    'Ringan', 'Ringan',    'Tidak',     'Tidak', 'Parah',    'Parah',    'Parah',    'Parah',    'Demam'),
('P10', 'Parah', 'Parah', 'Parah',    'Ringan',     'Ringan', 'Tidak',    'Parah',    'Tidak',    'Parah',    'Flu'),
('P11', 'Tidak', 'Tidak', 'Tidak',    'Ringan',     'Tidak', 'Parah',    'Ringan',    'Parah',    'Tidak',    'Demam'),
('P12', 'Parah', 'Ringan', 'Parah',    'Ringan',     'Parah', 'Tidak',    'Parah',    'Tidak',    'Ringan',    'Flu'),
('P13', 'Tidak', 'Tidak', 'Ringan',    'Ringan',     'Tidak', 'Parah',    'Parah',    'Parah',    'Tidak',    'Demam'),
('P14', 'Parah', 'Parah', 'Parah',    'Parah',     'Ringan', 'Tidak',    'Parah',    'Parah',    'Parah',    'Flu'),
('P15', 'Ringan', 'Tidak', 'Tidak',    'Ringan',     'Tidak', 'Parah',    'Tidak',    'Parah',    'Ringan',    'Demam'),
('P16', 'Tidak', 'Tidak', 'Tidak',    'Tidak',     'Tidak', 'Parah',    'Parah',    'Parah',    'Parah',    'Demam'),
('P17', 'Parah', 'Ringan', 'Parah',    'Ringan',     'Ringan', 'Tidak',    'Tidak',    'Tidak',    'Parah',    'Flu');


CREATE TABLE tblHitung(
	iterasi INT,
	atribut VARCHAR(20),
	informasi VARCHAR(100),
	jumlahdata INT,
	diagnosademam INT,
	diagnosaflu INT,
	entropy DECIMAL(8,4),
	gain DECIMAL(8,4)
);

CREATE TABLE tblSementara(
	iterasi INT,
	nourut VARCHAR(5),
	demam VARCHAR(10),
	sakit_kepala VARCHAR(10),
	nyeri VARCHAR(10),
	lemas VARCHAR(10),
	kelelahan VARCHAR(10),
	hidung_tersumbat VARCHAR(10),
	bersin VARCHAR(10),
	sakit_tenggorokan VARCHAR(10),
	sulit_bernafas VARCHAR(10), 
	diagnosa VARCHAR(10)
);

CREATE TABLE tblBabak(
	iterasi INT,
	atribut VARCHAR(20),
	informasi VARCHAR(100),
	gain DECIMAL(8,4) 
);

CREATE TABLE tblGain(
	iterasi INT,
	atribut VARCHAR(50),
	gain DECIMAL(8,4)
);

delimiter $$
CREATE PROCEDURE spPindah(pIterasi INT)
BEGIN
	select pIterasi as 'Urutan Ke- ';
	insert into tblSementara 
		select pIterasi,
			   nourut,
			   demam,
			   sakit_kepala,
			   nyeri,
			   lemas,
			   kelelahan,
			   hidung_tersumbat,
			   bersin,
			   sakit_tenggorokan,
			   sulit_bernafas,
			   diagnosa
		from tblData;

		call spKualifikasi(pIterasi);

		call spDiagnosa(pIterasi);
end $$
delimiter ;

delimiter $$
CREATE PROCEDURE spKualifikasi(pIterasi INT)
BEGIN
	declare vIterasiBabak, vLoopBabak, vJumlahDataBabak INT default 0;
	declare vAtributBabak VARCHAR(20);

	declare vLoopSementara, vJumlahDataSementara, vIterasiSementara INT default 0;
	declare vNoUrutSementara, vDemamSementara,vSakitKepalaSementara, vNyeriSementara, vLemasSementara, vKelelahanSementara,
			vHidungTersumbatSementara, vBersinSementara, vSakitTenggorokanSementara, vSulitBernafasSementara, 
			vDiagnosaSementara, vInformasiSementara VARCHAR(100);

	declare cBabak cursor for select iterasi, atribut, informasi from tblBabak;
	declare cSementara cursor for select * from tblSementara;
	select count(*) into vJumlahDataBabak from tblBabak;
	select count(*) into vJumlahDataSementara from tblSementara where iterasi = pIterasi;

	open cSementara;
		while vLoopSementara < vJumlahDataSementara do 
			fetch cSementara into vIterasiSementara, vNoUrutSementara, vDemamSementara, vSakitKepalaSementara, vNyeriSementara,
								  vLemasSementara, vKelelahanSementara, vHidungTersumbatSementara, vBersinSementara, vSakitTenggorokanSementara,
								  vSulitBernafasSementara, vDiagnosaSementara;
			set vLoopBabak = 0;
			open cBabak;
			while vLoopBabak < vJumlahDataBabak do
				fetch cBabak into vIterasiBabak, vAtributBabak, vInformasiSementara;
				if vAtributBabak = 'demam' then 
					if vDemamSementara <> vInformasiSementara then 
						delete from tblSementara where iterasi = pIterasi and nourut = vNoUrutSementara;
					end if;
				elseif vAtributBabak = 'sakit_kepala' then 
					if vSakitKepalaSementara <> vInformasiSementara then 
						delete from tblSementara where iterasi = pIterasi and nourut = vNoUrutSementara;
					end if;
				elseif vAtributBabak = 'nyeri' then 
					if vNyeriSementara <> vInformasiSementara then 
						delete from tblSementara where iterasi = pIterasi and nourut = vNoUrutSementara;
					end if;
				elseif vAtributBabak = 'lemas' then 
					if vLemasSementara <> vInformasiSementara then 
						delete from tblSementara where iterasi = pIterasi and nourut = vNoUrutSementara;
					end if;
				elseif vAtributBabak = 'kelelahan' then 
					if vKelelahanSementara <> vInformasiSementara then 
						delete from tblSementara where iterasi = pIterasi and nourut = vNoUrutSementara;
					end if;
				elseif vAtributBabak = 'hidung_tersumbat' then 
					if vHidungTersumbatSementara <> vInformasiSementara then 
						delete from tblSementara where iterasi = pIterasi and nourut = vNoUrutSementara;
					end if;
				elseif vAtributBabak = 'bersin' then 
					if vBersinSementara <> vInformasiSementara then 
						delete from tblSementara where iterasi = pIterasi and nourut = vNoUrutSementara;
					end if;
				elseif vAtributBabak = 'sakit_tenggorokan' then 
					if vSakitTenggorokanSementara <> vInformasiSementara then 
						delete from tblSementara where iterasi = pIterasi and nourut = vNoUrutSementara;
					end if;
				elseif vAtributBabak = 'sulit_bernafas' then 
					if vSulitBernafasSementara <> vInformasiSementara then 
						delete from tblSementara where iterasi = pIterasi and nourut = vNoUrutSementara;
					end if;
				elseif vAtributBabak = 'diagnosa' then 
					if vDiagnosaSementara <> vInformasiSementara then 
						delete from tblSementara where iterasi = pIterasi and nourut = vNoUrutSementara;
					end if;
				end if;
				set vLoopBabak = vLoopBabak + 1;
			end while;
			close cBabak;
			set vLoopSementara = vLoopSementara + 1;
		end while;
	close cSementara;
END $$
delimiter ;


delimiter $$
CREATE PROCEDURE spDiagnosa(pIterasi INT)
BEGIN 
	declare vAtributDiagnosa VARCHAR(50) default '';
	declare vDiagnosaDemam, vDiagnosaFlu INT default 0;

	declare vIterasiBabak, vJumlahDataBabak, vLoopBabak INT default 0;
	declare vAtributBabak, vInformasi VARCHAR(50);

	declare cBabak cursor for select atribut, informasi from tblBabak;
	select count(*) into vJumlahDataBabak from tblBabak;

	if pIterasi = 1 then 
		set vAtributDiagnosa = 'Total';
		select count(*) into vDiagnosaDemam from tblSementara where diagnosa = 'Demam';
		select count(*) into vDiagnosaFlu from tblSementara where diagnosa = 'Flu';

		insert into tblHitung(iterasi, atribut, informasi, jumlahdata, diagnosademam, diagnosaflu)
			VALUES (pIterasi, vAtributDiagnosa, "", vDiagnosaDemam+vDiagnosaFlu, vDiagnosaDemam, vDiagnosaFlu);
	elseif pIterasi > 1 then 
		select atribut from tblBabak where iterasi = (pIterasi - 1);
		select count(*) into vDiagnosaDemam from tblSementara where diagnosa = 'Demam' and iterasi = pIterasi;
		select count(*) into vDiagnosaFlu from tblSementara where diagnosa = 'Flu' and iterasi = pIterasi;

		insert into tblHitung(iterasi, atribut, jumlahdata, diagnosademam, diagnosaflu)
			VALUES (pIterasi, vAtributDiagnosa, vDiagnosaDemam+vDiagnosaFlu, vDiagnosaDemam, vDiagnosaFlu);
	end if;

	insert into tblHitung(informasi, iterasi, atribut, jumlahdata, diagnosademam, diagnosaflu)
	select distinct(A.demam), pIterasi, 'demam', 
		(select count(*) from tblSementara where iterasi = pIterasi and demam = A.demam),
		(select count(*) from tblSementara where iterasi = pIterasi and demam = A.demam and diagnosa = 'Demam'),
		(select count(*) from tblSementara where iterasi = pIterasi and demam = A.demam and diagnosa = 'Flu')
	from tblSementara as A where iterasi = pIterasi;

	insert into tblHitung(informasi, iterasi, atribut, jumlahdata, diagnosademam, diagnosaflu)
	select distinct(A.sakit_kepala), pIterasi, 'sakit_kepala', 
		(select count(*) from tblSementara where iterasi = pIterasi and sakit_kepala = A.sakit_kepala),
		(select count(*) from tblSementara where iterasi = pIterasi and sakit_kepala = A.sakit_kepala and diagnosa = 'Demam'),
		(select count(*) from tblSementara where iterasi = pIterasi and sakit_kepala = A.sakit_kepala and diagnosa = 'Flu')
	from tblSementara as A where iterasi = pIterasi;

	insert into tblHitung(informasi, iterasi, atribut, jumlahdata, diagnosademam, diagnosaflu)
	select distinct(A.nyeri), pIterasi, 'nyeri', 
		(select count(*) from tblSementara where iterasi = pIterasi and nyeri = A.nyeri),
		(select count(*) from tblSementara where iterasi = pIterasi and nyeri = A.nyeri and diagnosa = 'Demam'),
		(select count(*) from tblSementara where iterasi = pIterasi and nyeri = A.nyeri and diagnosa = 'Flu')
	from tblSementara as A where iterasi = pIterasi;

	insert into tblHitung(informasi, iterasi, atribut, jumlahdata, diagnosademam, diagnosaflu)
	select distinct(A.lemas), pIterasi, 'lemas', 
		(select count(*) from tblSementara where iterasi = pIterasi and lemas = A.lemas),
		(select count(*) from tblSementara where iterasi = pIterasi and lemas = A.lemas and diagnosa = 'Demam'),
		(select count(*) from tblSementara where iterasi = pIterasi and lemas = A.lemas and diagnosa = 'Flu')
	from tblSementara as A where iterasi = pIterasi;

	insert into tblHitung(informasi, iterasi, atribut, jumlahdata, diagnosademam, diagnosaflu)
	select distinct(A.kelelahan), pIterasi, 'kelelahan', 
		(select count(*) from tblSementara where iterasi = pIterasi and kelelahan = A.kelelahan),
		(select count(*) from tblSementara where iterasi = pIterasi and kelelahan = A.kelelahan and diagnosa = 'Demam'),
		(select count(*) from tblSementara where iterasi = pIterasi and kelelahan = A.kelelahan and diagnosa = 'Flu')
	from tblSementara as A where iterasi = pIterasi;

	insert into tblHitung(informasi, iterasi, atribut, jumlahdata, diagnosademam, diagnosaflu)
	select distinct(A.hidung_tersumbat), pIterasi, 'hidung_tersumbat', 
		(select count(*) from tblSementara where iterasi = pIterasi and hidung_tersumbat = A.hidung_tersumbat),
		(select count(*) from tblSementara where iterasi = pIterasi and hidung_tersumbat = A.hidung_tersumbat and diagnosa = 'Demam'),
		(select count(*) from tblSementara where iterasi = pIterasi and hidung_tersumbat = A.hidung_tersumbat and diagnosa = 'Flu')
	from tblSementara as A where iterasi = pIterasi;

	insert into tblHitung(informasi, iterasi, atribut, jumlahdata, diagnosademam, diagnosaflu)
	select distinct(A.bersin), pIterasi, 'bersin', 
		(select count(*) from tblSementara where iterasi = pIterasi and bersin = A.bersin),
		(select count(*) from tblSementara where iterasi = pIterasi and bersin = A.bersin and diagnosa = 'Demam'),
		(select count(*) from tblSementara where iterasi = pIterasi and bersin = A.bersin and diagnosa = 'Flu')
	from tblSementara as A where iterasi = pIterasi;

	insert into tblHitung(informasi, iterasi, atribut, jumlahdata, diagnosademam, diagnosaflu)
	select distinct(A.sakit_tenggorokan), pIterasi, 'sakit_tenggorokan', 
		(select count(*) from tblSementara where iterasi = pIterasi and sakit_tenggorokan = A.sakit_tenggorokan),
		(select count(*) from tblSementara where iterasi = pIterasi and sakit_tenggorokan = A.sakit_tenggorokan and diagnosa = 'Demam'),
		(select count(*) from tblSementara where iterasi = pIterasi and sakit_tenggorokan = A.sakit_tenggorokan and diagnosa = 'Flu')
	from tblSementara as A where iterasi = pIterasi;

	insert into tblHitung(informasi, iterasi, atribut, jumlahdata, diagnosademam, diagnosaflu)
	select distinct(A.sulit_bernafas), pIterasi, 'sulit_bernafas', 
		(select count(*) from tblSementara where iterasi = pIterasi and sulit_bernafas = A.sulit_bernafas),
		(select count(*) from tblSementara where iterasi = pIterasi and sulit_bernafas = A.sulit_bernafas and diagnosa = 'Demam'),
		(select count(*) from tblSementara where iterasi = pIterasi and sulit_bernafas = A.sulit_bernafas and diagnosa = 'Flu')
	from tblSementara as A where iterasi = pIterasi;

	open cBabak;
	while vLoopBabak < vJumlahDataBabak do 
	fetch cBabak into vAtributBabak, vInformasi;
		delete from tblHitung where iterasi = pIterasi and atribut = vAtributBabak;
	set vLoopBabak = vLoopBabak + 1;
	end while;
	close cBabak; 
END $$
delimiter ; 

delimiter $$
CREATE PROCEDURE spHitungEntropy(pIterasi INT) 
BEGIN
	declare vLoopHitung, vIterasi, vJumlahData, vJumlahDataHitung, vDiagnosaDemam, vDiagnosaFlu INT default 0;
	declare vAtributHitung, vInformasiHitung VARCHAR(50) default '';
	declare vEntropyHitung, vGainHitung DECIMAL(8,4);

	declare cHitung cursor for select * from tblHitung;
	select count(*) into vJumlahDataHitung from tblHitung;

	open cHitung;
	while vLoopHitung < vJumlahDataHitung do 
	fetch cHitung into vIterasi, vAtributHitung, vInformasiHitung, vJumlahData, vDiagnosaDemam, vDiagnosaFlu, vEntropyHitung, vGainHitung;
		if vDiagnosaDemam = 0 or vDiagnosaFlu = 0 then
			update tblHitung set entropy = 0 where iterasi = vIterasi and atribut = vAtributHitung and informasi = vInformasiHitung;
		else 
			update tblHitung set entropy = ( -(vDiagnosaDemam/vJumlahData) * log2(vDiagnosaDemam/vJumlahData) ) + ( -(vDiagnosaFlu/vJumlahData) * log2(vDiagnosaFlu/vJumlahData) ) 
				where iterasi = vIterasi and atribut = vAtributHitung and informasi = vInformasiHitung;
		end if;
		set vLoopHitung = vLoopHitung + 1;
	end while;
	close cHitung;
 
END $$
delimiter ;


delimiter $$
CREATE PROCEDURE spHitungGain(pIterasi INT)
BEGIN
	declare vEntropy, vGainSementara DECIMAL(8,4);
	declare vJumlahData, vJumlahGain INT default 0;

	select jumlahdata into vJumlahData from tblHitung where iterasi = pIterasi limit 1;
	select entropy into vEntropy from tblHitung where iterasi = pIterasi limit 1;

	insert into tblGain(iterasi, atribut, gain)
	select pIterasi,
		   atribut,
		   round((vEntropy - SUM((jumlahdata/vJumlahData) * entropy)), 4) AS ENTROPY
	from tblHitung
	where iterasi = pIterasi
	group by atribut;

	update tblHitung set gain = 
	(
		select gain 
		from tblGain
		where atribut = tblHitung.atribut
		and iterasi = pIterasi
	)
	where iterasi = pIterasi;

	select max(gain) into @gainbefore from tblGain where iterasi = pIterasi;

	select @gainbefore as GAINBeneran;

	insert into tblBabak(iterasi, atribut, informasi, gain)
	select iterasi, atribut, informasi, gain
	from tblHitung
	where gain = @gainbefore and 
		  iterasi = pIterasi and
		  diagnosademam != 0 and 
		  diagnosaflu != 0;

	select count(*) into vJumlahGain from tblBabak where iterasi = pIterasi;
	if vJumlahGain < 1 then 
		insert into tblBabak(iterasi, atribut, informasi, gain)
		select iterasi, atribut, 'Finish', gain
		from tblHitung
		where gain = @gainbefore and
			iterasi = pIterasi
		limit 1;
	end if;
END $$
delimiter ;


delimiter $$
CREATE PROCEDURE spLoop()
BEGIN
	declare pIterasi INT default 1;
	declare vStop INT default 0;

	while vStop != 1 do 
		call spPindah(pIterasi);
		call spHitungEntropy(pIterasi);
		call spHitungGain(pIterasi);
		set pIterasi = pIterasi + 1;
		set vStop = (select count(*) from tblBabak where informasi = 'Finish');
	select * from tblData;
	select * from tblSementara;
	select * from tblBabak;
	select * from tblHitung;
	end while;


END $$
delimiter ;

call spLoop();



