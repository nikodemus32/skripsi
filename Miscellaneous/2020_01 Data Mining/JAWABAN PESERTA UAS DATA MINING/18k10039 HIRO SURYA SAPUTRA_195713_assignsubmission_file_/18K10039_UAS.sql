DROP DATABASE IF EXISTS dbC45;
CREATE DATABASE dbC45;
USE dbC45;


CREATE TABLE tblData(   
    nourut int,
    Demam VARCHAR(256),
    Sakit_Kepala VARCHAR(256),
    Nyeri VARCHAR(256),  
    Lemas VARCHAR(256),
    Kelelahan VARCHAR(256),
    Hidung_Tersumbat VARCHAR(256),
    Bersin VARCHAR(256),
    Sakit_Tenggorokan VARCHAR(256),
    Sulit_bernafas VARCHAR(256),
    Diagnosa VARCHAR(256)
 );

INSERT INTO tblData
VALUES
(1,'Tidak',	'Ringan','Tidak','Tidak','Tidak','Ringan','Parah','Parah','Ringan','Demam'),
(2,'Parah','Parah','Parah','Parah','Parah','Tidak',	'Tidak','Parah','Parah','Flu'),
(3,'Parah',	'Parah','Ringan','Parah','Parah','Parah','Tidak','Parah','Parah','Flu'),
(4,'Tidak','Tidak','Tidak','Ringan','Tidak','Parah','Tidak','Ringan','Ringan','Demam'),
(5,'Parah','Parah','Ringan','Parah','Parah','Parah','Tidak','Parah','Parah','Flu'),
(6,'Tidak','Tidak','Tidak','Ringan','Tidak','Parah','Parah','Parah','Tidak','Demam'),
(7,'Parah','Parah','Parah','Parah','Parah','Tidak','Tidak','Tidak','Parah','Flu'),
(8,'Tidak','Tidak','Tidak','Tidak','Tidak','Parah','Parah','Tidak','Ringan','Demam'),
(9,'Tidak','Ringan','Ringan','Tidak','Tidak','Parah','Parah','Parah','Parah','Demam'),
(10,'Parah','Parah','Parah','Ringan','Ringan','Tidak','Parah','Tidak','Parah','Flu'),
(11,'Tidak','Tidak','Tidak','Ringan','Tidak','Parah','Ringan','Parah','Tidak','Demam'),
(12,'Parah','Ringan','Parah','Ringan','Parah','Tidak','Parah','Tidak','Ringan','Flu'),
(13,'Tidak','Tidak','Ringan','Ringan','Tidak','Parah','Parah','Parah','Tidak','Demam'),
(14,'Parah','Parah','Parah','Parah','Ringan','Tidak','Parah','Parah','Parah','Flu'),
(15,'Ringan','Tidak','Tidak','Ringan','Tidak','Parah','Tidak','Parah','Ringan','Demam'),
(16,'Tidak','Tidak','Tidak','Tidak','Tidak','Parah','Parah','Parah','Parah','Demam'),
(17,'Parah','Ringan','Parah','Ringan','Ringan','Tidak','Tidak','Tidak','Parah','Flu');

SELECT * FROM tblData;

DELIMITER $$
CREATE FUNCTION Count_Data_Diagnosa(a VARCHAR(256))
RETURNS FLOAT 
BEGIN
    DECLARE Count_Data_Diagnosa INT;
    set Count_Data_Diagnosa =(SELECT COUNT(Diagnosa) FROM tblData WHERE Diagnosa=a);
    RETURN (Count_Data_Diagnosa); 
END $$
DELIMITER ;


DELIMITER $$
CREATE FUNCTION ENTROPY_TOTAL()
RETURNS FLOAT 
BEGIN
    DECLARE ENTROPY1 FLOAT;
    DECLARE ENTROPY2 FLOAT;
    DECLARE ENTROPY FLOAT;

    DECLARE b1 FLOAT;
    DECLARE b2 FLOAT;
    DECLARE c FLOAT;

    SET b1=(SELECT Count_Data_Diagnosa('Demam'));
    SET b2=(SELECT Count_Data_Diagnosa('Flu'));

    SET c =(SELECT COUNT(*) FROM tblData);

    SET ENTROPY1=(-b1/(c))*log2(b1/(c));
    SET ENTROPY2=(-b2/(c))*log2(b2/(c));

    SET ENTROPY = ENTROPY1+ENTROPY2;

    RETURN (ENTROPY);
END $$
DELIMITER ;


/*Demam*/
DELIMITER $$
CREATE FUNCTION Count_Data_Demam(a VARCHAR(256),b VARCHAR(256))
RETURNS FLOAT 
BEGIN
    DECLARE Count_Data_Demam INT;
    SET Count_Data_Demam =
        (SELECT COUNT(Demam) 
            FROM tblData 
            WHERE Demam=a AND Diagnosa=b);
    RETURN (Count_Data_Demam); 
END $$
DELIMITER ;


DELIMITER $$
CREATE FUNCTION Entropy_Demam(a VARCHAR(256),b VARCHAR(256))
RETURNS FLOAT 
BEGIN
    
    DECLARE ENTROPY FLOAT;
    DECLARE d INT;
    DECLARE e INT;
   
    SET d = (SELECT Count_Data_Demam(a,b));
    SET e = (SELECT COUNT(Demam) FROM tblData);
    
    IF d = 0 THEN
        RETURN(0);
    END IF; 
         
    SET ENTROPY=(-d/(e))*log2(d/(e));

    RETURN(ENTROPY);
