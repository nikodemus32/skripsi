/*membuat database untuk rumah makan*/
drop database dbRumahMakan;
create database dbRumahMakan;
use dbRumahMakan;

/*membuat daftar menu*/
create table tblMenu
(
nomenu int primary key auto_increment,
menu varchar(255) not null,
harga double
) engine = Innodb;

/*mencatat pemesanan*/
create table tblPemesan
(
nopemesanan varchar(8) primary key,
nomeja int,
waktupemesanan timestamp,
namapemesan varchar(100)
) engine = InnoDB;

/*membuat daftar pesanan*/
create table tblPesanan
(
nopemesanan varchar(8),
nomenu int,
porsi int,
hargabayar double,
diskon int,
foreign key(nopemesanan) references tblPemesan(nopemesanan) on delete cascade on update cascade,
foreign key(nomenu) references tblMenu(nomenu) on delete cascade on update cascade
);

insert into tblMenu values
(1, 'NASI + AYAM GORENG MENTEGA', 18182),
(2, 'NASI + AYAM GORENG TEPUNG', 18182),
(3, 'NASI + AYAM GORENG RICA-RICA', 18182),
(4, 'NASI + AYAM NANKING', 18182),
(5, 'NASI + AYAM ASAM MANIS', 18182),
(6, 'NASI + CUMI GORENG MENTEGA', 20910),
(7, 'NASI + CUMI GORENG RICA-RICA', 20910),
(8, 'NASI + FILLET IKAN GORENG MENTEGA', 21819),
(9, 'NASI + FILLET IKAN GORENG TEPUNG', 21819),
(10, 'NASI + FILLET IKAN GORENG RICA-RICA', 21819),
(11, 'NASI + FILLET IKAN ASAM MANIS', 21819),
(12, 'NASI + UDANG GORENG TEPUNG', 20910);

select * from tblMenu;

insert into tblPemesan values
('0106-001', 3, '2013-06-01', 'Carolina'),
('0106-002', 5, '2013-06-01', 'Vey'),
('0106-003', 8, '2013-06-01', 'Beni'),
('0106-004', 4, '2013-06-01', 'Merly'),
('0106-005', 2, '2013-06-01', 'Edward'),
('0106-006', 4, '2013-06-01', 'Jerry');

select * from tblPemesan;

/* nopemesanan nomenu porsi hargabayar diskon*/
insert into tblPesanan values
('0106-001', 1, 2, 0, 0),
('0106-002', 2, 1, 0, 5),
('0106-002', 2, 3, 0, 5),
('0106-002', 3, 4, 0, 5),
('0106-003', 3, 2, 0, 0),
('0106-003', 5, 4, 0, 0),
('0106-003', 7, 3, 0, 0),
('0106-003', 9, 1, 0, 0),
('0106-004', 11, 1, 0, 0),
('0106-004', 12, 5, 0, 0),
('0106-004', 5, 2, 0, 0),
('0106-005', 6, 3, 0, 0),
('0106-005', 4, 5, 0, 0),
('0106-006', 2, 7, 0, 10),
('0106-006', 1, 2, 0, 10),
('0106-006', 7, 3, 0, 10),
('0106-006', 9, 1, 0, 10),
('0106-006', 12, 4, 0, 10),
('0106-002', 10, 5, 0, 5),
('0106-003', 12, 5, 0, 0);

update tblPesanan
set hargabayar =
(select tblMenu.harga
from tblMenu
where tblMenu.nomenu = tblPesanan.nomenu);

select * from tblPesanan;

/*No. 1*/
create view vwPesanan as
select (nopemesanan) as Pemesanan
from tblPesanan;

