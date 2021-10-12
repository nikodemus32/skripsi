drop database if exists dbSP;
create database dbSP;
use dbSP;

create table tblSP(
angka int primary key,
hari varchar (10)
);

/*No. 1*/
DELIMITER ##
create procedure spHari(angka int)
begin
	if(angka>=0 && angka<=6) then
	case
		when angka = 0 then select 'Minggu' as Hari;
		when angka = 1 then select 'Senin' as Hari;
		when angka = 2 then select 'Selasa' as Hari;
		when angka = 3 then select 'Rabu' as Hari;
		when angka = 4 then select 'Kamis' as Hari;
		when angka = 5 then select 'Jumat' as Hari;
		when angka = 6 then select 'Sabtu' as Hari;
	end case;
	else select "Hari tidak valid" as Hari;
	end if;
end ##
DELIMITER ;

call spHari(1);
call spHari(2);
call spHari(3);
call spHari(7);

/*No. 2*/
DELIMITER ##
create procedure spKabisat(angka int)
begin
	if(angka>=0 && angka<=3000) then
	case
		when angka % 4 = 0 then select 'Tahun Kabisat' as "Tahun Kabisat ?";
		when angka % 100 = 0  and angka % 400 = 0 then select 'Tahun Kabisat' as "Tahun Kabisat ?";
		when angka % 4 != 0 then select 'Bukan Tahun Kabisat' as "Tahun Kabisat ?";
		when angka % 100 != 0  and angka % 400 != 0 then select 'Bukan Tahun Kabisat' as "Tahun Kabisat ?";
	end case;
	else select 'Diluar data tahun' as "Tahun Kabisat ?";
	end if;
end ##
DELIMITER ;

call spKabisat(1203);
call spKabisat(1204);
call spKabisat(3004);

/*No. 3*/
DELIMITER ##
create procedure spPerkalian(angka int)
begin
	declare x, p, m, total, data int;
	declare datatotal varchar(100);

	while length(angka)!=1 do
		set m:=1;
		set x:=length(angka);
		set p:=substr(angka,1,1);
		set total:=substr(angka,x,1);
		set data:=substr(angka,m,1);
		set datatotal:=substr(angka,m,1);

		while x>1 do
			set total:=total*substr(angka,x-1,1);
			set x:=x-1;
			set data:=substr(angka,m+1,1);
			set datatotal:=concat(datatotal,'*',data);
			set m:=m+1;
		end while;

		select datatotal as datakali, total as hasil;
		set angka:=total;
	end while;
end ##
DELIMITER ;

call spPerkalian(188);
-- call spPerkalian(123456);


/*no 4*/
delimiter ##
create procedure spUang(uang int)
begin
  declare a,b,c,d,e,f,g,h,i,j,sisaa,sisab,sisac,sisad,sisae,sisaf,sisag,sisah,sisai,sisaj int;
  set a:=floor(uang/100000);
  set sisaa:=uang%100000;
  set b:=floor(sisaa/50000);
  set sisab:=sisaa%50000;
  set c:=floor(sisab/20000);
  set sisac=sisab%20000;
  set d:=floor(sisac/10000);
  set sisad=sisac%10000;
  set e:=floor(sisad/5000);
  set sisae=sisad%5000;
  set f:=floor(sisae/2000);
  set sisaf=sisae%2000;
  set g:=floor(sisaf/1000);
  set sisag=sisaf%1000;
  set h:=floor(sisag/500);
  set sisah=sisag%500;
  set i:=floor(sisah/200);
  set sisai=sisah%200;
  set j:=floor(sisai/100);
  set sisaj=sisai%100;

  select a as "lembar 100000", b as "lembar 50000", c as "lembar 20000", d as "lembar 10000",
         e as "lembar 5000", f as "lembar 2000", g as "lembar 1000", h as "koin 500",
         i as "koin 200", j as "koin 100";

end ##
  delimiter ;
call spUang(12500);
call spUang(289800);


/*No. 5*/
DELIMITER ##
create procedure spKata(kata varchar(100))
begin
	declare vHello varchar(100);
	set vHello = reverse(kata);
	select vHello as Hasil;
end ##
DELIMITER ;

call spKata('database');

/*No. 6*/
delimiter ##
create procedure spHuruf(kata varchar(100))
begin
    declare v,k,l,x int;
    declare huruf varchar(100);
    set v:=0;
    set k:=0;
    set l:=0;
    set x:=1;

    while x <= length(kata) do
        set huruf:=substr(kata, x, 1);
            if huruf in ( 'A', 'E', 'I', 'O', 'U' )
              or huruf in ( 'a', 'e', 'i', 'o', 'u' )
              then set v:=v + 1;
            else if huruf in ('B','C','D','F','G','H','J','K','L','M','N','P','Q','R','S','T','V','W','X','Y','Z')
              or huruf in ('b','c','d','f','g','h','j','k','l','m','n','p','q','r','s','t','v','w','x','y','z')
              then set k:=k + 1;
            else
              set l:=l + 1;

            end if;
            end if;
            set x:=x + 1;
    end while;

    select v as "Jumlah Vokal", k as "Jumlah Konsonan", l as "Jumlah Karakter Lain";
end ##
delimiter ;

call spHuruf('database programming');
