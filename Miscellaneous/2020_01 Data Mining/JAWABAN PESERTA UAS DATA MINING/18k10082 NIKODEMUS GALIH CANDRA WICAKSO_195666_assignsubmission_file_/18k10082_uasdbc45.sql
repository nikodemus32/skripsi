/*
  NIKODEMUS GALIH CANDRA WICAKSONO
  DATA D:/Galih/Unika Soegijapranata/Data Mining
  Last modified: Monday, 11 January 2021 07:53
*/

DROP DATABASE IF EXISTS 18k10082_uasdbc45;
CREATE DATABASE 18k10082_uasdbc45;
USE 18k10082_uasdbc45;

CREATE TABLE tblData(
  pasien varchar(3),
  demam varchar(20),
  sakitkepala varchar(20),
  nyeri varchar(20),
  lemas varchar(20),
  kelelahan varchar(20),
  hidungtersumbat varchar(20),
  bersin varchar(20),
  sakittenggorokan varchar(20),
  sulitbernafas varchar(20),
  diagnosa varchar(20)
);

INSERT INTO tblData VALUES
  ("P1","Tidak","Ringan","Tidak","Tidak","Tidak","Ringan","Parah","Parah","Ringan","Demam"),
  ("P2","Parah","Parah","Parah","Parah","Parah","Tidak","Tidak","Parah","Parah","Flu"),
  ("P3","Parah","Parah","Ringan","Parah","Parah","Parah","Tidak","Parah","Parah","Flu"),
  ("P4","Tidak","Tidak","Tidak","Ringan","Tidak","Parah","Tidak","Ringan","Ringan","Demam"),
  ("P5","Parah","Parah","Ringan","Parah","Parah","Parah","Tidak","Parah","Parah","Flu"),
  ("P6","Tidak","Tidak","Tidak","Ringan","Tidak","Parah","Parah","Parah","Tidak","Demam"),
  ("P7","Parah","Parah","Parah","Parah","Parah","Tidak","Tidak","Tidak","Parah","Flu"),
  ("P8","Tidak","Tidak","Tidak","Tidak","Tidak","Parah","Parah","Tidak","Ringan","Demam"),
  ("P9","Tidak","Ringan","Ringan","Tidak","Tidak","Parah","Parah","Parah","Parah","Demam"),
  ("P10","Parah","Parah","Parah","Ringan","Ringan","Tidak","Parah","Tidak","Parah","Flu"),
  ("P11","Tidak","Tidak","Tidak","Ringan","Tidak","Parah","Ringan","Parah","Tidak","Demam"),
  ("P12","Parah","Ringan","Parah","Ringan","Parah","Tidak","Parah","Tidak","Ringan","Flu"),
  ("P13","Tidak","Tidak","Ringan","Ringan","Tidak","Parah","Parah","Parah","Tidak","Demam"),
  ("P14","Parah","Parah","Parah","Parah","Ringan","Tidak","Parah","Parah","Parah","Flu"),
  ("P15","Ringan","Tidak","Tidak","Ringan","Tidak","Parah","Tidak","Parah","Ringan","Demam"),
  ("P16","Tidak","Tidak","Tidak","Tidak","Tidak","Parah","Parah","Parah","Parah","Demam"),
  ("P17","Parah","Ringan","Parah","Ringan","Ringan","Tidak","Tidak","Tidak","Parah","Flu");

/*tambahan Testing data karena looping hanya 1*/
-- INSERT INTO tblData VALUES
--   ("P18","Tidak","Ringan","Tidak","Tidak","Tidak","Ringan","Parah","Parah","Ringan","Flu"),
--   ("P19","Parah","Parah","Parah","Parah","Parah","Tidak","Tidak","Parah","Parah","Demam");

SELECT * FROM tblData;

CREATE TABLE tblHitung(
	iterasi INT,
	atribut VARCHAR(20),
	informasi VARCHAR(255),
	jumlahdata INT,
	diagnosaflu INT,
	diagnosademam INT,
	entropy DECIMAL(8,4),
	gain DECIMAL(8,4)
);

CREATE TABLE tblHitungSementara(
	iterasi INT,
	atribut VARCHAR(20),
	informasi VARCHAR(255),
	jumlahdata INT,
	diagnosaflu INT,
	diagnosademam INT,
	entropy DECIMAL(8,4),
  splitgain DECIMAL(8,4),
	gain DECIMAL(8,4)
);

CREATE TABLE tblTree(
  iterasi INT,
  demam varchar(20),
	sakitkepala varchar(20),
	nyeri varchar(20),
	lemas varchar(20),
  kelelahan varchar(20),
  hidungtersumbat varchar(20),
  bersin varchar(20),
  sakittenggorokan varchar(20),
  sulitbernafas varchar(20),
  diagnosa varchar(20)
  );

INSERT INTO tblTree VALUES (0, "","","","","","","","","","lanjut");

SELECT * FROM tblTree;


/*spRunning menjalankan autoloopingc45 berdasarkan tblTree per iterasi
	Default tblTree iterasi=0 diagnosa="lanjut"(dihapus saat insert iterasi 1)
	 supaya autoloopingc45 berjalan sendiri.
	autoloopingc45 berhenti saat jumlah diagnosa="lanjut" adalah 0
	 pada iterasi paling terakhir ditblTree
	*/
