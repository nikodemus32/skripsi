drop database if exists dbUTS;
create database dbUTS;
use dbUTS;

create table tblData
(
datake int,
x decimal(8,2),
y decimal(8,2)
);

create table tblCentroid
(
Centroid int,
cx decimal (8,2),
cy decimal (8,2)
);

create table tblDistancemin
(
distancemin decimal(8,2)
);

create table tblBanding
(
NoDataB int,
CSebelum varchar(5),
CSesudah varchar(5)
);


delimiter $$
create procedure spInsertData(vBerapa int)
begin
	declare i int default 0;
	declare x,y decimal(8,2);
		while i <> vBerapa do
		insert into tblData values(i+1, floor(rand()*(60-30+1)+30), floor(rand()*(60-30+1)+30));
		set i = i+1;
	end while;
	select * from tblData;
end $$
delimiter ;

call spInsertData(15);

delimiter $$
create procedure spRandomCentroid(vBerapa int)
begin
	declare i int default 0;
	declare x,y decimal(8,2);
	while i <> vBerapa do
	insert into tblCentroid values(i+1, floor(rand()*100), floor(rand()*100));
		set i = i+1;
	end while;
	select * from tblCentroid;
end $$
delimiter ;

call spRandomCentroid(3);

delimiter $$
create procedure spInserttblBanding()
begin
	declare i, vJumData, vNoData int default 0;
	declare cTblBanding cursor for select datake from tblData;

	select count(*) into vJumData FROM tblData;
  	open cTblBanding;
  	while i<>vJumData do
    	fetch cTblBanding into vNoData;
      	insert into tblBanding VALUES (vNoData, '--', '');
  	set i:=i+1;
  	end while;
  	close cTblBanding;
end $$
delimiter ;
call spInserttblBanding();


delimiter $$
create procedure spCentroidBaru()
begin
	declare vCBaru int;
	declare vCxBaru, vCyBaru decimal(8,2);
	declare i, vJumData int;
	declare cVwCBaru cursor for select * from CentroidBaru;
	select count(*) into vJumData from CentroidBaru;

	set i:=0;
	open cVwCBaru;
	truncate table tblCentroid;
	truncate table tblITERASI;
	while i <> vJumData do
		fetch cVwCBaru into vCBaru, vCxBaru, vCyBaru;
		insert into tblCentroid values (vCBaru, vCxBaru, vCyBaru);
	set i:=i+1;
	end while;
	close cVwCBaru;
end $$


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


CREATE TABLE tblITERASI (NoData int, X1 decimal, Y1 decimal, C int, Cx decimal(8,2), Cy decimal(8,2), 
	MasukCluster int, Distance decimal(8,2));
DELIMITER $$
CREATE PROCEDURE spCluster()
begin
	declare i, j int default 0;
	declare vJumData, vJumData2 int;
	declare vNoData, vNoC int;
	declare vC1 int;
	declare d1, k1, titikX1, titikY1, vCx, vCy decimal(8,2);
	declare cData cursor for select * from tblData;
	declare cCentroid cursor for select * from tblCentroid;

	select count(*) into vJumData from tblData;
	select count(*) into vJumData2 from tblCentroid;

	open cData;
	set i=0;
	while i <> vJumData do 
	fetch cData into vNoData, titikX1, titikY1;
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
				insert into tblITERASI values (vNoData, titikX1, titikY1, vNoC, vCx, vCy, vC1, d1);
				update tblITERASI set MasukCluster=vC1 where NoData=vNoData;
				update tblBanding set CSesudah=vC1 where NoDataB=vNoData;
			set j=j+1;
			end while;
		close cCentroid;
		insert into tblDistancemin values (k1);
	set i=i+1;
	end while;
	close cData;
	select NoData, X1, Y1, C, Cx, Cy, Distance, CONCAT("C", MasukCluster) as MasukCluster from tblITERASI;
	select * from tblDistancemin;

end
$$
DELIMITER ;

delimiter $$
create procedure spHasilCluster()
begin
	declare i, j, vJumData, vNoDataB, jumlahSama int;
	declare vCSebelum, vCSesudah varchar(5);
	declare cBanding cursor for select * from tblBanding;
	select count(*) into vJumData from tblBanding;
		truncate table tblDistancemin;
		truncate tblBanding;
		call spInserttblBanding();
		set j:=0;
	  	set jumlahSama:=0;
	  	while jumlahSama<>vJumData DO
	  	set jumlahSama:=0;
      	set j:=j+1;
      	select j as 'looping ke';
      	select * from tblCentroid;
		call spCluster();
		select * from tblBanding;
		open cBanding;
        	set i:=0;
        	while i<>vJumData DO
          		fetch cBanding into vNoDataB, vCSebelum, vCSesudah;
            	if(vCSebelum=vCSesudah) then
            		set jumlahSama:=jumlahSama+1;
            		update tblBanding set CSebelum=vCSesudah where NoDataB=1+i;
           		 else
            		update tblBanding set CSebelum=vCSesudah where NoDataB=1+i;
            	end if;
        	set i=i+1;
        	end while;
        
        DROP VIEW IF EXISTS CentroidBaru;
		CREATE VIEW CentroidBaru AS
		select (MasukCluster) as CentroidBaru,
		AVG(X1) as CxBaru, AVG(Y1) as CyBaru
		from tblITERASI
		group by MasukCluster
		order by CentroidBaru;

		call spCentroidBaru();
		truncate tblDistancemin;
      	close cBanding;
    	end while;
end $$
delimiter ;

call spHasilCluster();