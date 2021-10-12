DROP DATABASE IF EXISTS dbTransaction;
CREATE DATABASE dbTransaction;
USE dbTransaction;
set autocommit=0;

CREATE TABLE tblBook(
  bookid int primary key,
  booktitle varchar(100) not null,
  copyright varchar(4)
) engine=InnoDB;

Insert INTO tblBook values
(1, 'buku pertama', '2020'),
(2, 'buku kedua', '2019');

SELECT * FROM tblBook;

START TRANSACTION;
Insert INTO tblBook values
(3, 'buku ketiga', '2020'),
(4, 'buku keempat', '2019');
COMMIT;
SELECT * FROM tblBook;

START TRANSACTION;
Insert INTO tblBook values
(5, 'buku kelima', '2020'),
(6, 'buku keenam', '2019');
savepoint svp1;

SELECT * FROM tblBook;

Insert INTO tblBook values
(7, 'buku ketujuh', '2020'),
(8, 'buku kedelapan', '2019');

SELECT * FROM tblBook;

Insert INTO tblBook values
(9, 'buku kesembilan', '2020'),
(10, 'buku kesepuluh', '2019');
SELECT * FROM tblBook;

Insert INTO tblBook values
(11, 'buku kesembilan', '2020'),
(12, 'buku kesepuluh', '2019');
ROLLBACK to savepoint svp1;
SELECT * FROM tblBook;