DELIMITER $$
CREATE PROCEDURE spRunning()
	BEGIN
	DECLARE vIterasi, vLoop INT DEFAULT 0;
	DECLARE vJumlahLanjut INT DEFAULT 1;

	WHILE vJumlahLanjut <> 0 DO
		SELECT vIterasi+1 AS looping;

		/*menjalankan loooping iterasi, dibuat procedure karena membutuhkan
		cursor yang berubah-ubah didalam whilenya*/
		call spLooping(vIterasi);

		SET vIterasi=(SELECT max(iterasi) FROM tblTree);
		SELECT COUNT(*) INTO vJumlahLanjut FROM tblTree WHERE diagnosa='lanjut' and iterasi=(SELECT max(iterasi) FROM tblTree);
		SELECT vIterasi as loopKe, vJumlahLanjut as JumlahLanjut;

		SELECT "" AS "-------------------------------------------------------------------------------------------------------------------";

	END WHILE;

	END $$
	DELIMITER ;


/*spLooping cursor tblTree saat iterasi=pIterasi
	jika diagnosa="lanjut" maka akan menjalankan "proses autolooping iterasi"

	"proses autolooping iterasi"
	1. copy tblData ke vwTblData
	2. Delete vwTblData sesuai Fetch tblTree
	3. Data vwTblData diolah dan
			di Insert ke tblHitungSementara
			kemudian dihitung entropy
	4. Delete tblHitungSementara yang merupakan kriteria filter
	5. Hitung gain dari data tblHitungSementara
			kemudian dimasukkan ke tblGain.
			gain tblHitungSementara diupdate
			disesuaikan dengan data tblGain.
	6. tblHitungSementara sudah selesai, di insert ke tblHitung
	7. Cursor tblHitungSementara dengan gain tertinggi
			kemudian di insert ke tblTree iterasi+1
	8. kembali ke 1 untuk autoloppingiterasi berikutnya
	*/
DELIMITER $$
CREATE PROCEDURE spLooping(pIterasi INT)
  BEGIN
    -- DECLARE done INT DEFAULT 0;
    DECLARE vIterasi, vJumlahData, i INT DEFAULT 0;
    DECLARE vDemam, vSakitKepala, vNyeri, vLemas, vKelelahan, vHidungTersumbat,
            vBersin, vSakitTenggorokan, vSulitBernafas, vDiagnosa varchar(20);

    DECLARE cTblTree CURSOR FOR SELECT * FROM tblTree WHERE iterasi=pIterasi;
    -- DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
  	SELECT COUNT(*) INTO vJumlahData FROM TblTree WHERE iterasi=pIterasi;

    OPEN cTblTree;
      WHILE i <> vJumlahData DO
        FETCH cTblTree INTO vIterasi, vDemam, vSakitKepala, vNyeri, vLemas, vKelelahan, vHidungTersumbat,
                vBersin, vSakitTenggorokan, vSulitBernafas, vDiagnosa;

          IF vDiagnosa="lanjut" THEN
            DROP VIEW IF EXISTS vwTblData;
  					CREATE VIEW vwTblData AS
  						SELECT * FROM tblData;

  					call spDelete(vIterasi, vDemam, vSakitKepala, vNyeri, vLemas, vKelelahan, vHidungTersumbat,
                    vBersin, vSakitTenggorokan, vSulitBernafas, vDiagnosa);
  					SELECT * FROM vwTblData;

  					call spInsertTblHitungSementara(pIterasi);

  					call spDeleteTblHitungSementara(vIterasi, vDemam, vSakitKepala, vNyeri, vLemas, vKelelahan, vHidungTersumbat,
                    vBersin, vSakitTenggorokan, vSulitBernafas, vDiagnosa);

  					call spGain(pIterasi);

  					call spInsertTblHitung(vIterasi, vDemam, vSakitKepala, vNyeri, vLemas, vKelelahan, vHidungTersumbat,
                    vBersin, vSakitTenggorokan, vSulitBernafas, vDiagnosa);
  					SELECT * FROM tblHitungSementara;
  					SELECT * FROM tblGain;

  					call spInsertTblTree(vIterasi, vDemam, vSakitKepala, vNyeri, vLemas, vKelelahan, vHidungTersumbat,
                    vBersin, vSakitTenggorokan, vSulitBernafas, vDiagnosa);

  					SELECT * FROM tblHitung;
  					SELECT * FROM tblTree;
          END IF;/*END FROM IF vDiagnosa='lanjut'*/
        SET i=+1;

      END WHILE;
    CLOSE cTblTree;
  END $$
  DELIMITER ;