END $$
DELIMITER ;

DELIMITER $$
CREATE FUNCTION GAIN_Demam()
RETURNS FLOAT 
BEGIN
    DECLARE GAIN FLOAT;
    DECLARE GAIN1 FLOAT;
    DECLARE GAIN2 FLOAT;
    DECLARE GAIN3 FLOAT;

    DECLARE Count1_1 FLOAT;
    DECLARE Count1_2 FLOAT;
    DECLARE Count2_1 FLOAT;
    DECLARE Count2_2 FLOAT;
    DECLARE Count3_1 FLOAT;
    DECLARE Count3_2 FLOAT;

    DECLARE CountAll INT;
    
    DECLARE Entropy1_1 FLOAT;
    DECLARE Entropy1_2 FLOAT;
    DECLARE Entropy2_1 FLOAT;
    DECLARE Entropy2_2 FLOAT;
    DECLARE Entropy3_1 FLOAT;
    DECLARE Entropy3_2 FLOAT;

    SET Entropy1_1 = (SELECT Entropy_Demam('Tidak','Demam'));
    SET Entropy1_2 = (SELECT Entropy_Demam('Tidak','Flu'));
    SET Entropy2_1 = (SELECT Entropy_Demam('Parah','Demam'));
    SET Entropy2_2 = (SELECT Entropy_Demam('Parah','Flu'));
    SET Entropy3_1 = (SELECT Entropy_Demam('Ringan','Demam'));
    SET Entropy3_2 = (SELECT Entropy_Demam('Ringan','Flu'));

    SET CountAll = (SELECT COUNT(*) FROM tblData);
    SET Count1_1 = (SELECT Count_Data_Demam('Tidak','Demam'));
    SET Count1_2 = (SELECT Count_Data_Demam('Tidak','Flu'));
    SET Count2_1 = (SELECT Count_Data_Demam('Parah','Demam'));
    SET Count2_2 = (SELECT Count_Data_Demam('Parah','Flu'));
    SET Count3_1 = (SELECT Count_Data_Demam('Ringan','Demam'));
    SET Count3_2 = (SELECT Count_Data_Demam('Ringan','Flu'));


    SET GAIN1 = (((Count1_1)/(CountAll))*(Entropy1_1))*(((Count1_2)/(CountAll))*(Entropy1_2));
    SET GAIN2 = (((Count2_1)/(CountAll))*(Entropy2_1))*(((Count2_2)/(CountAll))*(Entropy2_2));
    SET GAIN3 = (((Count3_1)/(CountAll))*(Entropy3_1))*(((Count3_2)/(CountAll))*(Entropy3_2));

    SET GAIN = Entropy_Total()-(GAIN1 + GAIN2 + GAIN3);


RETURN(GAIN);
END $$
DELIMITER ;



/*Sakit Kepala*/

DELIMITER $$
CREATE FUNCTION Count_Data_Sakit_Kepala(a VARCHAR(256),b VARCHAR(256))
RETURNS FLOAT 
BEGIN
    DECLARE Count_Data_Sakit_Kepala INT;
    SET Count_Data_Sakit_Kepala =
        (SELECT COUNT(Sakit_Kepala) 
            FROM tblData 
            WHERE Sakit_Kepala=a AND Diagnosa=b);
    RETURN (Count_Data_Sakit_Kepala); 
END $$
DELIMITER ;


DELIMITER $$
CREATE FUNCTION Entropy_Sakit_Kepala(a VARCHAR(256),b VARCHAR(256))
RETURNS FLOAT 
BEGIN
    
    DECLARE ENTROPY FLOAT;
    DECLARE d INT;
    DECLARE e INT;
   
    SET d = (SELECT Count_Data_Sakit_Kepala(a,b));
    SET e = (SELECT COUNT(Sakit_Kepala) FROM tblData);
    
    IF d = 0 THEN
        RETURN(0);
    END IF; 
         
    SET ENTROPY=(-d/(e))*log2(d/(e));

    RETURN(ENTROPY);
END $$
DELIMITER ;


