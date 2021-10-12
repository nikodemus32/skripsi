DROP DATABASE IF EXISTS dbSp18k10082;
CREATE DATABASE dbSp18k10082;
USE dbSp18k10082;

CREATE TABLE tblHari(
  parameterhari int primary key,
  namahari varchar(25)
);

CREATE TABLE tblKabisat(
  parameterkabisat int primary key,
  kabisat varchar(25)
);

CREATE TABLE tblRupiah(
	parameterrupiah int primary key,
	nilairupiah int,
	jenis varchar(10)
);

INSERT INTO tblHari values
(0, 'Minggu'),
(1, 'Senin'),
(2, 'Selasa'),
(3, 'Rabu'),
(4, 'Kamis'),
(5, 'Jumat'),
(6, 'Sabtu'),
(7, 'Hari Tidak Valid');

INSERT INTO tblKabisat values
(0, 'Tahun Kabisat'),
(1, 'Bukan Tahun Kabisat'),
(2, 'Parameter lebih dari 3000');

INSERT INTO tblRupiah values
(0, 100000, 'lembar'),
(1, 50000, 'lembar'),
(2, 20000, 'lembar'),
(3, 10000,'lembar'),
(4, 5000, 'lembar'),
(5, 2000, 'lembar'),
(6, 1000, 'lembar'),
(7, 500, 'koin'),
(8, 200, 'koin'),
(9, 100, 'koin');

DELIMITER ##
CREATE PROCEDURE nomor1(pmt INT)
BEGIN
  SELECT
	CASE
		WHEN pmt<7 THEN (SELECT namahari FROM tblHari WHERE parameterhari=pmt)
	ELSE (SELECT namahari FROM tblHari WHERE parameterhari=7)
	END AS NAMAHARI ;
END
##
DELIMITER ;

/*
mysql>
CALL nomor1(0);
CALL nomor1(1);
CALL nomor1(2);
CALL nomor1(3);
CALL nomor1(4);
CALL nomor1(5);
CALL nomor1(6);
CALL nomor1(7);
CALL nomor1(8);
*/

/* Nomor 2 */
DELIMITER ##
CREATE PROCEDURE nomor2(tahun INT)
BEGIN
SELECT
	CASE
		WHEN tahun<=3000 && tahun%4=0 THEN (SELECT kabisat FROM tblKabisat WHERE parameterkabisat=0)
		WHEN tahun<=3000 && tahun%4!=0 THEN (SELECT kabisat FROM tblKabisat WHERE parameterkabisat=1)
	ELSE (SELECT kabisat FROM tblKabisat WHERE parameterkabisat=2)
	END AS TAHUNKABISAT ;
END
##
DELIMITER ;
/*
mysql>
CALL nomor2(100);
CALL nomor2(102);
CALL nomor2(2000);
CALL nomor2(2002);
CALL nomor2(3000);
CALL nomor2(3002);
*/

/* Nomor 3 */
DELIMITER ##
CREATE PROCEDURE nomor3(input int)
BEGIN

    DECLARE temp_sum INT;
    DECLARE counting INT;
    DECLARE penghitung INT;
    DECLARE summary INT;
    DECLARE temp_tingkat INT;
    DECLARE temp_input INT;
    DECLARE memory VARCHAR(100);
    DECLARE temp_memory VARCHAR(100);

    SET temp_sum = 1;
    SET counting = LENGTH(input);
    SET penghitung = 1;
    SET summary = 1;
    SET temp_tingkat = 3;
    SET temp_input = input;
    SET memory = -2;

    WHILE temp_tingkat!=1 DO

            WHILE penghitung <= counting DO
                SET temp_sum = SUBSTRING(temp_input, penghitung, 1); /* Substring itu seperti mid*/
                SET summary = summary * temp_sum;

                CASE /*untuk mengambil digit*/
               		WHEN memory = -2 THEN SET memory = SUBSTRING(temp_input, penghitung, 1);
                	WHEN memory != -2 THEN SET memory = CONCAT(memory , " * ",SUBSTRING(temp_input, penghitung, 1));
                END CASE;

                SET penghitung = penghitung + 1;
            END WHILE;

        SET temp_tingkat = LENGTH(summary);

        SELECT memory AS Perkalian, summary AS "HASIL :";

        SET counting = LENGTH(summary);
        SET temp_sum = NULL;
        SET temp_input = summary;
        SET summary = 1;
        SET penghitung = 1;
        SET memory = -2;
    END WHILE;
END ##
DELIMITER ;
/*
mysql>
CALL nomor3(123456);
CALL nomor3(2222);
CALL nomor3(232323);
CALL nomor3(654321);
CALL nomor3(1212);
CALL nomor3(98989);
*/

/* Nomor 4 */

