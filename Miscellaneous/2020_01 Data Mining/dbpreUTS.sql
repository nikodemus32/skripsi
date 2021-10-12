drop database if exists dbpreUTS;
create database dbpreUTS;
use dbpreUTS;

create table tblData
(
notest int,
bahasa int,
matematika int,
logika int
);

create table tblCentroidPsi
(
C int,
cx decimal (8,2),
cy decimal (8,2)
);

create table tblCentroidInf
(
C int,
cx decimal (8,2),
cy decimal (8,2)
);

create table tblDistancemin
(
distanceminpsi decimal(8,2),
distancemininf decimal(8,2)
);

create table tblBanding
(
NoTest1 int,
CSebelum varchar(5),
CSesudah varchar(5)
);
/*
INSERT INTO tblBanding values
  (1101, 'NN', ''),
  (1102, 'NN', ''),
  (1103, 'NN', ''),
  (1104, 'NN', ''),
  (1105, 'NN', ''),
  (1106, 'NN', ''),
  (1107, 'NN', ''),
  (1108, 'NN', ''),
  (1109, 'NN', ''),
  (1110, 'NN', '');
/*create table tblClusterP
(
C int,
distance decimal (8,2)
);

create table tblClusterM
(
C int,
distance decimal (8,2)
);

create table tblCluster
(
C1 int,
distance1 decimal (8,2),
C2 int,
distance2 decimal (8,2)
);*/


delimiter $$
create procedure spInsertData(vNotest int, vBahasa int, vMath int, vLogic int)
begin
	insert into tblData values(vNotest, vBahasa, vMath, vLogic);
end $$
delimiter ;

call spInsertData(1101, 80, 98, 45);
call spInsertData(1102, 20, 65, 98);
call spInsertData(1103, 27, 38, 16);
call spInsertData(1104, 70, 99, 97);
call spInsertData(1105, 92, 99, 93);
call spInsertData(1106, 46, 45, 88);
call spInsertData(1107, 57, 39, 92);
call spInsertData(1108, 91, 17, 45);
call spInsertData(1109, 58, 58, 91);
call spInsertData(1110, 10, 57, 94);

delimiter $$
create procedure spRandomCentroid(vBerapa int)
begin
	declare i int default 0;
	while i <> vBerapa do
	insert into tblCentroidPsi values(i+1, rand()*100, rand()*100);
	insert into tblCentroidInf values(i+1, rand()*100, rand()*100);
		set i = i+1;
	end while;
end $$
delimiter ;

call spRandomCentroid(3);


delimiter $$
create procedure spInserttblBanding()
begin
	declare i, vJumData, vNoTest int default 0;
	declare cTblHasilCek cursor for select notest from tblData;

	select count(*) into vJumData FROM tblData;
  	open cTblHasilCek;
  	while i<>vJumData do
    	fetch cTblHasilCek into vNoTest;
      	insert into tblBanding VALUES (vNoTest, '--', '');
  	set i:=i+1;
  	end while;
  	close cTblHasilCek;
end $$
delimiter ;
call spInserttblBanding();

/*delimiter $$
create trigger tgAutoInsert after insert on tblCentroidPsi
for each row 
begin
	insert into tblCentroidInf(C, cx, cy)
	values(NEW.C, NEW.cx, NEW.cy);
end $$
delimiter ;	


select * from tblCentroidInf;
select * from tblCentroidPsi;
/*
/*
select CONCAT('(', cx, ',', cy, ')') as C1 from tblCentroid where C=1;
select CONCAT('(', cx, ',', cy, ')') as C2 from tblCentroid where C=2;
select CONCAT('(', cx, ',', cy, ')') as C3 from tblCentroid where C=3;*/

delimiter $$
create function sfDistance(x decimal(8,2), y decimal(8,2),
						   cx decimal(8,2), cy decimal(8,2))
returns decimal(8,2)
begin
	declare vJarak decimal(8,2);
	set vJarak = SQRT(POW((x - cx), 2) + POW((y - cy), 2));
	return(vJarak);
end $$
delimiter ;