DELIMITER $$
CREATE FUNCTION GAIN_Sakit_Kepala()
RETURNS FLOAT 
BEGIN
    DECLARE GAIN FLOAT;
    DECLARE GAIN1 FLOAT;
    DECLARE GAIN2 FLOAT;
    DECLARE GAIN3 FLOAT;

    DECLARE Count1_1 FLOAT;
    DECLARE Count1_2 FLOAT;
    DECLARE Count2_1 FLOAT;
    DECLARE Count2_2 FLOAT;
    DECLARE Count3_1 FLOAT;
    DECLARE Count3_2 FLOAT;

    DECLARE CountAll INT;
    
    DECLARE Entropy1_1 FLOAT;
    DECLARE Entropy1_2 FLOAT;
    DECLARE Entropy2_1 FLOAT;
    DECLARE Entropy2_2 FLOAT;
    DECLARE Entropy3_1 FLOAT;
    DECLARE Entropy3_2 FLOAT;

    SET Entropy1_1 = (SELECT Entropy_Sakit_Kepala('Tidak','Demam'));
    SET Entropy1_2 = (SELECT Entropy_Sakit_Kepala('Tidak','Flu'));
    SET Entropy2_1 = (SELECT Entropy_Sakit_Kepala('Parah','Demam'));
    SET Entropy2_2 = (SELECT Entropy_Sakit_Kepala('Parah','Flu'));
    SET Entropy3_1 = (SELECT Entropy_Sakit_Kepala('Ringan','Demam'));
    SET Entropy3_2 = (SELECT Entropy_Sakit_Kepala('Ringan','Flu'));

    SET CountAll = (SELECT COUNT(*) FROM tblData);
    SET Count1_1 = (SELECT Count_Data_Sakit_Kepala('Tidak','Demam'));
    SET Count1_2 = (SELECT Count_Data_Sakit_Kepala('Tidak','Flu'));
    SET Count2_1 = (SELECT Count_Data_Sakit_Kepala('Parah','Demam'));
    SET Count2_2 = (SELECT Count_Data_Sakit_Kepala('Parah','Flu'));
    SET Count3_1 = (SELECT Count_Data_Sakit_Kepala('Ringan','Demam'));
    SET Count3_2 = (SELECT Count_Data_Sakit_Kepala('Ringan','Flu'));


    SET GAIN1 = (((Count1_1)/(CountAll))*(Entropy1_1))*(((Count1_2)/(CountAll))*(Entropy1_2));
    SET GAIN2 = (((Count2_1)/(CountAll))*(Entropy2_1))*(((Count2_2)/(CountAll))*(Entropy2_2));
    SET GAIN3 = (((Count3_1)/(CountAll))*(Entropy3_1))*(((Count3_2)/(CountAll))*(Entropy3_2));

    SET GAIN =  Entropy_Total()-(GAIN1 + GAIN2 + GAIN3);

RETURN(GAIN);
END $$
DELIMITER ;


/*Nyeri*/

DELIMITER $$
CREATE FUNCTION Count_Data_Nyeri(a VARCHAR(256),b VARCHAR(256))
RETURNS FLOAT 
BEGIN
    DECLARE Count_Data_Nyeri INT;
    SET Count_Data_Nyeri =
        (SELECT COUNT(Nyeri) 
            FROM tblData 
            WHERE Nyeri=a AND Diagnosa=b);
    RETURN (Count_Data_Nyeri); 
END $$
DELIMITER ;


DELIMITER $$
CREATE FUNCTION Entropy_Nyeri(a VARCHAR(256),b VARCHAR(256))
RETURNS FLOAT 
BEGIN
    
    DECLARE ENTROPY FLOAT;
    DECLARE d INT;
    DECLARE e INT;
   
    SET d = (SELECT Count_Data_Nyeri(a,b));
    SET e = (SELECT COUNT(Nyeri) FROM tblData);
    
    IF d = 0 THEN
        RETURN(0);
    END IF; 
         
    SET ENTROPY=(-d/(e))*log2(d/(e));

    RETURN(ENTROPY);
END $$
DELIMITER ;


DELIMITER $$
CREATE FUNCTION GAIN_Nyeri()
RETURNS FLOAT 
BEGIN
    DECLARE GAIN FLOAT;
    DECLARE GAIN1 FLOAT;
    DECLARE GAIN2 FLOAT;
    DECLARE GAIN3 FLOAT;

    DECLARE Count1_1 FLOAT;
    DECLARE Count1_2 FLOAT;
    DECLARE Count2_1 FLOAT;
    DECLARE Count2_2 FLOAT;
    DECLARE Count3_1 FLOAT;
    DECLARE Count3_2 FLOAT;

    DECLARE CountAll INT;
    
    DECLARE Entropy1_1 FLOAT;
    DECLARE Entropy1_2 FLOAT;
    DECLARE Entropy2_1 FLOAT;
    DECLARE Entropy2_2 FLOAT;
    DECLARE Entropy3_1 FLOAT;
    DECLARE Entropy3_2 FLOAT;

    SET Entropy1_1 = (SELECT Entropy_Nyeri('Tidak','Demam'));
    SET Entropy1_2 = (SELECT Entropy_Nyeri('Tidak','Flu'));
    SET Entropy2_1 = (SELECT Entropy_Nyeri('Parah','Demam'));
    SET Entropy2_2 = (SELECT Entropy_Nyeri('Parah','Flu'));
    SET Entropy3_1 = (SELECT Entropy_Nyeri('Ringan','Demam'));
    SET Entropy3_2 = (SELECT Entropy_Nyeri('Ringan','Flu'));

    SET CountAll = (SELECT COUNT(*) FROM tblData);
    SET Count1_1 = (SELECT Count_Data_Nyeri('Tidak','Demam'));
    SET Count1_2 = (SELECT Count_Data_Nyeri('Tidak','Flu'));
    SET Count2_1 = (SELECT Count_Data_Nyeri('Parah','Demam'));
    SET Count2_2 = (SELECT Count_Data_Nyeri('Parah','Flu'));
    SET Count3_1 = (SELECT Count_Data_Nyeri('Ringan','Demam'));
    SET Count3_2 = (SELECT Count_Data_Nyeri('Ringan','Flu'));


    SET GAIN1 = (((Count1_1)/(CountAll))*(Entropy1_1))*(((Count1_2)/(CountAll))*(Entropy1_2));
    SET GAIN2 = (((Count2_1)/(CountAll))*(Entropy2_1))*(((Count2_2)/(CountAll))*(Entropy2_2));
    SET GAIN3 = (((Count3_1)/(CountAll))*(Entropy3_1))*(((Count3_2)/(CountAll))*(Entropy3_2));

    SET GAIN =  Entropy_Total()-(GAIN1 + GAIN2 + GAIN3);


