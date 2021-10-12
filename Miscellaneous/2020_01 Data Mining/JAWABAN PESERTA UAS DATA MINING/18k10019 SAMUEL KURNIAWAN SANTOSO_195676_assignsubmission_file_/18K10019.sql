drop database if exists dbC45;
CREATE DATABASE dbC45;
use dbC45;

CREATE TABLE tblData
(
    pasien VARCHAR(100),
    demam VARCHAR(100),
    sakitkepala VARCHAR(100),
    nyeri VARCHAR(100),
    lemas VARCHAR(100),
    kelelahan VARCHAR(100),
    hidungtersumbat VARCHAR(100),
    bersin VARCHAR(100),
    sakittenggorokan VARCHAR(100),
    sulitbernafas VARCHAR(10),
    diagnosa VARCHAR(10)
);
-- LOAD DATA LOCAL INFILE 'dbC45.csv'
-- into TABLE tblData
-- FIELDS terminated by ';'
-- enclosed by ''''
-- ignore 1 lines;
insert into tblData values
('P1','Tidak','Ringan','Tidak','Tidak','Tidak','Ringan', 'Parah', 'Parah', 'Ringan','Demam'),
('P2','Parah','Parah','Parah','Parah','Parah','Tidak', 'Tidak', 'Parah', 'Parah','Flu'),
('P3','Parah','Parah','Ringan','Parah','Parah','Parah', 'Tidak', 'Parah', 'Parah','Flu'),
('P4','Tidak','Tidak','Tidak','Ringan','Tidak','Parah', 'Tidak', 'Ringan', 'Ringan','Demam'),
('P5','Parah','Parah','Ringan','Parah','Parah','Parah', 'Tidak', 'Parah', 'Parah','Flu'),
('P6','Tidak','Tidak','Tidak','Ringan','Tidak','Parah', 'Parah', 'Parah', 'Tidak','Demam'),
('P7','Parah','Parah','Parah','Parah','Parah','Tidak', 'Tidak', 'Tidak', 'Parah','Flu'),
('P8','Tidak','Tidak','Tidak','Tidak','Tidak','Parah', 'Parah', 'Tidak', 'Ringan','Demam'),
('P9','Tidak','Ringan','Ringan','Tidak','Tidak','Parah', 'Parah', 'Parah', 'Parah','Demam'),
('P10','Parah','Parah','Parah','Ringan','Ringan','Tidak', 'Parah', 'Tidak', 'Parah','Flu'),
('P11','Tidak','Tidak','Tidak','Ringan','Tidak','Parah', 'Ringan', 'Parah', 'Tidak','Demam'),
('P12','Parah','Ringan','Parah','Ringan','Parah','Tidak', 'Parah', 'Tidak', 'Ringan','Flu'),
('P13','Tidak','Tidak','Ringan','Ringan','Tidak','Parah', 'Parah', 'Parah', 'Tidak','Demam'),
('P14','Parah','Parah','Parah','Parah','Ringan','Tidak', 'Parah', 'Parah', 'Parah','Flu'),
('P15','Ringan','Tidak','Tidak','Ringan','Tidak','Parah', 'Tidak', 'Parah', 'Ringan','Demam'),
('P16','Tidak','Tidak','Tidak','Tidak','Tidak','Parah', 'Parah', 'Parah', 'Parah','Demam'),
('P17','Parah','Ringan','Parah','Ringan','Ringan','Tidak', 'Tidak', 'Tidak', 'Parah','Flu');



select * from tblData;

CREATE TABLE tblHitungan
(
	iterasi int,
	atribut LONGTEXT,
	informasi VARCHAR(20),
	jumlah int,
	flu int,
	demam int,
	entropy decimal(8,4),
	gain decimal(8,4)
);

select * from tblHitungan;

create table tbltes like tblData;
drop table if exists tblmax;
		CREATE TABLE tblmax
		(
		atribut TEXT
		);

DELIMITER ##
create procedure spProsesBackup()
	begin
	 declare vJumData int default 0;
	  declare i int default 0;
	  declare vXbaru varchar(255);
	  declare vYbaru varchar(255);
	  declare querya TEXT;
	  declare queryb TEXT;
	  declare queryc TEXT;
	   declare queryd TEXT;
	
	declare cHit cursor for 
		select * from tblBackup;
		
	select @iterasi;
	set querya = concat("select @jmlhdata:= count(*) from tblData where ");
	set queryb = concat("select @flu:= count(*) from tblData where diagnosa='Flu' and ");
	set queryc = concat("select @demam:= count(*) from tblData where diagnosa='Demam' and ");
	-- insert into tblHitungan(iterasi,atribut, jumlah, flu, demam) values (@iterasi,'Demam Parah',@jmlhdata,@flu,@demam);

	set queryd = concat("insert into tblHitungan(iterasi,atribut, jumlah, flu, demam, entropy) values");
	set queryd = concat(queryd,"(",@iterasi,",","'");
	select count(*) from tblBackup into vJumData;
		 open cHit;
		  while i<>vJumData do
		    fetch cHit into vXbaru, vYbaru;
		    if(i+1<>@iterasi-1) then
				set querya = concat(querya,vXbaru,"='",vYbaru,"'");
				set querya = concat(querya,' AND ');
				set queryb = concat(queryb,vXbaru,"='",vYbaru,"'");
				set queryb = concat(queryb,' AND ');
				set queryc = concat(queryc,vXbaru,"='",vYbaru,"'");
				set queryc = concat(queryc,' AND ');
				set queryd = concat(queryd,vXbaru," ",vYbaru,",");
			else 
				set querya = concat(querya,vXbaru,"='",vYbaru,"'");
				set queryb = concat(queryb,vXbaru,"='",vYbaru,"'");
				set queryc = concat(queryc,vXbaru,"='",vYbaru,"'");
				set queryd = concat(queryd,vXbaru," ",vYbaru,"',");
		    end if;
		  set i = i+1;
		  end while;
		  close cHit;
		  set i=0; 
		PREPARE eksekusi FROM querya;
		EXECUTE eksekusi;
		deallocate prepare eksekusi;
		PREPARE eksekusi FROM queryb;
		EXECUTE eksekusi;
		deallocate prepare eksekusi;
		PREPARE eksekusi FROM queryc;
		EXECUTE eksekusi;
		deallocate prepare eksekusi;

		select @entropy:= round((-(@flu/@jmlhdata)*log2(@flu/@jmlhdata))
		+(-(@demam/@jmlhdata)*log2(@demam/@jmlhdata)),4);

        if(@entropy is NULL) then
	        set @entropy= 0;
	    end if;


        set queryd = concat(queryd,@jmlhdata,',',@flu,',',@demam,',',@entropy,")");
        prepare s1 from queryd;
        execute s1;
        deallocate prepare s1;

	end ##
	DELIMITER ;


DELIMITER ##
create procedure spProsesWer()
	begin
	 declare vJumData int default 0;
	 declare vJumData2 int default 0;
	 declare i int default 0;
	 declare j int default 0;
	 declare vbaru varchar(255);
	  declare vXbaru varchar(255);
	  declare vYbaru varchar(255);
	  declare querya TEXT;
	  declare queryb TEXT;
	  declare queryc TEXT;
	   declare queryd TEXT;
	 declare cWer cursor for
	 	SELECT COLUMN_NAME
  		FROM INFORMATION_SCHEMA.COLUMNS
  		WHERE table_name = 'tblData'
  		AND table_schema = 'dbC45'
  		and  COLUMN_NAME NOT IN('pasien','diagnosa');
  	 declare cHit cursor for 
		select * from tblBackup;
-- https://dev.mysql.com/doc/refman/8.0/en/information-schema-columns-table.html
  	 select count(*) into vJumData 
  	 FROM INFORMATION_SCHEMA.COLUMNS
  		WHERE table_name = 'tblData'
  		AND table_schema = 'dbC45'
  		and  COLUMN_NAME NOT IN('pasien','diagnosa');
	select count(*) from tblBackup into vJumData2;
  	 open cWer;

while i<>vJumData do
  	 
  	fetch cWer into vbaru;

  	 	 IF vbaru NOT IN (SELECT atribut FROM tblBackup) then
  	 	 select vbaru;
  	 	 set querya = concat('Insert into tblHitungan(iterasi, informasi,jumlah,flu,demam)');
         set querya = concat(querya,'select ',@iterasi,',');
         set querya = concat(querya,'A.',vbaru,',');
         set querya = concat(querya,'count(*) as jumlah_data',',');
         set querya = concat(querya,'(select count(*) from tblData as B
			where (B.diagnosa ="Flu"');
         open cHit;
         while j<>vJumData2 do
     	 fetch cHit into vXbaru,vYbaru;
         if(j+1<>@iterasi-1) then
				set querya = concat(querya,' AND ',vXbaru,'=','"',vYbaru,'"');
		 else
		 		set querya = concat(querya,' AND ',vXbaru,'=','"',vYbaru,'")');
		 end if;
		 set j=j+1;
		 end while;
		 set j=0;
		 close cHit;
		 set querya = concat(querya,' and B.',vbaru,'=','A.',vbaru,')',' as "No",');
		 set querya = concat(querya,'(select count(*) from tblData as C
		    where (C.diagnosa ="Demam"');
         open cHit;
		 while j<>vJumData2 do
     	 fetch cHit into vXbaru,vYbaru;
		 if(j+1<>@iterasi-1) then
        		set querya = concat(querya,' AND ',vXbaru,'=','"',vYbaru,'"');
         else
        		set querya = concat(querya,' AND ',vXbaru,'=','"',vYbaru,'")');
        		
         end if;
         set j=j+1;
		 end while;
         set j=0;
		 close cHit;
         set querya = concat(querya,' and C.',vbaru,'=','A.',vbaru,')',' as "Yes"');
          set querya = concat(querya,' from tblData as A where ');

         open cHit;
         while j<>vJumData2 do
     	 fetch cHit into vXbaru,vYbaru;
         if(j+1<>@iterasi-1) then
        		set querya = concat(querya,vXbaru,'=','"',vYbaru,'"',' AND ');
         else
        		set querya = concat(querya,vXbaru,'=','"',vYbaru,'"');
         end if;
         set j=j+1;
		 end while;
		 set j=0;
		 close cHit;
         set querya = concat(querya,' group by A.',vbaru);
        prepare s1 from querya;
        execute s1;
        deallocate prepare s1;
        end if;
        set querya = '';
        set querya = concat('update tblHitungan set atribut="',vbaru,'" where atribut is null and iterasi=',@iterasi);
        prepare s1 from querya;
        execute s1;
        deallocate prepare s1;
  	 	

	 set i=i+1;
  	 end while;

select vJumData;
		
	end ##
DELIMITER ;

CREATE TABLE tblBackup
(
	atribut TEXT,
	informasi VARCHAR(20)
);

DELIMITER ##
CREATE procedure spHitungan()
begin
	declare vA varchar(5) default '';
	declare querya TEXT;
	declare queryb TEXT;
	declare queryc TEXT;
	declare i int default 1;
  	SELECT count(*) into @numberofcol FROM information_schema.columns
    WHERE table_name ='tbltes';
    set @numberofcol=@numberofcol-2;

    set @iterasi=1;


	WHILE @numberofcol>7 DO

		if (@iterasi=1) then

		set querya = concat('select @jmlhdata:= count(*) from tblData');
		prepare s1 from querya;
        execute s1;
        deallocate prepare s1;

        set querya = concat('select @flu:= count(*) from tblData where diagnosa="Flu"');
		prepare s1 from querya;
        execute s1;
        deallocate prepare s1;

		set querya = concat('select @demam:= count(*) from tblData where diagnosa="Demam"');
		prepare s1 from querya;
        execute s1;
        deallocate prepare s1;		

        set querya = concat('select @entropy:= round((-(@flu/@jmlhdata)*log2(@flu/@jmlhdata))
		+(-(@demam/@jmlhdata)*log2(@demam/@jmlhdata)),4);');
		prepare s1 from querya;
        execute s1;
        deallocate prepare s1;


        set querya = concat('insert into tblHitungan(iterasi,atribut, jumlah, flu, demam , entropy) values');
        set queryb = concat(querya,'(',@iterasi,',"Total",', @jmlhdata, ',', @flu, ',',@demam,',', @entropy,')');
        prepare s1 from queryb;
        execute s1;
        deallocate prepare s1;

        set querya = concat('Insert into tblHitungan(informasi, jumlah, flu, demam)');
        set querya = concat(querya,'select A.demam, count(*) as jumlah_data,');
        set querya = concat(querya,'(select count(*) from tblData as B
			where B.diagnosa ="Flu" and B.demam=A.demam 
			) as "No",');
        set queryc = concat(querya,'(select count(*) from tblData as C
	 		where C.diagnosa ="Demam" and C.demam=A.demam 
	 		) as "Yes"');
        set queryb = concat(queryc,'from tblData as A group by A.demam');
        prepare s1 from queryb;
        execute s1;
        deallocate prepare s1;

        set querya = concat('update tblHitungan set atribut="Demam" where atribut is null');
        prepare s1 from querya;
        execute s1;
        deallocate prepare s1;

        set querya = concat('update tblHitungan set iterasi=',@iterasi,' where iterasi is null');
        prepare s1 from querya;
        execute s1;
        deallocate prepare s1;

        set querya = concat('Insert into tblHitungan(informasi, jumlah, flu, demam)');
        set queryb = concat(querya,'select A.sakitkepala, count(*) as jumlah_data,');
        set queryb = concat(queryb,'(select count(*) from tblData as B 
        	where B.diagnosa ="Flu" and B.sakitkepala=A.sakitkepala
        	) as "No",');
        set queryc = concat(queryb,'(select count(*) from tblData as C
			where C.diagnosa ="Demam" and C.sakitkepala=A.sakitkepala
		) as "Yes"');
		 set queryb = concat(queryc,'from tblData as A group by A.sakitkepala');
		 prepare s1 from queryb;
        execute s1;
        deallocate prepare s1;

        set querya = concat('update tblHitungan set atribut="sakit kepala" where atribut is null');
        prepare s1 from querya;
        execute s1;
        deallocate prepare s1;

        set querya = concat('update tblHitungan set iterasi=',@iterasi,' where iterasi is null');
        prepare s1 from querya;
        execute s1;
        deallocate prepare s1;

        set querya = concat('Insert into tblHitungan(informasi, jumlah, flu, demam)');
        set queryb = concat(querya,'select A.nyeri, count(*) as jumlah_data,');
        set queryb = concat(queryb,'(select count(*) from tblData as B 
        	where B.diagnosa ="Flu" and B.nyeri=A.nyeri
        	) as "No",');
        set queryc = concat(queryb,'(select count(*) from tblData as C
			where C.diagnosa ="Demam" and C.nyeri=A.nyeri
		) as "Yes"');
		 set queryb = concat(queryc,'from tblData as A group by A.nyeri');
		 prepare s1 from queryb;
        execute s1;
        deallocate prepare s1;

        set querya = concat('update tblHitungan set atribut="nyeri" where atribut is null');
        prepare s1 from querya;
        execute s1;
        deallocate prepare s1;

        set querya = concat('Insert into tblHitungan(informasi, jumlah, flu, demam)');
        set queryb = concat(querya,'select A.lemas, count(*) as jumlah_data,');
        set queryb = concat(queryb,'(select count(*) from tblData as B 
        	where B.diagnosa ="Flu" and B.lemas=A.lemas
        	) as "No",');
        set queryc = concat(queryb,'(select count(*) from tblData as C
			where C.diagnosa ="Demam" and C.lemas=A.lemas
		) as "Yes"');
		 set queryb = concat(queryc,'from tblData as A group by A.lemas');
		 prepare s1 from queryb;
        execute s1;
        deallocate prepare s1;

        set querya = concat('update tblHitungan set atribut="lemas" where atribut is null');
        prepare s1 from querya;
        execute s1;
        deallocate prepare s1;

        set querya = concat('Insert into tblHitungan(informasi, jumlah, flu, demam)');
        set queryb = concat(querya,'select A.kelelahan, count(*) as jumlah_data,');
        set queryb = concat(queryb,'(select count(*) from tblData as B 
        	where B.diagnosa ="Flu" and B.kelelahan=A.kelelahan
        	) as "No",');
        set queryc = concat(queryb,'(select count(*) from tblData as C
			where C.diagnosa ="Demam" and C.kelelahan=A.kelelahan
		) as "Yes"');
		 set queryb = concat(queryc,'from tblData as A group by A.kelelahan');
		 prepare s1 from queryb;
        execute s1;
        deallocate prepare s1;

        set querya = concat('update tblHitungan set atribut="kelelahan" where atribut is null');
        prepare s1 from querya;
        execute s1;
        deallocate prepare s1;

        set querya = concat('Insert into tblHitungan(informasi, jumlah, flu, demam)');
        set queryb = concat(querya,'select A.hidungtersumbat, count(*) as jumlah_data,');
        set queryb = concat(queryb,'(select count(*) from tblData as B 
        	where B.diagnosa ="Flu" and B.hidungtersumbat=A.hidungtersumbat
        	) as "No",');
        set queryc = concat(queryb,'(select count(*) from tblData as C
			where C.diagnosa ="Demam" and C.hidungtersumbat=A.hidungtersumbat
		) as "Yes"');
		 set queryb = concat(queryc,'from tblData as A group by A.hidungtersumbat');
		 prepare s1 from queryb;
        execute s1;
        deallocate prepare s1;

        set querya = concat('update tblHitungan set atribut="hidungtersumbat" where atribut is null');
        prepare s1 from querya;
        execute s1;
        deallocate prepare s1;

         set querya = concat('Insert into tblHitungan(informasi, jumlah, flu, demam)');
        set queryb = concat(querya,'select A.bersin, count(*) as jumlah_data,');
        set queryb = concat(queryb,'(select count(*) from tblData as B 
        	where B.diagnosa ="Flu" and B.bersin=A.bersin
        	) as "No",');
        set queryc = concat(queryb,'(select count(*) from tblData as C
			where C.diagnosa ="Demam" and C.bersin=A.bersin
		) as "Yes"');
		 set queryb = concat(queryc,'from tblData as A group by A.bersin');
		 prepare s1 from queryb;
        execute s1;
        deallocate prepare s1;

        set querya = concat('update tblHitungan set atribut="bersin" where atribut is null');
        prepare s1 from querya;
        execute s1;
        deallocate prepare s1;


        set querya = concat('Insert into tblHitungan(informasi, jumlah, flu, demam)');
        set queryb = concat(querya,'select A.sakittenggorokan, count(*) as jumlah_data,');
        set queryb = concat(queryb,'(select count(*) from tblData as B 
        	where B.diagnosa ="Flu" and B.sakittenggorokan=A.sakittenggorokan
        	) as "No",');
        set queryc = concat(queryb,'(select count(*) from tblData as C
			where C.diagnosa ="Demam" and C.sakittenggorokan=A.sakittenggorokan
		) as "Yes"');
		 set queryb = concat(queryc,'from tblData as A group by A.sakittenggorokan');
		 prepare s1 from queryb;
        execute s1;
        deallocate prepare s1;

        set querya = concat('update tblHitungan set atribut="sakittenggorokan" where atribut is null');
        prepare s1 from querya;
        execute s1;
        deallocate prepare s1;

         set querya = concat('Insert into tblHitungan(informasi, jumlah, flu, demam)');
        set queryb = concat(querya,'select A.sulitbernafas, count(*) as jumlah_data,');
        set queryb = concat(queryb,'(select count(*) from tblData as B 
        	where B.diagnosa ="Flu" and B.sulitbernafas=A.sulitbernafas
        	) as "No",');
        set queryc = concat(queryb,'(select count(*) from tblData as C
			where C.diagnosa ="Demam" and C.sulitbernafas=A.sulitbernafas
		) as "Yes"');
		 set queryb = concat(queryc,'from tblData as A group by A.sulitbernafas');
		 prepare s1 from queryb;
        execute s1;
        deallocate prepare s1;

        set querya = concat('update tblHitungan set atribut="sulitbernafas" where atribut is null');
        prepare s1 from querya;
        execute s1;
        deallocate prepare s1;

        set querya = concat('update tblHitungan set iterasi=',@iterasi,' where iterasi is null');
        prepare s1 from querya;
        execute s1;
        deallocate prepare s1;


        set querya = concat('update tblHitungan set entropy = (-(flu/jumlah)*log2(flu/jumlah))
        +(-(demam/jumlah)*log2(demam/jumlah)) where flu !=0 and demam!=0;');
        prepare s1 from querya;
        execute s1;
        deallocate prepare s1;

        set querya = concat('update tblHitungan set entropy = 0 where entropy is null');
        prepare s1 from querya;
        execute s1;
        deallocate prepare s1;

		drop TABLE if exists tblTampung;
		CREATE temporary TABLE tblTampung
		(
			atribut LONGTEXT,
			gain decimal(8,4)
		);

		insert into tblTampung(atribut, gain)
		select atribut, @entropy - 
		sum((jumlah/@jmlhdata)*entropy) as gain
		from tblHitungan
		group by atribut;

		select * from tblTampung;

		update tblHitungan set gain = (
		select gain
		  from tblTampung
		  where atribut=tblHitungan.atribut
		);
		
		select * from tblHitungan;
		drop table if exists tblmax;
		CREATE TABLE tblmax(
		atribut LONGTEXT
		);

	insert into tblmax(atribut)
		select @atribut1:=atribut 
		from tblHitungan
		where gain = (
			select max(gain)
			from tblHitungan

		)
		group by atribut
		limit 1;

		select * from tblmax;

		select informasi into @informasi1 from tblHitungan 
		where atribut = @atribut1 
		or (flu!=0 and demam!=0)
		and entropy=(select max(entropy) from tblHitungan where atribut=@atribut1 limit 1)  
		limit 1;
		insert into tblBackup values((select @atribut1),(select @informasi1));

		else

		call spProsesBackup();
		call spProsesWer();

        set querya = concat('update tblHitungan set entropy = (-(flu/jumlah)*log2(flu/jumlah))
        +(-(demam/jumlah)*log2(demam/jumlah)) where flu !=0 and demam!=0');
        prepare s1 from querya;
        execute s1;
        deallocate prepare s1;

        set querya = concat('update tblHitungan set entropy = 0 where entropy is null');
        prepare s1 from querya;
        execute s1;
        deallocate prepare s1;

		drop TABLE if exists tblTampung;
		CREATE temporary TABLE tblTampung
		(
			atribut LONGTEXT,
			gain decimal(8,4)
		);

		insert into tblTampung(atribut, gain)
		select atribut, @entropy - 
		sum((jumlah/@jmlhdata)*entropy) as gain
		from tblHitungan
		where iterasi=@iterasi
		group by atribut;

		select * from tblTampung;

		update tblHitungan set gain = (
		select gain
		  from tblTampung
		  where atribut=tblHitungan.atribut

		) where iterasi=@iterasi;

		set querya = concat('update tblHitungan set entropy = 0 where entropy is null');
        prepare s1 from querya;
        execute s1;
        deallocate prepare s1;
		
		drop table if exists tblmax;
		CREATE TABLE tblmax(
		atribut TEXT
		);

		select max(gain) into @maxcoffee from tblHitungan where iterasi=@iterasi;
		if @maxcoffee=0 then

		set querya = concat('insert into tblmax(atribut) values("Tidak memenuhi syarat C45 lagi")');
        prepare s1 from querya;
        execute s1;
        deallocate prepare s1;
		
		else 
			set querya = concat('insert into tblmax(atribut)
			select @atribut:=atribut 
			from tblHitungan
			where gain = (
				select max(gain)
				from tblHitungan
				where iterasi=@iterasi
			)');
				set querya =concat('select informasi into @informasi from tblHitungan where atribut = @atribut and (flu!=0 and demam!=0)
				 	and iterasi=@iterasi
				 	and entropy=(select max(entropy)from tblHitungan where atribut=@atribut and iterasi=@iterasi)')  ;
				prepare s1 from querya;
        		execute s1;
        		deallocate prepare s1;
				set querya = concat('insert into tblBackup values((select @atribut),(select @informasi))');
				prepare s1 from querya;
        		execute s1;
        		deallocate prepare s1;
		end if;

		end if;
		set @iterasi=@iterasi+1;
		set @numberofcol=@numberofcol-1;


	end while;
select * from tblHitungan;
select * from tblmax;
end##
DELIMITER ;

call spHitungan();



 