delimiter $$
create function sfTotalBayar(pNoPesan varchar(8))
returns double
begin
	declare i,j int default 0;
 	declare vJumData, vJumData2 int;
 	declare vNoPemesanan varchar(100);
 	declare vNoMenu, vPorsi, vDiskon int;
 	declare vHargaBayar, total double default 0.0;
	declare cPesanan cursor for select * from tblPesanan;

	select count(*) into vJumData from vwPesanan;
	open cPesanan;
	while i <> vJumData do
	fetch cPesanan into vNoPemesanan, vNoMenu, vPorsi, vHargaBayar, vDiskon;
		if vNoPemesanan = pNoPesan then
			set total =  total + (vPorsi * vHargaBayar - (vPorsi * vHargaBayar * (vDiskon/100)));
		end if;
	set i=i+1;
 	end while;
 	set total = round(total,2);
 	close cPesanan;
	return (total);
end ;
$$
delimiter ;

select sfTotalBayar('0106-006') as 'Grand Total';

select nopemesanan, sfTotalBayar(nopemesanan) as 'Grand Total'
from tblPemesan
where nopemesanan = '0106-004';

select nopemesanan, sfTotalBayar(nopemesanan) as 'Grand Total'
from tblPemesan;


/*No. 2
create view vwPemesan as
select (nopemesanan) as Pemesanan
from tblPemesan;

delimiter $$
create procedure spTampilNota(pNoPesan varchar(8))
begin
 	declare i,j,k int default 0;
 	declare vJumData, vJumData2, vJumData3 int;
 	declare vNoPemesanan, vNoPemesanan2, vNamaPemesan, vMenu varchar(100);
 	declare vNoMeja, vNoMenu, vNoMenu1, vNoMenu2, vPorsi, vDiskon int;
 	declare vWaktuPemesanan timestamp;
 	declare VHarga, vHargaBayar, total double default 0.0;
 	declare cMenu cursor for select * from tblMenu;
 	declare cPemesan cursor for select * from tblPemesan;
	declare cPesanan cursor for select * from tblPesanan;

 select count(*) into vJumData from vwPemesan;
 select count(*) into vJumData2 from tblMenu;
 select count(*) into vJumData3 from tblPesanan;

 open cPemesan;
 while i <> vJumData do
 	fetch cPemesan into vNoPemesanan, vNoMeja, vWaktuPemesanan, vNamaPemesan;
 	if vNoPemesanan=pNoPesan then
   		select concat("NOMOR MEJA: ", vNoMeja, "\n", "WAKTU PEMESANAN: ",vWaktuPemesanan, "\n", "NAMA PEMESAN : ", vNamaPemesan ) as "NOTA PEMBAYARAN";
   		open cPesanan;
   		while j <> vJumData2 do
   		fetch cPesanan into vNoPemesanan2, vNoMenu1, vPorsi, vHargaBayar, vDiskon;
   		if vNoPemesanan2=vNoPemesanan then
 			open cMenu;
 				while k <> vJumData3 do
				fetch cMenu into vNoMenu2, vMenu, vHarga;
				if vNoMenu1=vNoMenu2 then
   				select vMenu as MENU, vPorsi as JUMLAH, vHargaBayar as HARGA, vDiskon as DISKON,
   				ROUND((vPorsi * vHargaBayar - (vPorsi * vHargaBayar * (vDiskon/100)))) as TOTAL;
 				set total =  total + (vPorsi * vHargaBayar - (vPorsi * vHargaBayar * (vDiskon/100)));
 				end if;
 				set k=k+1;
			 	end while;
 			close cMenu;
 		end if;
 		set j=j+1;
 		end while;
 		set total = round(total,2);
 		select total as "GRAND TOTAL";
 		close cPesanan;
 	end if;
 	set i=i+1;
 end while;
 close cPemesan;

end
$$
delimiter ;*/

create view vwPemesan as
select (nopemesanan) as Pemesanan
from tblPemesan;