RETURN(GAIN);
END $$
DELIMITER ;


/*Lemas*/

DELIMITER $$
CREATE FUNCTION Count_Data_Lemas(a VARCHAR(256),b VARCHAR(256))
RETURNS FLOAT 
BEGIN
    DECLARE Count_Data_Lemas INT;
    SET Count_Data_Lemas =
        (SELECT COUNT(Lemas) 
            FROM tblData 
            WHERE Lemas=a AND Diagnosa=b);
    RETURN (Count_Data_Lemas); 
END $$
DELIMITER ;


DELIMITER $$
CREATE FUNCTION Entropy_Lemas(a VARCHAR(256),b VARCHAR(256))
RETURNS FLOAT 
BEGIN
    
    DECLARE ENTROPY FLOAT;
    DECLARE d INT;
    DECLARE e INT;
   
    SET d = (SELECT Count_Data_Lemas(a,b));
    SET e = (SELECT COUNT(Lemas) FROM tblData);
    
    IF d = 0 THEN
        RETURN(0);
    END IF; 
         
    SET ENTROPY=(-d/(e))*log2(d/(e));

    RETURN(ENTROPY);
END $$
DELIMITER ;


DELIMITER $$
CREATE FUNCTION GAIN_Lemas()
RETURNS FLOAT 
BEGIN
    DECLARE GAIN FLOAT;
    DECLARE GAIN1 FLOAT;
    DECLARE GAIN2 FLOAT;
    DECLARE GAIN3 FLOAT;

    DECLARE Count1_1 FLOAT;
    DECLARE Count1_2 FLOAT;
    DECLARE Count2_1 FLOAT;
    DECLARE Count2_2 FLOAT;
    DECLARE Count3_1 FLOAT;
    DECLARE Count3_2 FLOAT;

    DECLARE CountAll INT;
    
    DECLARE Entropy1_1 FLOAT;
    DECLARE Entropy1_2 FLOAT;
    DECLARE Entropy2_1 FLOAT;
    DECLARE Entropy2_2 FLOAT;
    DECLARE Entropy3_1 FLOAT;
    DECLARE Entropy3_2 FLOAT;

    SET Entropy1_1 = (SELECT Entropy_Lemas('Tidak','Demam'));
    SET Entropy1_2 = (SELECT Entropy_Lemas('Tidak','Flu'));
    SET Entropy2_1 = (SELECT Entropy_Lemas('Parah','Demam'));
    SET Entropy2_2 = (SELECT Entropy_Lemas('Parah','Flu'));
    SET Entropy3_1 = (SELECT Entropy_Lemas('Ringan','Demam'));
    SET Entropy3_2 = (SELECT Entropy_Lemas('Ringan','Flu'));

    SET CountAll = (SELECT COUNT(*) FROM tblData);
    SET Count1_1 = (SELECT Count_Data_Lemas('Tidak','Demam'));
    SET Count1_2 = (SELECT Count_Data_Lemas('Tidak','Flu'));
    SET Count2_1 = (SELECT Count_Data_Lemas('Parah','Demam'));
    SET Count2_2 = (SELECT Count_Data_Lemas('Parah','Flu'));
    SET Count3_1 = (SELECT Count_Data_Lemas('Ringan','Demam'));
    SET Count3_2 = (SELECT Count_Data_Lemas('Ringan','Flu'));


    SET GAIN1 = (((Count1_1)/(CountAll))*(Entropy1_1))*(((Count1_2)/(CountAll))*(Entropy1_2));
    SET GAIN2 = (((Count2_1)/(CountAll))*(Entropy2_1))*(((Count2_2)/(CountAll))*(Entropy2_2));
    SET GAIN3 = (((Count3_1)/(CountAll))*(Entropy3_1))*(((Count3_2)/(CountAll))*(Entropy3_2));

    SET GAIN =  Entropy_Total()-(GAIN1 + GAIN2 + GAIN3);


RETURN(GAIN);
END $$
DELIMITER ;


/*Kelelahan*/


DELIMITER $$
CREATE FUNCTION Count_Data_Kelelahan(a VARCHAR(256),b VARCHAR(256))
RETURNS FLOAT 
BEGIN
    DECLARE Count_Data_Kelelahan INT;
    SET Count_Data_Kelelahan =
        (SELECT COUNT(Kelelahan) 
            FROM tblData 
            WHERE Kelelahan=a AND Diagnosa=b);
    RETURN (Count_Data_Kelelahan); 
END $$
DELIMITER ;


DELIMITER $$
CREATE FUNCTION Entropy_Kelelahan(a VARCHAR(256),b VARCHAR(256))
RETURNS FLOAT 
BEGIN
    
    DECLARE ENTROPY FLOAT;
    DECLARE d INT;
    DECLARE e INT;
   
    SET d = (SELECT Count_Data_Kelelahan(a,b));
    SET e = (SELECT COUNT(Kelelahan) FROM tblData);
    
    IF d = 0 THEN
        RETURN(0);
    END IF; 
         
    SET ENTROPY=(-d/(e))*log2(d/(e));

    RETURN(ENTROPY);