/*spDelete memfilter vwTblData*/
DELIMITER $$
CREATE PROCEDURE spDelete(pIterasi INT, pDemam varchar(20), pSakitKepala varchar(20), pNyeri varchar(20),
                          pLemas varchar(20), pKelelahan varchar(20),pHidungTersumbat varchar(20), pBersin varchar(20),
                          pSakitTenggorokan varchar(20), pSulitBernafas varchar(20), pDiagnosa varchar(20)
                        )
  BEGIN

      IF pDemam!="" THEN
        DELETE FROM vwTblData WHERE  demam!=pDemam ;
      END IF;

      IF pSakitKepala!="" THEN
        DELETE FROM vwTblData WHERE  sakitkepala!=pSakitKepala ;
      END IF;

      IF pNyeri!="" THEN
        DELETE FROM vwTblData WHERE nyeri!=pNyeri ;
      END IF;

      IF pLemas!="" THEN
        DELETE FROM vwTblData WHERE lemas!=pLemas ;
      END IF;

      IF pKelelahan!="" THEN
        DELETE FROM vwTblData WHERE  kelelahan!=pKelelahan ;
      END IF;

      IF pHidungTersumbat!="" THEN
        DELETE FROM vwTblData WHERE hidungtersumbat!=pHidungTersumbat ;
      END IF;

      IF pBersin!="" THEN
        DELETE FROM vwTblData WHERE bersin!=pBersin ;
      END IF;

      IF pSakitTenggorokan!="" THEN
        DELETE FROM vwTblData WHERE sakittenggorokan!=pSakitTenggorokan ;
      END IF;

      IF pSulitBernafas!="" THEN
        DELETE FROM vwTblData WHERE  sulitbernafas!=pSulitBernafas;
      END IF;

  END $$
  DELIMITER ;


