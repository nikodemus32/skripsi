drop database if exists dbCursor;
create database dbCursor;
use dbCursor;

create table tblData
(
nama varchar(30),
alamat varchar(100)
);

insert into tblData values
('Anisa', 'Semarang'),
('Ari', 'Semarang'),
('Ira', 'Salatiga'),
('Ria', 'Magelang'),
('Maria', 'Semarang'),
('Rani', 'Yogyakarta');



delimiter $$
create procedure spTampilSatu()
begin
	declare i int default 0;
	declare vJumData int;

	declare vNama varchar(30);
declare vAlamat varchar(100);

	declare cTampil cursor for
	select * from tblData; /*deklarasikan cursornya*/

	select count(*) into vJumData
	from tblData;

	open cTampil; /*buka cursor*/
	while i <> vJumData Do
		fetch cTampil into vNama, vAlamat; /*baca data dari tabel*/
		select vNama as NAMA, vALamat as ALAMAT;
		set i=i+1;
	end while;
	close cTampil; /*tutup cursor*/
end
$$
delimiter ;

call spTampilSatu;

 create view vwAbjad as
 select distinct(left(nama, 1)) as Abjad
 from tblData
 group by left(nama, 1);

 delimiter $$
 create procedure spTampilAbjad()
 begin
 	declare i int default 0;
 	declare vJumData int;
 	declare vAbjad varchar(1);

 	declare cAbjad cursor for
 	select * from vwAbjad;

 	select count(abjad) into vJumData
 	from vwAbjad; /*cursor untuk abjad dr view vwAbjad*/

 	open cAbjad;
 	while i <> vJumData do
 		fetch cAbjad into vAbjad;
 		select vAbjad as ABJAD;
 		select * from tblData where left(nama, 1) = vAbjad;
 		set i=i+1;
 	end while;
 	close cAbjad;
 end
 $$
 delimiter ;

 call spTampilAbjad;

create view vwAlamat as
  select distinct(alamat) as ALAMAT
  from tblData;
  SELECT * FROM vwAlamat;

delimiter $$
create procedure spTampilAlamat()
begin
	declare i int default 0; /*cursor alamat*/
	declare j int default 0; /*cursor nama*/
	declare vJumData int; /*alamat*/
	declare vJumData2 int; /*nama*/
	declare vAlamat varchar(100);
	declare siapaaja varchar(255);
	declare vNama varchar(30);
	declare vAlamat2 varchar(100);
	declare cAlamat cursor for select * from vwAlamat;
	declare cSiapa cursor for select * from tblData;

	select count(*) into vJumData from vwAlamat; /*menghitung jumlah data vwAlamat (4)*/
	open cAlamat;
	while i <> vJumData do
		fetch cAlamat into vAlamat;
		select count(*) into vJumData2 /*menghitung jumlah data tblData (6)*/
		from tblData;

		set siapaaja='';
		open cSiapa;
		set j=0;
		while j <> vJumData2 DO
			fetch cSiapa into vNama, vAlamat2;
			if vAlamat2=vAlamat then
				set siapaaja=concat(siapaaja, ' ', vNama);
			end if;
			set j=j+1;
      -- SELECT siapaaja as nama; /*debug*/
		end while;
		close cSiapa;

		select vAlamat as Alamat, siapaaja as SIAPA_AJA;
		set i=i+1;
	end while;
	close cAlamat;
end
$$
delimiter ;

call spTampilAlamat();
