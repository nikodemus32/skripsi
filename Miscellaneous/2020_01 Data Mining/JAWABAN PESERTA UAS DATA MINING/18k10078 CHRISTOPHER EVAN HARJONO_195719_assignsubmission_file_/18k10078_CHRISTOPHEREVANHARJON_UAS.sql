/*CHRISTOPHER EVAN HARJONO || 18.K1.0078*/
drop database if exists dbC45_UAS;
create database dbC45_UAS;
use dbC45_UAS;

create table tblUas
(
    pasien varchar(10),
    demam varchar(20),
    sakit_Kepala varchar(20),
    nyeri varchar(20),
    lemas varchar(20),
    kelelahan varchar(20),
    hidung_tersumbat varchar(20),
    bersin varchar(20),
    sakit_Tenggorokan varchar(20),
    sulit_Bernafas varchar(20),
    diagnosa varchar(20)
);

create table tblKerja
(
    iterasi int,
    pasien varchar(10),
    demam varchar(10),
    sakit_kepala varchar(10),
    nyeri varchar(10),
    lemas varchar(10),
    kelelahan varchar(10),
    hidung_Tersumbat varchar(10),
    bersin varchar(10),
    sakit_tenggorokan varchar(10),
    sulit_bernafas varchar(10),
    diagnosa varchar(10)
);

create table tblProses
  (
    iterasi int,
    atribut varchar(100),
    informasi varchar(100),
    jumlahdata int,
    demam int,
    flu int,
    entropy decimal(8,4),
    gain decimal(8,4)
);

create table tblGain
(
    iterasi int,
    atribut varchar(100),
    gain decimal(8,4)
);

create table tblMaxGain
(
    iterasi int,
    atribut varchar(100),
    informasi varchar(20),
    gain decimal(8,4)
);

insert into tblUas values ("P1","Tidak","Ringan", "Tidak", "Tidak", "Tidak", "Ringan","Parah", "Parah", "Ringan","Demam");
insert into tblUas values ("P2", "Parah",	"Parah" ,"Parah", "Parah", "Parah", "Tidak", "Tidak", "Parah", "Parah", "Flu");
insert into tblUas values ("P3", "Parah",	"Parah" ,"Ringan", "Parah", "Parah", "Parah", "Tidak", "Parah", "Parah", "Flu");
insert into tblUas values ("P4", "Tidak",	"Tidak" ,"Tidak", "Ringan", "Tidak", "Parah", "Tidak", "Ringan", "Ringan", "Demam");
insert into tblUas values ("P5", "Parah",	"Parah" ,"Ringan", "Parah", "Parah", "Parah", "Tidak", "Parah", "Parah", "Flu");
insert into tblUas values ("P6", "Tidak",	"Tidak" ,"Tidak", "Ringan", "Tidak", "Parah", "Parah", "Parah", "Tidak", "Demam");
insert into tblUas values ("P7", "Parah",	"Parah" ,"Parah", "Parah", "Parah", "Tidak", "Tidak", "Tidak", "Parah", "Flu");
insert into tblUas values ("P8", "Tidak",	"Tidak" ,"Tidak", "Tidak", "Tidak", "Parah", "Parah", "Tidak", "Ringan", "Demam");
insert into tblUas values ("P9", "Tidak",	"Ringan", "Ringan", "Tidak", "Tidak", "Parah", "Parah", "Parah", "Parah", "Demam");
insert into tblUas values ("P10","Parah","Parah","Parah", "Ringan", "Ringan", "Tidak","Parah", "Tidak", "Parah", "Flu");
insert into tblUas values ("P11","Tidak","Tidak","Tidak", "Ringan", "Tidak", "Parah","Ringan", "Parah", "Tidak", "Demam");
insert into tblUas values ("P12","Parah","Ringan","Parah", "Ringan", "Parah", "Tidak","Parah", "Tidak", "Ringan", "Flu");
insert into tblUas values ("P13","Tidak","Tidak","Ringan", "Ringan", "Tidak", "Parah","Parah", "Parah", "Tidak", "Demam");
insert into tblUas values ("P14","Parah","Parah","Parah", "Parah", "Ringan", "Tidak","Parah", "Parah", "Parah", "Flu");
insert into tblUas values ("P15","Ringan","Tidak","Tidak", "Ringan", "Tidak", "Parah","Tidak", "Parah", "Ringan", "Demam");
insert into tblUas values ("P16","Tidak","Tidak","Tidak", "Tidak", "Tidak", "Parah","Parah", "Parah", "Parah", "Demam");
insert into tblUas values ("P17","Parah","Ringan","Parah", "Ringan", "Ringan", "Tidak","Tidak", "Tidak", "Parah", "Flu");
select * from tblUas;