/*spInsertTblHitungSementara dijalankan setelah spDelete(vwTblData sudah difilter)
	mentruncate tblHitungSementara sebelum kemudian mengisi
		atribut, informasi, jumlahdata, jumlahdiagnosaflu, jumlahdiagnosademam, entropy.
		setelahnya akan mengisi splitgain dan gain pada proses spGain.
*/
DELIMITER $$
CREATE PROCEDURE spInsertTblHitungSementara(pIterasi INT)
  BEGIN
    DECLARE i, vJumlahTblData INT DEFAULT 0;
    DECLARE pJumlahData, pDiagnosaFlu, pDiagnosaDemam INT;

    SET pIterasi=pIterasi+1;

    /*Mengosongkan tblHitungSementara untuk mengolah vwTblData sekarang*/
    TRUNCATE TABLE tblHitungSementara;

    /*Mengolah untuk totaldata dari vwTblData*/
    INSERT INTO tblHitungSementara(jumlahdata, diagnosaflu, diagnosademam)
    VALUES(
      (SELECT COUNT(*) FROM vwTblData),
			(SELECT COUNT(*) FROM vwTblData WHERE  diagnosa = 'Flu'),
			(SELECT COUNT(*) FROM vwTblData WHERE  diagnosa = 'Demam')
    );

    /*Mengolah data demam dari vwTblData*/
    INSERT INTO tblHitungSementara(informasi, iterasi, atribut,  jumlahdata, diagnosaflu, diagnosademam)
      SELECT DISTINCT(A.demam), pIterasi, 'Demam',
        (SELECT COUNT(*) FROM vwTblData WHERE   demam = A.demam),
        (SELECT COUNT(*) FROM vwTblData WHERE   demam = A.demam AND diagnosa = 'Flu'),
        (SELECT COUNT(*) FROM vwTblData WHERE   demam = A.demam AND diagnosa = 'Demam')
      FROM vwTblData AS A
      ORDER BY A.demam;

    /*Mengolah data sakitkepala dari vwTblData*/
    INSERT INTO tblHitungSementara(informasi, iterasi, atribut,  jumlahdata, diagnosaflu, diagnosademam)
      SELECT DISTINCT(A.sakitkepala), pIterasi, 'Sakit kepala',
        (SELECT COUNT(*) FROM vwTblData WHERE   sakitkepala= A.sakitkepala),
        (SELECT COUNT(*) FROM vwTblData WHERE   sakitkepala= A.sakitkepala AND diagnosa = 'Flu'),
        (SELECT COUNT(*) FROM vwTblData WHERE   sakitkepala= A.sakitkepala AND diagnosa = 'Demam')
      FROM vwTblData AS A
      ORDER BY A.sakitkepala;

    /*Mengolah data nyeri dari vwTblData*/
    INSERT INTO tblHitungSementara(informasi, iterasi, atribut,  jumlahdata, diagnosaflu, diagnosademam)
      SELECT DISTINCT(A.nyeri), pIterasi, 'Nyeri',
        (SELECT COUNT(*) FROM vwTblData WHERE  nyeri = A.nyeri),
        (SELECT COUNT(*) FROM vwTblData WHERE  nyeri = A.nyeri AND diagnosa = 'Flu'),
        (SELECT COUNT(*) FROM vwTblData WHERE  nyeri = A.nyeri AND diagnosa = 'Demam')
      FROM vwTblData AS A
      ORDER BY A.nyeri;

    /*Mengolah data lemas dari vwTblData*/
    INSERT INTO tblHitungSementara(informasi, iterasi, atribut,  jumlahdata, diagnosaflu, diagnosademam)
      SELECT DISTINCT(A.lemas), pIterasi, 'Lemas',
        (SELECT COUNT(*) FROM vwTblData WHERE  lemas = A.lemas),
        (SELECT COUNT(*) FROM vwTblData WHERE  lemas = A.lemas AND diagnosa = 'Flu'),
        (SELECT COUNT(*) FROM vwTblData WHERE  lemas = A.lemas AND diagnosa = 'Demam')
      FROM vwTblData AS A
      ORDER BY A.lemas;

    /*Mengolah data kelelahan dari vwTblData*/
    INSERT INTO tblHitungSementara(informasi, iterasi, atribut,  jumlahdata, diagnosaflu, diagnosademam)
      SELECT DISTINCT(A.kelelahan), pIterasi, 'Kelelahan',
        (SELECT COUNT(*) FROM vwTblData WHERE  kelelahan = A.kelelahan),
        (SELECT COUNT(*) FROM vwTblData WHERE  kelelahan = A.kelelahan AND diagnosa = 'Flu'),
        (SELECT COUNT(*) FROM vwTblData WHERE  kelelahan = A.kelelahan AND diagnosa = 'Demam')
      FROM vwTblData AS A
      ORDER BY A.kelelahan;

    /*Mengolah data hidungtersumbat dari vwTblData*/
    INSERT INTO tblHitungSementara(informasi, iterasi, atribut,  jumlahdata, diagnosaflu, diagnosademam)
      SELECT DISTINCT(A.hidungtersumbat), pIterasi, 'Hidung Tersumbat',
        (SELECT COUNT(*) FROM vwTblData WHERE  hidungtersumbat = A.hidungtersumbat),
        (SELECT COUNT(*) FROM vwTblData WHERE  hidungtersumbat = A.hidungtersumbat AND diagnosa = 'Flu'),
        (SELECT COUNT(*) FROM vwTblData WHERE  hidungtersumbat = A.hidungtersumbat AND diagnosa = 'Demam')
      FROM vwTblData AS A
      ORDER BY A.hidungtersumbat;

    /*Mengolah data bersin dari vwTblData*/
    INSERT INTO tblHitungSementara(informasi, iterasi, atribut,  jumlahdata, diagnosaflu, diagnosademam)
      SELECT DISTINCT(A.bersin), pIterasi, 'Bersin',
        (SELECT COUNT(*) FROM vwTblData WHERE  bersin = A.bersin),
        (SELECT COUNT(*) FROM vwTblData WHERE  bersin = A.bersin AND diagnosa = 'Flu'),
        (SELECT COUNT(*) FROM vwTblData WHERE  bersin = A.bersin AND diagnosa = 'Demam')
      FROM vwTblData AS A
      ORDER BY A.bersin;

    /*Mengolah data sakittenggorokan dari vwTblData*/
    INSERT INTO tblHitungSementara(informasi, iterasi, atribut,  jumlahdata, diagnosaflu, diagnosademam)
      SELECT DISTINCT(A.sakittenggorokan), pIterasi, 'Sakit Tenggorokan',
        (SELECT COUNT(*) FROM vwTblData WHERE  sakittenggorokan = A.sakittenggorokan),
        (SELECT COUNT(*) FROM vwTblData WHERE sakittenggorokan  = A.sakittenggorokan AND diagnosa = 'Flu'),
        (SELECT COUNT(*) FROM vwTblData WHERE sakittenggorokan  = A.sakittenggorokan AND diagnosa = 'Demam')
      FROM vwTblData AS A
      ORDER BY A.sakittenggorokan;

    /*Mengolah data sulitbernafas dari vwTblData*/
    INSERT INTO tblHitungSementara(informasi, iterasi, atribut,  jumlahdata, diagnosaflu, diagnosademam)
      SELECT DISTINCT(A.sulitbernafas), pIterasi, 'Sulit Bernafas',
        (SELECT COUNT(*) FROM vwTblData WHERE  sulitbernafas = A.sulitbernafas),
        (SELECT COUNT(*) FROM vwTblData WHERE  sulitbernafas = A.sulitbernafas AND diagnosa = 'Flu'),
        (SELECT COUNT(*) FROM vwTblData WHERE  sulitbernafas = A.sulitbernafas AND diagnosa = 'Demam')
      FROM vwTblData AS A
      ORDER BY A.sulitbernafas;

    /*Mengupdate entropy tblHitungSementara*/
    UPDATE tblHitungSementara
      SET entropy=(-(diagnosaflu/jumlahdata) * log2(diagnosaflu/jumlahdata)) +
                  (-(diagnosademam/jumlahdata) * log2(diagnosademam/jumlahdata))
      WHERE diagnosaflu != 0 or diagnosademam != 0;
    UPDATE tblHitungSementara SET entropy=0 WHERE entropy IS NULL;

    /*splitgain adalah
  			jumlahdata per informasi/jumlahdata pada 1 vwTblData
  			*entropy per informasi
  	*/
    UPDATE tblHitungSementara
      SET splitgain=((jumlahdata/(SELECT jumlahdata FROM tblHitungSementara WHERE iterasi IS NULL))
                    *entropy)
      WHERE jumlahdata !=0;
    UPDATE tblHitungSementara SET splitgain=0 WHERE splitgain IS NULL;
    -- SELECT * FROM tblHitungSementara;
  END $$
  DELIMITER ;