END $$
DELIMITER ;


DELIMITER $$
CREATE FUNCTION GAIN_Kelelahan()
RETURNS FLOAT 
BEGIN
    DECLARE GAIN FLOAT;
    DECLARE GAIN1 FLOAT;
    DECLARE GAIN2 FLOAT;
    DECLARE GAIN3 FLOAT;

    DECLARE Count1_1 FLOAT;
    DECLARE Count1_2 FLOAT;
    DECLARE Count2_1 FLOAT;
    DECLARE Count2_2 FLOAT;
    DECLARE Count3_1 FLOAT;
    DECLARE Count3_2 FLOAT;

    DECLARE CountAll INT;
    
    DECLARE Entropy1_1 FLOAT;
    DECLARE Entropy1_2 FLOAT;
    DECLARE Entropy2_1 FLOAT;
    DECLARE Entropy2_2 FLOAT;
    DECLARE Entropy3_1 FLOAT;
    DECLARE Entropy3_2 FLOAT;

    SET Entropy1_1 = (SELECT Entropy_Kelelahan('Tidak','Demam'));
    SET Entropy1_2 = (SELECT Entropy_Kelelahan('Tidak','Flu'));
    SET Entropy2_1 = (SELECT Entropy_Kelelahan('Parah','Demam'));
    SET Entropy2_2 = (SELECT Entropy_Kelelahan('Parah','Flu'));
    SET Entropy3_1 = (SELECT Entropy_Kelelahan('Ringan','Demam'));
    SET Entropy3_2 = (SELECT Entropy_Kelelahan('Ringan','Flu'));

    SET CountAll = (SELECT COUNT(*) FROM tblData);
    SET Count1_1 = (SELECT Count_Data_Kelelahan('Tidak','Demam'));
    SET Count1_2 = (SELECT Count_Data_Kelelahan('Tidak','Flu'));
    SET Count2_1 = (SELECT Count_Data_Kelelahan('Parah','Demam'));
    SET Count2_2 = (SELECT Count_Data_Kelelahan('Parah','Flu'));
    SET Count3_1 = (SELECT Count_Data_Kelelahan('Ringan','Demam'));
    SET Count3_2 = (SELECT Count_Data_Kelelahan('Ringan','Flu'));


    SET GAIN1 = (((Count1_1)/(CountAll))*(Entropy1_1))*(((Count1_2)/(CountAll))*(Entropy1_2));
    SET GAIN2 = (((Count2_1)/(CountAll))*(Entropy2_1))*(((Count2_2)/(CountAll))*(Entropy2_2));
    SET GAIN3 = (((Count3_1)/(CountAll))*(Entropy3_1))*(((Count3_2)/(CountAll))*(Entropy3_2));

    SET GAIN =  Entropy_Total()-(GAIN1 + GAIN2 + GAIN3);

RETURN(GAIN);
END $$
DELIMITER ;

/*Hidung_Tersumbat*/

DELIMITER $$
CREATE FUNCTION Count_Data_Hidung_Tersumbat(a VARCHAR(256),b VARCHAR(256))
RETURNS FLOAT 
BEGIN
    DECLARE Count_Data_Hidung_Tersumbat INT;
    SET Count_Data_Hidung_Tersumbat =
        (SELECT COUNT(Hidung_Tersumbat) 
            FROM tblData 
            WHERE Hidung_Tersumbat=a AND Diagnosa=b);
    RETURN (Count_Data_Hidung_Tersumbat); 
END $$
DELIMITER ;


DELIMITER $$
CREATE FUNCTION Entropy_Hidung_Tersumbat(a VARCHAR(256),b VARCHAR(256))
RETURNS FLOAT 
BEGIN
    
    DECLARE ENTROPY FLOAT;
    DECLARE d INT;
    DECLARE e INT;
   
    SET d = (SELECT Count_Data_Hidung_Tersumbat(a,b));
    SET e = (SELECT COUNT(Hidung_Tersumbat) FROM tblData);
    
    IF d = 0 THEN
        RETURN(0);
    END IF; 
         
    SET ENTROPY=(-d/(e))*log2(d/(e));

    RETURN(ENTROPY);
END $$
DELIMITER ;


