DROP DATABASE IF EXISTS dbaps;
CREATE DATABASE dbaps;
USE dbaps;

CREATE TABLE tbldata(
    id INT PRIMARY KEY AUTO_INCREMENT
    , Gender VARCHAR(10)
    , customer_type varchar(50)
    , age INT
    , type_of_travel VARCHAR(50)
    , customer_class VARCHAR(50)
    , flight_distance INT
    , inflight_wifi_service INT
    , departure_arrival_time_convenient INT
    , ease_of_online_booking INT
    , gate_location INT
    , food_and_drink INT
    , online_boarding INT
    , seat_comfort INT
    , inflight_entertainment INT
    , onboard_service INT
    , leg_room_service INT
    , baggage_handling INT
    , checkin_service INT
    , inflight_service INT
    , cleanliness INT
    , departure_delay_in_minutes INT
    , arrival_delay_in_minutes INT
    , satisfaction VARCHAR(255)
) engine=InnoDB;

CREATE TABLE tbldataprocess(
    id INT PRIMARY KEY
    , Gender VARCHAR(10)
    , customer_type varchar(50)
    , age INT
    , type_of_travel VARCHAR(50)
    , customer_class VARCHAR(50)
    , flight_distance INT
    , inflight_wifi_service INT
    , departure_arrival_time_convenient INT
    , ease_of_online_booking INT
    , gate_location INT
    , food_and_drink INT
    , online_boarding INT
    , seat_comfort INT
    , inflight_entertainment INT
    , onboard_service INT
    , leg_room_service INT
    , baggage_handling INT
    , checkin_service INT
    , inflight_service INT
    , cleanliness INT
    , departure_delay_in_minutes INT
    , arrival_delay_in_minutes INT
    , satisfaction VARCHAR(255)
) engine=InnoDB;


LOAD DATA LOCAL INFILE 'airline_passenger_satisfaction - Copy.csv'
-- LOAD DATA LOCAL INFILE 'dbaps.csv'
    INTO TABLE tbldata
    FIELDS TERMINATED BY ','
    ENCLOSED BY ''
    LINES TERMINATED BY '\n'
    IGNORE 1 LINES
    ;

INSERT INTO tbldataprocess
SELECT * FROM tbldata;

CREATE TABLE tblchange(
    id INT PRIMARY KEY AUTO_INCREMENT
    , column_code INT
    , column_name VARCHAR(255)
    , information VARCHAR(255)
    , content int
);