/*
delimiter $$
create function sfBanding(Distance1 decimal(8,2), Distance2 decimal(8,2))
returns decimal(8,2)
begin
	declare vBanding decimal(8,2);
	set vJarak = IF(Distance1>Distance2,Distance2,Distance1));
	return(vBanding);
end $$
delimiter ;*/

CREATE TABLE tblITERASIPsi (NoTest int, X1 decimal, Y1 decimal, C int, Cx decimal(8,2), Cy decimal(8,2), 
	CPsi int, Distance1 decimal(8,2));
DELIMITER $$
CREATE PROCEDURE spClusterPsi()
begin
	declare i, j int default 0;
	declare vJumData, vJumData2 int;
	declare vNoTest, vNoC int;
	declare vC1 int;
	declare d1, k1, titikX1, titikY1, vCx, vCy decimal(8,2);
	declare cPsikologi cursor for select notest, bahasa, logika from tblData;
	declare cCentroid cursor for select * from tblCentroidPsi;

	select count(*) into vJumData from tblData;
	select count(*) into vJumData2 from tblCentroidPsi;

	open cPsikologi;
	set i=0;
	while i <> vJumData do 
	fetch cPsikologi into vNoTest, titikX1, titikY1;
		open cCentroid;
			set j=0;
			set k1=1000;
			while j <> vJumData2 do
			fetch cCentroid into vNoC, vCx, vCy;
				set d1:=sfDistance(titikX1, titikY1, vCx, vCy);
				if(d1<k1) then
					set k1:=d1;
					set vC1:=vNoC;
				end if;
				insert into tblITERASIPsi values (vNoTest, titikX1, titikY1, vNoC, vCx, vCy, vC1, d1);
				update tblITERASIPsi set CPsi=vC1 where NoTest=vNoTest;
			set j=j+1;
			end while;
		close cCentroid;
	set i=i+1;
	end while;
	close cPsikologi;
	select NoTest, X1, Y1, C, Cx, Cy, Distance1, CONCAT("C", CPsi) as CPsi from tblITERASIPsi;

end
$$
DELIMITER ;

call spClusterPsi;


CREATE TABLE tblITERASIInf (NoTest int, X2 decimal, Y2 decimal, C int, Cx decimal(8,2), Cy decimal(8,2), CInf int, Distance2 decimal(8,2));
DELIMITER $$
CREATE PROCEDURE spClusterInf()
begin
	declare i, j int default 0;
	declare vJumData, vJumData2 int;
	declare vNoTest, vNoC int;
	declare vC1, vC2 int;
	declare d2, k2, titikX2, titikY2, vCx, vCy decimal(8,2);
	declare cInformatika cursor for select notest, matematika, logika from tblData;
	declare cCentroid cursor for select * from tblCentroidInf;

	select count(*) into vJumData from tblData;
	select count(*) into vJumData2 from tblCentroidInf;

	open cInformatika;
	set i=0;
	while i <> vJumData do 
	fetch cInformatika into vNoTest, titikX2, titikY2;
		open cCentroid;
			set j=0;
			set k2=1000;
			while j <> vJumData2 do
			fetch cCentroid into vNoC, vCx, vCy;

				set d2:=sfDistance(titikX2, titikY2, vCx, vCy);
				if(d2<k2) then
					set k2:=d2;
					set vC2:=vNoC;
				end if;
				insert into tblITERASIInf values (vNoTest, titikX2, titikY2, vNoC, vCx, vCy, vC2, d2);
				update tblITERASIInf set CInf=vC2 where NoTest=vNoTest;
			set j=j+1;
			end while;
		close cCentroid;
		/*insert into tblDistancemin values (k1,k2);*/
	set i=i+1;
	end while;
	close cInformatika;
	select NoTest, X2, Y2, C, Cx, Cy, Distance2, CONCAT("C", CInf) as CInf from tblITERASIInf;

end
$$
DELIMITER ;

call spClusterInf;