/*spDeleteTblHitungSementara untuk mendelete data di tblHitungSementara
yang merupakan kriteria filter(tblTree yang terisi)
contoh:iterasi 1 humadity high, maka iterasi 2 akan dihapus
			selain humadity high. Dan saat di Insert ke tblHitungSementara,
			humadity high akan terolah ke tblHitungSementara dan diproses.
			Karena itu dihapus setelah spInsertTblHitungSementara
*/
DELIMITER $$
CREATE PROCEDURE spDeleteTblHitungSementara(pIterasi INT, pDemam varchar(20), pSakitKepala varchar(20), pNyeri varchar(20),
                          pLemas varchar(20), pKelelahan varchar(20),pHidungTersumbat varchar(20), pBersin varchar(20),
                          pSakitTenggorokan varchar(20), pSulitBernafas varchar(20), pDiagnosa varchar(20)
                        )
  BEGIN
    IF pDemam!="" THEN
      DELETE FROM vwTblData WHERE demam="Demam" ;
    END IF;

    IF pSakitKepala!="" THEN
      DELETE FROM vwTblData WHERE sakitkepala="Sakit kepala" ;
    END IF;

    IF pNyeri!="" THEN
      DELETE FROM vwTblData WHERE nyeri="Nyeri" ;
    END IF;

    IF pLemas!="" THEN
      DELETE FROM vwTblData WHERE lemas="Lemas" ;
    END IF;

    IF pKelelahan!="" THEN
      DELETE FROM vwTblData WHERE kelelahan="Kelelahan" ;
    END IF;

    IF pHidungTersumbat!="" THEN
      DELETE FROM vwTblData WHERE hidungtersumbat="Hidung Tersumbat" ;
    END IF;

    IF pBersin!="" THEN
      DELETE FROM vwTblData WHERE bersin="Bersin" ;
    END IF;

    IF pSakitTenggorokan!="" THEN
      DELETE FROM vwTblData WHERE sakittenggorokan="Sakit Tenggorokan" ;
    END IF;

    IF pSulitBernafas!="" THEN
      DELETE FROM vwTblData WHERE  sulitbernafas="Sulit Bernafas";
    END IF;

  END $$
  DELIMITER ;


/*spGain menghitung gain dari tblHitungSementara
	di masukkan ke tblGain,
	kemudian diupdate tblHitungSementara
	diupdate disesuaikan tblGain,(tblHitungSementara selesai)
	tblHitungSementara di insert ke tblHitung
*/
DELIMITER $$
CREATE PROCEDURE spGain(pIterasi INT)
  BEGIN
    SET pIterasi=pIterasi+1;

    DROP TABLE IF EXISTS tblGain;
    CREATE TABLE tblGain(
      atribut varchar(20),
      gain DECIMAL(8,4)
    );

    /*Menghitung gain ke tblGain*/
    INSERT INTO tblGain
    SELECT atribut, ROUND((SELECT entropy FROM tblHitungSementara WHERE iterasi IS NULL)-sum(splitgain),4)
    FROM tblHitungSementara
    GROUP BY atribut;

    /*DELETE baris atas(total)*/
    DELETE FROM tblGain WHERE atribut IS NULL;
    -- SELECT * FROM tblGain;

    /*Hasil tblGain di update ke tblHitung Sementara*/
    UPDATE tblHitungSementara SET gain=(SELECT gain FROM tblGain WHERE atribut='Demam') WHERE atribut='Demam';
    UPDATE tblHitungSementara SET gain=(SELECT gain FROM tblGain WHERE atribut='Sakit kepala') WHERE atribut='Sakit kepala';
    UPDATE tblHitungSementara SET gain=(SELECT gain FROM tblGain WHERE atribut='Nyeri') WHERE atribut='Nyeri';
    UPDATE tblHitungSementara SET gain=(SELECT gain FROM tblGain WHERE atribut='Lemas') WHERE atribut='Lemas';
    UPDATE tblHitungSementara SET gain=(SELECT gain FROM tblGain WHERE atribut='Kelelahan') WHERE atribut='Kelelahan';
    UPDATE tblHitungSementara SET gain=(SELECT gain FROM tblGain WHERE atribut='Hidung Tersumbat') WHERE atribut='Hidung Tersumbat';
    UPDATE tblHitungSementara SET gain=(SELECT gain FROM tblGain WHERE atribut='Bersin') WHERE atribut='Bersin';
    UPDATE tblHitungSementara SET gain=(SELECT gain FROM tblGain WHERE atribut='Sakit Tenggorokan') WHERE atribut='Sakit Tenggorokan';
    UPDATE tblHitungSementara SET gain=(SELECT gain FROM tblGain WHERE atribut='Sulit Bernafas') WHERE atribut='Sulit Bernafas';

    /*Mendefaultkan tblHitungSementara baris atas(total) supaya tidak ada NULL*/
    UPDATE tblHitungSementara set splitgain=0 WHERE iterasi is NULL;
    UPDATE tblHitungSementara set gain=0 WHERE iterasi is NULL;
    UPDATE tblHitungSementara set informasi='' WHERE iterasi is NULL;
    UPDATE tblHitungSementara set atribut='' WHERE iterasi is NULL;
    UPDATE tblHitungSementara set iterasi=pIterasi WHERE iterasi is NULL;
  END $$
  DELIMITER ;