DELIMITER ##
CREATE PROCEDURE nomor4(uang INT)
BEGIN

	SELECT CONCAT('Rp. ',nilairupiah) AS NILAIRUPIAH,
		CASE
			when uang>=1000000 && nilairupiah=100000 THEN LEFT(uang/100000,2)
			when uang<1000000 && uang>=100000 && nilairupiah=100000 THEN LEFT(uang/100000,1)
			when uang>=50000 && nilairupiah=50000 THEN LEFT(((uang%100000)/50000),1)
			when uang>=20000 && nilairupiah=20000 THEN LEFT((uang%50000)/20000,1)
			when uang>=10000 && nilairupiah=10000 && (((uang%100000)%50000)%20000>=10000)THEN LEFT(((uang%100000)%50000)%20000/10000,1)
			when uang>=5000 && nilairupiah=5000 && ((((uang%100000)%50000)%20000)%10000>=5000)THEN 1
			when uang>=2000 && nilairupiah=2000 && (((((uang%100000)%50000)%20000)%10000)%5000>=2000)THEN LEFT(((((uang%100000)%50000)%20000)%10000)%5000/2000,1)
			when uang>=1000 && nilairupiah=1000 && ((((((uang%100000)%50000)%20000)%10000)%5000)%2000>=1000) THEN 1
			when uang>=500 && nilairupiah=500 && (((((((uang%100000)%50000)%20000)%10000)%5000)%2000)%1000>=500) THEN 1
			when uang>=200 && nilairupiah=200 && ((((((((uang%100000)%50000)%20000)%10000)%5000)%2000)%1000)%500>=200) THEN LEFT((((((((uang%100000)%50000)%20000)%10000)%5000)%2000)%1000)%500/200,1)
			when uang>=100 && nilairupiah=100 && (((((((((uang%100000)%50000)%20000)%10000)%5000)%2000)%1000)%500)%200>=100) THEN 1
			ELSE 0
		END AS JUMLAHUANG
	FROM tblRupiah;

END ##
DELIMITER ;
/*mysql>
CALL nomor4(4900900);
CALL nomor4(190900);
CALL nomor4(202800);*/

/* Nomor 5 */
DELIMITER ##
CREATE PROCEDURE nomor5(input5 text)
BEGIN
	DECLARE lengthtext INT;
	SET lengthtext=length(input5);

	SELECT input5 AS INPUTAN,
		CASE
			WHEN lengthtext<=20 THEN REVERSE(input5)
			ELSE 'Melebihi batas kalimat(20)'
	 	END AS OUTPUT;

END ##
DELIMITER ;
/*
mysql>
CALL nomor5('nikodemus');
CALL nomor5('taat');
CALL nomor5('katak');
CALL nomor5('kasur ini rusak');
CALL nomor5('ibu ratna antar ubi');
CALL nomor5('level');
*/

/* Nomor 6 */
DELIMITER ##
CREATE PROCEDURE nomor6(input6 varchar(255))
BEGIN
	DECLARE hurufke int;
	DECLARE textlength int;
	DECLARE vocal int;
	DECLARE memory char;
	DECLARE konsonan int;
	DECLARE karakterlain int;
	SET hurufke=1;
	SET textlength=length(input6);
	SET vocal=0;
	SET konsonan=0;
	SET karakterlain =0;
	WHILE hurufke<=textlength DO
		SET memory = SUBSTRING(input6,hurufke,1);
		CASE
			WHEN (memory) IN('a','i','u','e','o') THEN SET vocal=vocal+1;
			WHEN (memory) IN('b','c','d','f','g','h','j','k','l','m','n','p','q','r','s','t','v','w','x','y','z') THEN SET konsonan=konsonan+1;
			ELSE SET karakterlain=karakterlain+1;
		END CASE;
	SET hurufke=hurufke+1;
	END WHILE;
	SELECT vocal AS JUMLAHVOCAL, konsonan AS JUMLAHKONSONAN, karakterlain AS KARAKTERLAIN;
END

##
DELIMITER ;

/*
mysql>
CALL nomor6('nikodemus');
CALL nomor6('NIKODEMUS GALIH CANDRA WICAKSONO');
CALL nomor6('terima KASIH');
*/