/*DROP VIEW IF EXISTS CBaruPsikologi;
CREATE VIEW CBaruPsikologi AS
select (CPsi) as CBaruPsikologi,
AVG(X1) as CxBaruP, AVG(Y1) as CyBaruP
from tblITERASIPsi
group by CPsi
order by CBaruPsikologi;

DROP VIEW IF EXISTS CBaruInformatika;
CREATE VIEW CBaruInformatika AS
select (CInf) as CBaruInformatika,
AVG(X2) as CxBaruI, AVG(Y2) as CyBaruI
from tblITERASIInf
group by CInf
order by CBaruInformatika;
/*
select * from CBaruPsikologi;
select * from CBaruInformatika;

/*insert C baru*/

delimiter $$
create procedure spCentroidBaruPsi()
begin
	declare vCBaru int;
	declare vCxBaru, vCyBaru decimal(8,2);
	declare i, vJumData int;
	declare cVwPsi cursor for select * from CBaruPsikologi;
	select count(*) into vJumData from CBaruPsikologi;

	set i:=0;
	open cVwPsi;
	truncate table tblCentroidPsi;
	truncate table tblITERASIPsi;
	while i <> vJumData do
		fetch cVwPsi into vCBaru, vCxBaru, vCyBaru;
		insert into tblCentroidPsi values (vCBaru, vCxBaru, vCyBaru);
	set i:=i+1;
	end while;
	close cVwPsi;
	select * from tblCentroidPsi;
end $$
/*
call spCentroidBaruPsi();
call spClusterPsi;
call spCentroidBaruPsi();
call spClusterPsi;*/



delimiter $$
create procedure spCentroidBaruInf()
begin
	declare vCBaru int;
	declare vCxBaru, vCyBaru decimal(8,2);
	declare i, vJumData int;
	declare cVwInf cursor for select * from CBaruInformatika;
	select count(*) into vJumData from CBaruInformatika;

	set i:=0;
	open cVwInf;
	truncate table tblCentroidInf;
	truncate table tblITERASIInf;
	while i <> vJumData do
		fetch cVwInf into vCBaru, vCxBaru, vCyBaru;
		insert into tblCentroidInf values (vCBaru, vCxBaru, vCyBaru);
	set i:=i+1;
	end while;
	close cVwInf;
	select * from tblCentroidInf;
end $$
delimiter ;
/*
call spCentroidBaruInf();
call spClusterInf;
call spCentroidBaruInf();
call spClusterInf;

/*delimiter $$
create procedure spUpdate()
begin
	declare i int default 0;
	declare vJumData int;
	select count(*) into vJumData from tblBandingPsi;
	while i <> vJumData do
	update tblBandingPsi set CSebelum=CSesudah where NoTest1=NoTest1;
	set i = i+1;
	end while;
end $$
delimiter ;

call spUpdate;*/

delimiter $$
create procedure spHasilClusterPsi(jurusan varchar(15))
begin
	declare i, j, vJumData, vNoTest, jumlahSama, pengulangan int;
	declare vCSebelum, vCSesudah varchar(5);
	declare cBanding cursor for select * from tblBanding;
	select count(*) into vJumData from tblBanding;
	if (jurusan="Psikologi") then
	  truncate tblBanding;
	  call spInserttblBanding();
	  set j:=0;
	  set jumlahSama:=0;
	  	while jumlahSama<>vJumData DO
      	set j:=j+1;
      	select j as 'looping ke';

      	DROP VIEW IF EXISTS CBaruPsikologi;
		CREATE VIEW CBaruPsikologi AS
		select (CPsi) as CBaruPsikologi,
		AVG(X1) as CxBaruP, AVG(Y1) as CyBaruP
		from tblITERASIPsi
		group by CPsi
		order by CBaruPsikologi;

		call spCentroidBaruPsi();
		call spClusterPsi();
		open cBanding;
        	set i:=0;
        	while i<>vJumData DO
          		fetch cBanding into vNoTest, vCSebelum, vCSesudah;
            	if(vCSebelum=vCSesudah) then
            		set jumlahSama:=jumlahSama+1;
            		update tblBanding set CSebelum=vCSesudah where NoTest1=1101+i;
           		 else
            		update tblBanding set CSebelum=vCSesudah where NoTest1=1101+i;
            	end if;
        	set i=i+1;
        	end while;
      	close cBanding;
    	end while;
    end if;
end $$
delimiter ;

