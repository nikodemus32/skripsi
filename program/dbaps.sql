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
    , satisfaction VARCHAR(50)
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
    , satisfaction VARCHAR(50)
) engine=InnoDB;


-- LOAD DATA LOCAL INFILE 'airline_passenger_satisfaction - Copy.csv'
LOAD DATA LOCAL INFILE 'dbaps.csv'
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
        SELECT DISTINCT gender INTO spinformation FROM tbldataprocess order by gender ASC limit iwhile, 1;
        INSERT INTO tblchange(column_code, column_name, information, content) VALUES (1, 'gender', spinformation, iwhile);
        UPDATE tbldataprocess set gender=iwhile where gender=spinformation;
    set iwhile= iwhile +1;
    END WHILE ;

    -- Customer Type
    SELECT count(DISTINCT customer_type) into i from tbldataprocess;        
    SET iwhile = 0;
    WHILE iwhile <> i DO
        SELECT DISTINCT customer_type INTO spinformation FROM tbldataprocess order by customer_type ASC limit iwhile, 1;
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
        SELECT DISTINCT type_of_travel INTO spinformation FROM tbldataprocess order by type_of_travel ASC limit iwhile, 1;
        INSERT INTO tblchange(column_code, column_name, information, content) VALUES (4, 'type_of_travel', spinformation, iwhile);
        UPDATE tbldataprocess set type_of_travel=iwhile where type_of_travel=spinformation;
    set iwhile= iwhile +1;
    END WHILE ;

    -- Customer Class
    SELECT count(DISTINCT customer_class) into i from tbldataprocess;
    SET iwhile = 0;
    WHILE iwhile <> i DO
        SELECT DISTINCT customer_class into spinformation FROM tbldataprocess order by customer_class ASC limit iwhile, 1;        
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

    -- Departure Arrival Time Convenient
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
        SELECT DISTINCT satisfaction into spinformation FROM tbldataprocess order by satisfaction asc limit iwhile, 1;
        INSERT INTO tblchange(column_code, column_name, information, content) VALUES (23, 'satisfaction', spinformation, iwhile);
        UPDATE tbldataprocess set satisfaction=iwhile where satisfaction=spinformation;
    set iwhile= iwhile +1;
    END WHILE ;

    END ##
DELIMITER ;

-- DELIMITER ##
-- CREATE PROCEDURE tes()
-- BEGIN
--     DECLARE i, iwhile, spinformation_int INT DEFAULT 0;
--     DECLARE nama, spinformation, spinformation2 VARCHAR(255);
--     INSERT INTO tblchange(column_code, column_name, information, content) VALUES ('tes', spinformation_int, spinformation_int);
-- END ##
-- DELIMITER ;