DELIMITER $$
drop procedure if exists spUang;
CREATE PROCEDURE spUang(input int)
ThisSP:BEGIN

    DECLARE uang100, uang50, uang20, uang10, uang5, uang2, uang1, coin500, coin200, coin100 INT;

    DECLARE a,b,c,d,e,f,g,h,i,j INT;

    DECLARE inputasli VARCHAR(1000);
    DECLARE keterangan VARCHAR(1000);

    SET uang100 = 100000;
    SET uang50 = 50000;
    SET uang20 = 20000;
    SET uang10 = 10000;
    SET uang5 = 5000;
    SET uang2 = 2000;
    SET uang1 = 1000;

    SET coin500 = 500;
    SET coin200 = 200;
    SET coin100 = 100;

    SET inputasli = input;
    SET keterangan = "";

    SET a = 0;
    SET b = 0;
    SET c = 0;
    SET d = 0;
    SET e = 0;
    SET f = 0;
    SET g = 0;
    SET h = 0;
    SET i = 0;
    SET j = 0;

    IF (RIGHT(input,2) > 0 AND RIGHT(input,2) <= 99) THEN /*jika input dibawah 100*/
            select inputasli as "Uang Yang Diinput", input, "INVALID INPUT ! Masukan input dengan 2 angka kanan HARUS 00 !" as "ERROR !";
            LEAVE ThisSP; /*BREAK PROCEDURE pake label dulu*/
        END IF;

        while input > 0 DO /*pembagian uangnya*/

        CASE
        WHEN input >= uang100 THEN SET a = a + 1;
        WHEN input < uang100 AND input >= uang50 THEN  SET b = b + 1 ;
        WHEN input < uang50 AND input >= uang20 THEN  SET c = c + 1;
        WHEN input < uang20 AND input >= uang10 THEN  SET d = d + 1;
        WHEN input < uang10 AND input >= uang5 THEN   SET e = e + 1;
        WHEN input < uang5 AND input >= uang2 THEN   SET f = f + 1;
        WHEN input < uang2 AND input >= uang1 THEN   SET g = g + 1;
        WHEN input < uang1 AND input >= coin500 THEN   SET h = h + 1;
        WHEN input < coin500 AND input >= coin200 THEN   SET i = i + 1;
        WHEN input < coin200 AND input >= coin100 THEN   SET j = j + 1;
        END CASE;


        CASE
            WHEN input >= uang100 THEN SET input = input - uang100;
            WHEN input < uang100 AND input >= uang50 THEN SET input = input - uang50;
            WHEN input < uang50 AND input >= uang20 THEN SET input = input - uang20;
            WHEN input < uang20 AND input >= uang10 THEN SET input = input - uang10;
            WHEN input < uang10 AND input >= uang5 THEN SET input = input - uang5 ;
            WHEN input < uang5 AND input >= uang2 THEN SET input = input - uang2 ;
            WHEN input < uang2 AND input >= uang1 THEN SET input = input - uang1 ;
            WHEN input < uang1 AND input >= coin500 THEN   SET input = input - coin500;
            WHEN input < coin500 AND input >= coin200 THEN   SET input = input - coin200;
            WHEN input < coin200 AND input >= coin100 THEN   SET input = input - coin100;

        END CASE;

        END WHILE;
        WHILE a+b+c+d+e+f+g+h+i+j != 0 DO /*hitung butuh brp lembar*/

    --  select a as checkera; debug
    --  select b as checkerb;

        CASE
        WHEN a > 0 THEN SET keterangan = CONCAT(keterangan, CONCAT(a , " lembar uang " , uang100, "   "));
        WHEN b > 0 THEN SET keterangan = CONCAT(keterangan, CONCAT(b , " lembar uang ", uang50, "   "));
        WHEN c > 0 THEN SET keterangan = CONCAT(keterangan, CONCAT(c , " lembar uang ", uang20, "   "));
        WHEN d > 0 THEN SET keterangan = CONCAT(keterangan, CONCAT(d , " lembar uang ", uang10, "   "));
        WHEN e > 0 THEN SET keterangan = CONCAT(keterangan, CONCAT(e , " lembar uang " , uang5, "   " ));
        WHEN f > 0 THEN SET keterangan = CONCAT(keterangan, CONCAT(f , " lembar uang " , uang2, "   " ));
        WHEN g > 0 THEN SET keterangan = CONCAT(keterangan, CONCAT(g , " lembar uang " , uang1, "   " ));
        WHEN h > 0 THEN SET keterangan = CONCAT(keterangan, CONCAT(h , " buah Coin " , coin500, "   " ));
        WHEN i > 0 THEN SET keterangan = CONCAT(keterangan, CONCAT(i , " buah Coin " , coin200, "   " ));
        WHEN j > 0 THEN SET keterangan = CONCAT(keterangan, CONCAT(j , " buah Coin " , coin100, "   " ));
        END CASE;

        CASE
        WHEN a > 0 THEN SET a = 0;
        WHEN b > 0 THEN SET b = 0;
        WHEN c > 0 THEN SET c = 0;
        WHEN d > 0 THEN SET d = 0;
        WHEN e > 0 THEN SET e = 0;
        WHEN f > 0 THEN SET f = 0;
        WHEN g > 0 THEN SET g = 0;
        WHEN h > 0 THEN SET h = 0;
        WHEN i > 0 THEN SET i = 0;
        WHEN j > 0 THEN SET j = 0;
        END CASE;


    END WHILE;
    select inputasli as "Uang Yang Diinput", keterangan as " Uang yang dibutuhkan ";


END $$
DELIMITER ;