DELIMITER $$
create procedure spTampilNota(pNoPesan varchar(8))
begin
	declare i,j,k int default 0;
 	declare vJumData, vJumData2, vJumData3 int;
 	declare vNoPemesanan, vNoPemesanan1, vNamaPemesan, vMenu varchar(100);
 	declare vNoMeja, vNoMenu, vNoMenu1, vNoMenu2, vPorsi, vDiskon int;
 	declare vWaktuPemesanan timestamp;
 	declare VHarga, vHargaBayar, total double default 0.0;
 	declare cMenu cursor for select * from tblMenu;
 	declare cPemesan cursor for select * from tblPemesan;
	declare cPesanan cursor for select * from tblPesanan;

	select count(*) into vJumData from vwPemesan;
 	select count(*) into vJumData2 from tblMenu;
 	select count(*) into vJumData3 from tblPesanan;

	open cPemesan;
	while i <> vJumData do
	fetch cPemesan into vNoPemesanan, vNoMeja, vWaktuPemesanan, vNamaPemesan;
	if vNoPemesanan=pNoPesan then
	select CONCAT("NOMOR MEJA : ", vNoMeja,"\n WAKTU PEMESANAN : ", vWaktuPemesanan,
    	"\n  NAMA PEMESAN : ", vNamaPemesan) as "NOTA PEMBAYARAN";
	end if;
	set i=i+1;
	end while;
	close cPemesan;

	open cPesanan;
	while j <> vJumData3 do
	fetch cPesanan into vNoPemesanan1, vNoMenu, vPorsi, vHargaBayar, vDiskon;
	if vNoPemesanan1=pNoPesan then
		open cMenu;
		while k <> vJumData2 do
		fetch cMenu into vNoMenu1, vMenu, vHarga;
		if vNoMenu=vNoMenu1 then
		select vMenu as MENU, vPorsi as JUMLAH, vHargaBayar as HARGA,
    		vDiskon as DISKON, ((vPorsi*vHargaBayar)-
    		(vPorsi*vHargaBayar*vDiskon/100)) as TOTAL;
    	set total=total + ((vPorsi*vHargaBayar)-(vPorsi*vHargaBayar*vDiskon/100));
    	end if;
    	set k=k+1;
    	end while;
    	close cMenu;
    end if;
    set j=j+1;
    end while;
    close cPesanan;
    select total as "GRAND TOTAL";

end $$
DELIMITER ;

call spTampilNota('0106-001');
call spTampilNota('0106-006');


/*No.3*/
delimiter $$
create function sfTampilDatar (pNoPesan varchar(8)) returns varchar(255)
begin
	declare i,j,k int default 0;
 	declare vJumData, vJumData2, vJumData3 int;
 	declare akhir, vNoPemesanan, vNamaPemesan, vMenu varchar(100);
 	declare vNoMeja, vNoMenu, vNoMenu1, vPorsi, vDiskon int;
 	declare VHarga, vHargaBayar, total double default 0.0;
 	declare vHasil varchar(255) default '[';
 	declare cMenu cursor for select * from tblMenu;
	declare cPesanan cursor for select * from tblPesanan;

 	select count(*) into vJumData2 from tblMenu;
 	select count(*) into vJumData3 from tblPesanan;

 	set akhir = " ";
 	open cPesanan;
 	while i <> vJumData3 do
	fetch cPesanan into vNoPemesanan, vNoMenu, vPorsi, vHargaBayar, vDiskon;

		if vNoPemesanan=pNoPesan then
        	set total=total+((vPorsi*vHargaBayar)-(vPorsi*vHargaBayar*vDiskon/100));

			open cMenu;
			set j =0;
			while j <> vJumData2 do
			fetch cMenu into vNoMenu1, vMenu, vHarga;
			if vNoMenu=vNoMenu1 then
					set vHasil = concat(vHasil,vMenu);
					if k <> vJumData then
						set vHasil = concat(vHasil,", ");
						set k=k+1;
					else
						set vHasil = concat(vHasil,"]");
					end if;
			end if;
			set j=j+1;
			end while;
			close cMenu;

		end if;
	set i=i+1;
 	end while;
 	close cPesanan;
 	set akhir = concat(pNoPesan, "=", vHasil," =",total);
 	return (akhir);
end ;
$$
delimiter ;

select sfTampilDatar('0106-001') as 'RINCI NOTA';
select sfTampilDatar('0106-005') as 'RINCI NOTA';
