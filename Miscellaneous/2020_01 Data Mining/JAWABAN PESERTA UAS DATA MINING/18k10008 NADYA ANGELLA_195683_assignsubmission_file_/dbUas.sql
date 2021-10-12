drop database if exists dbUas;
create database dbUas;
use dbUas;

create table tblDiagnosa
(
  nopasien varchar(3),
  demam varchar(10),
  sakitkepala varchar(10),
  nyeri varchar(10),
  lemas varchar(10),
  kelelahan varchar(10),
  tersumbat varchar(10),
  bersin varchar(10),
  sakittenggorokan varchar(10),
  sulitnafas varchar(10),
  diagnosa varchar(10)
);

insert into tblDiagnosa values
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

-- select * from tblDiagnosa;

create table tblTampung
(
  iterasi int,
  nopasien varchar(3),
  demam varchar(10),
  sakitkepala varchar(10),
  nyeri varchar(10),
  lemas varchar(10),
  kelelahan varchar(10),
  tersumbat varchar(10),
  bersin varchar(10),
  sakittenggorokan varchar(10),
  sulitnafas varchar(10),
  diagnosa varchar(10)
);

create table tblMaxGain
(
  iterasi int,
  atribut varchar(50),
  informasi varchar(10),
  gain decimal(8,4)
);

create table tblGain
(
  iterasi int,
  atribut varchar(50),
  informasi varchar(10),
  gain decimal(8,4)
);

create table tblHitung
(
  iterasi int,
  atribut varchar(20),
  informasi varchar(20),
  jumlahdata int,
  flu int,
  demam int,
  entropy decimal(8,4),
  gain decimal(8,4)
);

delimiter $$
create procedure spEntropy(iterasiKe int)
begin
declare i int default 0;
declare vJumData int;
declare vIterasi, vAtribut, vInformasi varchar(20);
declare vGain decimal(8,4);
declare cDelete cursor for select * from tblMaxGain;
select count(*) into vJumData from tblMaxGain;

insert into tblTampung
  select iterasiKe, nopasien, demam, sakitkepala, nyeri, lemas, kelelahan, tersumbat,
          bersin, sakittenggorokan, sulitnafas, diagnosa from tblDiagnosa;
call spDelete(iterasiKe);
call spHitung(iterasiKe);

open cDelete;
  while i <> vJumData do
    fetch cDelete into vIterasi, vAtribut, vInformasi, vGain;
    delete from tblHitung where atribut=vAtribut and iterasi=iterasiKe;
  set i=i+1;
  end while;
end $$
delimiter ;

-- call spEntropy(1);
-- select * from tblTampung;
delimiter $$
create procedure spEntropy2(iterasiKe int)
begin
  update tblHitung set entropy = (-(flu/jumlahdata)*log2(flu/jumlahdata))+
                                  (-(demam/jumlahdata)*log2(demam/jumlahdata))
                                  where flu !=0 and demam!=0;
  update tblHitung set entropy = 0 where entropy is null;
  call spGain(iterasiKe);
end $$
delimiter ;

