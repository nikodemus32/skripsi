drop database if exists db18K10081UAS;
create database db18K10081UAS;
use db18K10081UAS;

create table tblC45
(
    NoPasien VARCHAR(25),
    Demam VARCHAR(25),
    SakitKepala VARCHAR(25),
    Nyeri VARCHAR(25),
    Lemas VARCHAR(25),
    Kelelahan VARCHAR(25),
		HidungTersumbat VARCHAR(25),
		Bersin VARCHAR(25),
		SakitTenggorokan VARCHAR(25),
		SulitBernafas VARCHAR(25),
		Diagnosa VARCHAR(25)
);

LOAD DATA LOCAL INFILE 'uas.csv'
into table tblC45
FIELDS TERMINATED BY ','
ENCLOSED BY ''''
IGNORE 1 LINES;

select * from tblC45;

create table tblHitung
(
    atribut VARCHAR(20),
    informasi VARCHAR(20),
    jumlahdata INT,
    DiagnosaFlu INT,
    DiagnosaDemam INT,
    entropy decimal(8,4),
    gain decimal(8,4)
);

desc tblHitung;
select count(*) into @jumlahdata from tblC45;
select count(*) into @DiagnosaFlu from tblC45 where Diagnosa = 'Flu';
select count(*) into @DiagnosaDemam from tblC45 where Diagnosa = 'Demam';
select (-(@DiagnosaFlu/@jumlahdata) * log2(@DiagnosaFlu/@jumlahdata)) + (-(@DiagnosaDemam/@jumlahdata) * log2(@DiagnosaDemam/@jumlahdata)) into @entropy;
select @jumlahdata as JUM_DATA,
@DiagnosaFlu as JAWAB_NO, @DiagnosaDemam as JAWAB_YES, ROUND(@entropy,4) as ENTROPY;

insert into tblHitung(atribut, jumlahdata, DiagnosaFlu, DiagnosaDemam, entropy)
VALUES ('TOTAL DATA', @jumlahdata, @DiagnosaFlu, @DiagnosaDemam, @entropy);

select * from tblHitung;
insert into tblHitung(informasi, jumlahdata, DiagnosaFlu, DiagnosaDemam)
    select A.Demam as DEMAM, count(*) as JUMLAH_DATA,
        (
            select count(*) from tblC45 as B where B.Diagnosa = 'Flu' and B.Demam = A.Demam
        ) as 'FLU',
        (
            select count(*) from tblC45 as C where C.Diagnosa = 'Demam' and C.Demam = A.Demam
        ) as 'DEMAM'
    from tblC45 as A group by Demam;
update tblHitung set atribut = 'DEMAM' where atribut is null;


insert into tblHitung(informasi, jumlahdata, DiagnosaFlu, DiagnosaDemam)
    select A.SakitKepala as SAKITKEPALA, count(*) as JUMLAH_DATA,
        (
            select count(*) from tblC45 as B where B.Diagnosa = 'Flu' and B.SakitKepala = A.SakitKepala
        ) as 'FLU',
        (
            select count(*) from tblC45 as C where C.Diagnosa = 'Demam' and C.SakitKepala = A.SakitKepala
        ) as 'DEMAM'
    from tblC45 as A group by SakitKepala;
update tblHitung set atribut = 'SAKITKEPALA' where atribut is null;


insert into tblHitung(informasi, jumlahdata, DiagnosaFlu, DiagnosaDemam)
	   select A.Nyeri as Nyeri, count(*) as JUMLAH_DATA,
	       (
	           select count(*) from tblC45 as B where B.Diagnosa = 'Flu' and B.Nyeri = A.Nyeri
	       ) as 'FLU',
	       (
	           select count(*) from tblC45 as C where C.Diagnosa = 'Demam' and C.Nyeri = A.Nyeri
	       ) as 'DEMAM'
	   from tblC45 as A group by Nyeri;
update tblHitung set atribut = 'Nyeri' where atribut is null;


insert into tblHitung(informasi, jumlahdata, DiagnosaFlu, DiagnosaDemam)
		  select A.Lemas as LEMAS, count(*) as JUMLAH_DATA,
		      (
		          select count(*) from tblC45 as B where B.Diagnosa = 'Flu' and B.Lemas = A.Lemas
		      ) as 'FLU',
		      (
		          select count(*) from tblC45 as C where C.Diagnosa = 'Demam' and C.Lemas = A.Lemas
		      ) as 'DEMAM'
		  from tblC45 as A group by Lemas;
update tblHitung set atribut = 'LEMAS' where atribut is null;


insert into tblHitung(informasi, jumlahdata, DiagnosaFlu, DiagnosaDemam)
				select A.Kelelahan as KELELAHAN, count(*) as JUMLAH_DATA,
					   (
					       select count(*) from tblC45 as B where B.Diagnosa = 'Flu' and B.Kelelahan = A.Kelelahan
					   ) as 'FLU',
					   (
					       select count(*) from tblC45 as C where C.Diagnosa = 'Demam' and C.Kelelahan = A.Kelelahan
					   ) as 'DEMAM'
				from tblC45 as A group by Kelelahan;
	update tblHitung set atribut = 'KELELAHAN' where atribut is null;


insert into tblHitung(informasi, jumlahdata, DiagnosaFlu, DiagnosaDemam)
				select A.HidungTersumbat as HIDUNGTERSUMBAT, count(*) as JUMLAH_DATA,
							(
							      select count(*) from tblC45 as B where B.Diagnosa = 'Flu' and B.HidungTersumbat = A.HidungTersumbat
							) as 'FLU',
							(
							      select count(*) from tblC45 as C where C.Diagnosa = 'Demam' and C.HidungTersumbat = A.HidungTersumbat
						  ) as 'DEMAM'
				from tblC45 as A group by HidungTersumbat;
update tblHitung set atribut = 'HIDUNGTERSUMBAT' where atribut is null;


insert into tblHitung(informasi, jumlahdata, DiagnosaFlu, DiagnosaDemam)
				select A.Bersin as BERSIN, count(*) as JUMLAH_DATA,
							(
								    select count(*) from tblC45 as B where B.Diagnosa = 'Flu' and B.Bersin = A.Bersin
							) as 'FLU',
							(
								    select count(*) from tblC45 as C where C.Diagnosa = 'Demam' and C.Bersin = A.Bersin
							) as 'DEMAM'
			 from tblC45 as A group by Bersin;
update tblHitung set atribut = 'BERSIN' where atribut is null;


insert into tblHitung(informasi, jumlahdata, DiagnosaFlu, DiagnosaDemam)
				select A.SakitTenggorokan as SAKITTENGGOROKAN, count(*) as JUMLAH_DATA,
							(
									   select count(*) from tblC45 as B where B.Diagnosa = 'Flu' and B.SakitTenggorokan = A.SakitTenggorokan
							) as 'FLU',
							(
									   select count(*) from tblC45 as C where C.Diagnosa = 'Demam' and C.SakitTenggorokan = A.SakitTenggorokan
							) as 'DEMAM'
				from tblC45 as A group by SakitTenggorokan;
update tblHitung set atribut = 'SAKITTENGGOROKAN' where atribut is null;


insert into tblHitung(informasi, jumlahdata, DiagnosaFlu, DiagnosaDemam)
				select A.SulitBernafas as SULITBERNAFAS, count(*) as JUMLAH_DATA,
							(
									   select count(*) from tblC45 as B where B.Diagnosa = 'Flu' and B.SulitBernafas = A.SulitBernafas
							) as 'FLU',
							(
									   select count(*) from tblC45 as C where C.Diagnosa = 'Demam' and C.SulitBernafas = A.SulitBernafas
							) as 'DEMAM'
				from tblC45 as A group by SulitBernafas;
update tblHitung set atribut = 'SULITBERNAFAS' where atribut is null;


/*entrophy*/
update tblHitung set entropy = (-(DiagnosaFlu/jumlahdata) * log2(DiagnosaFlu/jumlahdata)) + (-(DiagnosaDemam/jumlahdata) * log2(DiagnosaDemam/jumlahdata));
update tblHitung set entropy = 0 where entropy is null;
select * from tblHitung;


/*gain*/
drop table if exists tblTampung;
create TEMPORARY table tblTampung
(
    atribut VARCHAR(20),
    gain decimal(8,4)
);

insert into tblTampung(atribut, gain)
select atribut, @entropy - SUM((jumlahdata/@jumlahdata) * entropy) as GAIN
from tblHitung group by atribut;
select * from tblTampung;


update tblHitung set GAIN =
    (
        select gain
        from tblTampung
        where atribut = tblHitung.atribut
    );

select * from tblHitung;

/*-------------------------------------------------------Iterasi 2-------------------------------------------------------*/
truncate table tblHitung;

select count(*) into @jumlahdata from tblC45 where Nyeri = 'Parah';
select count(*) into @DiagnosaFlu from tblC45 where Diagnosa = 'Flu' and Nyeri = 'Parah';
select count(*) into @DiagnosaDemam from tblC45 where Diagnosa = 'Demam' and Nyeri = 'Parah';
select (-(@DiagnosaFlu/@jumlahdata) * log2(@DiagnosaFlu/@jumlahdata)) + (-(@DiagnosaDemam/@jumlahdata) * log2(@DiagnosaDemam/@jumlahdata)) into @entropy;
select @jumlahdata as JUM_DATA,
@DiagnosaFlu as JAWAB_Flu, @DiagnosaDemam as JAWAB_Demam, ROUND(@entropy,4) as ENTROPY;

insert into tblHitung(atribut, jumlahdata, DiagnosaFlu, DiagnosaDemam, entropy) VALUES ('TOTAL DATA', @jumlahdata, @DiagnosaFlu, @DiagnosaDemam, @entropy);
select * from tblHitung;

insert into tblHitung(informasi, jumlahdata, DiagnosaFlu, DiagnosaDemam)
    select A.Demam as DEMAM, count(*) as JUMLAH_DATA,
        (
            select count(*) from tblC45 as B where B.Diagnosa = 'Flu' and B.Demam = A.Demam and Nyeri = 'Parah'
        ) as 'FLU',
        (
            select count(*) from tblC45 as C where C.Diagnosa = 'Demam' and C.Demam = A.Demam and Nyeri = 'Parah'
        ) as 'DEMAM'
    from tblC45 as A where Nyeri = 'Parah' group by Demam;
update tblHitung set atribut = 'DEMAM' where atribut is null;

insert into tblHitung(informasi, jumlahdata, DiagnosaFlu, DiagnosaDemam)
    select A.SakitKepala as SAKITKEPALA, count(*) as JUMLAH_DATA,
        (
            select count(*) from tblC45 as B where B.Diagnosa = 'Flu' and B.SakitKepala = A.SakitKepala and Nyeri = 'Parah'
        ) as 'FLU',
        (
            select count(*) from tblC45 as C where C.Diagnosa = 'Demam' and C.SakitKepala = A.SakitKepala and Nyeri = 'Parah'
        ) as 'DEMAM'
    from tblC45 as A where Nyeri = 'Parah' group by SakitKepala;
update tblHitung set atribut = 'SAKITKEPALA' where atribut is null;

insert into tblHitung(informasi, jumlahdata, DiagnosaFlu, DiagnosaDemam)
	   select A.Lemas as LEMAS, count(*) as JUMLAH_DATA,
	       (
	           select count(*) from tblC45 as B where B.Diagnosa = 'Flu' and B.Lemas = A.Lemas and Nyeri = 'Parah'
	       ) as 'FLU',
	       (
	           select count(*) from tblC45 as C where C.Diagnosa = 'Demam' and C.Lemas = A.Lemas and Nyeri = 'Parah'
	       ) as 'DEMAM'
	   from tblC45 as A where Nyeri = 'Parah' group by Lemas;
update tblHitung set atribut = 'LEMAS' where atribut is null;

	insert into tblHitung(informasi, jumlahdata, DiagnosaFlu, DiagnosaDemam)
		   select A.Kelelahan as KELELAHAN, count(*) as JUMLAH_DATA,
		       (
		           select count(*) from tblC45 as B where B.Diagnosa = 'Flu' and B.Kelelahan = A.Kelelahan and Nyeri = 'Parah'
		       ) as 'FLU',
		       (
		           select count(*) from tblC45 as C where C.Diagnosa = 'Demam' and C.Kelelahan = A.Kelelahan and Nyeri = 'Parah'
		       ) as 'DEMAM'
		   from tblC45 as A where Nyeri = 'Parah' group by Kelelahan;
	update tblHitung set atribut = 'KELELAHAN' where atribut is null;

insert into tblHitung(informasi, jumlahdata, DiagnosaFlu, DiagnosaDemam)
			  select A.HidungTersumbat as HIDUNGTERSUMBAT, count(*) as JUMLAH_DATA,
			      (
			          select count(*) from tblC45 as B where B.Diagnosa = 'Flu' and B.HidungTersumbat = A.HidungTersumbat and Nyeri = 'Parah'
			      ) as 'FLU',
			      (
			          select count(*) from tblC45 as C where C.Diagnosa = 'Demam' and C.HidungTersumbat = A.HidungTersumbat and Nyeri = 'Parah'
			      ) as 'DEMAM'
			   from tblC45 as A where Nyeri = 'Parah' group by HidungTersumbat;
	update tblHitung set atribut = 'HIDUNGTERSUMBAT' where atribut is null;

insert into tblHitung(informasi, jumlahdata, DiagnosaFlu, DiagnosaDemam)
		  select A.Bersin as BERSIN, count(*) as JUMLAH_DATA,
  		      (
	             select count(*) from tblC45 as B where B.Diagnosa = 'Flu' and B.Bersin = A.Bersin and Nyeri = 'Parah'
			      ) as 'FLU',
			      (
		           select count(*) from tblC45 as C where C.Diagnosa = 'Demam' and C.Bersin = A.Bersin and Nyeri = 'Parah'
			      ) as 'DEMAM'
				   from tblC45 as A where Nyeri = 'Parah' group by Bersin;
	update tblHitung set atribut = 'BERSIN' where atribut is null;

insert into tblHitung(informasi, jumlahdata, DiagnosaFlu, DiagnosaDemam)
			select A.SakitTenggorokan as SAKITTENGGOROKAN, count(*) as JUMLAH_DATA,
		  		    (
			           select count(*) from tblC45 as B where B.Diagnosa = 'Flu' and B.SakitTenggorokan = A.SakitTenggorokan and Nyeri = 'Parah'
					     ) as 'FLU',
					     (
				         select count(*) from tblC45 as C where C.Diagnosa = 'Demam' and C.SakitTenggorokan = A.SakitTenggorokan and Nyeri = 'Parah'
					     ) as 'DEMAM'
						 from tblC45 as A where Nyeri = 'Parah' group by SakitTenggorokan;
	update tblHitung set atribut = 'SAKITTENGGOROKAN' where atribut is null;

insert into tblHitung(informasi, jumlahdata, DiagnosaFlu, DiagnosaDemam)
		select A.SulitBernafas as SULITBERNAFAS, count(*) as JUMLAH_DATA,
		  		    (
		           select count(*) from tblC45 as B where B.Diagnosa = 'Flu' and B.SulitBernafas = A.SulitBernafas and Nyeri = 'Parah'
					     ) as 'FLU',
					     (
			         select count(*) from tblC45 as C where C.Diagnosa = 'Demam' and C.SulitBernafas = A.SulitBernafas and Nyeri = 'Parah'
					     ) as 'DEMAM'
					 from tblC45 as A where Nyeri = 'Parah' group by SulitBernafas;
   update tblHitung set atribut = 'SULITBERNAFAS' where atribut is null;

	update tblHitung set entropy = (-(DiagnosaFlu/jumlahdata) * log2(DiagnosaFlu/jumlahdata)) + (-(DiagnosaDemam/jumlahdata) * log2(DiagnosaDemam/jumlahdata));
	update tblHitung set entropy = 0 where entropy is null;
	select * from tblHitung;


	/*gain*/
	drop table if exists tblTampung;
	create TEMPORARY table tblTampung
		(
     		atribut VARCHAR(20),
		    gain decimal(8,4)
		);

	insert into tblTampung(atribut, gain)
	select atribut, @entropy - SUM((jumlahdata/@jumlahdata) * entropy) as GAIN
	from tblHitung group by atribut;
	select * from tblTampung;


	update tblHitung set GAIN =
	    (
	        select gain
	        from tblTampung
	        where atribut = tblHitung.atribut
	    );

	 select * from tblHitung;

/*-------------------------------------------------------Iterasi 3-------------------------------------------------------*/

truncate table tblHitung;


select count(*) into @jumlahdata from tblC45 where Nyeri = 'Parah' and SakitTenggorokan = 'Parah';
select count(*) into @DiagnosaFlu from tblC45 where Diagnosa = 'Flu' and Nyeri = 'Parah' and SakitTenggorokan = 'Parah';
select count(*) into @DiagnosaDemam from tblC45 where Diagnosa = 'Demam' and Nyeri = 'Parah' and SakitTenggorokan = 'Parah';
select (-(@DiagnosaFlu/@jumlahdata) * log2(@DiagnosaFlu/@jumlahdata)) + (-(@DiagnosaDemam/@jumlahdata) * log2(@DiagnosaDemam/@jumlahdata)) into @entropy;
select @jumlahdata as JUM_DATA,
@DiagnosaFlu as JAWAB_Flu, @DiagnosaDemam as JAWAB_Demam, ROUND(@entropy,4) as ENTROPY;

insert into tblHitung(atribut, jumlahdata, DiagnosaFlu, DiagnosaDemam, entropy) VALUES ('TOTAL DATA', @jumlahdata, @DiagnosaFlu, @DiagnosaDemam, @entropy);
select * from tblHitung;

insert into tblHitung(atribut, jumlahdata, DiagnosaFlu, DiagnosaDemam, entropy) VALUES ('TOTAL DATA', @jumlahdata, @DiagnosaFlu, @DiagnosaDemam, @entropy);
select * from tblHitung;

insert into tblHitung(informasi, jumlahdata, DiagnosaFlu, DiagnosaDemam)
    select A.Demam as DEMAM, count(*) as JUMLAH_DATA,
        (
            select count(*) from tblC45 as B where B.Diagnosa = 'Flu' and B.Demam = A.Demam and Nyeri = 'Parah' and SakitTenggorokan = 'Parah'
        ) as 'FLU',
        (
            select count(*) from tblC45 as C where C.Diagnosa = 'Demam' and C.Demam = A.Demam and Nyeri = 'Parah' and SakitTenggorokan = 'Parah'
        ) as 'DEMAM'
    from tblC45 as A where Nyeri = 'Parah' and SakitTenggorokan = 'Parah' group by Demam;
update tblHitung set atribut = 'DEMAM' where atribut is null;

insert into tblHitung(informasi, jumlahdata, DiagnosaFlu, DiagnosaDemam)
	   select A.SakitKepala as SAKITKEPALA, count(*) as JUMLAH_DATA,
	       (
	           select count(*) from tblC45 as B where B.Diagnosa = 'Flu' and B.SakitKepala = A.SakitKepala and Nyeri = 'Parah' and SakitTenggorokan = 'Parah'
	       ) as 'FLU',
	       (
	           select count(*) from tblC45 as C where C.Diagnosa = 'Demam' and C.SakitKepala = A.SakitKepala and Nyeri = 'Parah' and SakitTenggorokan = 'Parah'
	       ) as 'DEMAM'
	   from tblC45 as A where Nyeri = 'Parah' and SakitTenggorokan = 'Parah' group by SakitKepala;
update tblHitung set atribut = 'SAKITKEPALA' where atribut is null;

insert into tblHitung(informasi, jumlahdata, DiagnosaFlu, DiagnosaDemam)
		select A.Kelelahan as KELELAHAN, count(*) as JUMLAH_DATA,
			 	(
					 select count(*) from tblC45 as B where B.Diagnosa = 'Flu' and B.Kelelahan = A.Kelelahan and Nyeri = 'Parah' and SakitTenggorokan = 'Parah'
				) as 'FLU',
				(
					 select count(*) from tblC45 as C where C.Diagnosa = 'Demam' and C.Kelelahan = A.Kelelahan and Nyeri = 'Parah' and SakitTenggorokan = 'Parah'
				) as 'DEMAM'
				from tblC45 as A where Nyeri = 'Parah' and SakitTenggorokan = 'Parah' group by Kelelahan;
update tblHitung set atribut = 'KELELAHAN' where atribut is null;

insert into tblHitung(informasi, jumlahdata, DiagnosaFlu, DiagnosaDemam)
		 select A.HidungTersumbat as HIDUNGTERSUMBAT, count(*) as JUMLAH_DATA,
		    (
		      select count(*) from tblC45 as B where B.Diagnosa = 'Flu' and B.HidungTersumbat = A.HidungTersumbat and Nyeri = 'Parah' and SakitTenggorokan = 'Parah'
		    ) as 'FLU',
		    (
		      select count(*) from tblC45 as C where C.Diagnosa = 'Demam' and C.HidungTersumbat = A.HidungTersumbat and Nyeri = 'Parah' and SakitTenggorokan = 'Parah'
		    ) as 'DEMAM'
		     from tblC45 as A where Nyeri = 'Parah' and SakitTenggorokan = 'Parah' group by HidungTersumbat;
update tblHitung set atribut = 'HIDUNGTERSUMBAT' where atribut is null;

insert into tblHitung(informasi, jumlahdata, DiagnosaFlu, DiagnosaDemam)
	  select A.Bersin as BERSIN, count(*) as JUMLAH_DATA,
	      (
         	select count(*) from tblC45 as B where B.Diagnosa = 'Flu' and B.Bersin = A.Bersin and Nyeri = 'Parah' and SakitTenggorokan = 'Parah'
				) as 'FLU',
			  (
			    select count(*) from tblC45 as C where C.Diagnosa = 'Demam' and C.Bersin = A.Bersin and Nyeri = 'Parah' and SakitTenggorokan = 'Parah'
			  ) as 'DEMAM'
			    from tblC45 as A where Nyeri = 'Parah' and SakitTenggorokan = 'Parah' group by Bersin;
update tblHitung set atribut = 'BERSIN' where atribut is null;

insert into tblHitung(informasi, jumlahdata, DiagnosaFlu, DiagnosaDemam)
		select A.SulitBernafas as SULITBERNAFAS, count(*) as JUMLAH_DATA,
		    (
          select count(*) from tblC45 as B where B.Diagnosa = 'Flu' and B.SulitBernafas = A.SulitBernafas and Nyeri = 'Parah' and SakitTenggorokan = 'Parah'
       	) as 'FLU',
	     	(
				  select count(*) from tblC45 as C where C.Diagnosa = 'Demam' and C.SulitBernafas = A.SulitBernafas and Nyeri = 'Parah' and SakitTenggorokan = 'Parah'
	     	) as 'DEMAM'
 				 	from tblC45 as A where Nyeri = 'Parah' and SakitTenggorokan = 'Parah' group by SulitBernafas;
update tblHitung set atribut = 'SULITBERNAFAS' where atribut is null;

update tblHitung set entropy = (-(DiagnosaFlu/jumlahdata) * log2(DiagnosaFlu/jumlahdata)) + (-(DiagnosaDemam/jumlahdata) * log2(DiagnosaDemam/jumlahdata));
update tblHitung set entropy = 0 where entropy is null;
select * from tblHitung;


/*gain*/
drop table if exists tblTampung;
create TEMPORARY table tblTampung
				(
				    		atribut VARCHAR(20),
								gain decimal(8,4)
				);

insert into tblTampung(atribut, gain)
select atribut, @entropy - SUM((jumlahdata/@jumlahdata) * entropy) as GAIN
from tblHitung group by atribut;
select * from tblTampung;


update tblHitung set GAIN =
			(
							select gain
							from tblTampung
							where atribut = tblHitung.atribut
			);

select * from tblHitung;

/*Jadi Berdasarkan Hasil yang saya dapatkan dari metode C45 ini adalah
,tidak terdapat pasien yang terkena penyakit demam. Dan perhitungan gain
dan entropy berakhir dengan NULL */