delimiter $$
create procedure spEntropy(noiterasi int)
begin
    insert into tblKerja
    select noiterasi, pasien, demam, sakit_kepala, nyeri, lemas, kelelahan, hidung_tersumbat, bersin, sakit_tenggorokan, sulit_bernafas, diagnosa from tblUas;
    call spDelete(noiterasi);
    call spHitung(noiterasi);
end $$
delimiter ;

delimiter $$
create procedure spHitEntropy(noiterasi int)
begin
    update tblProses set entropy = (-(demam/jumlahdata)*log2(demam/jumlahdata)) + (-(flu/jumlahdata)*log2(flu/jumlahdata)) where demam !=0 and flu!=0;
    update tblProses set entropy = 0 where entropy is null;
    call spHitungGain(noiterasi);
end $$
delimiter ;

delimiter $$
create procedure spHitung(noiterasi int)
begin
  declare vdemam, vflu, vjumdata1, i, vjumdata int;
  declare viterasi, vatribut, vinformasi varchar(100);
  declare vGain decimal(8,4);
  declare cDelete cursor for select * from tblMaxGain;

  select count(*) into vjumdata from tblMaxGain;
  select count(*) into vdemam from tblKerja where diagnosa = 'Demam' and iterasi=noiterasi;
  select count(*) into vflu from tblKerja where diagnosa = 'Flu' and iterasi=noiterasi;
  set vjumdata1 = vdemam + vflu;
    insert into tblProses (iterasi,atribut,informasi,jumlahdata,demam,flu) values (noiterasi, 'TOTAL DATA', '', vjumdata1, vdemam, vflu);

/*demam*/
  insert into tblProses(iterasi, informasi, atribut, jumlahdata, demam, flu)
    select distinct noiterasi, (A.demam), 'Demam',
    (select count(*) from tblKerja where demam=A.demam and iterasi=noiterasi),
    (select count(*) from tblKerja where diagnosa='Demam' and demam=A.demam and iterasi=noiterasi),
    (select count(*) from tblKerja where diagnosa='Flu' and demam=A.demam and iterasi=noiterasi)
    from tblKerja as A where iterasi=noiterasi;

/*sakit kepala*/
  insert into tblProses(iterasi, informasi, atribut, jumlahdata, demam, flu)
    select distinct noiterasi, (A.sakit_kepala), 'Sakit_Kepala',
    (select count(*) from tblKerja where sakit_kepala=A.sakit_kepala and iterasi=noiterasi),
    (select count(*) from tblKerja where diagnosa='Demam' and sakit_kepala=A.sakit_kepala and iterasi=noiterasi),
    (select count(*) from tblKerja where diagnosa='Flu' and sakit_kepala=A.sakit_kepala and iterasi=noiterasi)
    from tblKerja as A where iterasi=noiterasi;

/*nyeri*/
  insert into tblProses(iterasi, informasi, atribut, jumlahdata, demam, flu)
    select distinct noiterasi, (A.nyeri), 'Nyeri',
    (select count(*) from tblKerja where nyeri=A.nyeri and iterasi=noiterasi),
    (select count(*) from tblKerja where diagnosa='Demam' and nyeri=A.nyeri and iterasi=noiterasi),
    (select count(*) from tblKerja where diagnosa='Flu' and nyeri=A.nyeri and iterasi=noiterasi)
    from tblKerja as A where iterasi=noiterasi;

/*lemas*/
  insert into tblProses(iterasi, informasi, atribut, jumlahdata, demam, flu)
    select distinct noiterasi, (A.lemas), 'Lemas',
    (select count(*) from tblKerja where lemas=A.lemas and iterasi=noiterasi),
    (select count(*) from tblKerja where diagnosa='Demam' and lemas=A.lemas and iterasi=noiterasi),
    (select count(*) from tblKerja where diagnosa='Flu' and lemas=A.lemas and iterasi=noiterasi)
    from tblKerja as A where iterasi=noiterasi;