/*spInsertTblHitung untuk menginsert hasil tblHitungSementara yang sudah jadi,
sekaligus mengubah atribut dan informasi yang ="",
sehingga tahu total datanya dan apa saja yang di filter dan lebih mudah dibaca
*/
DELIMITER $$
CREATE PROCEDURE spInsertTblHitung(pIterasi INT, pDemam varchar(20), pSakitKepala varchar(20), pNyeri varchar(20),
                          pLemas varchar(20), pKelelahan varchar(20),pHidungTersumbat varchar(20), pBersin varchar(20),
                          pSakitTenggorokan varchar(20), pSulitBernafas varchar(20), pDiagnosa varchar(20)
                        )
  BEGIN
    -- DECLARE done INT DEFAULT 0;
    DECLARE vIterasi, vJumlahData, vDiagnosaFlu, vDiagnosaDemam, i, vJumlahTblHitungSementara INT DEFAULT 0;
    DECLARE vConcatInformasi varchar(255) DEFAULT "  ";
    DECLARE vAtribut, vInformasi varchar(20);
    DECLARE vEntropy, vGain DECIMAL(8,4);

    DECLARE cTblHitungSementara CURSOR FOR
            SELECT iterasi, atribut, informasi, jumlahdata, diagnosaflu, diagnosademam, entropy, gain
            FROM tblHitungSementara;
    -- DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    SELECT COUNT(*) INTO vJumlahTblHitungSementara FROM tblHitungSementara;

    IF pDemam!="" THEN
      SET vConcatInformasi=CONCAT(vConcatInformasi, "[2]",pDemam, ", ");
    END IF;

    IF pSakitKepala!="" THEN
      SET vConcatInformasi=CONCAT(vConcatInformasi, "[3]",pSakitKepala, ", ");
    END IF;

    IF pNyeri!="" THEN
      SET vConcatInformasi=CONCAT(vConcatInformasi, "[4]",pNyeri, ", ");
    END IF;

    IF pLemas!="" THEN
      SET vConcatInformasi=CONCAT(vConcatInformasi, "[5]",pLemas, ", ");
    END IF;

    IF pKelelahan!="" THEN
      SET vConcatInformasi=CONCAT(vConcatInformasi, "[6]",pKelelahan, ", ");
    END IF;

    IF pHidungTersumbat!="" THEN
      SET vConcatInformasi=CONCAT(vConcatInformasi, "[7]",pHidungTersumbat, ", ");
    END IF;

    IF pBersin!="" THEN
      SET vConcatInformasi=CONCAT(vConcatInformasi, "[8]",pBersin, ", ");
    END IF;

    IF pSakitTenggorokan!="" THEN
      SET vConcatInformasi=CONCAT(vConcatInformasi, "[9]",pSakitTenggorokan, ", ");
    END IF;

    IF pSulitBernafas!="" THEN
      SET vConcatInformasi=CONCAT(vConcatInformasi, "[10]",pSulitBernafas, ", ");
    END IF;

    SET vConcatInformasi=SUBSTRING(vConcatInformasi, 1, LENGTH(vConcatInformasi)-2);

    OPEN cTblHitungSementara;
      WHILE i <> vJumlahTblHitungSementara DO
        FETCH cTblHitungSementara INTO vIterasi, vAtribut, vInformasi, vJumlahData, vDiagnosaFlu, vDiagnosaDemam, vEntropy, vGain;
          IF vAtribut = "" THEN
            INSERT INTO tblHitung VALUES
              (vIterasi, "  Filter :", vConcatInformasi, vJumlahData, vDiagnosaFlu, vDiagnosaDemam, vEntropy, vGain);
          ELSE
            INSERT INTO tblHitung VALUES
              (vIterasi, vAtribut, vInformasi, vJumlahData, vDiagnosaFlu, vDiagnosaDemam, vEntropy, vGain);
          END IF;
        SET i=i+1;
      END WHILE;
      CLOSE cTblHitungSementara;

  END $$
  DELIMITER ;