DELIMITER ##
    CREATE PROCEDURE preprocessing()
    BEGIN
    DECLARE i, iwhile, spinformation_int INT DEFAULT 0;
    DECLARE nama, spinformation, spinformation2 VARCHAR(255);
    
    -- GENDER
    SELECT count(DISTINCT gender) into i from tbldataprocess;        
    SET iwhile = 0;
    WHILE iwhile<>i DO
        SELECT DISTINCT gender INTO spinformation FROM tbldataprocess limit iwhile, 1;
        INSERT INTO tblchange(column_code, column_name, information, content) VALUES (1, 'gender', spinformation, iwhile);
        UPDATE tbldataprocess set gender=iwhile where gender=spinformation;
    set iwhile= iwhile +1;
    END WHILE ;

    -- Customer Type
    SELECT count(DISTINCT customer_type) into i from tbldataprocess;        
    SET iwhile = 0;
    WHILE iwhile <> i DO
        SELECT DISTINCT customer_type INTO spinformation FROM tbldataprocess limit iwhile, 1;
        INSERT INTO tblchange(column_code, column_name, information, content) VALUES (2, 'customer_type', spinformation, iwhile);
        UPDATE tbldataprocess set customer_type=iwhile where customer_type=spinformation;
    set iwhile= iwhile +1;
    END WHILE ;

    -- AGE
    INSERT INTO tblchange (column_code, column_name, information, content) VALUES
        (3, 'age', 'age <= 27', 0),
        (3, 'age', '27 > age <= 51', 1),
        (3, 'age', 'age > 51', 2);
    UPDATE tbldataprocess set age=0 where age <= 27;
    UPDATE tbldataprocess set age=1 where age > 27 and age <= 51;
    UPDATE tbldataprocess set age=2 where age > 51;

    -- Type Of Travel
    SELECT count(DISTINCT type_of_travel) into i from tbldataprocess;        
    SET iwhile = 0;
    WHILE iwhile <> i DO
        SELECT DISTINCT type_of_travel INTO spinformation FROM tbldataprocess limit iwhile, 1;
        INSERT INTO tblchange(column_code, column_name, information, content) VALUES (4, 'type_of_travel', spinformation, iwhile);
        UPDATE tbldataprocess set type_of_travel=iwhile where type_of_travel=spinformation;
    set iwhile= iwhile +1;
    END WHILE ;

    -- Customer Class
    SELECT count(DISTINCT customer_class) into i from tbldataprocess;        
    SET iwhile = 0;
    WHILE iwhile <> i DO
        SELECT DISTINCT customer_class into spinformation FROM tbldataprocess limit iwhile, 1;        
        INSERT INTO tblchange(column_code, column_name, information, content) VALUES (5, 'customer_class', spinformation, iwhile);
        UPDATE tbldataprocess set customer_class=iwhile where customer_class=spinformation;
    set iwhile= iwhile +1;
    END WHILE ;

    -- FLIGHT DISTANCE
    INSERT INTO tblchange (column_code, column_name, information, content) VALUES
        (6, 'flight_distance', 'fd <= 414', 0),
        (6, 'flight_distance', '414 > fd <= 1744', 1),
        (6, 'flight_distance', 'fd > 1744', 2);
    UPDATE tbldataprocess set flight_distance=0 where flight_distance <= 414;
    UPDATE tbldataprocess set flight_distance=1 where flight_distance > 414 && flight_distance <= 1744;
    UPDATE tbldataprocess set flight_distance=2 where flight_distance > 1744;

    -- Inflight Wifi Service
    SELECT count(DISTINCT inflight_wifi_service) into i from tbldataprocess;
    SET iwhile = 0;
    WHILE iwhile <> i DO
        SELECT DISTINCT inflight_wifi_service into spinformation_int FROM tbldataprocess order by inflight_wifi_service ASC limit iwhile, 1;
        INSERT INTO tblchange(column_code, column_name, information, content) VALUES (7, 'inflight_wifi_service', spinformation_int, spinformation_int);        
    set iwhile= iwhile +1;
    END WHILE;

    -- Departure Arrival Time Conventient
    SELECT count(DISTINCT departure_arrival_time_convenient) into i from tbldataprocess;
    SET iwhile = 0;
    WHILE iwhile <> i DO
        SELECT DISTINCT departure_arrival_time_convenient into spinformation_int FROM tbldataprocess order by departure_arrival_time_convenient ASC limit iwhile, 1;
        INSERT INTO tblchange(column_code, column_name, information, content) VALUES (8, 'departure_arrival_time_convenient', spinformation_int, spinformation_int);        
    set iwhile= iwhile +1;
    END WHILE;

    -- Ease of Online Booking
    SELECT count(DISTINCT ease_of_online_booking) into i from tbldataprocess;
    SET iwhile = 0;
    WHILE iwhile <> i DO
        SELECT DISTINCT ease_of_online_booking into spinformation_int FROM tbldataprocess order by ease_of_online_booking ASC limit iwhile, 1;
        INSERT INTO tblchange(column_code, column_name, information, content) VALUES (9, 'ease_of_online_booking', spinformation_int, spinformation_int);        
    set iwhile= iwhile +1;
    END WHILE;

    -- Gate Location
    SELECT count(DISTINCT gate_location) into i from tbldataprocess;
    SET iwhile = 0;
    WHILE iwhile <> i DO
        SELECT DISTINCT gate_location into spinformation_int FROM tbldataprocess order by gate_location ASC limit iwhile, 1;
        INSERT INTO tblchange(column_code, column_name, information, content) VALUES (10, 'gate_location', spinformation_int, spinformation_int);        
    set iwhile= iwhile +1;
    END WHILE;

    -- Food and Drink
    SELECT count(DISTINCT food_and_drink) into i from tbldataprocess;
    SET iwhile = 0;
    WHILE iwhile <> i DO
        SELECT DISTINCT food_and_drink into spinformation_int FROM tbldataprocess order by food_and_drink ASC limit iwhile, 1;
        INSERT INTO tblchange(column_code, column_name, information, content) VALUES (11, 'food_and_drink', spinformation_int, spinformation_int);        
    set iwhile= iwhile +1;
    END WHILE;

    -- Online Boarding
    SELECT count(DISTINCT online_boarding) into i from tbldataprocess;
    SET iwhile = 0;
    WHILE iwhile <> i DO
        SELECT DISTINCT online_boarding into spinformation_int FROM tbldataprocess order by online_boarding ASC limit iwhile, 1;
        INSERT INTO tblchange(column_code, column_name, information, content) VALUES (12, 'online_boarding', spinformation_int, spinformation_int);        
    set iwhile= iwhile +1;
    END WHILE;

    -- Seat Comfort
    SELECT count(DISTINCT seat_comfort) into i from tbldataprocess;
    SET iwhile = 0;
    WHILE iwhile <> i DO
        SELECT DISTINCT seat_comfort into spinformation_int FROM tbldataprocess order by seat_comfort ASC limit iwhile, 1;
        INSERT INTO tblchange(column_code, column_name, information, content) VALUES (13, 'seat_comfort', spinformation_int, spinformation_int);        
    set iwhile= iwhile +1;
    END WHILE;

    -- Inflight Enterteinment
    SELECT count(DISTINCT inflight_entertainment) into i from tbldataprocess;
    SET iwhile = 0;
    WHILE iwhile <> i DO
        SELECT DISTINCT inflight_entertainment into spinformation_int FROM tbldataprocess order by inflight_entertainment ASC limit iwhile, 1;
        INSERT INTO tblchange(column_code, column_name, information, content) VALUES (14, 'inflight_entertainment', spinformation_int, spinformation_int);        
    set iwhile= iwhile +1;
    END WHILE;

    -- Onboard Service
    SELECT count(DISTINCT onboard_service) into i from tbldataprocess;
    SET iwhile = 0;
    WHILE iwhile <> i DO
        SELECT DISTINCT onboard_service into spinformation_int FROM tbldataprocess order by onboard_service ASC limit iwhile, 1;
        INSERT INTO tblchange(column_code, column_name, information, content) VALUES (15, 'onboard_service', spinformation_int, spinformation_int);        
    set iwhile= iwhile +1;
    END WHILE;

    -- Leg Room Service
    SELECT count(DISTINCT leg_room_service) into i from tbldataprocess;
    SET iwhile = 0;
    WHILE iwhile <> i DO
        SELECT DISTINCT leg_room_service into spinformation_int FROM tbldataprocess order by leg_room_service ASC limit iwhile, 1;
        INSERT INTO tblchange(column_code, column_name, information, content) VALUES (16, 'leg_room_service', spinformation_int, spinformation_int);        
    set iwhile= iwhile +1;
    END WHILE;

    -- Baggage Handling
    SELECT count(DISTINCT baggage_handling) into i from tbldataprocess;
    SET iwhile = 0;
    WHILE iwhile <> i DO
        SELECT DISTINCT baggage_handling into spinformation_int FROM tbldataprocess order by baggage_handling ASC limit iwhile, 1;
        INSERT INTO tblchange(column_code, column_name, information, content) VALUES (17,'baggage_handling', spinformation_int, spinformation_int);        
    set iwhile= iwhile +1;
    END WHILE;

    -- Checkin Service
    SELECT count(DISTINCT checkin_service) into i from tbldataprocess;
    SET iwhile = 0;
    WHILE iwhile <> i DO
        SELECT DISTINCT checkin_service into spinformation_int FROM tbldataprocess order by checkin_service ASC limit iwhile, 1;
        INSERT INTO tblchange(column_code, column_name, information, content) VALUES (18, 'checkin_service', spinformation_int, spinformation_int);        
    set iwhile= iwhile +1;
    END WHILE;

    -- Inflight Service
    SELECT count(DISTINCT inflight_service) into i from tbldataprocess;
    SET iwhile = 0;
    WHILE iwhile <> i DO
        SELECT DISTINCT inflight_service into spinformation_int FROM tbldataprocess order by inflight_service ASC limit iwhile, 1;
        INSERT INTO tblchange(column_code, column_name, information, content) VALUES (19, 'inflight_service', spinformation_int, spinformation_int);        
    set iwhile= iwhile +1;
    END WHILE;

    -- Cleanliness
    SELECT count(DISTINCT cleanliness) into i from tbldataprocess;
    SET iwhile = 0;
    WHILE iwhile <> i DO
        SELECT DISTINCT cleanliness into spinformation_int FROM tbldataprocess order by cleanliness ASC limit iwhile, 1;
        INSERT INTO tblchange(column_code, column_name, information, content) VALUES (20, 'cleanliness', spinformation_int, spinformation_int);        
    set iwhile= iwhile +1;
    END WHILE;

    -- Departure Delay In Minutes
    INSERT INTO tblchange (column_code, column_name, information, content) VALUES
        (21, 'departure_delay_in_minutes', 'ddim <= 12', 0),
        (21, 'departure_delay_in_minutes', 'ddim > 12', 1);
    UPDATE tbldataprocess set departure_delay_in_minutes=0 where departure_delay_in_minutes <= 12;
    UPDATE tbldataprocess set departure_delay_in_minutes=1 where departure_delay_in_minutes > 12;
    
    -- Arrival Delay In Minutes
    INSERT INTO tblchange (column_code, column_name, information, content) VALUES
        (22, 'arrival_delay_in_minutes', 'adim <= 13', 0),
        (22, 'arrival_delay_in_minutes', 'adim > 13', 1);
    UPDATE tbldataprocess set arrival_delay_in_minutes=0 where arrival_delay_in_minutes <= 13;
    UPDATE tbldataprocess set arrival_delay_in_minutes=1 where arrival_delay_in_minutes > 13;

    -- Satisfaction
    SELECT count(DISTINCT satisfaction) into i from tbldataprocess;        
    SET iwhile = 0;
    WHILE iwhile <> i DO
        SELECT DISTINCT satisfaction into spinformation FROM tbldataprocess limit iwhile, 1;
        INSERT INTO tblchange(column_code, column_name, information, content) VALUES (23, 'satisfaction', spinformation, iwhile);
        UPDATE tbldataprocess set satisfaction=iwhile where satisfaction=spinformation;
    set iwhile= iwhile +1;
    END WHILE ;

    END ##