DELIMITER $$
CREATE FUNCTION GAIN_Hidung_Tersumbat()
RETURNS FLOAT 
BEGIN
    DECLARE GAIN FLOAT;
    DECLARE GAIN1 FLOAT;
    DECLARE GAIN2 FLOAT;
    DECLARE GAIN3 FLOAT;

    DECLARE Count1_1 FLOAT;
    DECLARE Count1_2 FLOAT;
    DECLARE Count2_1 FLOAT;
    DECLARE Count2_2 FLOAT;
    DECLARE Count3_1 FLOAT;
    DECLARE Count3_2 FLOAT;

    DECLARE CountAll INT;
    
    DECLARE Entropy1_1 FLOAT;
    DECLARE Entropy1_2 FLOAT;
    DECLARE Entropy2_1 FLOAT;
    DECLARE Entropy2_2 FLOAT;
    DECLARE Entropy3_1 FLOAT;
    DECLARE Entropy3_2 FLOAT;

    SET Entropy1_1 = (SELECT Entropy_Hidung_Tersumbat('Tidak','Demam'));
    SET Entropy1_2 = (SELECT Entropy_Hidung_Tersumbat('Tidak','Flu'));
    SET Entropy2_1 = (SELECT Entropy_Hidung_Tersumbat('Parah','Demam'));
    SET Entropy2_2 = (SELECT Entropy_Hidung_Tersumbat('Parah','Flu'));
    SET Entropy3_1 = (SELECT Entropy_Hidung_Tersumbat('Ringan','Demam'));
    SET Entropy3_2 = (SELECT Entropy_Hidung_Tersumbat('Ringan','Flu'));

    SET CountAll = (SELECT COUNT(*) FROM tblData);
    SET Count1_1 = (SELECT Count_Data_Hidung_Tersumbat('Tidak','Demam'));
    SET Count1_2 = (SELECT Count_Data_Hidung_Tersumbat('Tidak','Flu'));
    SET Count2_1 = (SELECT Count_Data_Hidung_Tersumbat('Parah','Demam'));
    SET Count2_2 = (SELECT Count_Data_Hidung_Tersumbat('Parah','Flu'));
    SET Count3_1 = (SELECT Count_Data_Hidung_Tersumbat('Ringan','Demam'));
    SET Count3_2 = (SELECT Count_Data_Hidung_Tersumbat('Ringan','Flu'));


    SET GAIN1 = (((Count1_1)/(CountAll))*(Entropy1_1))*(((Count1_2)/(CountAll))*(Entropy1_2));
    SET GAIN2 = (((Count2_1)/(CountAll))*(Entropy2_1))*(((Count2_2)/(CountAll))*(Entropy2_2));
    SET GAIN3 = (((Count3_1)/(CountAll))*(Entropy3_1))*(((Count3_2)/(CountAll))*(Entropy3_2));

    SET GAIN =  Entropy_Total()-(GAIN1 + GAIN2 + GAIN3);


RETURN(GAIN);
END $$
DELIMITER ;

/*Bersin*/

DELIMITER $$
CREATE FUNCTION Count_Data_Bersin(a VARCHAR(256),b VARCHAR(256))
RETURNS FLOAT 
BEGIN
    DECLARE Count_Data_Bersin INT;
    SET Count_Data_Bersin =
        (SELECT COUNT(Bersin) 
            FROM tblData 
            WHERE Bersin=a AND Diagnosa=b);
    RETURN (Count_Data_Bersin); 
END $$
DELIMITER ;


DELIMITER $$
CREATE FUNCTION Entropy_Bersin(a VARCHAR(256),b VARCHAR(256))
RETURNS FLOAT 
BEGIN
    
    DECLARE ENTROPY FLOAT;
    DECLARE d INT;
    DECLARE e INT;
   
    SET d = (SELECT Count_Data_Bersin(a,b));
    SET e = (SELECT COUNT(Bersin) FROM tblData);
    
    IF d = 0 THEN
        RETURN(0);
    END IF; 
         
    SET ENTROPY=(-d/(e))*log2(d/(e));

    RETURN(ENTROPY);
END $$
DELIMITER ;


DELIMITER $$
CREATE FUNCTION GAIN_Bersin()
RETURNS FLOAT 
BEGIN
    DECLARE GAIN FLOAT;
    DECLARE GAIN1 FLOAT;
    DECLARE GAIN2 FLOAT;
    DECLARE GAIN3 FLOAT;

    DECLARE Count1_1 FLOAT;
    DECLARE Count1_2 FLOAT;
    DECLARE Count2_1 FLOAT;
    DECLARE Count2_2 FLOAT;
    DECLARE Count3_1 FLOAT;
    DECLARE Count3_2 FLOAT;

    DECLARE CountAll INT;
    
    DECLARE Entropy1_1 FLOAT;
    DECLARE Entropy1_2 FLOAT;
    DECLARE Entropy2_1 FLOAT;
    DECLARE Entropy2_2 FLOAT;
    DECLARE Entropy3_1 FLOAT;
    DECLARE Entropy3_2 FLOAT;

    SET Entropy1_1 = (SELECT Entropy_Bersin('Tidak','Demam'));
    SET Entropy1_2 = (SELECT Entropy_Bersin('Tidak','Flu'));
    SET Entropy2_1 = (SELECT Entropy_Bersin('Parah','Demam'));
    SET Entropy2_2 = (SELECT Entropy_Bersin('Parah','Flu'));
    SET Entropy3_1 = (SELECT Entropy_Bersin('Ringan','Demam'));
    SET Entropy3_2 = (SELECT Entropy_Bersin('Ringan','Flu'));

    SET CountAll = (SELECT COUNT(*) FROM tblData);
    SET Count1_1 = (SELECT Count_Data_Bersin('Tidak','Demam'));
    SET Count1_2 = (SELECT Count_Data_Bersin('Tidak','Flu'));
    SET Count2_1 = (SELECT Count_Data_Bersin('Parah','Demam'));
    SET Count2_2 = (SELECT Count_Data_Bersin('Parah','Flu'));
    SET Count3_1 = (SELECT Count_Data_Bersin('Ringan','Demam'));
    SET Count3_2 = (SELECT Count_Data_Bersin('Ringan','Flu'));


    SET GAIN1 = (((Count1_1)/(CountAll))*(Entropy1_1))*(((Count1_2)/(CountAll))*(Entropy1_2));
    SET GAIN2 = (((Count2_1)/(CountAll))*(Entropy2_1))*(((Count2_2)/(CountAll))*(Entropy2_2));
    SET GAIN3 = (((Count3_1)/(CountAll))*(Entropy3_1))*(((Count3_2)/(CountAll))*(Entropy3_2));

    SET GAIN =  Entropy_Total()-(GAIN1 + GAIN2 + GAIN3);


