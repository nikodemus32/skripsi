-- Kevin Victor A. - 18.K1.0011
DROP DATABASE IF EXISTS UAS_18k10011;
CREATE DATABASE UAS_18k10011;
USE UAS_18k10011;

CREATE TABLE tblData
(
	Pasien varchar(10),
	Demam varchar(10),
	SakitKepala varchar(10),
	Nyeri varchar(10),
	Lemas varchar(10),
	Kelelahan varchar(10),
	HidungTersumbat varchar(10),
	Bersin varchar(10),
	SakitTenggorokan varchar(10),
	SulitBernafas varchar(10),
	Diagnosa varchar(10)
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

SELECT * FROM tblData;

CREATE TABLE tblSementara
(
	Iterasi int,
	Pasien varchar(10),
	Demam varchar(10),
	SakitKepala varchar(10),
	Nyeri varchar(10),
	Lemas varchar(10),
	Kelelahan varchar(10),
	HidungTersumbat varchar(10),
	Bersin varchar(10),
	SakitTenggorokan varchar(10),
	SulitBernafas varchar(10),
	Diagnosa varchar(10)
);

create table tblHitung(
	Iterasi int,
  	atribut varchar(20),
  	informasi varchar(20),
  	jumlahdata int,
  	d_demam int,
  	d_flu int,
  	entropy decimal(8,4),
  	gain decimal(8,4)
);

create table tblGain
(
    iterasi int,
    atribut varchar(20),
    informasi varchar(20),
    gain decimal(8,4)
);

create table tblMaxGain
(
    iterasi int,
    atribut varchar(20),
    informasi varchar(20),
    gain decimal(8,4)
);


delimiter @@
CREATE PROCEDURE spMasukData(noIterasi int)
BEGIN

    INSERT INTO tblSementara
    SELECT noIterasi, Pasien, Demam, SakitKepala, Nyeri, Lemas, Kelelahan,
    		HidungTersumbat, Bersin, SakitTenggorokan, SulitBernafas, Diagnosa from tblData;
    call spHapus(noIterasi);
    call spHitung(noIterasi);

end @@
delimiter ;


-- masukan rumus entropy
delimiter @@
CREATE FUNCTION sfEntropy(pjumlahdata int, pd_demam int, pd_flu int)
returns decimal(8,4)
BEGIN

  	declare vEntropy decimal(8,4);

  	set vEntropy=(-(pd_demam/pjumlahdata)*log2(pd_demam/pjumlahdata))+
    	(-(pd_flu/pjumlahdata)*log2(pd_flu/pjumlahdata));
  
  	return(vEntropy);

end @@
delimiter ;


SELECT COUNT(*) INTO @jumlahdata
FROM tblData;

SELECT COUNT(*) INTO  @d_demam
FROM tblData
WHERE Diagnosa = 'Demam';

SELECT COUNT(*) INTO @d_flu
FROM tblData
WHERE Diagnosa = 'Flu';

set @entropy := sfEntropy(@jumlahdata,@d_demam,@d_flu);

SELECT @jumlahdata as JUM_DATA,
@d_demam as Diagnosa_DEMAM,
@d_flu as Diagnosa_FLU,
ROUND(@entropy, 4) as ENTROPY;

INSERT INTO tblHitung(atribut, jumlahdata, d_demam, d_flu, entropy) VALUES
('TOTAL DATA', @jumlahdata, @d_demam, @d_flu, @entropy);

SELECT * FROM tblHitung;


delimiter @@
CREATE PROCEDURE spHitungEntropy(no_Iterasi int)
BEGIN

    UPDATE tblHitung set entropy = @entropy where d_demam !=0 and d_flu !=0;
    UPDATE tblHitung set entropy = 0 WHERE entropy is null;
    call spHitungGain(no_Iterasi);

end @@
delimiter ;


delimiter @@
CREATE PROCEDURE spHitungGain(noIterasi int)
BEGIN

	declare vEntropy decimal(8,4);
	declare vJumData, vJumGain int default 0;
	select jumlahdata into vJumData from tblHitung where iterasi=noIterasi limit 1;
	select entropy into vEntropy from tblHitung where iterasi=noIterasi limit 1;

	insert into tblGain(iterasi, atribut, gain)
	  select noIterasi, atribut, abs(vEntropy - SUM((jumlahdata/vJumData) * entropy)) AS ENTROPY
	  from tblHitung
	  where iterasi = noIterasi
    group by atribut;

  	update tblHitung set gain =
    (
      select gain
      from tblGain
      where atribut = tblHitung.atribut and iterasi = noIterasi
    )
  	where iterasi = noIterasi;

  	select MAX(gain) into @gain from tblGain where iterasi = noIterasi;

  	insert into tblMaxGain(iterasi, atribut, informasi, gain)
    select iterasi, atribut, informasi, gain
    from tblHitung
    where gain = @gain and d_demam != 0 and d_flu != 0 and iterasi = noIterasi limit 1;

  	select count(*) into vJumGain from tblMaxGain where iterasi = noIterasi;
  	if vJumGain < 1 then
		insert into tblMaxGain(iterasi, atribut, informasi, gain)
	    select iterasi, atribut, 'selesai', gain
	    from tblHitung
	    where gain = @gain and iterasi = noIterasi limit 1;
  	end if;

end @@
delimiter ;


delimiter @@
CREATE PROCEDURE spHitung(noIterasi int)
BEGIN

  	declare vD_Demam, vD_Flu, vJumlahdata, i, vJumData int;
  	declare vIterasi, vAtribut, vInformasi varchar(20);
  	declare vGain decimal(8,4);
  	declare cHapus cursor for select * from tblMaxGain;
  
  	select count(*) into vJumData from tblMaxGain;
  	select count(*) into vD_Demam from tblSementara where Diagnosa = 'Demam' and iterasi = noIterasi;
  	select count(*) into vD_Flu from tblSementara where Diagnosa = 'Flu' and iterasi = noIterasi;
	  set vJumlahdata = vD_Demam + vD_Flu;
	    insert into tblHitung (iterasi, atribut, informasi, jumlahdata, d_demam, d_flu) 
	    	values (noIterasi, 'TOTAL DATA', '', vJumlahdata, vD_Demam, vD_Flu);
	
-- demam
	insert into tblHitung(iterasi, informasi, atribut, jumlahdata, d_demam, d_flu)
	  select distinct noIterasi, (A.Demam), 'Demam',
	  (select count(*) from tblSementara where Demam = A.Demam and iterasi = noIterasi),
	  (select count(*) from tblSementara where Diagnosa = 'Demam' and Demam = A.Demam and iterasi = noIterasi),
	  (select count(*) from tblSementara where Diagnosa = 'Flu' and Demam = A.Demam and iterasi = noIterasi)
	  from tblSementara as A where iterasi = noIterasi;

-- sakit kepala
	insert into tblHitung(iterasi, informasi, atribut, jumlahdata, d_demam, d_flu)
	  select distinct noIterasi, (A.SakitKepala), 'SakitKepala',
	  (select count(*) from tblSementara where SakitKepala = A.SakitKepala and iterasi = noIterasi),
	  (select count(*) from tblSementara where Diagnosa = 'Demam' and SakitKepala = A.SakitKepala and iterasi = noIterasi),
	  (select count(*) from tblSementara where Diagnosa = 'Flu' and SakitKepala = A.SakitKepala and iterasi = noIterasi)
	  from tblSementara as A where iterasi = noIterasi;

-- nyeri
	insert into tblHitung(iterasi, informasi, atribut, jumlahdata, d_demam, d_flu)
	  select distinct noIterasi, (A.Nyeri), 'Nyeri',
	  (select count(*) from tblSementara where Nyeri = A.Nyeri and iterasi = noIterasi),
	  (select count(*) from tblSementara where Diagnosa = 'Demam' and Nyeri = A.Nyeri and iterasi = noIterasi),
	  (select count(*) from tblSementara where Diagnosa = 'Flu' and Nyeri = A.Nyeri and iterasi = noIterasi)
	  from tblSementara as A where iterasi = noIterasi;

-- lemas
	insert into tblHitung(iterasi, informasi, atribut, jumlahdata, d_demam, d_flu)
	  select distinct noIterasi, (A.Lemas), 'Lemas',
	  (select count(*) from tblSementara where Lemas = A.Lemas and iterasi = noIterasi),
	  (select count(*) from tblSementara where Diagnosa = 'Demam' and Lemas = A.Lemas and iterasi = noIterasi),
	  (select count(*) from tblSementara where Diagnosa = 'Flu' and Lemas = A.Lemas and iterasi = noIterasi)
	  from tblSementara as A where iterasi = noIterasi;

-- kelelahan
	insert into tblHitung(iterasi, informasi, atribut, jumlahdata, d_demam, d_flu)
	  select distinct noIterasi, (A.Kelelahan), 'Kelelahan',
	  (select count(*) from tblSementara where Kelelahan = A.Kelelahan and iterasi = noIterasi),
	  (select count(*) from tblSementara where Diagnosa = 'Demam' and Kelelahan = A.Kelelahan and iterasi = noIterasi),
	  (select count(*) from tblSementara where Diagnosa = 'Flu' and Kelelahan = A.Kelelahan and iterasi = noIterasi)
	  from tblSementara as A where iterasi = noIterasi;

-- hidung tersumbat
	insert into tblHitung(iterasi, informasi, atribut, jumlahdata, d_demam, d_flu)
	  select distinct noIterasi, (A.HidungTersumbat), 'HidungTersumbat',
	  (select count(*) from tblSementara where HidungTersumbat = A.HidungTersumbat and iterasi = noIterasi),
	  (select count(*) from tblSementara where Diagnosa = 'Demam' and HidungTersumbat = A.HidungTersumbat and iterasi = noIterasi),
	  (select count(*) from tblSementara where Diagnosa = 'Flu' and HidungTersumbat = A.HidungTersumbat and iterasi = noIterasi)
	  from tblSementara as A where iterasi = noIterasi;

-- bersin
	insert into tblHitung(iterasi, informasi, atribut, jumlahdata, d_demam, d_flu)
	  select distinct noIterasi, (A.Bersin), 'Bersin',
	  (select count(*) from tblSementara where Bersin = A.Bersin and iterasi = noIterasi),
	  (select count(*) from tblSementara where Diagnosa = 'Demam' and Bersin = A.Bersin and iterasi = noIterasi),
	  (select count(*) from tblSementara where Diagnosa = 'Flu' and Bersin = A.Bersin and iterasi = noIterasi)
	  from tblSementara as A where iterasi = noIterasi;

-- sakit tenggorokan
	insert into tblHitung(iterasi, informasi, atribut, jumlahdata, d_demam, d_flu)
	  select distinct noIterasi, (A.SakitTenggorokan), 'SakitTenggorokan',
	  (select count(*) from tblSementara where SakitTenggorokan = A.SakitTenggorokan and iterasi = noIterasi),
	  (select count(*) from tblSementara where Diagnosa = 'Demam' and SakitTenggorokan = A.SakitTenggorokan and iterasi = noIterasi),
	  (select count(*) from tblSementara where Diagnosa = 'Flu' and SakitTenggorokan = A.SakitTenggorokan and iterasi = noIterasi)
	  from tblSementara as A where iterasi = noIterasi;

-- sulit bernapas
	insert into tblHitung(iterasi, informasi, atribut, jumlahdata, d_demam, d_flu)
	  select distinct noIterasi, (A.SulitBernafas), 'SulitBernafas',
	  (select count(*) from tblSementara where SulitBernafas = A.SulitBernafas and iterasi = noIterasi),
	  (select count(*) from tblSementara where Diagnosa = 'Demam' and SulitBernafas = A.SulitBernafas and iterasi = noIterasi),
	  (select count(*) from tblSementara where Diagnosa = 'Flu' and SulitBernafas = A.SulitBernafas and iterasi = noIterasi)
	  from tblSementara as A where iterasi = noIterasi;

	set i=0;
	open cHapus;
	while i <> vJumData do
	  fetch cHapus into vIterasi, vAtribut, vInformasi, vGain;
	  delete from tblHitung where iterasi=noIterasi and atribut=vAtribut;
	  set i=i+1;
  	end while;

end @@
delimiter ;


delimiter @@
CREATE PROCEDURE spHapus(noIterasi int)
BEGIN

	declare i, j, vJumData, vJumData2, vIterasi, vIterasi2 int default 0;
    declare vPasien, vDemam, vSakitKepala, vNyeri, vLemas, vKelelahan, vHidungTersumbat, vBersin,
    					vSakitTenggorokan, vSulitBernafas, vDiagnosa, vAtribut, vInformasi varchar(20);
    declare vGain decimal(8,4);
    declare cTampung cursor for select * from tblSementara where iterasi=noIterasi;
    declare cMaxGain cursor for select * from tblMaxGain;
    select count(*) into vJumData from tblSementara where iterasi=noIterasi;
    select count(*) into vJumData2 from tblMaxGain;

    open cTampung;
    while i <> vJumData do
    	fetch cTampung into vIterasi, vPasien ,vDemam, vSakitKepala, vNyeri, vLemas, vKelelahan, vHidungTersumbat, vBersin,
      						vSakitTenggorokan, vSulitBernafas , vDiagnosa;
    	set j=0;
    	open cMaxGain;

      	while j <> vJumData2 do
        	fetch cMaxGain into vIterasi2, vAtribut, vInformasi, vGain;
            	if vAtribut = 'Demam' then
             		delete from tblSementara where vDemam <> vInformasi and iterasi = noIterasi and pasien = vPasien;
            	elseif vAtribut = 'SakitKepala' then
              		delete from tblSementara where vSakitKepala <> vInformasi and iterasi = noIterasi and pasien = vPasien;
            	elseif vAtribut = 'Nyeri' then
              		delete from tblSementara where vNyeri <> vInformasi and iterasi = noIterasi and pasien = vPasien;
            	elseif vAtribut = 'Lemas' then
              		delete from tblSementara where vLemas <> vInformasi and iterasi = noIterasi and pasien = vPasien;
                elseif vAtribut = 'Kelelahan' then
              		delete from tblSementara where vKelelahan <> vInformasi and iterasi = noIterasi and pasien = vPasien;
                elseif vAtribut = 'HidungTersumbat' then
               		delete from tblSementara where vHidungTersumbat <> vInformasi and iterasi = noIterasi and pasien = vPasien;
                elseif vAtribut = 'Bersin' then
              		delete from tblSementara where vBersin <> vInformasi and iterasi = noIterasi and pasien = vPasien;
            	elseif vAtribut = 'SakitTenggorokan' then
              		delete from tblSementara where vSakitTenggorokan <> vInformasi and iterasi = noIterasi and pasien = vPasien;
                elseif vAtribut = 'SulitBernafas' then
              		delete from tblSementara where vSulitBernafas <> vInformasi and iterasi = noIterasi and pasien = vPasien;       
        		end if;

      		set j=j+1;
    	end while;
    	close cMaxGain;
  	set i=i+1;
  	end while;

  	close cTampung;

end @@
delimiter ;


delimiter @@
CREATE PROCEDURE spLooping()
BEGIN

	declare i, vIterasi int default 1;
	declare vStop int default 0;
	while i = 1 do
    call spMasukData(vIterasi);
    call spHitungEntropy(vIterasi);

    	set vIterasi = vIterasi + 1;
    	select * from tblSementara;
    	select * from tblHitung;
    	select * from tblMaxGain;
    	select count(informasi) into vStop from tblMaxGain where informasi = 'selesai';
    
    	if vStop > 0 then
      		set i = 2;
    	end if;
  	end while;

end @@
delimiter ;

call spLooping();

SELECT 'Hitungan selesai pada iterasi pertama' as Kesimpulan;