/*spInsertTblTree berisi parameter dari tblTree yang sedang diproses(perbaris dengan cursor)
kemudian akan insert tblTree untuk iterasi berikutnya dengan isi parameter tadi
dan tambahan vInformasi pada kolom tblTree yang sesuai atribut tblHitungSementara
dengan kriteria gain tertinggi di tblHitungSementara,
*/
DELIMITER $$
CREATE PROCEDURE spInsertTblTree(pIterasi INT, pDemam varchar(20), pSakitKepala varchar(20), pNyeri varchar(20),
                          pLemas varchar(20), pKelelahan varchar(20),pHidungTersumbat varchar(20), pBersin varchar(20),
                          pSakitTenggorokan varchar(20), pSulitBernafas varchar(20), pDiagnosa varchar(20)
                        )
  BEGIN
    -- DECLARE done INT DEFAULT 0;
    DECLARE vIterasi, vJumlahData, vDiagnosaFlu, vDiagnosaDemam, vJumlahTblHitungSementara, i INT DEFAULT 0;
    DECLARE vAtribut, vInformasi varchar(255);
    DECLARE vEntropy, vSplitGain, vGain DECIMAL(8,4);

    DECLARE cTblHitungSementara CURSOR FOR SELECT * FROM tblHitungSementara WHERE gain=(SELECT max(gain) FROM tblHitungSementara);
    -- DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    SELECT COUNT(*) INTO vJumlahTblHitungSementara FROM  tblHitungSementara WHERE gain=(SELECT max(gain) FROM tblHitungSementara);
    SET pIterasi=pIterasi+1;

    OPEN cTblHitungSementara;
    WHILE i <> vJumlahTblHitungSementara and vJumlahTblHitungSementara != 0 DO
	    FETCH cTblHitungSementara INTO vIterasi, vAtribut, vInformasi, vJumlahData, vDiagnosaFlu, vDiagnosaDemam, vEntropy, vSplitGain, vGain;
			IF vJumlahData = 0 THEN
				INSERT INTO tblTree VALUES(vIterasi,pDemam, pSakitKepala, pNyeri,pLemas, pKelelahan,pHidungTersumbat, pBersin, pSakitTenggorokan, pSulitBernafas, '    No Data');
			ELSE
	      IF vAtribut='Demam' THEN
	        IF vJumlahData=vDiagnosaFlu THEN
	          INSERT INTO tblTree VALUES(vIterasi,vInformasi, pSakitKepala, pNyeri,pLemas, pKelelahan,pHidungTersumbat, pBersin, pSakitTenggorokan, pSulitBernafas, '        FLU');
	        ELSEIF vJumlahData=vDiagnosaDemam THEN
	          	INSERT INTO tblTree VALUES(vIterasi,vInformasi, pSakitKepala, pNyeri,pLemas, pKelelahan,pHidungTersumbat, pBersin, pSakitTenggorokan, pSulitBernafas, '      DEMAM');
	        ELSE
	          	INSERT INTO tblTree VALUES(vIterasi,vInformasi, pSakitKepala, pNyeri,pLemas, pKelelahan,pHidungTersumbat, pBersin, pSakitTenggorokan, pSulitBernafas, 'lanjut');
	        END IF;
	      END IF;

        IF vAtribut='Sakit kepala' THEN
	        IF vJumlahData=vDiagnosaFlu THEN
	          INSERT INTO tblTree VALUES(vIterasi,pDemam, vInformasi, pNyeri,pLemas, pKelelahan,pHidungTersumbat, pBersin, pSakitTenggorokan, pSulitBernafas, '        FLU');
	        ELSEIF vJumlahData=vDiagnosaDemam THEN
	          	INSERT INTO tblTree VALUES(vIterasi,pDemam, vInformasi, pNyeri,pLemas, pKelelahan,pHidungTersumbat, pBersin, pSakitTenggorokan, pSulitBernafas, '      DEMAM');
	        ELSE
	          	INSERT INTO tblTree VALUES(vIterasi,pDemam, vInformasi, pNyeri,pLemas, pKelelahan,pHidungTersumbat, pBersin, pSakitTenggorokan, pSulitBernafas, 'lanjut');
	        END IF;
	      END IF;

        IF vAtribut='Nyeri' THEN
	        IF vJumlahData=vDiagnosaFlu THEN
	          INSERT INTO tblTree VALUES(vIterasi,pDemam, pSakitKepala, vInformasi,pLemas, pKelelahan,pHidungTersumbat, pBersin, pSakitTenggorokan, pSulitBernafas, '        FLU');
	        ELSEIF vJumlahData=vDiagnosaDemam THEN
	          	INSERT INTO tblTree VALUES(vIterasi,pDemam, pSakitKepala, vInformasi,pLemas, pKelelahan,pHidungTersumbat, pBersin, pSakitTenggorokan, pSulitBernafas, '      DEMAM');
	        ELSE
	          	INSERT INTO tblTree VALUES(vIterasi,pDemam, pSakitKepala, vInformasi,pLemas, pKelelahan,pHidungTersumbat, pBersin, pSakitTenggorokan, pSulitBernafas, 'lanjut');
	        END IF;
	      END IF;

        IF vAtribut='Lemas' THEN
	        IF vJumlahData=vDiagnosaFlu THEN
	          INSERT INTO tblTree VALUES(vIterasi,pDemam, pSakitKepala, pNyeri,vInformasi, pKelelahan,pHidungTersumbat, pBersin, pSakitTenggorokan, pSulitBernafas, '        FLU');
	        ELSEIF vJumlahData=vDiagnosaDemam THEN
	          	INSERT INTO tblTree VALUES(vIterasi,pDemam, pSakitKepala, pNyeri,vInformasi, pKelelahan,pHidungTersumbat, pBersin, pSakitTenggorokan, pSulitBernafas, '      DEMAM');
	        ELSE
	          	INSERT INTO tblTree VALUES(vIterasi,pDemam, pSakitKepala, pNyeri,vInformasi, pKelelahan,pHidungTersumbat, pBersin, pSakitTenggorokan, pSulitBernafas, 'lanjut');
	        END IF;
	      END IF;

        IF vAtribut='Kelelahan' THEN
	        IF vJumlahData=vDiagnosaFlu THEN
	          INSERT INTO tblTree VALUES(vIterasi,pDemam, pSakitKepala, pNyeri,pLemas, vInformasi,pHidungTersumbat, pBersin, pSakitTenggorokan, pSulitBernafas, '        FLU');
	        ELSEIF vJumlahData=vDiagnosaDemam THEN
	          	INSERT INTO tblTree VALUES(vIterasi,pDemam, pSakitKepala, pNyeri,pLemas, vInformasi,pHidungTersumbat, pBersin, pSakitTenggorokan, pSulitBernafas, '      DEMAM');
	        ELSE
	          	INSERT INTO tblTree VALUES(vIterasi,pDemam, pSakitKepala, pNyeri,pLemas, vInformasi,pHidungTersumbat, pBersin, pSakitTenggorokan, pSulitBernafas, 'lanjut');
	        END IF;
	      END IF;

        IF vAtribut='Hidung Tersumbat' THEN
	        IF vJumlahData=vDiagnosaFlu THEN
	          INSERT INTO tblTree VALUES(vIterasi,pDemam, pSakitKepala, pNyeri,pLemas, pKelelahan,vInformasi, pBersin, pSakitTenggorokan, pSulitBernafas, '        FLU');
	        ELSEIF vJumlahData=vDiagnosaDemam THEN
	          	INSERT INTO tblTree VALUES(vIterasi,pDemam, pSakitKepala, pNyeri,pLemas, pKelelahan,vInformasi, pBersin, pSakitTenggorokan, pSulitBernafas, '      DEMAM');
	        ELSE
	          	INSERT INTO tblTree VALUES(vIterasi,pDemam, pSakitKepala, pNyeri,pLemas, pKelelahan,vInformasi, pBersin, pSakitTenggorokan, pSulitBernafas, 'lanjut');
	        END IF;
	      END IF;

        IF vAtribut='Bersin' THEN
	        IF vJumlahData=vDiagnosaFlu THEN
	          INSERT INTO tblTree VALUES(vIterasi,pDemam, pSakitKepala, pNyeri,pLemas, pKelelahan,pHidungTersumbat, vInformasi, pSakitTenggorokan, pSulitBernafas, '        FLU');
	        ELSEIF vJumlahData=vDiagnosaDemam THEN
	          	INSERT INTO tblTree VALUES(vIterasi,pDemam, pSakitKepala, pNyeri,pLemas, pKelelahan,pHidungTersumbat, vInformasi, pSakitTenggorokan, pSulitBernafas, '      DEMAM');
	        ELSE
	          	INSERT INTO tblTree VALUES(vIterasi,pDemam, pSakitKepala, pNyeri,pLemas, pKelelahan,pHidungTersumbat, vInformasi, pSakitTenggorokan, pSulitBernafas, 'lanjut');
	        END IF;
	      END IF;

        IF vAtribut='Sakit Tenggorokan' THEN
	        IF vJumlahData=vDiagnosaFlu THEN
	          INSERT INTO tblTree VALUES(vIterasi,pDemam, pSakitKepala, pNyeri,pLemas, pKelelahan,pHidungTersumbat, pBersin, vInformasi, pSulitBernafas, '        FLU');
	        ELSEIF vJumlahData=vDiagnosaDemam THEN
	          	INSERT INTO tblTree VALUES(vIterasi,pDemam, pSakitKepala, pNyeri,pLemas, pKelelahan,pHidungTersumbat, pBersin, vInformasi, pSulitBernafas, '      DEMAM');
	        ELSE
	          	INSERT INTO tblTree VALUES(vIterasi,pDemam, pSakitKepala, pNyeri,pLemas, pKelelahan,pHidungTersumbat, pBersin, vInformasi, pSulitBernafas, 'lanjut');
	        END IF;
	      END IF;

        IF vAtribut='Sulit Bernafas' THEN
	        IF vJumlahData=vDiagnosaFlu THEN
	          INSERT INTO tblTree VALUES(vIterasi,pDemam, pSakitKepala, pNyeri,pLemas, pKelelahan,pHidungTersumbat, pBersin, pSakitTenggorokan, vInformasi, '        FLU');
	        ELSEIF vJumlahData=vDiagnosaDemam THEN
	          	INSERT INTO tblTree VALUES(vIterasi,pDemam, pSakitKepala, pNyeri,pLemas, pKelelahan,pHidungTersumbat, pBersin, pSakitTenggorokan, vInformasi, '      DEMAM');
	        ELSE
	          	INSERT INTO tblTree VALUES(vIterasi,pDemam, pSakitKepala, pNyeri,pLemas, pKelelahan,pHidungTersumbat, pBersin, pSakitTenggorokan, vInformasi, 'lanjut');
	        END IF;
	      END IF;
      END IF; /* END FROM IF vJumlahData = 0*/

			/*Menghilangkan baris 1(iterasi=0 diagnosa="lanjut")
				karena hanya digunakan untuk menjalankan autolooping awal*/
	    DELETE FROM tblTree WHERE iterasi=0;
	    SET i=i+1;
    END WHILE;
    CLOSE cTblHitungSementara;

  END $$
  DELIMITER ;

call spRunning();

-- SELECT "|  ______         _____ ______    ________  __    __  ________  ________     ______  __      _______  ________  ______   | |
-- | | |   ___|       / _  ||   ___|  |   __   ||  |  |  ||___  ___||   ___  |   |   ___||  |    |   ____||   __   ||  __  )  | |
-- | | |  |     ___  / /_| ||  |__    |  |__|  ||  |  |  |   |  |   |  |   | |   |  |    |  |    |  |____ |  |__|  || |_/ /   | |
-- | | |  |    |___|/___   ||___  \\   |   __   ||  |  |  |   |  |   |  |   | |   |  |    |  |    |   ____||   __   ||     \\   | |
-- | | |  |___          |  | ___)  |  |  |  |  ||  |__|  |   |  |   |  |___| |   |  |___ |  |___ |  |____ |  |  |  ||  |\\  \\  | |
-- | | |______|         |__||_____/   |__|  |__||________|   |__|   |________|   |______||______||_______||__|  |__||__| \__\\ | |
-- | |                                                                                                                        |" as "-";
