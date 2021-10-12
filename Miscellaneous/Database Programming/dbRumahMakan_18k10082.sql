/*
    Nikodemus Galih Candra Wicaksono
    2020/05/13
*/

/*membuat database untuk rumah makan*/
drop database if exists dbRumahMakan;
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

-- select * from tblMenu;

insert into tblPemesan values
('0106-001', 3, '2013-06-01', 'Carolina'),
('0106-002', 5, '2013-06-01', 'Vey'),
('0106-003', 8, '2013-06-01', 'Beni'),
('0106-004', 4, '2013-06-01', 'Merly'),
('0106-005', 2, '2013-06-01', 'Edward'),
('0106-006', 4, '2013-06-01', 'Jerry');

-- select * from tblPemesan;

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

-- select * from tblPesanan;

/*START NOMOR 1*/
DELIMITER $$
  CREATE FUNCTION sfTotalBayar(noPesan varchar(8))
  RETURNS float
  BEGIN
    DECLARE temp_total, temp_diskon double default 0;
    DECLARE fNoPemesanan varchar(8);
    DECLARE total double default 0;
    DECLARE fMenu, fPorsi  int;
    DECLARE fHargaBayar, fDiskon double;
    DECLARE vJumlahData int;
    DECLARE i int default 0;
    DECLARE cTblPesanan cursor for SELECT DISTINCT * FROM tblPesanan;

    SELECT count(*) into vJumlahData FROM tblPesanan;

      open cTblPesanan;
      WHILE i<> vJumlahData DO
        fetch cTblPesanan INTO fNoPemesanan, fMenu, fPorsi, fHargaBayar, fDiskon;

        if noPesan=fNoPemesanan then
          SET temp_total=fPorsi*fHargabayar; /*temp_total mencari harga total */
          SET temp_diskon=fPorsi*fHargabayar*(fDiskon/100); /*temp_diskon mencari harga diskon*/
          SET temp_total=temp_total-temp_diskon; /*temp_total adalah harga akhir setelah harga total-diskon*/

          SET total=total+temp_total; /*Untuk menghitung mencari grand total*/
        end if;

        SET i=i+1;
      END WHILE;
      close cTblPesanan;

    RETURN(total);
  END ;
  $$
DELIMITER ;
/*END NOMOR 1*/
  select sfTotalBayar('0106-006') as 'Grand Total';
  select nopemesanan, sfTotalBayar(nopemesanan) as 'Grand Total'
    from tblPemesan
    where nopemesanan = '0106-004';
  select nopemesanan, sfTotalBayar(nopemesanan) as 'Grand Total'
    from tblPemesan;


/*START no 2 with cursor*/
DELIMITER $$
  CREATE PROCEDURE spTampilNota(nopemesanan varchar(8))
  BEGIN
    /*DECLARE for fetch table*/
    DECLARE fNoPemesananTblPem, fNoPemesananTblPes varchar(8);
    DECLARE fNoMeja, fNoMenuTblM, fNoMenuTblPes, fPorsi, fDiskon int;
    DECLARE fWaktuPemesanan timestamp;
    DECLARE fNamaPemesan varchar(100);
    DECLARE fMenu varchar(255);
    DECLARE fHarga, fHargaBayar double;

    DECLARE countTblPemesan, countTblPesanan, countTblMenu int;
    DECLARE i, j, k, fTotal, fGrandTotal int default 0;
    DECLARE hasilNota1 varchar(255);

    /*DECLARE cursor*/
    DECLARE cTblPemesan cursor for SELECT * FROM tblPemesan;
    DECLARE cTblPesanan cursor for SELECT * FROM tblPesanan;
    DECLARE cTblMenu cursor for SELECT * FROM tblMenu;

    SELECT count(*) INTO countTblPemesan FROM tblPemesan;
    SELECT count(*) INTO countTblPesanan FROM tblPesanan;
    SELECT count(*) INTO countTblMenu FROM tblMenu;

    DROP TABLE IF EXISTS tblNomor2;
    CREATE TABLE tblNomor2(
      menu varchar(255),
      jumlah int,
      harga double,
      diskon int,
      total double
    );

    SET hasilNota1 = '';

    open cTblPemesan;
    WHILE i<> countTblPemesan DO
      fetch cTblPemesan INTO fNoPemesananTblPem, fNoMeja, fWaktuPemesanan, fNamaPemesan;
      if fNoPemesananTblPem=nopemesanan THEN
        SET hasilNota1= CONCAT(
          'NOMOR MEJA       : ', fNoMeja,
          '\n  WAKTU PEMESANAN  : ', fWaktuPemesanan,
          '\n  NAMA PEMESAN     : ', fNamaPemesan
        );
      END if;
    SET i=i+1;
    END WHILE;
    close cTblPemesan;

    open cTblPesanan;
      WHILE j<> countTblPesanan DO
        fetch cTblPesanan INTO fNoPemesananTblPes, fNoMenuTblPes, fPorsi, fHargaBayar, fDiskon;
        if fNoPemesananTblPes=nopemesanan then

          open cTblMenu;
            SET k=0;
            WHILE k<>countTblMenu DO
            fetch cTblMenu INTO fNoMenuTblM, fMenu, fHarga;
              -- if fNoMenuTblPes=fNoMenuTblM then
                SET fTotal=((fPorsi*fHargaBayar)-(fPorsi*fHargaBayar*(fDiskon/100)));
              -- end if;

              if fNoMenuTblPes=fNoMenuTblM then
                SET fGrandTotal=fGrandTotal+fTotal;
              end if;
              if fNoMenuTblPes=fNoMenuTblM then
                INSERT INTO tblNomor2 values (fMenu, fPorsi, fHargaBayar, fDiskon, fTotal);
              end if;
            SET k=k+1;
            END WHILE;
          close cTblMenu;

        end if;
      SET j=j+1;
      END WHILE;
    close cTblPesanan;

    SELECT hasilNota1 as 'NOTA PEMBAYARAN';
    SELECT
      menu as MENU,
      jumlah as JUMLAH,
      harga as HARGA,
      diskon as DISKON,
      total as TOTAL
    from tblNomor2;

    /*Grand total bisa 2 yaitu
      dengan menghitung saat proses cursor
      atau memanggil function yang telah dibuat diawal*/

    SELECT fGrandTotal as 'GRAND TOTAL';
    -- SELECT sfTotalBayar(nopemesanan) as 'GRAND TOTAL';

  END
  $$
