/* Nama : Boy Yafet Marcelino N
   NIM : 18.K1.0055 */

/* DATA MINING UAS */

drop database if exists dbUas18k10055;
create database dbUas18k10055;

use dbUas18k10055;

create table tblUas_18k10055
(
	pasien varchar(4),
	demam varchar(10),
	sakitkepala varchar(10),
	nyeri varchar(10),
	lemas varchar(10),
	kelelahan varchar(10),
	hidungtersumbat varchar(10),
	bersin varchar(10),
	sakit_tenggorokan varchar(10),
	sulitbernafas varchar(10),
	diagnosa varchar(10)
);

create table tblPenampung
(
	uastblheader varchar(50),
	infoheader varchar(50),
	jumlah int,
	demam int,
	flu int,
	entropy decimal(8, 4),
	gain decimal(8, 4)
);

insert into tblUas_18k10055 values
('P1','TIDAK','RINGAN','TIDAK','TIDAK','TIDAK','RINGAN','PARAH','PARAH','RINGAN','DEMAM'),
('P2','PARAH','PARAH','PARAH','PARAH','PARAH','TIDAK','TIDAK','PARAH','PARAH','FLU'),
('P3','PARAH','PARAH','RINGAN','PARAH','PARAH','PARAH','TIDAK','PARAH','PARAH','FLU'),
('P4','TIDAK','TIDAK','TIDAK','RINGAN','TIDAK','PARAH','TIDAK','RINGAN','RINGAN','DEMAM'),
('P5','PARAH','PARAH','RINGAN','PARAH','PARAH','PARAH','TIDAK','PARAH','PARAH','FLU'),
('P6','TIDAK','TIDAK','TIDAK','RINGAN','TIDAK','PARAH','PARAH','PARAH','TIDAK','DEMAM'),
('P7','PARAH','PARAH','PARAH','PARAH','PARAH','TIDAK','TIDAK','TIDAK','PARAH','FLU'),
('P8','TIDAK','TIDAK','TIDAK','TIDAK','TIDAK','PARAH','PARAH','TIDAK','RINGAN','DEMAM'),
('P9','TIDAK','RINGAN','RINGAN','TIDAK','TIDAK','PARAH','PARAH','PARAH','PARAH','DEMAM'),
('P10','PARAH','PARAH','PARAH','RINGAN','RINGAN','TIDAK','PARAH','TIDAK','PARAH','FLU'),
('P11','TIDAK','TIDAK','TIDAK','RINGAN','TIDAK','PARAH','RINGAN','PARAH','TIDAK','DEMAM'),
('P12','PARAH','RINGAN','PARAH','RINGAN','PARAH','TIDAK','PARAH','TIDAK','RINGAN','FLU'),
('P13','TIDAK','TIDAK','RINGAN','RINGAN','TIDAK','PARAH','PARAH','PARAH','TIDAK','DEMAM'),
('P14','PARAH','PARAH','PARAH','PARAH','RINGAN','TIDAK','PARAH','PARAH','PARAH','FLU'),
('P15','RINGAN','TIDAK','TIDAK','RINGAN','TIDAK','PARAH','TIDAK','PARAH','RINGAN','DEMAM'),
('P16','TIDAK','TIDAK','TIDAK','TIDAK','TIDAK','PARAH','PARAH','PARAH','PARAH','DEMAM'),
('P17','PARAH','RINGAN','PARAH','RINGAN','RINGAN','TIDAK','TIDAK','TIDAK','PARAH','FLU');

select pasien as '[1]',
	   demam as '[2]',
	   sakitkepala as '[3]',
	   nyeri as '[4]',
	   lemas as '[5]',
	   kelelahan as'[6]',
	   hidungtersumbat as '[7]',
	   bersin as '[8]',
	   sakit_tenggorokan as '[9]',
	   sulitbernafas as '[10]',
	   diagnosa as 'Diagnosa'
from tblUas_18k10055;

/* ITERASI PERTAMA */

select count(*) from tblUas_18k10055
into @hitungan;

select count(*) from tblUas_18k10055
where diagnosa = 'DEMAM'
into @demam;

select count(*) from tblUas_18k10055
where diagnosa = 'FLU'
into @flu;

select (-(@demam/@hitungan) * log2(@demam/@hitungan))
        +
       (-(@flu/@hitungan) * log2(@flu/@hitungan))
into @entropy;

insert into tblPenampung(uastblheader, jumlah, demam, 
						flu, entropy) values