/*kelelahan*/
  insert into tblProses(iterasi, informasi, atribut, jumlahdata, demam, flu)
    select distinct noiterasi, (A.kelelahan), 'Kelelahan',
    (select count(*) from tblKerja where kelelahan=A.kelelahan and iterasi=noiterasi),
    (select count(*) from tblKerja where diagnosa='Demam' and kelelahan=A.kelelahan and iterasi=noiterasi),
    (select count(*) from tblKerja where diagnosa='Flu' and kelelahan=A.kelelahan and iterasi=noiterasi)
    from tblKerja as A where iterasi=noiterasi;

/*hidung tersumbat*/
  insert into tblProses(iterasi, informasi, atribut, jumlahdata, demam, flu)
    select distinct noiterasi, (A.hidung_tersumbat), 'Hidung_Tersumbat',
    (select count(*) from tblKerja where hidung_tersumbat=A.hidung_tersumbat and iterasi=noiterasi),
    (select count(*) from tblKerja where diagnosa='Demam' and hidung_tersumbat=A.hidung_tersumbat and iterasi=noiterasi),
    (select count(*) from tblKerja where diagnosa='Flu' and hidung_tersumbat=A.hidung_tersumbat and iterasi=noiterasi)
    from tblKerja as A where iterasi=noiterasi;

/*Bersin*/
  insert into tblProses(iterasi, informasi, atribut, jumlahdata, demam, flu)
    select distinct noiterasi, (A.bersin), 'Bersin',
    (select count(*) from tblKerja where bersin=A.bersin and iterasi=noiterasi),
    (select count(*) from tblKerja where diagnosa='Demam' and bersin=A.bersin and iterasi=noiterasi),
    (select count(*) from tblKerja where diagnosa='Flu' and bersin=A.bersin and iterasi=noiterasi)
    from tblKerja as A where iterasi=noiterasi;

/*Sakit Tenggorokan*/
  insert into tblProses(iterasi, informasi, atribut, jumlahdata, demam, flu)
    select distinct noiterasi, (A.sakit_tenggorokan), 'Sakit_Tenggorokan',
    (select count(*) from tblKerja where sakit_tenggorokan=A.sakit_tenggorokan and iterasi=noiterasi),
    (select count(*) from tblKerja where diagnosa='Demam' and sakit_tenggorokan=A.sakit_tenggorokan and iterasi=noiterasi),
    (select count(*) from tblKerja where diagnosa='Flu' and sakit_tenggorokan=A.sakit_tenggorokan and iterasi=noiterasi)
    from tblKerja as A where iterasi=noiterasi;

/*Sulit Bernapas*/
  insert into tblProses(iterasi, informasi, atribut, jumlahdata, demam, flu)
    select distinct noiterasi, (A.sulit_bernafas), 'Sulit_Bernafas',
    (select count(*) from tblKerja where sulit_bernafas=A.sulit_bernafas and iterasi=noiterasi),
    (select count(*) from tblKerja where diagnosa='Demam' and sulit_bernafas=A.sulit_bernafas and iterasi=noiterasi),
    (select count(*) from tblKerja where diagnosa='Flu' and sulit_bernafas=A.sulit_bernafas and iterasi=noiterasi)
    from tblKerja as A where iterasi=noiterasi;


  set i=0;
  open cDelete;
  while i <> vjumdata do
    fetch cDelete into viterasi, vatribut, vinformasi, vgain;
    delete from tblProses where iterasi=noiterasi and atribut=vatribut;
    set i=i+1;
  end while;
end $$
delimiter ;

