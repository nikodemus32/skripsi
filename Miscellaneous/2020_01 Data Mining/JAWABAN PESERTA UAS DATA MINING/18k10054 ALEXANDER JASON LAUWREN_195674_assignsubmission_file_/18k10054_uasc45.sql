drop database if exists db18k10054_uas;
create database db18k10054_uas;
use db18k10054_uas;

create table tblC45(
  nourut varchar(4),
  demam varchar(100),
  sakitkepala varchar(100),
  nyeri varchar(100),
  lemas varchar(100),
  kelelahan varchar(100),
  hidungtersumbat varchar(100),
  bersin varchar(100),
  sakittenggorokan varchar(100),
  sulitbernafas varchar(100),
  diagnosa varchar(100)
);
-- dibuat oleh 18k10054
insert into tblC45 values
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
select * from tblC45;

create table tblData like tblC45;
insert into tblData  select * from tblC45;
select * from tblData;

create table tblHitung(
  iterasi int default 0,
  atribut varchar(20),
  informasi varchar(20),
  jumlahdata int,
  demam int,
  flu int,
  entropy decimal(8,2),
  gain double
);

create table tblBackup like tblHitung;

create  table tblTampung(
  atribut varchar(20),
  gain double
);

create table tblKesimpulan(
  atribut varchar(20),
  informasi varchar(20),
  demam varchar(20),
  flu varchar(20),
  entropy varchar(20),
  gain double
);

delimiter ##
create procedure spIsi()
-- untuk total data
begin
  select count(*) into @jumlahdata from tblC45;
  select @demam := count(*)
  from tblC45
  where diagnosa ='demam';

  select @flu := count(*)
  from tblC45
  where diagnosa ='flu';

  select @jumlahdata,@demam,@flu;
  select @entropy := (-1*(@demam/@jumlahdata)*log2(@demam/@jumlahdata))+
  @entropy := (-1*(@flu/@jumlahdata)*log2(@flu/@jumlahdata));
  if @entropy is null THEN
    set @entropy=0;
  end if;
  select @entropy;
  insert into tblHitung(atribut,jumlahdata,demam,flu,entropy) values
    ('TOTAL DATA',@jumlahdata,@demam,@flu,@entropy);

end ##
delimiter ;
-- isi tabel hitung
delimiter ##
create procedure spEntropy(kolom varchar(233))
  begin
    declare queryv varchar(1000);
    declare queryw varchar(1000);
    declare queryz varchar(1000);
    declare queryu varchar(1000);
    declare querya varchar(1000);
    set queryv = concat('insert into tblHitung(informasi,jumlahdata,demam,flu) select A.',kolom,', count(*),');
    set queryw = concat('(select count(*) from tblC45 as B where B.diagnosa ="demam" and B.',kolom,'=A.',kolom,' ),');
    set queryu = concat('(select count(*) from tblC45 as B where B.diagnosa ="flu" and B.',kolom,'=A.',kolom,' )');
    set queryz = concat('from tblC45 as A group by ',kolom,';');
    set querya = concat('update tblHitung set atribut="',kolom,'"where atribut is null;');
    set queryv = concat(queryv,queryw,queryu,queryz);
    prepare s2 from queryv;
    execute s2;
    deallocate prepare s2;
    prepare s3 from querya;
    execute s3;
    deallocate prepare s3;
  end ##
delimiter ;
delimiter ##
create procedure spHitungEntropy()
BEGIN
  update tblHitung set entropy = (-(demam/jumlahdata)* log2(demam/jumlahdata))+
  (-(flu/jumlahdata)*log2(flu/jumlahdata))
  where demam<>0 and flu<>0;
  update tblHitung set entropy =0 where entropy is null;
end ##
delimiter ;


delimiter ##
create procedure spHitungGain()
  BEGIN
  truncate table tblTampung;
  insert into tblTampung(atribut,gain)
  select atribut,
  @entropy-sum((jumlahdata/@jumlahdata) * entropy)
  from tblHitung
  group by atribut;

  update tblHitung set gain=(
    select gain
    from tblTampung
    where atribut=tblHitung.atribut
  );
  insert into tblKesimpulan select atribut,informasi,demam,flu,entropy,gain from tblHitung where gain<>0 order by gain desc limit 6 ;

end ##
delimiter ;

delimiter ##
create procedure spJajal()
  BEGIN
  declare x varchar(255);
  declare y varchar(255);
  declare queryx text;
  select informasi into x from tblHitung order by gain desc limit 0,1;
  select atribut into y from tblHitung order by gain desc limit 0,1;
  set queryx =concat('delete from tblC45 where ',y,'<>"',x,'";');
  prepare s1 from queryx;
  execute s1;
  deallocate prepare s1;

end ##
delimiter ;


select 1 into @itr;
delimiter ##
create procedure spIterasi()
begin
call spIsi();
call spEntropy('demam');
call spEntropy('sakitkepala');
call spEntropy('nyeri');
call spEntropy('lemas');
call spEntropy('kelelahan');
call spEntropy('hidungtersumbat');
call spEntropy('bersin');
call spEntropy('sakittenggorokan');
call spEntropy('sulitbernafas');
call spHitungEntropy();
call spHitungGain();
select atribut,informasi,gain from tblHitung order by gain desc limit 1;
call spJajal();
if 0 in (select iterasi from tblHitung ) THEN
 update tblHitung set iterasi=@itr;
  set @itr=@itr+1;
else
  update tblHitung set iterasi=iterasi + 1;
end if;
insert into tblBackup select * from tblHitung;
truncate table tblHitung;

end ##
delimiter ;
-- hasil gain tertinggi yang menjadi root kembar...
-- auto
delimiter ##
-- while 1 not in (select round(gain,1) from tblBackup) do
while 3< (select count(*) from tblC45) do
  call spIterasi();
end while ##
delimiter ;
-- call spIterasi();
select * from tblC45;
select * from tblHitung;
select * from tblBackup;
select * from tblKesimpulan order by atribut;
select "ALEXANDER JASON L (18.K1.0054)" as Pembuat;

-- terimakasih untuk dinamika satu semester ini pak, Semoga semakin baik kedepannya.
-- Code ini saya buat sendiri dengan logic saya sendiri.
-- ALEXANDER Jason Lauwren (18.k1.0054)