DELIMITER ;

/*END no 2 with cursor*/
call spTampilNota('0106-001');
call spTampilNota('0106-006');


/*START NOMOR 2 without cursor*/
DELIMITER $$
  CREATE PROCEDURE spTampilNota2(nopemesanan varchar(8))
  BEGIN
    SELECT
      CONCAT(
        'NOMOR MEJA       : ', nomeja,
        '\n  WAKTU PEMESANAN  : ', waktupemesanan,
        '\n  NAMA PEMESAN     : ', namapemesan
      ) AS 'NOTA PEMBAYARAN'
    FROM tblPemesan
    WHERE tblPemesan.nopemesanan=nopemesanan;

    SELECT
      tblMenu.menu as MENU,
      tblPesanan.porsi as JUMLAH,
      tblPesanan.hargabayar as HARGA,
      tblPesanan.diskon as DISKON,
      ((tblPesanan.porsi*tblPesanan.hargabayar)-
      (tblPesanan.porsi*tblPesanan.hargabayar*tblPesanan.diskon/100)) as TOTAL
    FROM tblPesanan
    NATURAL JOIN tblMenu
    WHERE tblPesanan.nopemesanan=nopemesanan;

    SELECT
    -- SUM((tblPesanan.porsi*tblPesanan.hargabayar)-
    -- (tblPesanan.porsi*tblPesanan.hargabayar*tblPesanan.diskon/100)) as 'GRAND TOTAL'
    -- FROM tblPesanan
    -- WHERE tblPesanan.nopemesanan=nopemesanan;

      sfTotalBayar(nopemesanan) as 'GRAND TOTAL';
  END
  $$
DELIMITER ;
/*END NOMOR 2 without cursor*/
-- call spTampilNota('0106-001');
-- call spTampilNota2('0106-001');
-- call spTampilNota('0106-006');
-- call spTampilNota2('0106-006');




/*START NOMOR 3*/
DELIMITER $$
  CREATE FUNCTION sfTampilDatar(nopemesanan varchar(8))
  RETURNS varchar(255)
  BEGIN
    DECLARE hasil, fMenu varchar(255);
    DECLARE fNoPemesanan varchar(8);
    DECLARE fNoMenuTblM, fNoMenuTblP, fPorsi, fDiskon int;
    DECLARE fHarga, fHargaBayar double;
    DECLARE grandTotal double default 0;
    DECLARE i, j, countTblMenu, countTblPesanan, lenHasil int default 0;

    DECLARE cTblMenu cursor for SELECT * FROM tblMenu;
    DECLARE cTblPesanan cursor for SELECT * FROM tblPesanan;

    SELECT COUNT(*) INTO countTblMenu FROM tblMenu;
    SELECT COUNT(*) INTO countTblPesanan FROM tblPesanan;
    SET hasil=concat(nopemesanan, ' = [');
    open cTblPesanan;
      WHILE i <> countTblPesanan DO
        fetch cTblPesanan INTO fNoPemesanan, fNoMenuTblP, fPorsi, fHargaBayar, fDiskon;

        if fNoPemesanan=nopemesanan then
          SET grandTotal=(fPorsi*fHargaBayar)-(fPorsi*fHargaBayar*(fDiskon/100));
          /*^grandTotal diatas^ sesuai output soal*/

          -- SET grandTotal=grandTotal+((fPorsi*fHargaBayar)-(fPorsi*fHargaBayar*(fDiskon/100)));
          -- /*^grandTotal diatas^ hasil jumlah semua pesanan*/
        end if;

        if fNoPemesanan=nopemesanan then
          open cTblMenu;
            set j=0;
            while j <> countTblMenu DO
              fetch cTblMenu INTO fNoMenuTblM, fMenu, fHarga;
              if fNoMenuTblP=fNoMenuTblM THEN
                SET hasil=concat(hasil, fMenu, ', ');
              END if;
            SET j=j+1;
            END WHILE;
          close cTblMenu;
        END if;


      SET i=i+1;
      END WHILE;
    close cTblPesanan;

    SET lenHasil=LENGTH(hasil);
    SET hasil=concat(left(hasil,lenhasil-2),'] = ', grandTotal);
    /*jika grand total adalah total semua pemesanan
    dapat langsung seperti di bawah*/
    -- SET hasil=concat(left(hasil,lenhasil-2),'] = ', sfTotalBayar(nopemesanan));
    RETURN (hasil);
  END ;
  $$
DELIMITER ;
/*END NOMOR 3*/
  select sfTampilDatar('0106-001') as 'RINCI NOTA';
  select sfTampilDatar('0106-005') as 'RINCI NOTA';