delimiter $$
create procedure spDelete(iterasiKe int)
begin
  declare i, j, vJumData, vJumData2, vIterasi, vIterasi2 int default 0;
  declare vNopasien, vDemam, vSakitkepala, vNyeri, vLemas, vKelelahan,
          vTersumbat, vBersin, vSakittenggorokan, vSulitnafas, vDiagnosa,
          vAtribut, vInformasi varchar(30);
  declare vGain decimal(8,4);
  declare cTampung cursor for select * from tblTampung where iterasi=iterasiKe;
  declare cMaxGain cursor for select * from tblMaxGain;
  select count(*) into vJumData from tblTampung where iterasi=iterasiKe;
  select count(*) into vJumData2 from tblMaxGain;

  open cTampung;
  while i <> vJumData do
    fetch cTampung into vIterasi, vNopasien, vDemam, vSakitkepala, vNyeri, vLemas, vKelelahan,
            vTersumbat, vBersin, vSakittenggorokan, vSulitnafas, vDiagnosa;
    set j=0;
    open cMaxGain;
    while j <> vJumData2 do
    fetch cMaxGain into vIterasi2, vAtribut, vInformasi, vGain;
    if vAtribut='demam' then
      delete from tblTampung where vDemam <> vInformasi and iterasi=iterasiKe and nopasien=vNopasien;
    elseif vAtribut='sakitkepala' then
      delete from tblTampung where vSakitkepala <> vInformasi and iterasi=iterasiKe and nopasien=vNopasien;
    elseif vAtribut='nyeri' then
      delete from tblTampung where vNyeri <> vInformasi and iterasi=iterasiKe and nopasien=vNopasien;
    elseif vAtribut='lemas' then
      delete from tblTampung where vLemas <> vInformasi and iterasi=iterasiKe and nopasien=vNopasien;
    elseif vAtribut='kelelahan' then
      delete from tblTampung where vKelelahan <> vInformasi and iterasi=iterasiKe and nopasien=vNopasien;
    elseif vAtribut='tersumbat' then
      delete from tblTampung where vTersumbat <> vInformasi and iterasi=iterasiKe and nopasien=vNopasien;
    elseif vAtribut='bersin' then
      delete from tblTampung where vBersin <> vInformasi and iterasi=iterasiKe and nopasien=vNopasien;
    elseif vAtribut='sakittenggorokan' then
      delete from tblTampung where vSakittenggorokan <> vInformasi and iterasi=iterasiKe and nopasien=vNopasien;
    elseif vAtribut='sulitnafas' then
      delete from tblTampung where vSulitnafas <> vInformasi and iterasi=iterasiKe and nopasien=vNopasien;
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
create procedure spHitung(iterasiKe int)
begin
  declare vFlu, vDemam, vJumlahdata, i, vJumData int;
  select count(*) into vFlu from tblTampung where diagnosa = 'Flu' and iterasi=iterasiKe;
  select count(*) into vDemam from tblTampung where diagnosa = 'Demam' and iterasi=iterasiKe;
  set vJumlahdata = vFlu + vDemam;
  insert into tblHitung (iterasi, atribut, informasi, jumlahdata, flu, demam) values (iterasiKe, 'TOTAL DATA', '', vJumlahdata, vFlu, vDemam);

  insert into tblHitung(iterasi, informasi, atribut, jumlahdata, flu, demam)
    select distinct iterasiKe, (A.demam), 'demam',
    (select count(*) from tblTampung where demam=A.demam and iterasi=iterasiKe),
    (select count(*) from tblTampung where diagnosa='Flu' and demam=A.demam and iterasi=iterasiKe),
    (select count(*) from tblTampung where diagnosa='Demam' and demam=A.demam and iterasi=iterasiKe)
    from tblTampung as A where iterasi=iterasiKe;
  insert into tblHitung(iterasi, informasi, atribut, jumlahdata, flu, demam)
    select distinct iterasiKe, (A.sakitkepala), 'sakitkepala',
    (select count(*) from tblTampung where sakitkepala=A.sakitkepala and iterasi=iterasiKe),
    (select count(*) from tblTampung where diagnosa='Flu' and sakitkepala=A.sakitkepala and iterasi=iterasiKe),
    (select count(*) from tblTampung where diagnosa='Demam' and sakitkepala=A.sakitkepala and iterasi=iterasiKe)
    from tblTampung as A where iterasi=iterasiKe;
  insert into tblHitung(iterasi, informasi, atribut, jumlahdata, flu, demam)
    select distinct iterasiKe, (A.nyeri), 'nyeri',
    (select count(*) from tblTampung where nyeri=A.nyeri and iterasi=iterasiKe),
    (select count(*) from tblTampung where diagnosa='Flu' and nyeri=A.nyeri and iterasi=iterasiKe),
    (select count(*) from tblTampung where diagnosa='Demam' and nyeri=A.nyeri and iterasi=iterasiKe)
    from tblTampung as A where iterasi=iterasiKe;
  insert into tblHitung(iterasi, informasi, atribut, jumlahdata, flu, demam)
    select distinct iterasiKe, (A.lemas), 'lemas',
    (select count(*) from tblTampung where lemas=A.lemas and iterasi=iterasiKe),
    (select count(*) from tblTampung where diagnosa='Flu' and lemas=A.lemas and iterasi=iterasiKe),
    (select count(*) from tblTampung where diagnosa='Demam' and lemas=A.lemas and iterasi=iterasiKe)
    from tblTampung as A where iterasi=iterasiKe;
  insert into tblHitung(iterasi, informasi, atribut, jumlahdata, flu, demam)
    select distinct iterasiKe, (A.kelelahan), 'kelelahan',
    (select count(*) from tblTampung where kelelahan=A.kelelahan and iterasi=iterasiKe),
    (select count(*) from tblTampung where diagnosa='Flu' and kelelahan=A.kelelahan and iterasi=iterasiKe),
    (select count(*) from tblTampung where diagnosa='Demam' and kelelahan=A.kelelahan and iterasi=iterasiKe)
    from tblTampung as A where iterasi=iterasiKe;
  insert into tblHitung(iterasi, informasi, atribut, jumlahdata, flu, demam)
    select distinct iterasiKe, (A.tersumbat), 'tersumbat',
    (select count(*) from tblTampung where tersumbat=A.tersumbat and iterasi=iterasiKe),
    (select count(*) from tblTampung where diagnosa='Flu' and tersumbat=A.tersumbat and iterasi=iterasiKe),
    (select count(*) from tblTampung where diagnosa='Demam' and tersumbat=A.tersumbat and iterasi=iterasiKe)
    from tblTampung as A where iterasi=iterasiKe;
  insert into tblHitung(iterasi, informasi, atribut, jumlahdata, flu, demam)
    select distinct iterasiKe, (A.bersin), 'bersin',
    (select count(*) from tblTampung where bersin=A.bersin and iterasi=iterasiKe),
    (select count(*) from tblTampung where diagnosa='Flu' and bersin=A.bersin and iterasi=iterasiKe),
    (select count(*) from tblTampung where diagnosa='Demam' and bersin=A.bersin and iterasi=iterasiKe)
    from tblTampung as A where iterasi=iterasiKe;
  insert into tblHitung(iterasi, informasi, atribut, jumlahdata, flu, demam)
    select distinct iterasiKe, (A.sakittenggorokan), 'sakittenggorokan',
    (select count(*) from tblTampung where sakittenggorokan=A.sakittenggorokan and iterasi=iterasiKe),
    (select count(*) from tblTampung where diagnosa='Flu' and sakittenggorokan=A.sakittenggorokan and iterasi=iterasiKe),
    (select count(*) from tblTampung where diagnosa='Demam' and sakittenggorokan=A.sakittenggorokan and iterasi=iterasiKe)
    from tblTampung as A where iterasi=iterasiKe;
  insert into tblHitung(iterasi, informasi, atribut, jumlahdata, flu, demam)
    select distinct iterasiKe, (A.sulitnafas), 'sulitnafas',
    (select count(*) from tblTampung where sulitnafas=A.sulitnafas and iterasi=iterasiKe),
    (select count(*) from tblTampung where diagnosa='Flu' and sulitnafas=A.sulitnafas and iterasi=iterasiKe),
    (select count(*) from tblTampung where diagnosa='Demam' and sulitnafas=A.sulitnafas and iterasi=iterasiKe)
    from tblTampung as A where iterasi=iterasiKe;