RETURN(GAIN);
END $$
DELIMITER ;


/*Sakit_Tenggorokan*/

DELIMITER $$
CREATE FUNCTION Count_Data_Sakit_Tenggorokan(a VARCHAR(256),b VARCHAR(256))
RETURNS FLOAT 
BEGIN
    DECLARE Count_Data_Sakit_Tenggorokan INT;
    SET Count_Data_Sakit_Tenggorokan =
        (SELECT COUNT(Sakit_Tenggorokan) 
            FROM tblData 
            WHERE Sakit_Tenggorokan=a AND Diagnosa=b);
    RETURN (Count_Data_Sakit_Tenggorokan); 
END $$
DELIMITER ;


DELIMITER $$
CREATE FUNCTION Entropy_Sakit_Tenggorokan(a VARCHAR(256),b VARCHAR(256))
RETURNS FLOAT 
BEGIN
    
    DECLARE ENTROPY FLOAT;
    DECLARE d INT;
    DECLARE e INT;
   
    SET d = (SELECT Count_Data_Sakit_Tenggorokan(a,b));
    SET e = (SELECT COUNT(Sakit_Tenggorokan) FROM tblData);
    
    IF d = 0 THEN
        RETURN(0);
    END IF; 
         
    SET ENTROPY=(-d/(e))*log2(d/(e));

    RETURN(ENTROPY);
END $$
DELIMITER ;


DELIMITER $$
CREATE FUNCTION GAIN_Sakit_Tenggorokan()
RETURNS FLOAT 
BEGIN
    DECLARE GAIN FLOAT;
    DECLARE GAIN1 FLOAT;
    DECLARE GAIN2 FLOAT;
    DECLARE GAIN3 FLOAT;

    DECLARE Count1_1 FLOAT;
    DECLARE Count1_2 FLOAT;
    DECLARE Count2_1 FLOAT;
    DECLARE Count2_2 FLOAT;
    DECLARE Count3_1 FLOAT;
    DECLARE Count3_2 FLOAT;

    DECLARE CountAll INT;
    
    DECLARE Entropy1_1 FLOAT;
    DECLARE Entropy1_2 FLOAT;
    DECLARE Entropy2_1 FLOAT;
    DECLARE Entropy2_2 FLOAT;
    DECLARE Entropy3_1 FLOAT;
    DECLARE Entropy3_2 FLOAT;

    SET Entropy1_1 = (SELECT Entropy_Sakit_Tenggorokan('Tidak','Demam'));
    SET Entropy1_2 = (SELECT Entropy_Sakit_Tenggorokan('Tidak','Flu'));
    SET Entropy2_1 = (SELECT Entropy_Sakit_Tenggorokan('Parah','Demam'));
    SET Entropy2_2 = (SELECT Entropy_Sakit_Tenggorokan('Parah','Flu'));
    SET Entropy3_1 = (SELECT Entropy_Sakit_Tenggorokan('Ringan','Demam'));
    SET Entropy3_2 = (SELECT Entropy_Sakit_Tenggorokan('Ringan','Flu'));

    SET CountAll = (SELECT COUNT(*) FROM tblData);
    SET Count1_1 = (SELECT Count_Data_Sakit_Tenggorokan('Tidak','Demam'));
    SET Count1_2 = (SELECT Count_Data_Sakit_Tenggorokan('Tidak','Flu'));
    SET Count2_1 = (SELECT Count_Data_Sakit_Tenggorokan('Parah','Demam'));
    SET Count2_2 = (SELECT Count_Data_Sakit_Tenggorokan('Parah','Flu'));
    SET Count3_1 = (SELECT Count_Data_Sakit_Tenggorokan('Ringan','Demam'));
    SET Count3_2 = (SELECT Count_Data_Sakit_Tenggorokan('Ringan','Flu'));


    SET GAIN1 = (((Count1_1)/(CountAll))*(Entropy1_1))*(((Count1_2)/(CountAll))*(Entropy1_2));
    SET GAIN2 = (((Count2_1)/(CountAll))*(Entropy2_1))*(((Count2_2)/(CountAll))*(Entropy2_2));
    SET GAIN3 = (((Count3_1)/(CountAll))*(Entropy3_1))*(((Count3_2)/(CountAll))*(Entropy3_2));

    SET GAIN =  Entropy_Total()-(GAIN1 + GAIN2 + GAIN3);


RETURN(GAIN);
END $$
DELIMITER ;




/*Sulit_Bernafas*/

DELIMITER $$
CREATE FUNCTION Count_Data_Sulit_Bernafas(a VARCHAR(256),b VARCHAR(256))
RETURNS FLOAT 
BEGIN
    DECLARE Count_Data_Sulit_Bernafas INT;
    SET Count_Data_Sulit_Bernafas =
        (SELECT COUNT(Sulit_Bernafas) 
            FROM tblData 
            WHERE Sulit_Bernafas=a AND Diagnosa=b);
    RETURN (Count_Data_Sulit_Bernafas); 
END $$
DELIMITER ;


