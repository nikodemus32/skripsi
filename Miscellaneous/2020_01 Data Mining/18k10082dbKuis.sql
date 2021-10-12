DROP DATABASE IF EXISTS dbQuis18k10082;
CREATE DATABASE dbQuis18k10082;
USE dbQuis18k10082;

CREATE TABLE tblNomor1(
  nomor int,
  waktu int,
  jarak int
);

DELIMITER $$
CREATE PROCEDURE spInsertData(vSub int, vTime int, vDist int)
BEGIN
  INSERT INTO tblNomor1 values(vSub, vTime, vDist);
END $$
DELIMITER ;

call spInsertData(1, 2, 10);
call spInsertData(2, 2, 11);
call spInsertData(3, 3, 12);
call spInsertData(4, 4, 13);
call spInsertData(5, 4, 14);
call spInsertData(6, 5, 15);
call spInsertData(7, 6, 20);
call spInsertData(8, 7, 18);
call spInsertData(9, 8, 22);
call spInsertData(10, 9, 25);

SELECT * from tblNomor1;


/*Function untuk mendapatkan nilai hasil Rata-rata*/
DELIMITER $$
CREATE FUNCTION fRata(fVariabel varchar(5))
RETURNS DECIMAL (8,2)
BEGIN
  DECLARE rata DECIMAL(8,2);
  IF fVariabel =  'waktu' THEN
    SELECT AVG(waktu) INTO rata FROM tblNomor1;
  ELSE
    SELECT AVG(jarak) INTO rata FROM tblNomor1;
  END IF;
  RETURN(rata);
END $$
DELIMITER ;

SELECT fRata('waktu') as RATAX, fRata('jarak') as RATAY;


/*Function untuk mendapatkan nilai hasil Beta
rumus
beta=sumAtas/sumBawah
sumAtas=sum(Xi-Xrata*Yi-Yrata)
sumBawah=sum((Xi-Xrata)^2)
*/
DELIMITER $$
CREATE FUNCTION fBeta()
RETURNS DECIMAL(8,2)
BEGIN
  DECLARE beta, sumAtas, sumBawah DECIMAL(8,2) DEFAULT 0;
  DECLARE fJumlahData, i INT DEFAULT 0;
  DECLARE vNomor, vWaktu, vJarak, tempAtas, tempBawah INT;
  DECLARE cSum cursor for SELECT * FROM tblNomor1;


  SELECT count(*) INTO fJumlahData FROM tblNomor1;

  OPEN cSum;
    while i <> fJumlahData DO
    fetch cSum INTO vNomor, vWaktu, vJarak;
      SET tempAtas=(vWaktu-(SELECT fRata('waktu')))*((vJarak-(SELECT fRata('jarak'))));
      SET sumAtas=sumAtas+tempAtas;

      SET tempBawah=POW(vWaktu-(SELECT fRata('waktu')), 2);
      SET sumBawah=sumBawah+tempBawah;
    SET i=i+1;
    END WHILE;

    SET beta=sumAtas/sumBawah;
  CLOSE cSum;
  RETURN(beta);
END $$
DELIMITER ;

SELECT fBeta() as Beta;



/*Function untuk mendapatkan nilai alpha
rumus alpha=Yrata-(Xrata*beta)*/

DELIMITER $$
CREATE FUNCTION fAlpha()
RETURNS DECIMAL (8,2)
BEGIN
  DECLARE alpha DECIMAL(8,2) DEFAULT 0;

  SET alpha=(SELECT fRata('jarak'))-(fBeta()*(SELECT fRata('waktu')));
RETURN(alpha);
END $$
DELIMITER ;

SELECT fAlpha() as Alpha;




/*Function untuk mendapatkan nilai hasil prediksi
*/
DELIMITER $$
CREATE FUNCTION fPrediksi(fBerapa int)
RETURNS DECIMAL(8,2)
BEGIN
  DECLARE hasil DECIMAL(8,2);
  SET hasil=(SELECT fAlpha())+((SELECT fBeta())*fBerapa);

  RETURN(hasil);
END $$
DELIMITER ;

SELECT fPrediksi(20) as "Hasil Prediksi";

DELIMITER $$
CREATE PROCEDURE spInput(pWaktu int)
BEGIN
  DECLARE angkaTerakhir int;
  SELECT max(nomor)+1 INTO angkaTerakhir FROM tblNomor1;
  INSERT INTO tblNomor1(nomor,waktu,jarak) values (angkaTerakhir, pWaktu, (SELECT fPrediksi(pWaktu)));
END $$
DELIMITER ;
