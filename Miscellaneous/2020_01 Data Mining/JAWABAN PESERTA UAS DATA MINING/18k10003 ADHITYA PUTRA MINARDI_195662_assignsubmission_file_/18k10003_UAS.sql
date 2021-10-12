DROP DATABASE IF EXISTS dbC45;
CREATE DATABASE dbC45;
USE dbC45;

CREATE TABLE tblData(
Nomor varchar(5),
Demam varchar(10),
Sakitkepala varchar(10),
Nyeri varchar(10),
Lemas varchar(10),
Kelelahan varchar(10),
Hidungtersumbat varchar(10),
Bersin varchar(10),
Sakittenggorokan varchar(10),
Sulitbernafas varchar(10),
diagnosa varchar(10)
);

insert into tblData values
('P1','Tidak','Ringan','Tidak','Tidak','Tidak','Ringan','Parah','Parah','Ringan','Demam'),
('P2','Parah','Parah','Parah','Parah','Parah','Tidak','Tidak','Parah','Parah','Flu'),
('P3','Parah','Parah','Ringan','Parah','Parah','Parah','Tidak','Parah','Parah','Flu'),
('P4','Tidak','Tidak','Tidak','Ringan','Tidak','Parah','Tidak','Ringan','Ringan','Demam'),
('P5','Parah','Parah','Ringan','Parah','Parah','Parah','Tidak','Parah','Parah','Flu'),
('P6','Tidak','Tidak','Tidak','Ringan','Tidak','Parah','Parah','Parah','Tidak','Demam'),
('P7','Parah','Parah','Parah','Parah','Parah','Tidak','Tidak','Tidak','Parah','Flu'),
('P8','Tidak','Tidak','Tidak','Tidak','Tidak','Parah','Parah','Tidak','Ringan','Demam'),
('P9','Tidak','Ringan','Ringan','Tidak','Tidak','Parah','Parah','Parah','Parah','Demam'),
('P10','Parah','Parah','Parah','Ringan','Ringan','Tidak','Parah','Tidak','Parah','Flu'),
('P11','Tidak','Tidak','Tidak','Ringan','Tidak','Parah','Ringan','Parah','Tidak','Demam'),
('P12','Parah','Ringan','Parah','Ringan','Parah','Tidak','Parah','Tidak','Ringan','Flu'),
('P13','Tidak','Tidak','Ringan','Ringan','Tidak','Parah','Parah','Parah','Tidak','Demam'),
('P14','Parah','Parah','Parah','Parah','Ringan','Tidak','Parah','Parah','Parah','Flu'),
('P15','Ringan','Tidak','Tidak','Ringan','Tidak','Parah','Tidak','Parah','Ringan','Demam'),
('P16','Tidak','Tidak','Tidak','Tidak','Tidak','Parah','Parah','Parah','Parah','Demam'),
('P17','Parah','Ringan','Parah','Ringan','Ringan','Tidak','Tidak','Tidak','Parah','Flu');
select * from tblData;
create table tblTampung(
iterasi varchar(5),
keterangan varchar(20),
informasi varchar(20),
jumlah int,
demam int,
flu int,
entropy decimal(8,4),
gain double
);

delimiter $$
create function sfEntropy(a int,b int,c int)
returns decimal (8,4)
begin
	declare entropy decimal (8,4);
	if a = 0 then
		set entropy = 0;
	elseif c = 0 then
		set entropy = 0;
	else
		set entropy = (-(a/b) * log2(a/b))+(-(c/b)*log2(c/b));
	end if ;
	
	
	return entropy;
end $$
delimiter ;


delimiter $$
create function sfGain(a int, b int,c decimal(8,4))
returns double
begin
	declare gain double;
	declare entropy decimal(8,4);
	declare t,i int default 0;
	declare cEntropy cursor for
	select entropy from tblHitung;
	select count(*) into t from tblHitung;
	set gain = @entropy - sum((b/a)*c);
	set @gain = gain;

	return gain;
end $$
delimiter ;
select @gain;

create table tblEntropy(
ket varchar(20),
entropy decimal(8,4)
);

create table tblGain(
kete varchar(20),
gain double
);