delimiter $$
create procedure spHasilClusterInf(jurusan varchar(15))
begin
	declare i, j, vJumData, vNoTest, jumlahSama, pengulangan int;
	declare vCSebelum, vCSesudah varchar(5);
	declare cBanding cursor for select * from tblBanding;
	select count(*) into vJumData from tblBanding;
	if (jurusan="Informatika") then
		truncate tblBanding;
		call spInserttblBanding();
		set j:=0;
	  	set jumlahSama:=0;
	  	while jumlahSama<>vJumData DO
      	set j:=j+1;
      	select j as 'looping ke';


		DROP VIEW IF EXISTS CBaruInformatika;
		CREATE VIEW CBaruInformatika AS
		select (CInf) as CBaruInformatika,
		AVG(X2) as CxBaruI, AVG(Y2) as CyBaruI
		from tblITERASIInf
		group by CInf
		order by CBaruInformatika;


		call spCentroidBaruInf();
		call spClusterInf();
		open cBanding;
        	set i:=0;
        	while i<>vJumData DO
          		fetch cBanding into vNoTest, vCSebelum, vCSesudah;
            	if(vCSebelum=vCSesudah) then
            		set jumlahSama:=jumlahSama+1;
            		update tblBanding set CSebelum=vCSesudah where NoTest1=1101+i;
           		 else
            		update tblBanding set CSebelum=vCSesudah where NoTest1=1101+i;
            	end if;
        	set i=i+1;
        	end while;
      	close cBanding;
    	end while;
    end if;
end $$
delimiter ;


call spHasilClusterPsi("Psikologi");
call spHasilClusterInf("Informatika");




















/*
CREATE TABLE tblITERASIPsi (NoTest int, X1 decimal, Y1 decimal, X2 decimal, Y2 decimal, C int, Cx decimal(8,2), Cy decimal(8,2), 
	CPsi int, Distance1 decimal(8,2), CInf int, Distance2 decimal(8,2));
DELIMITER $$
CREATE PROCEDURE spCluster()
begin
	declare i, j int default 0;
	declare vJumData, vJumData2 int;
	declare vNoTest, vNoC int;
	declare vC1, vC2 int;
	declare d1, d2, k1, k2, titikX1, titikY1, titikX2, titikY2, vCx, vCy decimal(8,2);
	declare cPsikologi cursor for select notest, bahasa, logika from tblData;
	declare cInformatika cursor for select matematika, logika from tblData;
	declare cCentroid cursor for select * from tblCentroid;

	select count(*) into vJumData from tblData;
	select count(*) into vJumData2 from tblCentroid;

	open cPsikologi;
	open cInformatika;
	set i=0;
	while i <> vJumData do 
	fetch cPsikologi into vNoTest, titikX1, titikY1;
	fetch cInformatika into titikX2, titikY2;
		open cCentroid;
			set j=0;
			set k1=1000;
			set k2=1000;
			while j <> vJumData2 do
			fetch cCentroid into vNoC, vCx, vCy;
				set d1:=sfDistance(titikX1, titikY1, vCx, vCy);
				if(d1<k1) then
					set k1:=d1;
					set vC1:=vNoC;
				end if;

				set d2:=sfDistance(titikX2, titikY2, vCx, vCy);
				if(d2<k2) then
					set k2:=d2;
					set vC2:=vNoC;
				end if;

				insert into tblITERASIPsi values (vNoTest, titikX1, titikY1, titikX2, titikY2, vNoC, vCx, vCy, vC1, d1, vC2, d2);
				update tblITERASI1 set CPsi=vC1, CInf=vC2 where NoTest=vNoTest;
			set j=j+1;
			end while;
		close cCentroid;
		insert into tblDistancemin values (k1,k2);
	set i=i+1;
	end while;
	close cInformatika;
	close cPsikologi;
	select vNoTest, titikX1, titikY1, titikX2, titikY2, vNoC, vCx, vCy, CONCAT("C", vC1) as CPsi, d1, CONCAT("C", vC1) as CInf, d2 from tblITERASIPsi;
	select * from tblDistancemin;

end
$$
DELIMITER ;

call spCluster;*/

