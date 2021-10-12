/*Paskal Setiaji || 18.K1.0032*/
drop database if exists dbC45_UAS;
create database dbC45_UAS;
use dbC45_UAS;

create table tblC45
(
    pasien VARCHAR (20),
    Demam varchar(20),
    Sakit_Kepala varchar(20),
    Nyeri varchar(20),
    Lemas varchar(20),
    Kelelahan varchar(20),
    Hidung_Tersumbat varchar(20),
    Bersin varchar(20),
    Sakit_Tenggorokan varchar(20),
    Sulit_Bernafas varchar(20),
    diagnosa varchar(20)
);

create table tblTemp
(
    iterasi int,
    pasien VARCHAR (20),
    Demam varchar(20),
    Sakit_Kepala varchar(20),
    Nyeri varchar(20),
    Lemas varchar(20),
    Kelelahan varchar(20),
    Hidung_Tersumbat varchar(20),
    Bersin varchar(20),
    Sakit_Tenggorokan varchar(20),
    Sulit_Bernafas varchar(20),
    diagnosa varchar(20)
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

insert into tblC45 values 
("P1","Tidak","Ringan", "Tidak", "Tidak", "Tidak", "Ringan","Parah", "Parah", "Ringan","Demam"),
("P2", "Parah",	"Parah" ,"Parah", "Parah", "Parah", "Tidak", "Tidak", "Parah", "Parah", "Flu"),
("P3", "Parah",	"Parah" ,"Ringan", "Parah", "Parah", "Parah", "Tidak", "Parah", "Parah", "Flu"),
("P4", "Tidak",	"Tidak" ,"Tidak", "Ringan", "Tidak", "Parah", "Tidak", "Ringan", "Ringan", "Demam"),
("P5", "Parah",	"Parah" ,"Ringan", "Parah", "Parah", "Parah", "Tidak", "Parah", "Parah", "Flu"),
("P6", "Tidak",	"Tidak" ,"Tidak", "Ringan", "Tidak", "Parah", "Parah", "Parah", "Tidak", "Demam"),
("P7", "Parah",	"Parah" ,"Parah", "Parah", "Parah", "Tidak", "Tidak", "Tidak", "Parah", "Flu"),
("P8", "Tidak",	"Tidak" ,"Tidak", "Tidak", "Tidak", "Parah", "Parah", "Tidak", "Ringan", "Demam"),
("P9", "Tidak",	"Ringan", "Ringan", "Tidak", "Tidak", "Parah", "Parah", "Parah", "Parah", "Demam"),
("P10","Parah","Parah","Parah", "Ringan", "Ringan", "Tidak","Parah", "Tidak", "Parah", "Flu"),
("P11","Tidak","Tidak","Tidak", "Ringan", "Tidak", "Parah","Ringan", "Parah", "Tidak", "Demam"),
("P12","Parah","Ringan","Parah", "Ringan", "Parah", "Tidak","Parah", "Tidak", "Ringan", "Flu"),
("P13","Tidak","Tidak","Ringan", "Ringan", "Tidak", "Parah","Parah", "Parah", "Tidak", "Demam"),
("P14","Parah","Parah","Parah", "Parah", "Ringan", "Tidak","Parah", "Parah", "Parah", "Flu"),
("P15","Ringan","Tidak","Tidak", "Ringan", "Tidak", "Parah","Tidak", "Parah", "Ringan", "Demam"),
("P16","Tidak","Tidak","Tidak", "Tidak", "Tidak", "Parah","Parah", "Parah", "Parah", "Demam"),
("P17","Parah","Ringan","Parah", "Ringan", "Ringan", "Tidak","Tidak", "Tidak", "Parah", "Flu");

select * from tblC45;

create table tblHitung
(
    iterasi int,
    atribut varchar(20),
    informasi varchar(20),
    jumlahdata int,
    diagnosademam int,
    diagnosaflu int,
    entropy decimal(8,4),
    gain decimal(8,4)
);

delimiter $$
create procedure spEntropy(no_Iterasi int)
begin
    insert into tblTemp
    select no_Iterasi, pasien, Demam, Sakit_Kepala, Nyeri, Lemas, Kelelahan, Hidung_Tersumbat, Bersin, Sakit_Tenggorokan, Sulit_Bernafas, diagnosa from tblC45;
    call spDelete(no_Iterasi);
    call spHitung(no_Iterasi);
end $$
delimiter ;

delimiter $$
create procedure spHitEntropy(no_Iterasi int)
begin
    update tblHitung set entropy = (-(diagnosademam/jumlahdata)*log2(diagnosademam/jumlahdata)) + (-(diagnosaflu/jumlahdata)*log2(diagnosaflu/jumlahdata)) where diagnosademam !=0 and diagnosaflu!=0;
    update tblHitung set entropy = 0 where entropy is null;
    call spHitungGain(no_Iterasi);
end $$
delimiter ;

delimiter $$
create procedure spHitung(no_Iterasi int)
begin
  declare vDiagnosa_Demam, vDiagnosa_Flu, vJumlahdata, i, vJumData int;
  declare vIterasi, vAtribut, vInformasi varchar(20);
  declare vGain decimal(8,4);
  declare cDelete cursor for select * from tblMaxGain;
  
  select count(*) into vJumData from tblMaxGain;
  select count(*) into vDiagnosa_Demam from tblTemp where diagnosa = 'Demam' and iterasi=no_Iterasi;
  select count(*) into vDiagnosa_Flu from tblTemp where diagnosa = 'Flu' and iterasi=no_Iterasi;
  set vJumlahdata = vDiagnosa_Demam + vDiagnosa_Flu;
    insert into tblHitung (iterasi, atribut, informasi, jumlahdata, diagnosademam, diagnosaflu) values (no_Iterasi, 'TOTAL DATA', '', vJumlahdata, vDiagnosa_Demam, vDiagnosa_Flu);

/*demam*/
  insert into tblHitung(iterasi, informasi, atribut, jumlahdata, diagnosademam, diagnosaflu)
    select distinct no_Iterasi, (A.Demam), 'Demam',
    (select count(*) from tblTemp where Demam=A.Demam and iterasi=no_Iterasi),
    (select count(*) from tblTemp where diagnosa='Demam' and Demam=A.Demam and iterasi=no_Iterasi),
    (select count(*) from tblTemp where diagnosa='Flu' and Demam=A.Demam and iterasi=no_Iterasi)
    from tblTemp as A where iterasi=no_Iterasi;

/*sakit kepala*/
  insert into tblHitung(iterasi, informasi, atribut, jumlahdata, diagnosademam, diagnosaflu)
    select distinct no_Iterasi, (A.Sakit_Kepala), 'Sakit_Kepala',
    (select count(*) from tblTemp where Sakit_Kepala=A.Sakit_Kepala and iterasi=no_Iterasi),
    (select count(*) from tblTemp where diagnosa='Demam' and Sakit_Kepala=A.Sakit_Kepala and iterasi=no_Iterasi),
    (select count(*) from tblTemp where diagnosa='Flu' and Sakit_Kepala=A.Sakit_Kepala and iterasi=no_Iterasi)
    from tblTemp as A where iterasi=no_Iterasi;

/*nyeri*/
  insert into tblHitung(iterasi, informasi, atribut, jumlahdata, diagnosademam, diagnosaflu)
    select distinct no_Iterasi, (A.Nyeri), 'Nyeri',
    (select count(*) from tblTemp where Nyeri=A.Nyeri and iterasi=no_Iterasi),
    (select count(*) from tblTemp where diagnosa='Demam' and Nyeri=A.Nyeri and iterasi=no_Iterasi),
    (select count(*) from tblTemp where diagnosa='Flu' and Nyeri=A.Nyeri and iterasi=no_Iterasi)
    from tblTemp as A where iterasi=no_Iterasi;

/*lemas*/
  insert into tblHitung(iterasi, informasi, atribut, jumlahdata, diagnosademam, diagnosaflu)
    select distinct no_Iterasi, (A.Lemas), 'Lemas',
    (select count(*) from tblTemp where Lemas=A.Lemas and iterasi=no_Iterasi),
    (select count(*) from tblTemp where diagnosa='Demam' and Lemas=A.Lemas and iterasi=no_Iterasi),
    (select count(*) from tblTemp where diagnosa='Flu' and Lemas=A.Lemas and iterasi=no_Iterasi)
    from tblTemp as A where iterasi=no_Iterasi;

/*kelelahan*/
  insert into tblHitung(iterasi, informasi, atribut, jumlahdata, diagnosademam, diagnosaflu)
    select distinct no_Iterasi, (A.Kelelahan), 'Kelelahan',
    (select count(*) from tblTemp where Kelelahan=A.Kelelahan and iterasi=no_Iterasi),
    (select count(*) from tblTemp where diagnosa='Demam' and Kelelahan=A.Kelelahan and iterasi=no_Iterasi),
    (select count(*) from tblTemp where diagnosa='Flu' and Kelelahan=A.Kelelahan and iterasi=no_Iterasi)
    from tblTemp as A where iterasi=no_Iterasi;

/*hidung tersumbat*/
  insert into tblHitung(iterasi, informasi, atribut, jumlahdata, diagnosademam, diagnosaflu)
    select distinct no_Iterasi, (A.Hidung_Tersumbat), 'Hidung_Tersumbat',
    (select count(*) from tblTemp where Hidung_Tersumbat=A.Hidung_Tersumbat and iterasi=no_Iterasi),
    (select count(*) from tblTemp where diagnosa='Demam' and Hidung_Tersumbat=A.Hidung_Tersumbat and iterasi=no_Iterasi),
    (select count(*) from tblTemp where diagnosa='Flu' and Hidung_Tersumbat=A.Hidung_Tersumbat and iterasi=no_Iterasi)
    from tblTemp as A where iterasi=no_Iterasi;

/*Bersin*/
  insert into tblHitung(iterasi, informasi, atribut, jumlahdata, diagnosademam, diagnosaflu)
    select distinct no_Iterasi, (A.Bersin), 'Bersin',
    (select count(*) from tblTemp where Bersin=A.Bersin and iterasi=no_Iterasi),
    (select count(*) from tblTemp where diagnosa='Demam' and Bersin=A.Bersin and iterasi=no_Iterasi),
    (select count(*) from tblTemp where diagnosa='Flu' and Bersin=A.Bersin and iterasi=no_Iterasi)
    from tblTemp as A where iterasi=no_Iterasi;

/*Sakit Tenggorokan*/
  insert into tblHitung(iterasi, informasi, atribut, jumlahdata, diagnosademam, diagnosaflu)
    select distinct no_Iterasi, (A.Sakit_Tenggorokan), 'Sakit_Tenggorokan',
    (select count(*) from tblTemp where Sakit_Tenggorokan=A.Sakit_Tenggorokan and iterasi=no_Iterasi),
    (select count(*) from tblTemp where diagnosa='Demam' and Sakit_Tenggorokan=A.Sakit_Tenggorokan and iterasi=no_Iterasi),
    (select count(*) from tblTemp where diagnosa='Flu' and Sakit_Tenggorokan=A.Sakit_Tenggorokan and iterasi=no_Iterasi)
    from tblTemp as A where iterasi=no_Iterasi;

/*Sulit Bernapas*/
  insert into tblHitung(iterasi, informasi, atribut, jumlahdata, diagnosademam, diagnosaflu)
    select distinct no_Iterasi, (A.Sulit_Bernafas), 'Sulit_Bernafas',
    (select count(*) from tblTemp where Sulit_Bernafas=A.Sulit_Bernafas and iterasi=no_Iterasi),
    (select count(*) from tblTemp where diagnosa='Demam' and Sulit_Bernafas=A.Sulit_Bernafas and iterasi=no_Iterasi),
    (select count(*) from tblTemp where diagnosa='Flu' and Sulit_Bernafas=A.Sulit_Bernafas and iterasi=no_Iterasi)
    from tblTemp as A where iterasi=no_Iterasi;


  set i=0;
  open cDelete;
  while i <> vJumData do
    fetch cDelete into vIterasi, vAtribut, vInformasi, vGain;
    delete from tblHitung where iterasi=no_Iterasi and atribut=vAtribut;
    set i=i+1;
  end while;
end $$
delimiter ;

delimiter $$
create procedure spDelete(no_Iterasi int)
begin
    declare i, j, vJumData, vJumData2, vIterasi, vIterasi2 int default 0;
    declare vPasien, vDemam, vSakit_Kepala, vNyeri, vLemas, vKelelahan, vHidung_Tersumbat, vBersin, vSakit_Tenggorokan, vSulit_Bernafas, vDiagnosa, vAtribut, vInformasi varchar(20);
    declare vGain decimal(8,4);
    declare cTampung cursor for select * from tblTemp where iterasi=no_Iterasi;
    declare cMaxGain cursor for select * from tblMaxGain;
    select count(*) into vJumData from tblTemp where iterasi=no_Iterasi;
    select count(*) into vJumData2 from tblMaxGain;

    open cTampung;
    while i <> vJumData do
      fetch cTampung into vIterasi, vPasien ,vDemam, vSakit_Kepala, vNyeri, vLemas, vKelelahan, vHidung_Tersumbat, vBersin, vSakit_Tenggorokan, vSulit_Bernafas , vDiagnosa;
      set j=0;
      open cMaxGain;

      while j <> vJumData2 do
        fetch cMaxGain into vIterasi2, vAtribut, vInformasi, vGain;
            if vAtribut='Demam' then
				    delete from tblTemp where vDemam <> vInformasi and iterasi=no_Iterasi and pasien=vPasien;
			    elseif vAtribut='Sakit_Kepala' then
				    delete from tblTemp where vSakit_Kepala <> vInformasi and iterasi=no_Iterasi and pasien=vPasien;
			    elseif vAtribut='Nyeri' then
				    delete from tblTemp where vNyeri <> vInformasi and iterasi=no_Iterasi and pasien=vPasien;
			    elseif vAtribut='Lemas' then
				    delete from tblTemp where vLemas <> vInformasi and iterasi=no_Iterasi and pasien=vPasien;
                elseif vAtribut='Kelelahan' then
				    delete from tblTemp where vKelelahan <> vInformasi and iterasi=no_Iterasi and pasien=vPasien;
                elseif vAtribut='Hidung_Tersumbat' then
				    delete from tblTemp where vHidung_Tersumbat <> vInformasi and iterasi=no_Iterasi and pasien=vPasien;
                elseif vAtribut='Bersin' then
				    delete from tblTemp where vBersin <> vInformasi and iterasi=no_Iterasi and pasien=vPasien;
			    elseif vAtribut='Sakit_Tenggorokan' then
				    delete from tblTemp where vSakit_Tenggorokan <> vInformasi and iterasi=no_Iterasi and pasien=vPasien;
                elseif vAtribut='Sulit_Bernafas' then
				    delete from tblTemp where vSulit_Bernafas <> vInformasi and iterasi=no_Iterasi and pasien=vPasien;			  
			  end if;
      set j=j+1;
    end while;
    close cMaxGain;
  set i=i+1;
  end while;

  close cTampung;
end $$
delimiter ;

delimiter $$
create procedure spHitungGain(no_Iterasi int)
begin
  declare vEntropy decimal(8,4);
  declare vJumData, vJumGain int default 0;
  select jumlahdata into vJumData from tblHitung where iterasi=no_Iterasi limit 1;
  select entropy into vEntropy from tblHitung where iterasi=no_Iterasi limit 1;

  insert into tblGain(iterasi, atribut, gain)
    select no_Iterasi, atribut, abs(vEntropy - SUM((jumlahdata/vJumData) * entropy)) AS ENTROPY
    from tblHitung
    where iterasi=no_Iterasi
    group by atribut;

  update tblHitung set gain =
    (
      select gain
      from tblGain
      where atribut = tblHitung.atribut and iterasi=no_Iterasi
    )
  where iterasi=no_Iterasi;

  select MAX(gain) into @gain from tblGain where iterasi=no_Iterasi;


  insert into tblMaxGain(iterasi, atribut, informasi, gain)
    select iterasi, atribut, informasi, gain
    from tblHitung
    where gain = @gain and diagnosademam != 0 and diagnosaflu != 0 and iterasi=no_Iterasi limit 1;

  select count(*) into vJumGain from tblMaxGain where iterasi=no_Iterasi;
  if vJumGain < 1 then
	 insert into tblMaxGain(iterasi, atribut, informasi, gain)
	    select iterasi, atribut, 'Berhenti', gain
	    from tblHitung
	    where gain = @gain and iterasi=no_Iterasi limit 1;
  end if;
end $$
delimiter ;

delimiter $$
create procedure spLoop()
begin
  declare i, vIterasi int default 1;
  declare vStop int default 0;
  while i=1 do
    call spEntropy(vIterasi);
    call spHitEntropy(vIterasi);

    set vIterasi=vIterasi+1;
    select * from tblTemp;
    select * from tblHitung;
    select * from tblMaxGain;
    select count(informasi) into vStop from tblMaxGain where informasi='Berhenti';
    
    if vStop>0 then
      set i=2;
    end if;
  end while;
end $$
delimiter ;

call spLoop();