DELIMITER $$
CREATE FUNCTION Entropy_Sulit_Bernafas(a VARCHAR(256),b VARCHAR(256))
RETURNS FLOAT 
BEGIN
    
    DECLARE ENTROPY FLOAT;
    DECLARE d INT;
    DECLARE e INT;
   
    SET d = (SELECT Count_Data_Sulit_Bernafas(a,b));
    SET e = (SELECT COUNT(Sulit_Bernafas) FROM tblData);
    
    IF d = 0 THEN
        RETURN(0);
    END IF; 
         
    SET ENTROPY=(-d/(e))*log2(d/(e));

    RETURN(ENTROPY);
END $$
DELIMITER ;


DELIMITER $$
CREATE FUNCTION GAIN_Sulit_Bernafas()
RETURNS FLOAT 
BEGIN
    DECLARE GAIN FLOAT;
    DECLARE GAIN1 FLOAT;
    DECLARE GAIN2 FLOAT;
    DECLARE GAIN3 FLOAT;

    DECLARE Count1_1 FLOAT;
    DECLARE Count1_2 FLOAT;
    DECLARE Count2_1 FLOAT;
    DECLARE Count2_2 FLOAT;
    DECLARE Count3_1 FLOAT;
    DECLARE Count3_2 FLOAT;

    DECLARE CountAll INT;
    
    DECLARE Entropy1_1 FLOAT;
    DECLARE Entropy1_2 FLOAT;
    DECLARE Entropy2_1 FLOAT;
    DECLARE Entropy2_2 FLOAT;
    DECLARE Entropy3_1 FLOAT;
    DECLARE Entropy3_2 FLOAT;

    SET Entropy1_1 = (SELECT Entropy_Sulit_Bernafas('Tidak','Demam'));
    SET Entropy1_2 = (SELECT Entropy_Sulit_Bernafas('Tidak','Flu'));
    SET Entropy2_1 = (SELECT Entropy_Sulit_Bernafas('Parah','Demam'));
    SET Entropy2_2 = (SELECT Entropy_Sulit_Bernafas('Parah','Flu'));
    SET Entropy3_1 = (SELECT Entropy_Sulit_Bernafas('Ringan','Demam'));
    SET Entropy3_2 = (SELECT Entropy_Sulit_Bernafas('Ringan','Flu'));

    SET CountAll = (SELECT COUNT(*) FROM tblData);
    SET Count1_1 = (SELECT Count_Data_Sulit_Bernafas('Tidak','Demam'));
    SET Count1_2 = (SELECT Count_Data_Sulit_Bernafas('Tidak','Flu'));
    SET Count2_1 = (SELECT Count_Data_Sulit_Bernafas('Parah','Demam'));
    SET Count2_2 = (SELECT Count_Data_Sulit_Bernafas('Parah','Flu'));
    SET Count3_1 = (SELECT Count_Data_Sulit_Bernafas('Ringan','Demam'));
    SET Count3_2 = (SELECT Count_Data_Sulit_Bernafas('Ringan','Flu'));


    SET GAIN1 = (((Count1_1)/(CountAll))*(Entropy1_1))*(((Count1_2)/(CountAll))*(Entropy1_2));
    SET GAIN2 = (((Count2_1)/(CountAll))*(Entropy2_1))*(((Count2_2)/(CountAll))*(Entropy2_2));
    SET GAIN3 = (((Count3_1)/(CountAll))*(Entropy3_1))*(((Count3_2)/(CountAll))*(Entropy3_2));

    SET GAIN =  Entropy_Total()-(GAIN1 + GAIN2 + GAIN3);


RETURN(GAIN);
END $$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE MAX_GAIN()
BEGIN
    CREATE TABLE tbl_GAIN_1(   
        no_urut INT,
        Gejala VARCHAR(256),
        Gain FLOAT
    );

    INSERT INTO tbl_GAIN_1
        VALUES
        (1,'Demam',GAIN_Demam()),
        (2,'Sakit_Kepala',GAIN_Sakit_Kepala()),
        (3,'Nyeri',GAIN_Nyeri()),
        (4,'Lemas',GAIN_Lemas()),
        (5,'Kelelahan',GAIN_Kelelahan()),
        (6,'Hidung_Tersumbat',GAIN_Hidung_Tersumbat()),
        (7,'Bersin',GAIN_Bersin()),
        (8,'Sakit_Tenggorokan',GAIN_Sakit_Tenggorokan()),
        (9,'Sulit_Bernafas',GAIN_Sulit_Bernafas());
 
    SELECT * FROM tbl_GAIN_1
        ORDER BY GAIN DESC;
    
    SELECT MAX(GAIN) as 'Max_Gain' FROM tbl_GAIN_1; 

END $$
DELIMITER ;    

CALL MAX_GAIN();

SELECT * FROM tblData;

SELECT Demam,Diagnosa
FROM tblData
WHERE Demam='Tidak';

SELECT Demam,Diagnosa
FROM tblData
WHERE Demam='Ringan';

SELECT Demam,Diagnosa
FROM tblData
WHERE Demam='Parah';


SELECT Kelelahan,Diagnosa
FROM tblData
WHERE Kelelahan='Tidak';

SELECT Kelelahan,Diagnosa
FROM tblData
WHERE Kelelahan='Ringan';

SELECT Kelelahan,Diagnosa
FROM tblData
WHERE Kelelahan='Parah';
/*SELECT (column1, column2)
FROM table_name
WHERE condition;*/ 