DELIMITER ;

DELIMITER ##
CREATE PROCEDURE selectdata(input int)
BEGIN
IF (input = 0) THEN
    SELECT id as "id" , gender as "gender" , customer_type as "ct" , age as "age" , type_of_travel as "tot" , customer_class as "cc" , flight_distance as "fd" , inflight_wifi_service as "iws" , departure_arrival_time_convenient as "datc" , ease_of_online_booking as "eoob" , gate_location as "gl" , food_and_drink as "fad" , online_boarding as "ob" , seat_comfort as "sc" , inflight_entertainment as "ie" , onboard_service as "os" , leg_room_service as "lrs" , baggage_handling as "bh" , checkin_service as "cs" , inflight_service as "is" , cleanliness as "c" , departure_delay_in_minutes as "ddim" , arrival_delay_in_minutes as "adim" , satisfaction as "satisfaction" FROM tbldata;
    ELSE
    SELECT id as "id" , gender as "gender" , customer_type as "ct" , age as "age" , type_of_travel as "tot" , customer_class as "cc" , flight_distance as "fd" , inflight_wifi_service as "iws" , departure_arrival_time_convenient as "datc" , ease_of_online_booking as "eoob" , gate_location as "gl" , food_and_drink as "fad" , online_boarding as "ob" , seat_comfort as "sc" , inflight_entertainment as "ie" , onboard_service as "os" , leg_room_service as "lrs" , baggage_handling as "bh" , checkin_service as "cs" , inflight_service as "is" , cleanliness as "c" , departure_delay_in_minutes as "ddim" , arrival_delay_in_minutes as "adim" , satisfaction as "satisfaction" FROM tbldata where id = input;
    END IF;