DELIMITER ##
CREATE PROCEDURE selectdata(table_name VARCHAR(50), conditions VARCHAR(500))
BEGIN
    DECLARE query VARCHAR(1000);
    -- if(substring(table_name, 1,7) = "tbldata") THEN
        -- SELECT DISTINCT column_name FROM tblchange;
        SET query = CONCAT('SELECT id as "id" , gender as "gender" , customer_type as "ct" , age as "age" , type_of_travel as "tot" , customer_class as "cc" , flight_distance as "fd" , inflight_wifi_service as "iws" , departure_arrival_time_convenient as "datc" , ease_of_online_booking as "eoob" , gate_location as "gl" , food_and_drink as "fad" , online_boarding as "ob" , seat_comfort as "sc" , inflight_entertainment as "ie" , onboard_service as "os" , leg_room_service as "lrs" , baggage_handling as "bh" , checkin_service as "cs" , inflight_service as "is" , cleanliness as "c" , departure_delay_in_minutes as "ddim" , arrival_delay_in_minutes as "adim" , satisfaction as "satisfaction" 
        -- FROM tbldata, table_name
        ');

        IF table_name = 'testing' THEN
            SET query = CONCAT(query, ', prediksi');
        END IF;

        SET query = CONCAT(query, ' FROM tbldata', table_name);
        
        IF conditions <> '' THEN
            SET query = CONCAT(query, ' WHERE ', conditions);
        END IF;

        PREPARE query_execute FROM query;
        EXECUTE query_execute;    
    -- END IF;

END ##
DELIMITER ;

CREATE TABLE tbldatatraining(
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
    , satisfaction VARCHAR(50)
) engine=InnoDB;

CREATE TABLE tbldatatesting(
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
    , satisfaction VARCHAR(50)
    , prediksi VARCHAR(255)
) engine=InnoDB;


CREATE TABLE tblaccuracy (
    id INT PRIMARY KEY AUTO_INCREMENT
    , algoritma VARCHAR(15)
    , testing INT
    , total_data INT
    , tp INT
    , tn INT
    , fp INT
    , fn INT
    , tnull INT
    , fnull INT
    , accuracy FLOAT(4,2)
);

INSERT INTO tblaccuracy(algoritma, testing, tp,tn,fp,fn,tnull,fnull) VALUES
('Bayesian', 1,0,0,0,0,0,0),
('Bayesian', 2,0,0,0,0,0,0),
('Bayesian', 3,0,0,0,0,0,0),
('Bayesian', 4,0,0,0,0,0,0),
('Bayesian', 5,0,0,0,0,0,0),
('LVQ', 1,0,0,0,0,0,0),
('LVQ', 2,0,0,0,0,0,0),
('LVQ', 3,0,0,0,0,0,0),
('LVQ', 4,0,0,0,0,0,0),
('LVQ', 5,0,0,0,0,0,0);

DELIMITER ##
-- CREATE PROCEDURE bayesian(number_of_testing INT)
CREATE PROCEDURE bayesian()
BEGIN
    -- prob = probability
    DECLARE 
        prob_satisfied, prob_gender_s, prob_customer_type_s, prob_age_s, prob_type_of_travel_s, prob_customer_class_s
        , prob_flight_distance_s, prob_inflight_wifi_service_s, prob_departure_arrival_time_convenient_s, prob_ease_of_online_booking_s
        , prob_gate_location_s, prob_food_and_drink_s, prob_online_boarding_s, prob_seat_comfort_s, prob_inflight_entertainment_s
        , prob_onboard_service_s, prob_leg_room_service_s, prob_baggage_handling_s, prob_checkin_service_s, prob_inflight_service_s
        , prob_cleanliness_s, prob_departure_delay_in_minutes_s, prob_arrival_delay_in_minutes_s    
    FLOAT(30,30) DEFAULT 0;
    DECLARE total_satisfied, total_notsatisfied FLOAT(30,0);

    DECLARE 
        prob_notsatisfied, prob_gender_ns, prob_customer_type_ns, prob_age_ns, prob_type_of_travel_ns, prob_customer_class_ns
        , prob_flight_distance_ns, prob_inflight_wifi_service_ns, prob_departure_arrival_time_convenient_ns, prob_ease_of_online_booking_ns
        , prob_gate_location_ns, prob_food_and_drink_ns, prob_online_boarding_ns, prob_seat_comfort_ns, prob_inflight_entertainment_ns
        , prob_onboard_service_ns, prob_leg_room_service_ns, prob_baggage_handling_ns, prob_checkin_service_ns, prob_inflight_service_ns
        , prob_cleanliness_ns, prob_departure_delay_in_minutes_ns, prob_arrival_delay_in_minutes_ns
        
    FLOAT(30,30) DEFAULT 0;

    DECLARE prediksi_s, prediksi_ns FLOAT(30,30);
    DECLARE i, testing_ke, total_training, total_testing, i_testing, total_data INT DEFAULT 0;
    DECLARE info_satisfaction VARCHAR(2);

    SELECT COUNT(*) INTO total_data FROM tbldataprocess;
    SET testing_ke = 1;

    -- WHILE uji ke
    WHILE testing_ke <= 5 DO
        IF testing_ke = 1 THEN SET total_training = 0.1 * total_data;
        ELSEIF testing_ke = 2 THEN SET total_training = 0.25 * total_data;
        ELSEIF testing_ke = 3 THEN SET total_training = 0.5 * total_data;
        ELSEIF testing_ke = 4 THEN SET total_training = 0.75 * total_data;
        ELSEIF testing_ke = 5 THEN SET total_training = 0.9 * total_data;
        END IF;
        -- SET total_training = 0.9 * total_data;
        SET total_testing = total_data-total_training;
        SET i_testing = 1;

        UPDATE tblaccuracy SET total_data = total_testing WHERE testing = testing_ke AND algoritma = "Bayesian";

        INSERT INTO tbldatatraining ( Gender, customer_type, age, type_of_travel, customer_class, flight_distance, inflight_wifi_service, departure_arrival_time_convenient, ease_of_online_booking, gate_location, food_and_drink, online_boarding, seat_comfort, inflight_entertainment, onboard_service, leg_room_service, baggage_handling, checkin_service, inflight_service, cleanliness, departure_delay_in_minutes, arrival_delay_in_minutes, satisfaction) 
        SELECT Gender, customer_type, age, type_of_travel, customer_class, flight_distance, inflight_wifi_service, departure_arrival_time_convenient, ease_of_online_booking, gate_location, food_and_drink, online_boarding, seat_comfort, inflight_entertainment, onboard_service, leg_room_service, baggage_handling, checkin_service, inflight_service, cleanliness, departure_delay_in_minutes, arrival_delay_in_minutes, satisfaction
        FROM tbldataprocess where id<= total_training;

        INSERT INTO tbldatatesting ( Gender, customer_type, age, type_of_travel, customer_class, flight_distance, inflight_wifi_service, departure_arrival_time_convenient, ease_of_online_booking, gate_location, food_and_drink, online_boarding, seat_comfort, inflight_entertainment, onboard_service, leg_room_service, baggage_handling, checkin_service, inflight_service, cleanliness, departure_delay_in_minutes, arrival_delay_in_minutes, satisfaction) 
        SELECT Gender, customer_type, age, type_of_travel, customer_class, flight_distance, inflight_wifi_service, departure_arrival_time_convenient, ease_of_online_booking, gate_location, food_and_drink, online_boarding, seat_comfort, inflight_entertainment, onboard_service, leg_room_service, baggage_handling, checkin_service, inflight_service, cleanliness, departure_delay_in_minutes, arrival_delay_in_minutes, satisfaction
        FROM tbldataprocess WHERE    
            id > total_training
            AND id <= ( total_training + total_testing);

        SET total_satisfied = (SELECT count(satisfaction) FROM tbldatatraining WHERE satisfaction = 1); 
        SET total_notsatisfied = (SELECT count(satisfaction) FROM tbldatatraining WHERE satisfaction = 0);

        SET prob_satisfied =  total_satisfied / total_training;
        SET prob_notsatisfied =  total_notsatisfied / total_training;

        -- WHILE per baris
        WHILE i_testing <= total_testing DO
        -- GENDER
        SET prob_gender_s  = (SELECT count(gender) FROM tbldatatraining WHERE gender=(SELECT gender FROM tbldatatesting where id=i_testing) AND satisfaction =1) / total_satisfied;    
        SET prob_gender_ns = (SELECT count(gender) FROM tbldatatraining WHERE gender=(SELECT gender FROM tbldatatesting where id=i_testing) AND satisfaction =0) / total_notsatisfied;

        -- Customer Type
        SET prob_customer_type_s  = (SELECT count(customer_type) FROM tbldatatraining WHERE customer_type=(SELECT customer_type FROM tbldatatesting where id=i_testing) AND satisfaction =1) / total_satisfied;    
        SET prob_customer_type_ns = (SELECT count(customer_type) FROM tbldatatraining WHERE customer_type=(SELECT customer_type FROM tbldatatesting where id=i_testing) AND satisfaction =0) / total_notsatisfied;

        -- AGE
        SET prob_age_s  = (SELECT count(age) FROM tbldatatraining WHERE age=(SELECT age FROM tbldatatesting where id=i_testing) AND satisfaction =1) / total_satisfied;    
        SET prob_age_ns = (SELECT count(age) FROM tbldatatraining WHERE age=(SELECT age FROM tbldatatesting where id=i_testing) AND satisfaction =0) / total_notsatisfied;

        -- Type Of Travel
        SET prob_type_of_travel_s  = (SELECT count(type_of_travel) FROM tbldatatraining WHERE type_of_travel=(SELECT type_of_travel FROM tbldatatesting where id=i_testing) AND satisfaction =1) / total_satisfied;    
        SET prob_type_of_travel_ns = (SELECT count(type_of_travel) FROM tbldatatraining WHERE type_of_travel=(SELECT type_of_travel FROM tbldatatesting where id=i_testing) AND satisfaction =0) / total_notsatisfied;
        
        -- Customer Class
        SET prob_customer_class_s  = (SELECT count(customer_class) FROM tbldatatraining WHERE customer_class=(SELECT customer_class FROM tbldatatesting where id=i_testing) AND satisfaction =1) / total_satisfied;    
        SET prob_customer_class_ns = (SELECT count(customer_class) FROM tbldatatraining WHERE customer_class=(SELECT customer_class FROM tbldatatesting where id=i_testing) AND satisfaction =0) / total_notsatisfied;
        
        -- FLIGHT DISTANCE
        SET prob_flight_distance_s  = (SELECT count(flight_distance) FROM tbldatatraining WHERE flight_distance=(SELECT flight_distance FROM tbldatatesting where id=i_testing) AND satisfaction =1) / total_satisfied;    
        SET prob_flight_distance_ns = (SELECT count(flight_distance) FROM tbldatatraining WHERE flight_distance=(SELECT flight_distance FROM tbldatatesting where id=i_testing) AND satisfaction =0) / total_notsatisfied;
        
        -- Inflight Wifi Service
        SET prob_inflight_wifi_service_s  = (SELECT count(inflight_wifi_service) FROM tbldatatraining WHERE inflight_wifi_service=(SELECT inflight_wifi_service FROM tbldatatesting where id=i_testing) AND satisfaction =1) / total_satisfied;    
        SET prob_inflight_wifi_service_ns = (SELECT count(inflight_wifi_service) FROM tbldatatraining WHERE inflight_wifi_service=(SELECT inflight_wifi_service FROM tbldatatesting where id=i_testing) AND satisfaction =0) / total_notsatisfied;
        
        -- Departure Arrival Time Convenient
        SET prob_departure_arrival_time_convenient_s  = (SELECT count(departure_arrival_time_convenient) FROM tbldatatraining WHERE departure_arrival_time_convenient=(SELECT departure_arrival_time_convenient FROM tbldatatesting where id=i_testing) AND satisfaction =1) / total_satisfied;    
        SET prob_departure_arrival_time_convenient_ns = (SELECT count(departure_arrival_time_convenient) FROM tbldatatraining WHERE departure_arrival_time_convenient=(SELECT departure_arrival_time_convenient FROM tbldatatesting where id=i_testing) AND satisfaction =0) / total_notsatisfied;
        
        -- Ease of Online Booking
        SET prob_ease_of_online_booking_s  = (SELECT count(ease_of_online_booking) FROM tbldatatraining WHERE ease_of_online_booking=(SELECT ease_of_online_booking FROM tbldatatesting where id=i_testing) AND satisfaction =1) / total_satisfied;    
        SET prob_ease_of_online_booking_ns = (SELECT count(ease_of_online_booking) FROM tbldatatraining WHERE ease_of_online_booking=(SELECT ease_of_online_booking FROM tbldatatesting where id=i_testing) AND satisfaction =0) / total_notsatisfied;

        -- Gate Location
        SET prob_gate_location_s  = (SELECT count(gate_location) FROM tbldatatraining WHERE gate_location=(SELECT gate_location FROM tbldatatesting where id=i_testing) AND satisfaction =1) / total_satisfied;    
        SET prob_gate_location_ns = (SELECT count(gate_location) FROM tbldatatraining WHERE gate_location=(SELECT gate_location FROM tbldatatesting where id=i_testing) AND satisfaction =0) / total_notsatisfied;

        -- Food and Drink
        SET prob_food_and_drink_s  = (SELECT count(food_and_drink) FROM tbldatatraining WHERE food_and_drink=(SELECT food_and_drink FROM tbldatatesting where id=i_testing) AND satisfaction =1) / total_satisfied;    
        SET prob_food_and_drink_ns = (SELECT count(food_and_drink) FROM tbldatatraining WHERE food_and_drink=(SELECT food_and_drink FROM tbldatatesting where id=i_testing) AND satisfaction =0) / total_notsatisfied;

        -- Online Boarding
        SET prob_online_boarding_s = (SELECT count(online_boarding) FROM tbldatatraining WHERE online_boarding=(SELECT online_boarding FROM tbldatatesting where id=i_testing) AND satisfaction =1) / total_satisfied;    
        SET prob_online_boarding_ns = (SELECT count(online_boarding) FROM tbldatatraining WHERE online_boarding=(SELECT online_boarding FROM tbldatatesting where id=i_testing) AND satisfaction =0) / total_notsatisfied;
        
        -- Seat Comfort
        SET prob_seat_comfort_s  = (SELECT count(seat_comfort) FROM tbldatatraining WHERE seat_comfort=(SELECT seat_comfort FROM tbldatatesting where id=i_testing) AND satisfaction =1) / total_satisfied;    
        SET prob_seat_comfort_ns = (SELECT count(seat_comfort) FROM tbldatatraining WHERE seat_comfort=(SELECT seat_comfort FROM tbldatatesting where id=i_testing) AND satisfaction =0) / total_notsatisfied;
        
        -- Inflight Enterteinment
        SET prob_inflight_entertainment_s  = (SELECT count(inflight_entertainment) FROM tbldatatraining WHERE inflight_entertainment=(SELECT inflight_entertainment FROM tbldatatesting where id=i_testing) AND satisfaction =1) / total_satisfied;    
        SET prob_inflight_entertainment_ns = (SELECT count(inflight_entertainment) FROM tbldatatraining WHERE inflight_entertainment=(SELECT inflight_entertainment FROM tbldatatesting where id=i_testing) AND satisfaction =0) / total_notsatisfied;

        -- Onboard Service
        SET prob_onboard_service_s  = (SELECT count(onboard_service) FROM tbldatatraining WHERE onboard_service=(SELECT onboard_service FROM tbldatatesting where id=i_testing) AND satisfaction =1) / total_satisfied;    
        SET prob_onboard_service_ns = (SELECT count(onboard_service) FROM tbldatatraining WHERE onboard_service=(SELECT onboard_service FROM tbldatatesting where id=i_testing) AND satisfaction =0) / total_notsatisfied;
        
        -- Leg Room Service
        SET prob_leg_room_service_s  = (SELECT count(leg_room_service) FROM tbldatatraining WHERE leg_room_service=(SELECT leg_room_service FROM tbldatatesting where id=i_testing) AND satisfaction =1) / total_satisfied;    
        SET prob_leg_room_service_ns = (SELECT count(leg_room_service) FROM tbldatatraining WHERE leg_room_service=(SELECT leg_room_service FROM tbldatatesting where id=i_testing) AND satisfaction =0) / total_notsatisfied;

        -- Baggage Handling
        SET prob_baggage_handling_s  = (SELECT count(baggage_handling) FROM tbldatatraining WHERE baggage_handling=(SELECT baggage_handling FROM tbldatatesting where id=i_testing) AND satisfaction =1) / total_satisfied;    
        SET prob_baggage_handling_ns = (SELECT count(baggage_handling) FROM tbldatatraining WHERE baggage_handling=(SELECT baggage_handling FROM tbldatatesting where id=i_testing) AND satisfaction =0) / total_notsatisfied;

        -- Checkin Service
        SET prob_checkin_service_s  = (SELECT count(checkin_service) FROM tbldatatraining WHERE checkin_service=(SELECT checkin_service FROM tbldatatesting where id=i_testing) AND satisfaction =1) / total_satisfied;    
        SET prob_checkin_service_ns = (SELECT count(checkin_service) FROM tbldatatraining WHERE checkin_service=(SELECT checkin_service FROM tbldatatesting where id=i_testing) AND satisfaction =0) / total_notsatisfied;

        -- Inflight Service
        SET prob_inflight_service_s  = (SELECT count(inflight_service) FROM tbldatatraining WHERE inflight_service=(SELECT inflight_service FROM tbldatatesting where id=i_testing) AND satisfaction =1) / total_satisfied;    
        SET prob_inflight_service_ns = (SELECT count(inflight_service) FROM tbldatatraining WHERE inflight_service=(SELECT inflight_service FROM tbldatatesting where id=i_testing) AND satisfaction =0) / total_notsatisfied;

        -- Cleanliness
        SET prob_cleanliness_s  = (SELECT count(cleanliness) FROM tbldatatraining WHERE cleanliness=(SELECT cleanliness FROM tbldatatesting where id=i_testing) AND satisfaction =1) / total_satisfied;    
        SET prob_cleanliness_ns = (SELECT count(cleanliness) FROM tbldatatraining WHERE cleanliness=(SELECT cleanliness FROM tbldatatesting where id=i_testing) AND satisfaction =0) / total_notsatisfied;
        
        -- Departure Delay In Minutes
        SET prob_departure_delay_in_minutes_s  = (SELECT count(departure_delay_in_minutes) FROM tbldatatraining WHERE departure_delay_in_minutes=(SELECT departure_delay_in_minutes FROM tbldatatesting where id=i_testing) AND satisfaction =1) / total_satisfied;    
        SET prob_departure_delay_in_minutes_ns = (SELECT count(departure_delay_in_minutes) FROM tbldatatraining WHERE departure_delay_in_minutes=(SELECT departure_delay_in_minutes FROM tbldatatesting where id=i_testing) AND satisfaction =0) / total_notsatisfied;
        
        -- Arrival Delay In Minutes
        SET prob_arrival_delay_in_minutes_s  = (SELECT count(arrival_delay_in_minutes) FROM tbldatatraining WHERE arrival_delay_in_minutes=(SELECT arrival_delay_in_minutes FROM tbldatatesting where id=i_testing) AND satisfaction =1) / total_satisfied;  
        SET prob_arrival_delay_in_minutes_ns = (SELECT count(arrival_delay_in_minutes) FROM tbldatatraining WHERE arrival_delay_in_minutes=(SELECT arrival_delay_in_minutes FROM tbldatatesting where id=i_testing) AND satisfaction =0) / total_notsatisfied;
        
        SET prediksi_s  = prob_satisfied* prob_gender_s* prob_customer_type_s* prob_age_s* prob_type_of_travel_s* prob_customer_class_s* prob_flight_distance_s* prob_inflight_wifi_service_s* prob_departure_arrival_time_convenient_s* prob_ease_of_online_booking_s* prob_gate_location_s* prob_food_and_drink_s* prob_online_boarding_s* prob_seat_comfort_s* prob_inflight_entertainment_s* prob_onboard_service_s* prob_leg_room_service_s* prob_baggage_handling_s* prob_checkin_service_s* prob_inflight_service_s* prob_cleanliness_s* prob_departure_delay_in_minutes_s* prob_arrival_delay_in_minutes_s;        
        SET prediksi_ns =prob_notsatisfied* prob_gender_ns* prob_customer_type_ns* prob_age_ns* prob_type_of_travel_ns* prob_customer_class_ns* prob_flight_distance_ns* prob_inflight_wifi_service_ns* prob_departure_arrival_time_convenient_ns* prob_ease_of_online_booking_ns* prob_gate_location_ns* prob_food_and_drink_ns* prob_online_boarding_ns* prob_seat_comfort_ns* prob_inflight_entertainment_ns* prob_onboard_service_ns* prob_leg_room_service_ns* prob_baggage_handling_ns* prob_checkin_service_ns* prob_inflight_service_ns* prob_cleanliness_ns* prob_departure_delay_in_minutes_ns* prob_arrival_delay_in_minutes_ns;

        SELECT satisfaction INTO info_satisfaction from tbldatatesting where id = i_testing;
        
        
        IF info_satisfaction = 0 THEN -- actual not satisfied
            IF prediksi_s < prediksi_ns THEN
                UPDATE tblaccuracy SET tn=tn+1 WHERE algoritma="Bayesian" AND testing=testing_ke;
            ELSEIF prediksi_s > prediksi_ns THEN                 
                UPDATE tblaccuracy SET fp=fp+1 WHERE algoritma="Bayesian" AND testing=testing_ke;
            ELSEIF prediksi_s = 0 AND prediksi_ns = 0 THEN 
                UPDATE tblaccuracy SET fnull=fnull+1 WHERE algoritma="Bayesian" AND testing=testing_ke;                
            END IF;
        ELSEIF info_satisfaction = 1 THEN -- actual satisfied
            IF prediksi_s < prediksi_ns THEN 
                UPDATE tblaccuracy SET fn=fn+1 WHERE algoritma="Bayesian" AND testing=testing_ke;
            ELSEIF prediksi_s > prediksi_ns THEN 
                UPDATE tblaccuracy SET tp=tp+1 WHERE algoritma="Bayesian" AND testing=testing_ke;
            ELSEIF prediksi_s = 0 AND prediksi_ns = 0 THEN 
                UPDATE tblaccuracy SET tnull=tnull+1 WHERE algoritma="Bayesian" AND testing=testing_ke;
            END IF;        
        END IF;
        SET i_testing = i_testing+1;
        END WHILE;
        -- END WHILE per baris

        -- call selectdata('testing', 'prediksi<>1 AND prediksi <>0');
        -- UPDATE tblaccuracy SET accuracy=
        -- (
        --   (SELECT tp FROM tblaccuracy  WHERE algoritma="Bayesian" AND testing=testing_ke) 
        -- + (SELECT tn FROM tblaccuracy  WHERE algoritma="Bayesian" AND testing=testing_ke)
        -- )
        -- / 
        -- (
        --     (SELECT tp FROM tblaccuracy  WHERE algoritma="Bayesian" AND testing=testing_ke) 
        -- + (SELECT tn FROM tblaccuracy  WHERE algoritma="Bayesian" AND testing=testing_ke)
        -- + (SELECT fp FROM tblaccuracy  WHERE algoritma="Bayesian" AND testing=testing_ke) 
        -- + (SELECT fn FROM tblaccuracy  WHERE algoritma="Bayesian" AND testing=testing_ke)
        -- + (SELECT tnull FROM tblaccuracy  WHERE algoritma="Bayesian" AND testing=testing_ke) 
        -- + (SELECT fnull FROM tblaccuracy  WHERE algoritma="Bayesian" AND testing=testing_ke)
        -- )
        -- WHERE algoritma="Bayesian" AND testing=testing_ke;
        TRUNCATE tbldatatesting;
        TRUNCATE tbldatatraining;
        SELECT testing_ke as 'selesai uji ke';
    SET testing_ke = testing_ke+1;
    END WHILE;
    -- END WHILE uji ke
END ##
DELIMITER ;

DELIMITER ##
CREATE PROCEDURE processb()
BEGIN    
    UPDATE tblaccuracy SET total_data=0, tp=0, tn=0, fp=0, fn=0,tnull=0,fnull=0 WHERE algoritma = 'Bayesian';
    CALL preprocessing();
    CALL bayesian();
    -- CALL bayesian(2);
    -- CALL bayesian(3);
    -- CALL bayesian(4);
    -- CALL bayesian(5);
    UPDATE tblaccuracy SET accuracy=((tp+tn)/(tp+tn+fp+fn+tnull+fnull))*100 where algoritma='Bayesian';
    SELECT * FROM tblaccuracy;
    

END ##
DELIMITER ;

-- DELIMITER ##
-- CREATE PROCEDURE tes()
-- BEGIN
--     SET i = 0;
--     WHILE i<15 DO
--     SET a =0;
--         SET a = a + i;
--         SELECT a;

--         SET i = i + 1;
--     END WHILE;

-- END ##
-- DELIMITER ;
-- GENDER    
    -- Customer Type
    -- AGE
    -- Type Of Travel
    -- Customer Class
    -- FLIGHT DISTANCE
    -- Inflight Wifi Service
    -- Departure Arrival Time Convenient
    -- Ease of Online Booking
    -- Gate Location
    -- Food and Drink
    -- Online Boarding
    -- Seat Comfort
    -- Inflight Enterteinment
    -- Onboard Service
    -- Leg Room Service
    -- Baggage Handling
    -- Checkin Service
    -- Inflight Service
    -- Cleanliness
    -- Departure Delay In Minutes
    -- Arrival Delay In Minutes
    -- Satisfaction


-- function euclidian distance
DELIMITER ##
CREATE FUNCTION ed(
    w1t FLOAT(30,25)
    , w1 FLOAT(30,25)
    , w2t FLOAT(30,25)
    , w2 FLOAT(30,25)
    , w3t FLOAT(30,25)
    , w3 FLOAT(30,25)
    , w4t FLOAT(30,25)
    , w4 FLOAT(30,25)
    , w5t FLOAT(30,25)
    , w5 FLOAT(30,25)
    , w6t FLOAT(30,25)
    , w6 FLOAT(30,25)
    , w7t FLOAT(30,25)
    , w7 FLOAT(30,25)
    , w8t FLOAT(30,25)
    , w8 FLOAT(30,25)
    , w9t FLOAT(30,25)
    , w9 FLOAT(30,25)
    , w10t FLOAT(30,25)
    , w10 FLOAT(30,25)
    , w11t FLOAT(30,25)
    , w11 FLOAT(30,25)
    , w12t FLOAT(30,25)
    , w12 FLOAT(30,25)
    , w13t FLOAT(30,25)
    , w13 FLOAT(30,25)
    , w14t FLOAT(30,25)
    , w14 FLOAT(30,25)
    , w15t FLOAT(30,25)
    , w15 FLOAT(30,25)
    , w16t FLOAT(30,25)
    , w16 FLOAT(30,25)
    , w17t FLOAT(30,25)
    , w17 FLOAT(30,25)
    , w18t FLOAT(30,25)
    , w18 FLOAT(30,25)
    , w19t FLOAT(30,25)
    , w19 FLOAT(30,25)
    , w20t FLOAT(30,25)
    , w20 FLOAT(30,25)
    , w21t FLOAT(30,25)
    , w21 FLOAT(30,25)
    , w22t FLOAT(30,25)
    , w22 FLOAT(30,25)
)
RETURNS FLOAT(30,25)
BEGIN
    DECLARE hasil FLOAT(30,25) DEFAULT 0;
    SET hasil = SQRT(( 
                  POWER((w1t - w1),2)
                + POWER((w2t - w2),2)
                + POWER((w3t - w3),2)
                + POWER((w4t - w4),2)
                + POWER((w5t - w5),2)
                + POWER((w6t - w6),2)
                + POWER((w7t - w7),2)
                + POWER((w8t - w8),2)
                + POWER((w9t - w9),2)
                + POWER((w10t - w10),2)
                + POWER((w11t - w11),2)
                + POWER((w12t - w12),2)
                + POWER((w13t - w13),2)
                + POWER((w14t - w14),2)
                + POWER((w15t - w15),2)
                + POWER((w16t - w16),2)
                + POWER((w17t - w17),2)
                + POWER((w18t - w18),2)
                + POWER((w19t - w19),2)
                + POWER((w20t - w20),2)
                + POWER((w21t - w21),2)
                + POWER((w22t - w22),2))
            )
            ;
    RETURN(hasil);
END; ##
DELIMITER ;

DELIMITER ##
CREATE PROCEDURE lvq()
BEGIN
    -- Weight of class satisfied
    DECLARE w1s,w2s,w3s,w4s,w5s,w6s,w7s,w8s,w9s,w10s,w11s,w12s,w13s,w14s,w15s,w16s,w17s,w18s,w19s,w20s,w21s,w22s,w23s FLOAT(30,25) DEFAULT 0;
    -- Weight of class neutral or dissatisfied
    DECLARE w1ns,w2ns,w3ns,w4ns,w5ns,w6ns,w7ns,w8ns,w9ns,w10ns,w11ns,w12ns,w13ns,w14ns,w15ns,w16ns,w17ns,w18ns,w19ns,w20ns,w21ns,w22ns,w23ns FLOAT(30,25) DEFAULT 0;
    -- Weight of training
    DECLARE w1t,w2t,w3t,w4t,w5t,w6t,w7t,w8t,w9t,w10t,w11t,w12t,w13t,w14t,w15t,w16t,w17t,w18t,w19t,w20t,w21t,w22t,w23t FLOAT(30,25) DEFAULT 0;
    -- Get id for initial class satisfied and not
    DECLARE ids, idns, cj, t INT DEFAULT 0;

    DECLARE ws, wns, wt FLOAT(30,25) DEFAULT 0;
    DECLARE alpha, eps, err FLOAT(30,25) DEFAULT 0;
    DECLARE info_satisfaction VARCHAR(2);
    
    DECLARE prediction INT DEFAULT 0;
    DECLARE i, testing_ke, total_training, total_testing, i_testing, i_training, total_data INT DEFAULT 0;
    

    SELECT COUNT(*) INTO total_data FROM tbldataprocess;
    SET testing_ke = 1;


    WHILE testing_ke <= 5 DO

        IF testing_ke = 1 THEN SET total_training = 0.1 * total_data;
            ELSEIF testing_ke = 2 THEN SET total_training = 0.25 * total_data;
            ELSEIF testing_ke = 3 THEN SET total_training = 0.5 * total_data;
            ELSEIF testing_ke = 4 THEN SET total_training = 0.75 * total_data;
            ELSEIF testing_ke = 5 THEN SET total_training = 0.9 * total_data;
            END IF;
        -- SET total_training = 0.1 * total_data;
        SET total_testing = total_data-total_training;
        SET i_testing = 1;
        SET i_training = 1;
        INSERT INTO tbldatatraining ( Gender, customer_type, age, type_of_travel, customer_class, flight_distance, inflight_wifi_service, departure_arrival_time_convenient, ease_of_online_booking, gate_location, food_and_drink, online_boarding, seat_comfort, inflight_entertainment, onboard_service, leg_room_service, baggage_handling, checkin_service, inflight_service, cleanliness, departure_delay_in_minutes, arrival_delay_in_minutes, satisfaction) 
        SELECT Gender, customer_type, age, type_of_travel, customer_class, flight_distance, inflight_wifi_service, departure_arrival_time_convenient, ease_of_online_booking, gate_location, food_and_drink, online_boarding, seat_comfort, inflight_entertainment, onboard_service, leg_room_service, baggage_handling, checkin_service, inflight_service, cleanliness, departure_delay_in_minutes, arrival_delay_in_minutes, satisfaction
        FROM tbldataprocess where id<= total_training;

        INSERT INTO tbldatatesting ( Gender, customer_type, age, type_of_travel, customer_class, flight_distance, inflight_wifi_service, departure_arrival_time_convenient, ease_of_online_booking, gate_location, food_and_drink, online_boarding, seat_comfort, inflight_entertainment, onboard_service, leg_room_service, baggage_handling, checkin_service, inflight_service, cleanliness, departure_delay_in_minutes, arrival_delay_in_minutes, satisfaction) 
        SELECT Gender, customer_type, age, type_of_travel, customer_class, flight_distance, inflight_wifi_service, departure_arrival_time_convenient, ease_of_online_booking, gate_location, food_and_drink, online_boarding, seat_comfort, inflight_entertainment, onboard_service, leg_room_service, baggage_handling, checkin_service, inflight_service, cleanliness, departure_delay_in_minutes, arrival_delay_in_minutes, satisfaction
        FROM tbldataprocess WHERE
            id > total_training
            AND id <= ( total_training + total_testing);
            

        -- INITIALITATION
        SET alpha = 0.9;
        SET eps = 0.0000001;
        -- 130000
        SET err = 1;
        -- get id from each class
        SELECT id INTO ids FROM tbldatatraining WHERE satisfaction = 1 ORDER BY RAND() LIMIT 1;
        SELECT id INTO idns FROM tbldatatraining WHERE satisfaction = 0 ORDER BY RAND() LIMIT 1;
        
        SELECT gender INTO w1s FROM tbldatatraining WHERE id=ids;
        SELECT gender INTO w1ns FROM tbldatatraining WHERE id=idns;
        SELECT customer_type INTO w2s FROM tbldatatraining WHERE id=ids;
        SELECT customer_type INTO w2ns FROM tbldatatraining WHERE id=idns;
        SELECT age INTO w3s FROM tbldatatraining WHERE id=ids;
        SELECT age INTO w3ns FROM tbldatatraining WHERE id=idns;
        SELECT type_of_travel INTO w4s FROM tbldatatraining WHERE id=ids;
        SELECT type_of_travel INTO w4ns FROM tbldatatraining WHERE id=idns;
        SELECT customer_class INTO w5s FROM tbldatatraining WHERE id=ids;
        SELECT customer_class INTO w5ns FROM tbldatatraining WHERE id=idns;
        SELECT flight_distance INTO w6s FROM tbldatatraining WHERE id=ids;
        SELECT flight_distance INTO w6ns FROM tbldatatraining WHERE id=idns;
        SELECT inflight_wifi_service INTO w7s FROM tbldatatraining WHERE id=ids;
        SELECT inflight_wifi_service INTO w7ns FROM tbldatatraining WHERE id=idns;
        SELECT departure_arrival_time_convenient INTO w8s FROM tbldatatraining WHERE id=ids;
        SELECT departure_arrival_time_convenient INTO w8ns FROM tbldatatraining WHERE id=idns;
        SELECT ease_of_online_booking INTO w9s FROM tbldatatraining WHERE id=ids;
        SELECT ease_of_online_booking INTO w9ns FROM tbldatatraining WHERE id=idns;
        SELECT gate_location INTO w10s FROM tbldatatraining WHERE id=ids;
        SELECT gate_location INTO w10ns FROM tbldatatraining WHERE id=idns;
        SELECT food_and_drink INTO w11s FROM tbldatatraining WHERE id=ids;
        SELECT food_and_drink INTO w11ns FROM tbldatatraining WHERE id=idns;
        SELECT online_boarding INTO w12s FROM tbldatatraining WHERE id=ids;
        SELECT online_boarding INTO w12ns FROM tbldatatraining WHERE id=idns;
        SELECT seat_comfort INTO w13s FROM tbldatatraining WHERE id=ids;
        SELECT seat_comfort INTO w13ns FROM tbldatatraining WHERE id=idns;
        SELECT inflight_entertainment INTO w14s FROM tbldatatraining WHERE id=ids;
        SELECT inflight_entertainment INTO w14ns FROM tbldatatraining WHERE id=idns;
        SELECT onboard_service INTO w15s FROM tbldatatraining WHERE id=ids;
        SELECT onboard_service INTO w15ns FROM tbldatatraining WHERE id=idns;
        SELECT leg_room_service INTO w16s FROM tbldatatraining WHERE id=ids;
        SELECT leg_room_service INTO w16ns FROM tbldatatraining WHERE id=idns;
        SELECT baggage_handling INTO w17s FROM tbldatatraining WHERE id=ids;
        SELECT baggage_handling INTO w17ns FROM tbldatatraining WHERE id=idns;
        SELECT checkin_service INTO w18s FROM tbldatatraining WHERE id=ids;
        SELECT checkin_service INTO w18ns FROM tbldatatraining WHERE id=idns;
        SELECT inflight_service INTO w19s FROM tbldatatraining WHERE id=ids;
        SELECT inflight_service INTO w19ns FROM tbldatatraining WHERE id=idns;
        SELECT cleanliness INTO w20s FROM tbldatatraining WHERE id=ids;
        SELECT cleanliness INTO w20ns FROM tbldatatraining WHERE id=idns;
        SELECT departure_delay_in_minutes INTO w21s FROM tbldatatraining WHERE id=ids;
        SELECT departure_delay_in_minutes INTO w21ns FROM tbldatatraining WHERE id=idns;
        SELECT arrival_delay_in_minutes INTO w22s FROM tbldatatraining WHERE id=ids;
        SELECT arrival_delay_in_minutes INTO w22ns FROM tbldatatraining WHERE id=idns;

        -- row used to initialitation is not use again    
        DELETE FROM tbldatatraining WHERE id=ids;
        DELETE FROM tbldatatraining WHERE id=idns;

        -- END INITIALITATION

        -- TRAINING
        WHILE i_training <= total_training DO    
            IF (SELECT COUNT(*) FROM tbldatatraining WHERE id=i_training) = 1 THEN            
                SELECT gender INTO w1t FROM tbldatatraining WHERE id=i_training;
                    SELECT customer_type INTO w2t FROM tbldatatraining WHERE id=i_training;
                    SELECT age INTO w3t FROM tbldatatraining WHERE id=i_training;
                    SELECT type_of_travel INTO w4t FROM tbldatatraining WHERE id=i_training;
                    SELECT customer_class INTO w5t FROM tbldatatraining WHERE id=i_training;
                    SELECT flight_distance INTO w6t FROM tbldatatraining WHERE id=i_training;
                    SELECT inflight_wifi_service INTO w7t FROM tbldatatraining WHERE id=i_training;
                    SELECT departure_arrival_time_convenient INTO w8t FROM tbldatatraining WHERE id=i_training;
                    SELECT ease_of_online_booking INTO w9t FROM tbldatatraining WHERE id=i_training;
                    SELECT gate_location INTO w10t FROM tbldatatraining WHERE id=i_training;
                    SELECT food_and_drink INTO w11t FROM tbldatatraining WHERE id=i_training;
                    SELECT online_boarding INTO w12t FROM tbldatatraining WHERE id=i_training;
                    SELECT seat_comfort INTO w13t FROM tbldatatraining WHERE id=i_training;
                    SELECT inflight_entertainment INTO w14t FROM tbldatatraining WHERE id=i_training;
                    SELECT onboard_service INTO w15t FROM tbldatatraining WHERE id=i_training;
                    SELECT leg_room_service INTO w16t FROM tbldatatraining WHERE id=i_training;
                    SELECT baggage_handling INTO w17t FROM tbldatatraining WHERE id=i_training;
                    SELECT checkin_service INTO w18t FROM tbldatatraining WHERE id=i_training;
                    SELECT inflight_service INTO w19t FROM tbldatatraining WHERE id=i_training;
                    SELECT cleanliness INTO w20t FROM tbldatatraining WHERE id=i_training;
                    SELECT departure_delay_in_minutes INTO w21t FROM tbldatatraining WHERE id=i_training;
                    SELECT arrival_delay_in_minutes INTO w22t FROM tbldatatraining WHERE id=i_training;
                    SELECT satisfaction INTO w23t FROM tbldatatraining WHERE id=i_training;
                
                -- SELECT
                --     i_training as '1'
                --     , ROUND(w1t,2) as w1t
                --     , ROUND(w2t,2) as w2t
                --     , ROUND(w3t,2) as w3t
                --     , ROUND(w4t,2) as w4t
                --     , ROUND(w5t,2) as w5t
                --     , ROUND(w6t,2) as w6t
                --     , ROUND(w7t,2) as w7t
                --     , ROUND(w8t,2) as w8t
                --     , ROUND(w9t,2) as w9t
                --     , ROUND(w10t,2) as w10t
                --     , ROUND(w11t,2) as w11t
                --     , ROUND(w12t,2) as w12t
                --     , ROUND(w13t,2) as w13t
                --     , ROUND(w14t,2) as w14t
                --     , ROUND(w15t,2) as w15t
                --     , ROUND(w16t,2) as w16t
                --     , ROUND(w17t,2) as w17t
                --     , ROUND(w18t,2) as w18t
                --     , ROUND(w19t,2) as w19t
                --     , ROUND(w20t,2) as w20t
                --     , ROUND(w21t,2) as w21t
                --     , ROUND(w22t,2) as w22t
                --     , ROUND(w23t,2) as w23t
                --     ;
                SET ws = ed(
                    w1t, w1s, w2t, w2s, w3t, w3s, w4t, w4s, w5t, w5s, w6t, w6s, w7t, w7s, w8t, w8s, w9t, w9s, w10t, w10s, w11t, w11s, w12t, w12s, w13t, w13s, w14t, w14s, w15t, w15s, w16t, w16s, w17t, w17s, w18t, w18s, w19t, w19s, w20t, w20s, w21t, w21s, w22t, w22s
                );

                SET wns = ed(
                    w1t, w1ns, w2t, w2ns, w3t, w3ns, w4t, w4ns, w5t, w5ns, w6t, w6ns, w7t, w7ns, w8t, w8ns, w9t, w9ns, w10t, w10ns, w11t, w11ns, w12t, w12ns, w13t, w13ns, w14t, w14ns, w15t, w15ns, w16t, w16ns, w17t, w17ns, w18t, w18ns, w19t, w19ns, w20t, w20ns, w21t, w21ns, w22t, w22ns
                );
                            
                IF ws < wns THEN
                    SET cj = 1;
                ELSEIF ws > wns THEN
                    SET cj = 0;
                ELSE 
                    SET cj = 1;
                END IF;

                SELECT satisfaction INTO t FROM tbldatatraining WHERE id=i_training;

                -- cj 1 satisfied, 0 dissatisfied
                IF cj = 1 AND t = 1 THEN
                    SET w1s = w1s + (alpha * (w1t - w1s));
                    SET w2s = w2s + (alpha * (w2t - w2s));
                    SET w3s = w3s + (alpha * (w3t - w3s));
                    SET w4s = w4s + (alpha * (w4t - w4s));
                    SET w5s = w5s + (alpha * (w5t - w5s));
                    SET w6s = w6s + (alpha * (w6t - w6s));
                    SET w7s = w7s + (alpha * (w7t - w7s));
                    SET w8s = w8s + (alpha * (w8t - w8s));
                    SET w9s = w9s + (alpha * (w9t - w9s));
                    SET w10s = w10s + (alpha * (w10t - w10s));
                    SET w11s = w11s + (alpha * (w11t - w11s));
                    SET w12s = w12s + (alpha * (w12t - w12s));
                    SET w13s = w13s + (alpha * (w13t - w13s));
                    SET w14s = w14s + (alpha * (w14t - w14s));
                    SET w15s = w15s + (alpha * (w15t - w15s));
                    SET w16s = w16s + (alpha * (w16t - w16s));
                    SET w17s = w17s + (alpha * (w17t - w17s));
                    SET w18s = w18s + (alpha * (w18t - w18s));
                    SET w19s = w19s + (alpha * (w19t - w19s));
                    SET w20s = w20s + (alpha * (w20t - w20s));
                    SET w21s = w21s + (alpha * (w21t - w21s));
                    SET w22s = w22s + (alpha * (w22t - w22s));

                ELSEIF cj = 0 AND t = 0 THEN
                    SET w1ns = w1ns + (alpha * (w1t - w1ns));
                    SET w2ns = w2ns + (alpha * (w2t - w2ns));
                    SET w3ns = w3ns + (alpha * (w3t - w3ns));
                    SET w4ns = w4ns + (alpha * (w4t - w4ns));
                    SET w5ns = w5ns + (alpha * (w5t - w5ns));
                    SET w6ns = w6ns + (alpha * (w6t - w6ns));
                    SET w7ns = w7ns + (alpha * (w7t - w7ns));
                    SET w8ns = w8ns + (alpha * (w8t - w8ns));
                    SET w9ns = w9ns + (alpha * (w9t - w9ns));
                    SET w10ns = w10ns + (alpha * (w10t - w10ns));
                    SET w11ns = w11ns + (alpha * (w11t - w11ns));
                    SET w12ns = w12ns + (alpha * (w12t - w12ns));
                    SET w13ns = w13ns + (alpha * (w13t - w13ns));
                    SET w14ns = w14ns + (alpha * (w14t - w14ns));
                    SET w15ns = w15ns + (alpha * (w15t - w15ns));
                    SET w16ns = w16ns + (alpha * (w16t - w16ns));
                    SET w17ns = w17ns + (alpha * (w17t - w17ns));
                    SET w18ns = w18ns + (alpha * (w18t - w18ns));
                    SET w19ns = w19ns + (alpha * (w19t - w19ns));
                    SET w20ns = w20ns + (alpha * (w20t - w20ns));
                    SET w21ns = w21ns + (alpha * (w21t - w21ns));
                    SET w22ns = w22ns + (alpha * (w22t - w22ns));

                ELSEIF cj = 0 AND t = 1 THEN                
                    SET w1ns = w1ns - (alpha * (w1t - w1ns));
                    SET w2ns = w2ns - (alpha * (w2t - w2ns));
                    SET w3ns = w3ns - (alpha * (w3t - w3ns));
                    SET w4ns = w4ns - (alpha * (w4t - w4ns));
                    SET w5ns = w5ns - (alpha * (w5t - w5ns));
                    SET w6ns = w6ns - (alpha * (w6t - w6ns));
                    SET w7ns = w7ns - (alpha * (w7t - w7ns));
                    SET w8ns = w8ns - (alpha * (w8t - w8ns));
                    SET w9ns = w9ns - (alpha * (w9t - w9ns));
                    SET w10ns = w10ns - (alpha * (w10t - w10ns));
                    SET w11ns = w11ns - (alpha * (w11t - w11ns));
                    SET w12ns = w12ns - (alpha * (w12t - w12ns));
                    SET w13ns = w13ns - (alpha * (w13t - w13ns));
                    SET w14ns = w14ns - (alpha * (w14t - w14ns));
                    SET w15ns = w15ns - (alpha * (w15t - w15ns));
                    SET w16ns = w16ns - (alpha * (w16t - w16ns));
                    SET w17ns = w17ns - (alpha * (w17t - w17ns));
                    SET w18ns = w18ns - (alpha * (w18t - w18ns));
                    SET w19ns = w19ns - (alpha * (w19t - w19ns));
                    SET w20ns = w20ns - (alpha * (w20t - w20ns));
                    SET w21ns = w21ns - (alpha * (w21t - w21ns));
                    SET w22ns = w22ns - (alpha * (w22t - w22ns));

                ELSEIF cj = 1 AND t = 0 THEN                
                    SET w1s = w1s - (alpha * (w1t - w1s));
                    SET w2s = w2s - (alpha * (w2t - w2s));
                    SET w3s = w3s - (alpha * (w3t - w3s));
                    SET w4s = w4s - (alpha * (w4t - w4s));
                    SET w5s = w5s - (alpha * (w5t - w5s));
                    SET w6s = w6s - (alpha * (w6t - w6s));
                    SET w7s = w7s - (alpha * (w7t - w7s));
                    SET w8s = w8s - (alpha * (w8t - w8s));
                    SET w9s = w9s - (alpha * (w9t - w9s));
                    SET w10s = w10s - (alpha * (w10t - w10s));
                    SET w11s = w11s - (alpha * (w11t - w11s));
                    SET w12s = w12s - (alpha * (w12t - w12s));
                    SET w13s = w13s - (alpha * (w13t - w13s));
                    SET w14s = w14s - (alpha * (w14t - w14s));
                    SET w15s = w15s - (alpha * (w15t - w15s));
                    SET w16s = w16s - (alpha * (w16t - w16s));
                    SET w17s = w17s - (alpha * (w17t - w17s));
                    SET w18s = w18s - (alpha * (w18t - w18s));
                    SET w19s = w19s - (alpha * (w19t - w19s));
                    SET w20s = w20s - (alpha * (w20t - w20s));
                    SET w21s = w21s - (alpha * (w21t - w21s));
                    SET w22s = w22s - (alpha * (w22t - w22s));

                END IF;

                SET alpha = alpha - (alpha *(i_training/total_training));

                IF err < eps THEN
                    SELECT alpha;
                    SELECT i_training as 'it', total_training as 'tt';
                    SET i_training = total_training+1;
                END IF;
            END IF;
        SET i_training = i_training + 1;
        END WHILE;
        -- END TRAINING

        -- SELECT i_training;
        -- SELECT alpha;
        WHILE i_testing <= total_testing DO
            SELECT gender INTO w1t FROM tbldatatesting WHERE id=i_testing;
                SELECT customer_type INTO w2t FROM tbldatatesting WHERE id=i_testing;
                SELECT age INTO w3t FROM tbldatatesting WHERE id=i_testing;
                SELECT type_of_travel INTO w4t FROM tbldatatesting WHERE id=i_testing;
                SELECT customer_class INTO w5t FROM tbldatatesting WHERE id=i_testing;
                SELECT flight_distance INTO w6t FROM tbldatatesting WHERE id=i_testing;
                SELECT inflight_wifi_service INTO w7t FROM tbldatatesting WHERE id=i_testing;
                SELECT departure_arrival_time_convenient INTO w8t FROM tbldatatesting WHERE id=i_testing;
                SELECT ease_of_online_booking INTO w9t FROM tbldatatesting WHERE id=i_testing;
                SELECT gate_location INTO w10t FROM tbldatatesting WHERE id=i_testing;
                SELECT food_and_drink INTO w11t FROM tbldatatesting WHERE id=i_testing;
                SELECT online_boarding INTO w12t FROM tbldatatesting WHERE id=i_testing;
                SELECT seat_comfort INTO w13t FROM tbldatatesting WHERE id=i_testing;
                SELECT inflight_entertainment INTO w14t FROM tbldatatesting WHERE id=i_testing;
                SELECT onboard_service INTO w15t FROM tbldatatesting WHERE id=i_testing;
                SELECT leg_room_service INTO w16t FROM tbldatatesting WHERE id=i_testing;
                SELECT baggage_handling INTO w17t FROM tbldatatesting WHERE id=i_testing;
                SELECT checkin_service INTO w18t FROM tbldatatesting WHERE id=i_testing;
                SELECT inflight_service INTO w19t FROM tbldatatesting WHERE id=i_testing;
                SELECT cleanliness INTO w20t FROM tbldatatesting WHERE id=i_testing;
                SELECT departure_delay_in_minutes INTO w21t FROM tbldatatesting WHERE id=i_testing;
                SELECT arrival_delay_in_minutes INTO w22t FROM tbldatatesting WHERE id=i_testing;
                SELECT satisfaction INTO w23t FROM tbldatatesting WHERE id=i_testing;

            SET ws = ed(
                    w1t, w1s
                    , w2t, w2s
                    , w3t, w3s
                    , w4t, w4s
                    , w5t, w5s
                    , w6t, w6s
                    , w7t, w7s
                    , w8t, w8s
                    , w9t, w9s
                    , w10t, w10s
                    , w11t, w11s
                    , w12t, w12s
                    , w13t, w13s
                    , w14t, w14s
                    , w15t, w15s
                    , w16t, w16s
                    , w17t, w17s
                    , w18t, w18s
                    , w19t, w19s
                    , w20t, w20s
                    , w21t, w21s
                    , w22t, w22s
                );

            SET wns = ed(
                    w1t, w1ns
                    , w2t, w2ns
                    , w3t, w3ns
                    , w4t, w4ns
                    , w5t, w5ns
                    , w6t, w6ns
                    , w7t, w7ns
                    , w8t, w8ns
                    , w9t, w9ns
                    , w10t, w10ns
                    , w11t, w11ns
                    , w12t, w12ns
                    , w13t, w13ns
                    , w14t, w14ns
                    , w15t, w15ns
                    , w16t, w16ns
                    , w17t, w17ns
                    , w18t, w18ns
                    , w19t, w19ns
                    , w20t, w20ns
                    , w21t, w21ns
                    , w22t, w22ns
                );


            SELECT satisfaction INTO info_satisfaction FROM tbldatatesting WHERE id=i_testing;
            IF ws < wns THEN SET prediction = 1;
                ELSEIF ws > wns THEN SET prediction = 0;
                ELSE SET prediction = 1;
            END IF;
            IF info_satisfaction = 0 AND prediction=0 THEN
                UPDATE tblaccuracy SET tn=tn+1 WHERE algoritma="LVQ" AND testing=testing_ke;
            ELSEIF info_satisfaction = 0 AND prediction=1  THEN
                UPDATE tblaccuracy SET fp=fp+1 WHERE algoritma="LVQ" AND testing=testing_ke;
            ELSEIF info_satisfaction = 1 AND prediction=0 THEN
                UPDATE tblaccuracy SET fn=fn+1 WHERE algoritma="LVQ" AND testing=testing_ke;
            ELSEIF info_satisfaction = 1 AND prediction=1 THEN
                UPDATE tblaccuracy SET tp=tp+1 WHERE algoritma="LVQ" AND testing=testing_ke;
            -- ELSEIF info_satisfaction = 1 AND ws=wns THEN
            --     UPDATE tblaccuracy SET tnull=tnull+1 WHERE algoritma="LVQ" AND testing=testing_ke;
            -- ELSEIF info_satisfaction = 0 AND ws=wns THEN
            --     UPDATE tblaccuracy SET fnull=fnull+1 WHERE algoritma="LVQ" AND testing=testing_ke;
            END IF;
        SET i_testing = i_testing + 1;
        END WHILE;
        
        SELECT
            testing_ke as 'uji s ke'
            , ROUND(w1s,2) as w1s
            , ROUND(w2s,2) as w2s
            , ROUND(w3s,2) as w3s
            , ROUND(w4s,2) as w4s
            , ROUND(w5s,2) as w5s
            , ROUND(w6s,2) as w6s
            , ROUND(w7s,2) as w7s
            , ROUND(w8s,2) as w8s
            , ROUND(w9s,2) as w9s
            , ROUND(w10s,2) as w10s
            , ROUND(w11s,2) as w11s
            , ROUND(w12s,2) as w12s
            , ROUND(w13s,2) as w13s
            , ROUND(w14s,2) as w14s
            , ROUND(w15s,2) as w15s
            , ROUND(w16s,2) as w16s
            , ROUND(w17s,2) as w17s
            , ROUND(w18s,2) as w18s
            , ROUND(w19s,2) as w19s
            , ROUND(w20s,2) as w20s
            , ROUND(w21s,2) as w21s
            , ROUND(w22s,2) as w22s
            ;

        SELECT 
            testing_ke as 'uji ns ke'
            , ROUND(w1ns,2) as w1ns
            , ROUND(w2ns,2) as w2ns
            , ROUND(w3ns,2) as w3ns
            , ROUND(w4ns,2) as w4ns
            , ROUND(w5ns,2) as w5ns
            , ROUND(w6ns,2) as w6ns
            , ROUND(w7ns,2) as w7ns
            , ROUND(w8ns,2) as w8ns
            , ROUND(w9ns,2) as w9ns
            , ROUND(w10ns,2) as w10ns
            , ROUND(w11ns,2) as w11ns
            , ROUND(w12ns,2) as w12ns
            , ROUND(w13ns,2) as w13ns
            , ROUND(w14ns,2) as w14ns
            , ROUND(w15ns,2) as w15ns
            , ROUND(w16ns,2) as w16ns
            , ROUND(w17ns,2) as w17ns
            , ROUND(w18ns,2) as w18ns
            , ROUND(w19ns,2) as w19ns
            , ROUND(w20ns,2) as w20ns
            , ROUND(w21ns,2) as w21ns
            , ROUND(w22ns,2) as w22ns
            ;

        UPDATE tblaccuracy SET total_data=total_testing WHERE algoritma="LVQ" AND testing=testing_ke;
        TRUNCATE tbldatatesting;
        TRUNCATE tbldatatraining;
        SELECT testing_ke as 'selesai uji ke';
    SET testing_ke = testing_ke + 1;
    END WHILE;
    -- Call selectdata('training', 'id<5');
END ##
DELIMITER ;

DELIMITER ##
CREATE PROCEDURE processl()
BEGIN
    CALL preprocessing();
    CALL lvq();
    UPDATE tblaccuracy SET accuracy = ((tp+tn)/(tp+tn+fp+fn))*100 WHERE algoritma="LVQ";
    select * from tblaccuracy;
END ##
DELIMITER ;

DELIMITER ##
CREATE PROCEDURE process()
BEGIN
    CALL processb();
    CALL processl();
    END ##
DELIMITER ;