DELIMITER $$
CREATE PROCEDURE spTes()
BEGIN
  DECLARE vjumlah, vno1, vno2, v2no1, v2no2, sama, i int default 0;
  DECLARE vtes,v2tes varchar(2);
  DECLARE cTes cursor for SELECT * FROM tblTes;
  DECLARE cTes2 cursor for SELECT * FROM tblTes;

  SELECT count(*) into vjumlah FROM tblTes;

  open cTes;
    while i<>vjumlah DO
    fetch cTes into vtes, vno1, vno2;
      IF(vno1=vno2) THEN
        SET sama = sama +1;
      END IF;
    SET i=i+1;
    END WHILE;

  close cTes;

  SELECT sama as sama;
  SELECT * FROM tblTes;

  SET i=0;
  IF(vjumlah!=sama) THEN
  open cTes;
    while i<>vjumlah DO
    fetch cTes into vtes, vno1, vno2;
        UPDATE tblTes SET no1=vno2, no2=0 where tes=vtes;
    SET i=i+1;
    END WHILE;
  close cTes;
  END IF;
  SELECT * FROM tblTes;
END $$
DELIMITER ;

call spTes();