delimiter $$
create procedure spDelete(noiterasi int)
begin
    declare i, j, vjumdata, vjumdata1, viterasi, viterasi1 int default 0;
    declare vpasien,vdemam, vpusing, vnyeri, vlemas, vkelelahan, vpilek, vbersin, vradang,
    vsesak, vdiagnosa, vatribut, vinformasi varchar(100);
    declare vgain decimal(8,4);
    declare cTampung cursor for select * from tblKerja where iterasi=noiterasi;
    declare cMaxGain cursor for select * from tblMaxGain;
    select count(*) into vjumdata from tblKerja where iterasi=noiterasi;
    select count(*) into vjumdata1 from tblMaxGain;

    open cTampung;
    while i <> vjumdata do
      fetch cTampung into viterasi, vpasien ,vdemam, vpusing, vnyeri, vlemas, vkelelahan, vpilek, vbersin, vradang, vsesak , vdiagnosa;
      set j=0;
      open cMaxGain;

      while j <> vjumdata1 do
        fetch cMaxGain into viterasi1, vatribut, vinformasi, vgain;
            if vatribut='Demam' then
				    delete from tblKerja where vdemam <> vinformasi and iterasi=noiterasi and pasien=vpasien;
			    elseif vatribut='Sakit_Kepala' then
				    delete from tblKerja where vpusing <> vinformasi and iterasi=noiterasi and pasien=vpasien;
			    elseif vatribut='Nyeri' then
				    delete from tblKerja where vnyeri <> vinformasi and iterasi=noiterasi and pasien=vpasien;
			    elseif vatribut='Lemas' then
				    delete from tblKerja where vlemas <> vinformasi and iterasi=noiterasi and pasien=vpasien;
                elseif vatribut='Kelelahan' then
				    delete from tblKerja where vkelelahan <> vinformasi and iterasi=noiterasi and pasien=vpasien;
                elseif vatribut='Hidung_Tersumbat' then
				    delete from tblKerja where vpilek <> vinformasi and iterasi=noiterasi and pasien=vpasien;
                elseif vatribut='Bersin' then
				    delete from tblKerja where vbersin <> vinformasi and iterasi=noiterasi and pasien=vpasien;
			    elseif vatribut='Sakit_Tenggorokan' then
				    delete from tblKerja where vradang <> vinformasi and iterasi=noiterasi and pasien=vpasien;
                elseif vatribut='Sulit_Bernafas' then
				    delete from tblKerja where vsesak <> vinformasi and iterasi=noiterasi and pasien=vpasien;
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
create procedure spHitungGain(noiterasi int)
begin
  declare ventropy decimal(8,4);
  declare vjumdata, vjumgain int default 0;
  select jumlahdata into vjumdata from tblProses where iterasi=noiterasi limit 1;
  select entropy into ventropy from tblProses where iterasi=noiterasi limit 1;

  insert into tblGain(iterasi, atribut, gain)
    select noiterasi, atribut, abs(ventropy - SUM((jumlahdata/vjumdata) * entropy)) AS ENTROPY
    from tblProses
    where iterasi=noiterasi
    group by atribut;

  update tblProses set gain =
    (
      select gain
      from tblGain
      where atribut = tblProses.atribut and iterasi=noiterasi
    )
  where iterasi=noiterasi;
  select MAX(gain) into @gain from tblGain where iterasi=noiterasi;
  select count(*) into vjumgain from tblMaxGain where iterasi=noiterasi;
  if vjumgain < 1 then
	 insert into tblMaxGain(iterasi, atribut, informasi, gain)
	    select iterasi, atribut, 'Stop', gain
	    from tblProses
	    where gain = @gain and iterasi=noiterasi limit 1;
  end if;
end $$
delimiter ;

delimiter $$
create procedure spLoop()
begin
  declare i int default 1;
  declare viterasi int default 1;
  declare vstop int default 0;
  while i=1 do
    call spEntropy(viterasi);
    call spHitEntropy(viterasi);
    set viterasi=viterasi+1;
    select * from tblProses;
    select * from tblGain ;
    select * from tblMaxGain;
    select count(informasi) into vstop from tblMaxGain where informasi='Stop';

    if vstop>0 then
      set i=2;
    end if;
  end while;
end $$
delimiter ;

call spLoop();
/*Kesimpulannya adalah literasi samapi 1 karena nilai entropy nya yang paling tinngi
adalah demam dan informasi pada demam yang diagnosakan demam dan flu sebagai berikut:
parah diagnosa demam sebanyak 8 dan diagnosa flu 1
tidak diagnosa flu sebanyak 8 dan diagnosa demam 0
ringan diagnosa demam sebanyak 1 dan diagnosa flu 0
sehingga berhenti disitu saja. Apabila terdapat gain yang nilainya sama
maka untuk literasi berikutnya nilai gain diambil dari data sesuai abjad dari atribut yang ada/
