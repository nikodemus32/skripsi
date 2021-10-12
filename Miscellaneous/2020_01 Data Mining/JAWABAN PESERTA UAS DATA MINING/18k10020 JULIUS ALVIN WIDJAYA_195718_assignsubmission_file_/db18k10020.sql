/*Julius Alvin - 18.K1.0020*/

drop database if exists db18k10020;
create database db18k10020;
use db18k10020;

/*Membuat tabel gejala yang berisi gejala2 penyakit*/
create table tblgejala
(
	pasien varchar (10),
	demam varchar (10),
	sakit_kepala varchar (10),
	nyeri varchar (10),
	lemas varchar (10),
	kelelahan varchar (10),
	hidung_tersumbat varchar (10),
	bersin varchar (10),
	sakit_tenggorokan varchar (10),
	sulit_bernafas varchar (10),
	diagnosa varchar (10)
);

/*membuat tabel tingkatan gejala*/
create table tbltingkatgejala
(
	gejala varchar(10)
);

insert into tbltingkatgejala values
('Tidak'), ('Ringan'), ('Parah');


/*membuat tabel penyakit flu dan demam*/
create table tbldiagnosaa
(
	diagnosaa varchar (10)
);

insert into tbldiagnosaa values
('Demam'), ("Flu");



select @gejala as gejala,
@diagnosaa as diagnosa;

insert into tblgejala(gejala, diagnosa) values
(@gejala, @diagnosaa);

select * from tblgejala;

insert into tblgejala(gejala, diagnosaa)
	select gejala as gejala, diagnosaa as diagnosa,
		(
		select gejala
		from tbltingkatgejala as tg
		where tg.Tidak > 2, tg.Ringan > 2 and tg.Parah < 5
		) as 'Flu',
	
		(
		select count(*)
		from tbltingkatgejala as tg2
		where tg2.Tidak > 3, tg2.Ringan < 3 and tg2.Parah > 3
		) as 'Demam'

	from tblgejala as g

update tbldiagnosaa set atribut = 'diagnosa' where atribut is null;

select * from tblgejala;














/* (SP Delimiter)
delimiter $$
create procedure rumus()
begin
	declare i int default 1;
	declare p int default 18;

	while i <> p do
		select * into @p2 from tbltingkatgejala order by rand() limit 1; 
		select * into @p3 from tbltingkatgejala order by rand() limit 1;
		select * into @p4 from tbltingkatgejala order by rand() limit 1;
		select * into @p5 from tbltingkatgejala order by rand() limit 1;
		select * into @p6 from tbltingkatgejala order by rand() limit 1;
		select * into @p7 from tbltingkatgejala order by rand() limit 1;
		select * into @p8 from tbltingkatgejala order by rand() limit 1; 
		select * into @p9 from tbltingkatgejala order by rand() limit 1; 
		select * into @p10 from tbltingkatgejala order by rand() limit 1; 
		select * into @diagnosa from tbldiagnosa order by rand() limit 1; 

		insert into tblgejala values
			(concat('P', i),@p2,@p3,@p4,@p5,@p6,@p7,@p8,@p9,@p10,@diagnosa);

		set i = i+1;
	end while;

	select * from tblgejala;

end $$
delimiter ;

call rumus();
*/