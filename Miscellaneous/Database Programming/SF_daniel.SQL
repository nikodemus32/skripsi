DROP DATABASE IF EXISTS STOREFUCNTION;
CREATE DATABASE STOREFUCNTION;
USE STOREFUCNTION;


-- NO 1
DELIMITER $$
CREATE FUNCTION sfHitungHariJamMenitDetik(input INT) 
RETURNS varchar(255)
BEGIN
	DECLARE Output VARCHAR(255) DEFAULT ''; 
	DECLARE Penampung, Hitung, i INT DEFAULT 0;
	SET i = 1;
	SET Hitung = input;
	ULANGAN: WHILE i <= 4 DO
		CASE
			WHEN FLOOR(Hitung/86400) != 0 THEN
				SET Penampung= FLOOR(Hitung/86400);
				SET Hitung = Hitung-(Penampung*86400);
				SET Output = CONCAT(Output, Penampung, ' hari ');
				SET i=i+1;
			WHEN FLOOR(Hitung/3600) != 0 THEN
				SET Penampung= FLOOR(Hitung/3600);
				SET Hitung = Hitung-(Penampung*3600);
				SET Output = CONCAT(Output, Penampung, ' jam ');
				SET i=i+1;
			WHEN FLOOR(Hitung/60) != 0 THEN
				SET Penampung= FLOOR(Hitung/60);
				SET Hitung = Hitung-(Penampung*60);
				SET Output = CONCAT(Output, Penampung, ' menit ');
				SET i=i+1;
			ELSE
				IF(Hitung != 0) THEN
					SET Output = CONCAT(Output, Hitung, ' detik');
				END IF;
				SET i= 5;
			END CASE;
	END WHILE ULANGAN;
	RETURN (Output);
END$$
DELIMITER ;

select sfHitungHariJamMenitDetik(100000) as Hasil;

-- NO 2
CREATE TABLE SF(
	id INT PRIMARY KEY NOT NULL ,
	nama VARCHAR(255),
	tinggi INT
);
INSERT INTO SF VALUES
(0,'Desy',157),
(1,'Lili',162),
(2,'Mikael',175),
(3,'Benny',170);


DELIMITER $$
CREATE FUNCTION sfBeratIdeal()
RETURNS VARCHAR(255)
BEGIN
	DECLARE output,namaOrang VARCHAR(255) DEFAULT '';
	DECLARE hitung, ulang, tinggiOrang INT DEFAULT 0;
	SET ULANG = 1;
	WHILE ulang <=4  DO
		SELECT Nama INTO namaOrang FROM SF WHERE ID = ulang;
		SELECT Tinggi INTO tinggiOrang FROM SF WHERE ID = ulang;
		SET hitung = tinggiOrang-100;
		SET hitung = hitung-(hitung*(10/100));
		SET output = CONCAT(output, ' nama ', namaOrang, ' tinggi orangnya ', tinggiOrang, ' dengan itu berat idealnya adalah ',hitung);
		SET ulang = ulang+1;
	END WHILE;
	RETURN (output);
END$$
DELIMITER ;

SELECT sfBeratIdeal() AS HASIL;

-- NO 3
delimiter $$
create function sfHitungHurufVocal(kalimat VARCHAR(200))
RETURNS VARCHAR(255)
begin
  DECLARE output VARCHAR(255) DEFAULT '';
  declare penghitung,vokal,konsonan,karakterlain,panjang_parameter int;
  declare huruf varchar(1);
  set penghitung=1;
  set vokal=0;
  set konsonan=0;
  set karakterlain=0;
  set panjang_parameter=length(kalimat);

  while penghitung <= panjang_parameter do
    set huruf=SUBSTRING(kalimat, penghitung,1);

    case
      when UCASE(huruf) in ( 'A', 'E', 'I', 'O', 'U' )
        then set vokal = vokal + 1;
      when UCASE(huruf) in ('B','C','D','F','G','H','J','K','L','M','N','P','Q','R','S','T','V','W','X','Y','Z')
          then set konsonan = konsonan + 1;
      else set karakterlain = karakterlain + 1;
    end case;

    set penghitung = penghitung + 1;
  end while;

  SET output = CONCAT(vokal, ' huruf vokal ', konsonan, ' huruf konsonan dan ', karakterlain,' karakter lain');

  RETURN (output);

end$$
delimiter ;

SELECT sfHitungHurufVocal('Fakultas Ilmu Komputer') AS HASIL;