END ##
DELIMITER ;

DELIMITER ##
CREATE PROCEDURE selectall(input int)
BEGIN
IF (input = 0) THEN
    SELECT id as "id" , gender as "gender" , customer_type as "ct" , age as "age" , type_of_travel as "tot" , customer_class as "cc" , flight_distance as "fd" , inflight_wifi_service as "iws" , departure_arrival_time_convenient as "datc" , ease_of_online_booking as "eoob" , gate_location as "gl" , food_and_drink as "fad" , online_boarding as "ob" , seat_comfort as "sc" , inflight_entertainment as "ie" , onboard_service as "os" , leg_room_service as "lrs" , baggage_handling as "bh" , checkin_service as "cs" , inflight_service as "is" , cleanliness as "c" , departure_delay_in_minutes as "ddim" , arrival_delay_in_minutes as "adim" , satisfaction as "satisfaction" FROM tbldataprocess;
ELSE
    SELECT id as "id" , gender as "gender" , customer_type as "ct" , age as "age" , type_of_travel as "tot" , customer_class as "cc" , flight_distance as "fd" , inflight_wifi_service as "iws" , departure_arrival_time_convenient as "datc" , ease_of_online_booking as "eoob" , gate_location as "gl" , food_and_drink as "fad" , online_boarding as "ob" , seat_comfort as "sc" , inflight_entertainment as "ie" , onboard_service as "os" , leg_room_service as "lrs" , baggage_handling as "bh" , checkin_service as "cs" , inflight_service as "is" , cleanliness as "c" , departure_delay_in_minutes as "ddim" , arrival_delay_in_minutes as "adim" , satisfaction as "satisfaction" FROM tbldataprocess where id=input;
END IF;
    SELECT * from tblchange;
END ##
DELIMITER ;


DELIMITER ##
CREATE PROCEDURE tes()
BEGIN
    DECLARE i, iwhile, spinformation_int INT DEFAULT 0;
    DECLARE nama, spinformation, spinformation2 VARCHAR(255);
    INSERT INTO tblchange(column_code, column_name, information, content) VALUES ('tes', spinformation_int, spinformation_int);
END ##
DELIMITER ;

DELIMITER ##
CREATE PROCEDURE bayesian()
BEGIN
    
END ##
DELIMITER ;