('ITERASI I', @hitungan, @demam, @flu, @entropy);

/* -------------------SPACE--------------------- */

/* DEMAM */
select count(*) from tblUas_18k10055
where demam ='TIDAK'
into @hitungandemam1;

insert into tblPenampung(uastblheader, infoheader, jumlah, demam, flu) values
('DEMAM', 'TIDAK', @hitungandemam1, 8, 0);

select count(*) from tblUas_18k10055
where demam ='RINGAN'
into @hitungandemam2;

insert into tblPenampung(uastblheader, infoheader, jumlah, demam, flu) values
('DEMAM', 'RINGAN', @hitungandemam2, 1, 0);

select count(*) from tblUas_18k10055
where demam ='PARAH'
into @hitungandemam3;

insert into tblPenampung(uastblheader, infoheader, jumlah, demam, flu) values
('DEMAM', 'PARAH', @hitungandemam3, 0, 8);

/* SAKIT KEPALA */
select count(*) from tblUas_18k10055
where sakitkepala ='TIDAK'
into @hitungansakitkepala1;

insert into tblPenampung(uastblheader, infoheader, jumlah, demam, flu) values
('SAKITKEPALA', 'TIDAK', @hitungansakitkepala1, 7, 0);

select count(*) from tblUas_18k10055
where sakitkepala ='RINGAN'
into @hitungansakitkepala2;

insert into tblPenampung(uastblheader, infoheader, jumlah, demam, flu) values
('SAKITKEPALA', 'RINGAN', @hitungansakitkepala2, 2, 2);

select count(*) from tblUas_18k10055
where sakitkepala ='PARAH'
into @hitungansakitkepala3;

insert into tblPenampung(uastblheader, infoheader, jumlah, demam, flu) values
('SAKITKEPALA', 'PARAH', @hitungansakitkepala3, 0, 6);

/* NYERI */
select count(*) from tblUas_18k10055
where nyeri ='TIDAK'
into @hitungannyeri1;

insert into tblPenampung(uastblheader, infoheader, jumlah, demam, flu) values
('NYERI', 'TIDAK', @hitungannyeri1, 7, 0);

select count(*) from tblUas_18k10055
where nyeri ='RINGAN'
into @hitungannyeri2;

insert into tblPenampung(uastblheader, infoheader, jumlah, demam, flu) values
('NYERI', 'RINGAN', @hitungannyeri2, 2, 2);

select count(*) from tblUas_18k10055
where nyeri ='PARAH'
into @hitungannyeri3;

insert into tblPenampung(uastblheader, infoheader, jumlah, demam, flu) values
('NYERI', 'PARAH', @hitungannyeri3, 0, 6);

/* LEMAS */
select count(*) from tblUas_18k10055
where lemas ='TIDAK'
into @hitunganlemas1;

insert into tblPenampung(uastblheader, infoheader, jumlah, demam, flu) values
('LEMAS', 'TIDAK', @hitunganlemas1, 4, 0);

select count(*) from tblUas_18k10055
where lemas ='RINGAN'
into @hitunganlemas2;

insert into tblPenampung(uastblheader, infoheader, jumlah, demam, flu) values
('LEMAS', 'RINGAN', @hitunganlemas2, 5, 3);

select count(*) from tblUas_18k10055
where lemas ='PARAH'
into @hitunganlemas3;

insert into tblPenampung(uastblheader, infoheader, jumlah, demam, flu) values
('LEMAS', 'PARAH', @hitunganlemas3, 0, 5);

/* KELELAHAN */
select count(*) from tblUas_18k10055
where kelelahan ='TIDAK'
into @hitungankelelahan1;

insert into tblPenampung(uastblheader, infoheader, jumlah, demam, flu) values
('KELELAHAN', 'TIDAK', @hitungankelelahan1, 9, 0);

select count(*) from tblUas_18k10055
where kelelahan ='RINGAN'
into @hitungankelelahan2;

insert into tblPenampung(uastblheader, infoheader, jumlah, demam, flu) values
('KELELAHAN', 'RINGAN', @hitungankelelahan2, 0, 3);

select count(*) from tblUas_18k10055
where kelelahan ='PARAH'
into @hitungankelelahan3;

insert into tblPenampung(uastblheader, infoheader, jumlah, demam, flu) values
('KELELAHAN', 'PARAH', @hitungankelelahan3, 0, 5);

/* HIDUNG TERSUMBAT */
select count(*) from tblUas_18k10055
where hidungtersumbat ='TIDAK'
into @hitunganhidungtersumbat1;