delimiter $$
create procedure spHitung(kategori varchar(20))
begin
	declare total int;
	declare totaldemam int;
	declare i int default 0;
	declare	vNo varchar(5);
	declare iterasi int default 0;
	declare hitungdemam int default 0;
	declare hitungflu int default 0;
	declare hitung int default 0;
	declare hitungdemam1 int default 0;
	declare hitungflu1 int default 0;
	declare hitung1 int default 0;
	declare hitungdemam2 int default 0;
	declare gain double;
	declare hitungflu2 int default 0;
	declare hitung2 int default 0;
	declare	vDemam varchar(10);
	declare banding varchar(10);
	declare	vSakitkepala varchar(10);
	declare	vNyeri varchar(10);
	declare	vLemas varchar(10);
	declare	vKelelahan varchar(10);
	declare	vHidungtersumbat varchar(10);
	declare	vBersin varchar(10);
	declare	vSakittenggorokan varchar(10);
	declare	vSulitbernafas varchar(10);
	declare lanjut varchar(5) default 'Ya';
	declare	vdiagnosa varchar(10);
	declare totalflu int;
	
	declare entropy decimal(8,4);
	declare cData cursor for
	select * from tblData;
	
	select count(*) into total from tblData ;
	select count(*) into totaldemam from tblData where diagnosa = 'Demam' ;
	select count(*) into totalflu from tblData where diagnosa = 'Flu' ;
	set entropy = sfEntropy(totaldemam,total,totalflu);
	insert into tblTampung values ('1','','total',total,totaldemam,totalflu,entropy,0);
	set @entropy = entropy;
	while lanjut = 'Ya' do
	open cData;
		begin	
		declare ventropy decimal(8,4);
		
		while i <> total do
			fetch cData INTO vNo,vDemam,vSakitkepala,vNyeri,vLemas,vKelelahan,vHidungtersumbat,vBersin,vSakittenggorokan,vSulitbernafas,vdiagnosa;
			begin 
			if kategori = 'Demam' then
			if vDemam = 'Tidak' then
				if vdiagnosa = 'Demam' then
					set hitungdemam = hitungdemam +1 ;
				else
					set hitungflu = hitungflu + 1;
				end if;
				set hitung = hitung +1;
			end if;
			if vDemam ='Ringan'then
				if vdiagnosa = 'Demam' then
					set hitungdemam1 = hitungdemam1 +1 ;
				else
					set hitungflu1 = hitungflu1 + 1;
				end if;
				set hitung1 = hitung1 +1;	
			end if;		
			if vDemam = 'Parah' then
				if vdiagnosa = 'Demam' then
					set hitungdemam2 = hitungdemam2 +1 ;
				else
					set hitungflu2 = hitungflu2 +1;
				end if;
				set hitung2 = hitung2 +1;	
			end if;
		end if;
			if kategori = 'Kepala' then
			if vSakitkepala = 'Tidak' then
				if vdiagnosa = 'Demam' then
					set hitungdemam = hitungdemam +1 ;
				else
					set hitungflu = hitungflu + 1;
				end if;
				set hitung = hitung +1;
			end if;
			if vSakitkepala ='Ringan'then
				if vdiagnosa = 'Demam' then
					set hitungdemam1 = hitungdemam1 +1 ;
				else
					set hitungflu1 = hitungflu1 + 1;
				end if;
				set hitung1 = hitung1 +1;	
			end if;		
			if vSakitkepala = 'Parah' then
				if vdiagnosa = 'Demam' then
					set hitungdemam2 = hitungdemam2 +1 ;
				else
					set hitungflu2 = hitungflu2 +1;
				end if;
				set hitung2 = hitung2 +1;	
			end if;
		end if;
		if kategori = 'Nyeri' then
			if vNyeri = 'Tidak' then
				if vdiagnosa = 'Demam' then
					set hitungdemam = hitungdemam +1 ;
				else
					set hitungflu = hitungflu + 1;
				end if;
				set hitung = hitung +1;
			end if;
			if vNyeri ='Ringan'then
				if vdiagnosa = 'Demam' then
					set hitungdemam1 = hitungdemam1 +1 ;
				else
					set hitungflu1 = hitungflu1 + 1;
				end if;
				set hitung1 = hitung1 +1;	
			end if;		
			if vNyeri = 'Parah' then
				if vdiagnosa = 'Demam' then
					set hitungdemam2 = hitungdemam2 +1 ;
				else
					set hitungflu2 = hitungflu2 +1;
				end if;
				set hitung2 = hitung2 +1;	
			end if;
		end if;
		if kategori = 'Lemas' then
			if vLemas = 'Tidak' then
				if vdiagnosa = 'Demam' then
					set hitungdemam = hitungdemam +1 ;
				else
					set hitungflu = hitungflu + 1;
				end if;
				set hitung = hitung +1;
			end if;
			if vLemas ='Ringan'then
				if vdiagnosa = 'Demam' then
					set hitungdemam1 = hitungdemam1 +1 ;
				else
					set hitungflu1 = hitungflu1 + 1;
				end if;
				set hitung1 = hitung1 +1;	
			end if;		
			if vLemas = 'Parah' then
				if vdiagnosa = 'Demam' then
					set hitungdemam2 = hitungdemam2 +1 ;
				else
					set hitungflu2 = hitungflu2 +1;
				end if;
				set hitung2 = hitung2 +1;	
			end if;
		end if;
		if kategori = 'Kelelahan' then
			if vKelelahan = 'Tidak' then
				if vdiagnosa = 'Demam' then
					set hitungdemam = hitungdemam +1 ;
				else
					set hitungflu = hitungflu + 1;
				end if;
				set hitung = hitung +1;
			end if;
			if vKelelahan ='Ringan'then
				if vdiagnosa = 'Demam' then
					set hitungdemam1 = hitungdemam1 +1 ;
				else
					set hitungflu1 = hitungflu1 + 1;
				end if;
				set hitung1 = hitung1 +1;	
			end if;		
			if vKelelahan = 'Parah' then
				if vdiagnosa = 'Demam' then
					set hitungdemam2 = hitungdemam2 +1 ;
				else
					set hitungflu2 = hitungflu2 +1;
				end if;
				set hitung2 = hitung2 +1;	
			end if;
		end if;
		if kategori = 'Hidung Tersumbat' then
			if vHidungtersumbat = 'Tidak' then
				if vdiagnosa = 'Demam' then
					set hitungdemam = hitungdemam +1 ;
				else
					set hitungflu = hitungflu + 1;
				end if;
				set hitung = hitung +1;
			end if;
			if vHidungtersumbat ='Ringan'then
				if vdiagnosa = 'Demam' then
					set hitungdemam1 = hitungdemam1 +1 ;
				else
					set hitungflu1 = hitungflu1 + 1;
				end if;
				set hitung1 = hitung1 +1;	
			end if;		
			if vHidungtersumbat = 'Parah' then
				if vdiagnosa = 'Demam' then
					set hitungdemam2 = hitungdemam2 +1 ;
				else
					set hitungflu2 = hitungflu2 +1;
				end if;
				set hitung2 = hitung2 +1;	
			end if;
		end if;
		if kategori = 'Bersin' then
			if vBersin = 'Tidak' then
				if vdiagnosa = 'Demam' then
					set hitungdemam = hitungdemam +1 ;
				else
					set hitungflu = hitungflu + 1;
				end if;
				set hitung = hitung +1;
			end if;
			if vBersin ='Ringan'then
				if vdiagnosa = 'Demam' then
					set hitungdemam1 = hitungdemam1 +1 ;
				else
					set hitungflu1 = hitungflu1 + 1;
				end if;
				set hitung1 = hitung1 +1;	
			end if;		
			if vBersin = 'Parah' then
				if vdiagnosa = 'Demam' then
					set hitungdemam2 = hitungdemam2 +1 ;
				else
					set hitungflu2 = hitungflu2 +1;
				end if;
				set hitung2 = hitung2 +1;	
			end if;
		end if;
		if kategori = 'Sakit Tenggorokan' then
			if vSakittenggorokan = 'Tidak' then
				if vdiagnosa = 'Demam' then
					set hitungdemam = hitungdemam +1 ;
				else
					set hitungflu = hitungflu + 1;
				end if;
				set hitung = hitung +1;
			end if;
			if vSakittenggorokan ='Ringan'then
				if vdiagnosa = 'Demam' then
					set hitungdemam1 = hitungdemam1 +1 ;
				else
					set hitungflu1 = hitungflu1 + 1;
				end if;
				set hitung1 = hitung1 +1;	
			end if;		
			if vSakittenggorokan = 'Parah' then
				if vdiagnosa = 'Demam' then
					set hitungdemam2 = hitungdemam2 +1 ;
				else
					set hitungflu2 = hitungflu2 +1;
				end if;
				set hitung2 = hitung2 +1;	
			end if;
		end if;
		if kategori = 'Sulit Bernafas' then
			if vSulitbernafas = 'Tidak' then
				if vdiagnosa = 'Demam' then
					set hitungdemam = hitungdemam +1 ;
				else
					set hitungflu = hitungflu + 1;
				end if;
				set hitung = hitung +1;
			end if;
			if vSulitbernafas ='Ringan'then
				if vdiagnosa = 'Demam' then
					set hitungdemam1 = hitungdemam1 +1 ;
				else
					set hitungflu1 = hitungflu1 + 1;
				end if;
				set hitung1 = hitung1 +1;	
			end if;		
			if vSulitbernafas = 'Parah' then
				if vdiagnosa = 'Demam' then
					set hitungdemam2 = hitungdemam2 +1 ;
				else
					set hitungflu2 = hitungflu2 +1;
				end if;
				set hitung2 = hitung2 +1;	
			end if;
		end if;
			
			
			end;	
			set i = i +1 ;
		end while;
		
	close cData;
	
	if kategori = 'Demam' then
		set ventropy = sfEntropy(hitungdemam,hitung,hitungflu);
		set @total = total;
		insert into tblTampung values('1','Demam','Tidak',hitung,hitungdemam,hitungflu,ventropy,0);
		set ventropy = sfEntropy(hitungdemam1,hitung1,hitungflu1);
		insert into tblTampung values('1','Demam','Ringan',hitung1,hitungdemam1,hitungflu1,ventropy,0);
		set ventropy = sfEntropy(hitungdemam2,hitung2,hitungflu2);
		insert into tblTampung values('1','Demam','Parah',hitung2,hitungdemam2,hitungflu2,ventropy,0);
	end if;
	if kategori = 'Kepala' then
		set ventropy = sfEntropy(hitungdemam,hitung,hitungflu);
		insert into tblTampung values('1','Kepala','Tidak',hitung,hitungdemam,hitungflu,ventropy,0);
		set ventropy = sfEntropy(hitungdemam1,hitung1,hitungflu1);
		insert into tblTampung values('1','Kepala','Ringan',hitung1,hitungdemam1,hitungflu1,ventropy,0);
		set ventropy = sfEntropy(hitungdemam2,hitung2,hitungflu2);
		insert into tblTampung values('1','Kepala','Parah',hitung2,hitungdemam2,hitungflu2,ventropy,0);
	end if;
	if kategori = 'Nyeri' then
		set ventropy = sfEntropy(hitungdemam,hitung,hitungflu);
		insert into tblTampung values('1','Nyeri','Tidak',hitung,hitungdemam,hitungflu,ventropy,0);
		set ventropy = sfEntropy(hitungdemam1,hitung1,hitungflu1);
		insert into tblTampung values('1','Nyeri','Ringan',hitung1,hitungdemam1,hitungflu1,ventropy,0);
		set ventropy = sfEntropy(hitungdemam2,hitung2,hitungflu2);
		insert into tblTampung values('1','Nyeri','Parah',hitung2,hitungdemam2,hitungflu2,ventropy,0);
	end if;
	if kategori = 'Lemas' then
		set ventropy = sfEntropy(hitungdemam,hitung,hitungflu);
		insert into tblTampung values('1','Lemas','Tidak',hitung,hitungdemam,hitungflu,ventropy,0);
		set ventropy = sfEntropy(hitungdemam1,hitung1,hitungflu1);
		insert into tblTampung values('1','Lemas','Ringan',hitung1,hitungdemam1,hitungflu1,ventropy,0);
		set ventropy = sfEntropy(hitungdemam2,hitung2,hitungflu2);
		insert into tblTampung values('1','Lemas','Parah',hitung2,hitungdemam2,hitungflu2,ventropy,0);
	end if;
	if kategori = 'Kelelahan' then
		set ventropy = sfEntropy(hitungdemam,hitung,hitungflu);
		insert into tblTampung values('1','Kelelahan','Tidak',hitung,hitungdemam,hitungflu,ventropy,0);
		set ventropy = sfEntropy(hitungdemam1,hitung1,hitungflu1);
		insert into tblTampung values('1','Kelelahan','Ringan',hitung1,hitungdemam1,hitungflu1,ventropy,0);
		set ventropy = sfEntropy(hitungdemam2,hitung2,hitungflu2);
		insert into tblTampung values('1','Kelelahan','Parah',hitung2,hitungdemam2,hitungflu2,ventropy,0);
	end if;
	if kategori = 'Hidung Tersumbat' then
		set ventropy = sfEntropy(hitungdemam,hitung,hitungflu);
		insert into tblTampung values('1','Hidung Tersumbat','Tidak',hitung,hitungdemam,hitungflu,ventropy,0);
		set ventropy = sfEntropy(hitungdemam1,hitung1,hitungflu1);
		insert into tblTampung values('1','Hidung Tersumbat','Ringan',hitung1,hitungdemam1,hitungflu1,ventropy,0);
		set ventropy = sfEntropy(hitungdemam2,hitung2,hitungflu2);
		insert into tblTampung values('1','Hidung Tersumbat','Parah',hitung2,hitungdemam2,hitungflu2,ventropy,0);
	end if;
	if kategori = 'Bersin' then
		set ventropy = sfEntropy(hitungdemam,hitung,hitungflu);
		insert into tblTampung values('1','Bersin','Tidak',hitung,hitungdemam,hitungflu,ventropy,0);
		set ventropy = sfEntropy(hitungdemam1,hitung1,hitungflu1);
		insert into tblTampung values('1','Bersin','Ringan',hitung1,hitungdemam1,hitungflu1,ventropy,0);
		set ventropy = sfEntropy(hitungdemam2,hitung2,hitungflu2);
		insert into tblTampung values('1','Bersin','Parah',hitung2,hitungdemam2,hitungflu2,ventropy,0);
	end if;
	if kategori = 'Sakit Tenggorokan' then
		set ventropy = sfEntropy(hitungdemam,hitung,hitungflu);
		insert into tblTampung values('1','Sakit Tenggorokan','Tidak',hitung,hitungdemam,hitungflu,ventropy,0);
		set ventropy = sfEntropy(hitungdemam1,hitung1,hitungflu1);
		insert into tblTampung values('1','Sakit Tenggorokan','Ringan',hitung1,hitungdemam1,hitungflu1,ventropy,0);
		set ventropy = sfEntropy(hitungdemam2,hitung2,hitungflu2);
		insert into tblTampung values('1','Sakit Tenggorokan','Parah',hitung2,hitungdemam2,hitungflu2,ventropy,0);
	end if;
		if kategori = 'Sulit Bernafas' then
		set ventropy = sfEntropy(hitungdemam,hitung,hitungflu);
		insert into tblTampung values('1','Sulit Bernafas','Tidak',hitung,hitungdemam,hitungflu,ventropy,0);
		set ventropy = sfEntropy(hitungdemam1,hitung1,hitungflu1);
		insert into tblTampung values('1','Sulit Bernafas','Ringan',hitung1,hitungdemam1,hitungflu1,ventropy,0);
		set ventropy = sfEntropy(hitungdemam2,hitung2,hitungflu2);
		insert into tblTampung values('1','Sulit Bernafas','Parah',hitung2,hitungdemam2,hitungflu2,ventropy,0);
	end if;
	end;

	set lanjut ='Tidak';
	

	

	end while;
end $$
delimiter ;
call spHitung('Demam');
call spHitung('Kepala');
call spHitung('Nyeri');
call spHitung('Lemas');
call spHitung('Kelelahan');
call spHitung('Hidung Tersumbat');
call spHitung('Bersin');
call spHitung('Sakit Tenggorokan');
call spHitung('Sulit Bernafas');


insert into tblGain(kete,gain)
 select keterangan,@entropy-sum((jumlah/@total)*entropy) as gain
 from tblTampung
 group by keterangan;

update tblGain set gain = 0 where kete = ''; 


 update tblTampung set gain =
 (
	select gain 
	from tblGain
	where kete = tblTampung.keterangan
);
select * from tblGain;
select * from tblTampung;
select max(gain) into @max from tblTampung;
select @max;
select max(demam) into @demam from tblTampung where gain = @max;
select @demam;
select max(flu) into @flu from tblTampung where gain = @max;
select @flu;
set @kesimpulan = if(@demam>@flu,'Demam','Flu');
select @kesimpulan;
select iterasi,keterangan,gain,@kesimpulan as Kesimpulan from tblTampung where gain = @max and  demam = @demam;