end $$
delimiter ;

delimiter $$
create procedure spGain(iterasiKe int)
begin
  declare vEntropy decimal(8,4);
  declare vJumData, vJumGain int default 0;
  select jumlahdata into vJumData from tblHitung where iterasi=iterasiKe limit 1;
  select entropy into vEntropy from tblHitung where iterasi=iterasiKe limit 1;

  insert into tblGain(iterasi, atribut, gain)
    select iterasiKe, atribut, abs(vEntropy - SUM((jumlahdata/vJumData) * entropy)) AS ENTROPY
    from tblHitung
    where iterasi=iterasiKe
    group by atribut;

  update tblHitung set gain =
    (
      select gain
      from tblGain
      where atribut = tblHitung.atribut and iterasi=iterasiKe
    )
  where iterasi=iterasiKe;

  select MAX(gain) into @gain from tblGain where iterasi=iterasiKe;
  -- select * from tblTampung;

  insert into tblMaxGain(iterasi, atribut, informasi, gain)
    select iterasi, atribut, informasi, gain
    from tblHitung
    where gain = @gain and flu!=0 and demam!=0 and iterasi=iterasiKe;
    select count(*) into vJumGain from tblMaxGain where iterasi=iterasiKe;
  insert into tblMaxGain(iterasi, atribut, informasi, gain)
    select iterasi, atribut, informasi, gain
    from tblHitung
    where gain = @gain and iterasi=iterasiKe;

  if vJumGain < 1 then
	 insert into tblMaxGain(iterasi, atribut, informasi, gain)
	    select iterasi, '', 'Stop', gain
	    from tblHitung
	    where gain = @gain and iterasi=iterasiKe limit 1;
  end if;
end $$
delimiter ;

delimiter $$
create procedure spAutoLooping()
begin
  declare i, vIterasi int default 1;
  declare vStop int default 0;
  while i=1 do
    call spEntropy(vIterasi);
    call spEntropy2(vIterasi);
    set vIterasi=vIterasi+1;
    select * from tblTampung;
    select * from tblHitung;
    select * from tblMaxGain;
    select count(informasi) into vStop from tblMaxGain where informasi='Stop';
    if vStop>0 then
      set i=2;
    end if;
  end while;
end $$
delimiter ;

call spAutoLooping();