insert into tblPenampung(uastblheader, infoheader, jumlah, demam, flu) values
('HIDUNGTERSUMBAT', 'TIDAK', @hitunganhidungtersumbat1, 0, 6);

select count(*) from tblUas_18k10055
where hidungtersumbat ='RINGAN'
into @hitunganhidungtersumbat2;

insert into tblPenampung(uastblheader, infoheader, jumlah, demam, flu) values
('HIDUNGTERSUMBAT', 'RINGAN', @hitunganhidungtersumbat2, 1, 0);

select count(*) from tblUas_18k10055
where hidungtersumbat ='PARAH'
into @hitunganhidungtersumbat3;

insert into tblPenampung(uastblheader, infoheader, jumlah, demam, flu) values
('HIDUNGTERSUMBAT', 'PARAH', @hitunganhidungtersumbat3, 8, 2);

/* BERSIN */
select count(*) from tblUas_18k10055
where bersin ='TIDAK'
into @hitunganbersin1;

insert into tblPenampung(uastblheader, infoheader, jumlah, demam, flu) values
('BERSIN', 'TIDAK', @hitunganbersin1, 2, 5);

select count(*) from tblUas_18k10055
where bersin ='RINGAN'
into @hitunganbersin2;

insert into tblPenampung(uastblheader, infoheader, jumlah, demam, flu) values
('BERSIN', 'RINGAN', @hitunganbersin2, 1, 0);

select count(*) from tblUas_18k10055
where bersin ='PARAH'
into @hitunganbersin3;

insert into tblPenampung(uastblheader, infoheader, jumlah, demam, flu) values
('BERSIN', 'PARAH', @hitunganbersin3, 6, 3);

/* SAKIT TENGGOROKAN */
select count(*) from tblUas_18k10055
where sakit_tenggorokan ='TIDAK'
into @hitungansakit_tenggorokan1;

insert into tblPenampung(uastblheader, infoheader, jumlah, demam, flu) values
('SAKIT_TENGGOROKAN', 'TIDAK', @hitungansakit_tenggorokan1, 1, 4);

select count(*) from tblUas_18k10055
where sakit_tenggorokan ='RINGAN'
into @hitungansakit_tenggorokan2;

insert into tblPenampung(uastblheader, infoheader, jumlah, demam, flu) values
('SAKIT_TENGGOROKAN', 'RINGAN', @hitungansakit_tenggorokan2, 1, 0);

select count(*) from tblUas_18k10055
where sakit_tenggorokan ='PARAH'
into @hitungansakit_tenggorokan3;

insert into tblPenampung(uastblheader, infoheader, jumlah, demam, flu) values
('SAKIT_TENGGOROKAN', 'PARAH', @hitungansakit_tenggorokan3, 7, 4);

/* SULIT BERNAFAS */
select count(*) from tblUas_18k10055
where sulitbernafas ='TIDAK'
into @hitungansulitbernafas1;

insert into tblPenampung(uastblheader, infoheader, jumlah, demam, flu) values
('SULITBERNAFAS', 'TIDAK', @hitungansulitbernafas1, 3, 0);

select count(*) from tblUas_18k10055
where sulitbernafas ='RINGAN'
into @hitungansulitbernafas2;

insert into tblPenampung(uastblheader, infoheader, jumlah, demam, flu) values
('SULITBERNAFAS', 'RINGAN', @hitungansulitbernafas2, 4, 1);

select count(*) from tblUas_18k10055
where sulitbernafas ='PARAH'
into @hitungansulitbernafas3;

insert into tblPenampung(uastblheader, infoheader, jumlah, demam, flu) values
('SULITBERNAFAS', 'PARAH', @hitungansulitbernafas3, 2, 7);

/* ENTROPY */
update tblPenampung set entropy = (-(demam/jumlah) * log2(demam/jumlah))
                               + (-(flu/jumlah) * log2(flu/jumlah));

update tblPenampung set entropy = 0 where entropy is null;

/* GAIN */
drop table if exists tblHasilGain;
create temporary table tblHasilGain
(
	uastblheader varchar(50),
	uasgain decimal(8, 4)
);

insert into tblHasilGain(uastblheader, uasgain)
select uastblheader, 
@entropy - sum((jumlah/@hitungan) * entropy) as uasgain 
from tblPenampung
group by uastblheader;

update tblPenampung set gain =
	(
		select uasgain
		from tblHasilGain
		where uastblheader = tblPenampung.uastblheader
	);

select * from tblPenampung;
