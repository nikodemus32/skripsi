DROP DATABASE IF EXISTS dbC45;
CREATE DATABASE dbC45;
USE dbC45;

create table tblSoal
(
  Pasien varchar(5),
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

create table tblHasil
(
  iterasi int,
  Pasien varchar(10),
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

CREATE TABLE tblHitung
(
iterasi int,
atribut VARCHAR(20),
informasi VARCHAR(20),
jumlahdata INT,
diagnosa_demam INT,
diagnosa_flu INT,
entropy DECIMAL(8,4),
gain DECIMAL(8,4)
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

delimiter $$
create trigger tgAutoInsert
  after insert on tblSoal
  for each row
begin
  insert into tblHasil(Pasien, Demam, Sakit_Kepala ,Nyeri, Lemas, Kelelahan, Hidung_Tersumbat, Bersin, Sakit_Tenggorokan, Sulit_Bernafas,Diagnosa)
  values (new.Pasien, new.Demam, new.Sakit_Kepala ,new.Nyeri, new.Lemas, new.Kelelahan, new.Hidung_Tersumbat, new.Bersin, new.Sakit_Tenggorokan, new.Sulit_Bernafas, new.Diagnosa);
end$$
delimiter ;

insert into tblSoal values
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

delimiter $$
create procedure iteration(a int)
begin
 declare vjumdata,vjumdemam,vjumflu int default 0;
 select count(*) into vjumdemam from tblHasil where Diagnosa='Demam';
 select count(*) into vjumflu from tblHasil where Diagnosa='Flu';
 select count(*) into vjumdata from tblHasil;
 update tblHasil set iterasi = a where iterasi is null;
 insert into tblHitung (iterasi, atribut, informasi, jumlahdata, diagnosa_demam, diagnosa_flu) values (a, 'TOTAL DATA', '', vjumdata, vjumdemam, vjumflu);
 insert into tblHitung(iterasi, informasi, atribut, jumlahdata, diagnosa_demam, diagnosa_flu)
   select distinct a, (A.Demam), 'Demam',
   (select count(*) from tblHasil where Demam=A.Demam and iterasi=a),
   (select count(*) from tblHasil where Diagnosa='Demam' and Demam=A.Demam and iterasi=a),
   (select count(*) from tblHasil where Diagnosa='Flu' and Demam=A.Demam and iterasi=a)
   from tblHasil as A where iterasi=a;
 insert into tblHitung(iterasi, informasi, atribut, jumlahdata, diagnosa_demam, diagnosa_flu)
   select distinct a, (A.Sakit_Kepala), 'Sakit_Kepala',
   (select count(*) from tblHasil where Sakit_Kepala=A.Sakit_Kepala and iterasi=a),
   (select count(*) from tblHasil where Diagnosa='Demam' and Sakit_Kepala=A.Sakit_Kepala and iterasi=a),
   (select count(*) from tblHasil where Diagnosa='Flu' and Sakit_Kepala=A.Sakit_Kepala and iterasi=a)
   from tblHasil as A where iterasi=a;
 insert into tblHitung(iterasi, informasi, atribut, jumlahdata, diagnosa_demam, diagnosa_flu)
   select distinct a, (A.Nyeri), 'Nyeri',
   (select count(*) from tblHasil where Nyeri=A.Nyeri and iterasi=a),
   (select count(*) from tblHasil where Diagnosa='Demam' and Nyeri=A.Nyeri and iterasi=a),
   (select count(*) from tblHasil where Diagnosa='Flu' and Nyeri=A.Nyeri and iterasi=a)
   from tblHasil as A where iterasi=a;
 insert into tblHitung(iterasi, informasi, atribut, jumlahdata, diagnosa_demam, diagnosa_flu)
   select distinct a, (A.Lemas), 'Lemas',
   (select count(*) from tblHasil where Lemas=A.Lemas and iterasi=a),
   (select count(*) from tblHasil where Diagnosa='Demam' and Lemas=A.Lemas and iterasi=a),
   (select count(*) from tblHasil where Diagnosa='Flu' and Lemas=A.Lemas and iterasi=a)
   from tblHasil as A where iterasi=a;
 insert into tblHitung(iterasi, informasi, atribut, jumlahdata, diagnosa_demam, diagnosa_flu)
   select distinct a, (A.Kelelahan), 'Kelelahan',
   (select count(*) from tblHasil where Kelelahan=A.Kelelahan and iterasi=a),
   (select count(*) from tblHasil where Diagnosa='Demam' and Kelelahan=A.Kelelahan and iterasi=a),
   (select count(*) from tblHasil where Diagnosa='Flu' and Kelelahan=A.Kelelahan and iterasi=a)
   from tblHasil as A where iterasi=a;
 insert into tblHitung(iterasi, informasi, atribut, jumlahdata, diagnosa_demam, diagnosa_flu)
   select distinct a, (A.Hidung_Tersumbat), 'Hidung_Tersumbat',
   (select count(*) from tblHasil where Hidung_Tersumbat=A.Hidung_Tersumbat and iterasi=a),
   (select count(*) from tblHasil where Diagnosa='Demam' and Hidung_Tersumbat=A.Hidung_Tersumbat and iterasi=a),
   (select count(*) from tblHasil where Diagnosa='Flu' and Hidung_Tersumbat=A.Hidung_Tersumbat and iterasi=a)
   from tblHasil as A where iterasi=a;
 insert into tblHitung(iterasi, informasi, atribut, jumlahdata, diagnosa_demam, diagnosa_flu)
   select distinct a, (A.Bersin), 'Bersin',
   (select count(*) from tblHasil where Bersin=A.Bersin and iterasi=a),
   (select count(*) from tblHasil where Diagnosa='Demam' and Bersin=A.Bersin and iterasi=a),
   (select count(*) from tblHasil where Diagnosa='Flu' and Bersin=A.Bersin and iterasi=a)
   from tblHasil as A where iterasi=a;
 insert into tblHitung(iterasi, informasi, atribut, jumlahdata, diagnosa_demam, diagnosa_flu)
   select distinct a, (A.Sakit_Tenggorokan), 'Sakit_Tenggorokan',
   (select count(*) from tblHasil where Sakit_Tenggorokan=A.Sakit_Tenggorokan and iterasi=a),
   (select count(*) from tblHasil where Diagnosa='Demam' and Sakit_Tenggorokan=A.Sakit_Tenggorokan and iterasi=a),
   (select count(*) from tblHasil where Diagnosa='Flu' and Sakit_Tenggorokan=A.Sakit_Tenggorokan and iterasi=a)
   from tblHasil as A where iterasi=a;
 insert into tblHitung(iterasi, informasi, atribut, jumlahdata, diagnosa_demam, diagnosa_flu)
   select distinct a, (A.Sulit_Bernafas), 'Sulit_Bernafas',
   (select count(*) from tblHasil where Sulit_Bernafas=A.Sulit_Bernafas and iterasi=a),
   (select count(*) from tblHasil where Diagnosa='Demam' and Sulit_Bernafas=A.Sulit_Bernafas and iterasi=a),
   (select count(*) from tblHasil where Diagnosa='Flu' and Sulit_Bernafas=A.Sulit_Bernafas and iterasi=a)
   from tblHasil as A where iterasi=a;
 UPDATE tblHitung SET entropy = (-(diagnosa_demam/jumlahdata) * log2(diagnosa_demam/jumlahdata))
 +
 (-(diagnosa_flu/jumlahdata) * log2(diagnosa_flu/jumlahdata))
 where diagnosa_demam <> 0 and diagnosa_flu <> 0;
 UPDATE tblHitung SET entropy = 0 WHERE entropy IS NULL;
 call gain(a);
end$$
delimiter ;

delimiter $$
create procedure gain(a int)
begin
declare i,jumpasien,viterasi int default 0;
declare vpasien,vdemam,vsakit_kepala,vnyeri,vlemas,vkelelahan,vhidung_tersumbat,vbersin,vsakit_tenggorokan,vsulit_bernafas,vdiagnosa varchar(20);
declare cnumba cursor for select * from tblHasil where iterasi = a;

select entropy into @ventropy
from tblHitung where iterasi = a and atribut = 'TOTAL DATA';

select jumlahdata into @totaldata
from tblHitung where iterasi = a and atribut = 'TOTAL DATA';

insert into tblGain(iterasi, atribut,informasi, gain)
select iterasi, atribut, informasi, @ventropy -
sum((jumlahdata/@totaldata) * entropy) AS GAIN
from tblHitung
where iterasi = a
group by atribut;

update tblHitung set gain =
(
select gain
from tblgain
where iterasi = a and atribut=tblHitung.atribut
)where iterasi = a;

select MAX(gain) into @gain from tblGain where iterasi=a;

insert into tblMaxGain(iterasi, atribut,informasi, gain)
select iterasi, atribut,informasi, @gain
from tblHitung
where gain = @gain and diagnosa_demam != 0 and diagnosa_flu != 0 and iterasi=a limit 1;

select count(*) into @vJumGain from tblMaxGain where iterasi=a;
if @vJumGain < 1 then
 insert into tblMaxGain(iterasi, atribut, informasi, gain)
    select iterasi, atribut, 'Stop', gain
    from tblHitung
    where gain = @gain and iterasi=a limit 1;
end if;

select atribut into @atribut from tblMaxGain where iterasi=a;
select informasi into @informasi from tblMaxGain where iterasi=a;
select count(*) into jumpasien from tblHasil where iterasi = a;
select * from tblHasil;

open cnumba;
while i<>jumpasien do
fetch cnumba into viterasi,vpasien,vdemam,vsakit_kepala,vnyeri,vlemas,vkelelahan,vhidung_tersumbat,vbersin,vsakit_tenggorokan,vsulit_bernafas,vdiagnosa;
if @atribut='Demam' then
  delete from tblHasil where vdemam <> @informasi and iterasi = a and Pasien=vpasien;
elseif @atribut='Sakit_Kepala' then
  delete from tblHasil where vsakit_kepal <> @informasi and iterasi = a and Pasien=vpasien;
elseif @atribut='Nyeri' then
  delete from tblHasil where vnyeri <> @informasi and iterasi = a and Pasien=vpasien;
elseif @atribut='Lemas' then
  delete from tblHasil where vlemas <> @informasi and iterasi = a and Pasien=vpasien;
elseif @atribut='Kelelahan' then
  delete from tblHasil where vkelelahan <> @informasi and iterasi = a and Pasien=vpasien;
elseif @atribut='Hidung_Tersumbat' then
  delete from tblHasil where vhidung_tersumbat <> @informasi and iterasi = a and Pasien=vpasien;
elseif @atribut='Bersin' then
  delete from tblHasil where vbersin <> @informasi and iterasi = a and Pasien=vpasien;
elseif @atribut='Sakit_Tenggorokan' then
  delete from tblHasil where vsakit_tenggorokan <> @informasi and iterasi = a and Pasien=vpasien;
elseif @atribut='Sulit_Bernafas' then
  delete from tblHasil where vsulit_bernafas <> @informasi and iterasi = a and Pasien=vpasien;
end if;
set i = i+1;
end while;
close cnumba;
end$$
delimiter ;

delimiter $$
create procedure loops()
begin
declare i int default 1;
declare x int default 0;
set @triggers = 1;
while @triggers = 1 do
call iteration(i);
set i=i+1;
select * from tblHitung;
select * from tblGain;
select * from tblMaxGain;
select * from tblHasil;
select count(informasi) into x from tblMaxGain where informasi='Stop';
if x>0 then
  set @triggers=2;
end if;
end while;
end$$
delimiter ;

call loops();

--select * from tblSoal;
