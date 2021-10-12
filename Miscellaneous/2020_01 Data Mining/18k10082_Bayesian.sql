DROP DATABASE IF EXISTS db18k10082_probabilitas;
CREATE DATABASE db18k10082_probabilitas;
USE db18k10082_probabilitas;

CREATE TABLE tblBayesian(
	no int primary key,
	age varchar(6),
	income varchar(6),
	student varchar(3),
	creditrating varchar(10),
	buyscomputer varchar(3)
);

CREATE TABLE tblBayesian2(
	hewan varchar(50) Primary Key,
	kulit varchar(20),
	melahirkan varchar(5),
	berat float,
	kelas varchar(10)
);

CREATE TABLE tblBayesian3(
	no int Primary Key,
	divisi varchar(10),
	status varchar(10),
	umur varchar(10),
	pendapatan varchar(10),
	jumlahKaryawan int
);

INSERT INTO tblBayesian VALUES
(1, "<=30", "HIGH", "NO", "FAIR", "NO"),
(2, "<=30", "HIGH", "NO", "EXCELLENT", "NO"),
(3, "31..40", "HIGH", "NO", "FAIR", "YES"),
(4, ">40", "MEDIUM", "NO", "FAIR", "YES"),
(5, ">40", "LOW", "YES", "FAIR", "YES"),
(6, ">40", "LOW", "YES", "EXCELLENT", "NO"),
(7, "31..40", "LOW", "YES", "EXCELLENT", "YES"),
(8, "<=30", "MEDIUM", "NO", "FAIR", "NO"),
(9, "<=30", "LOW", "YES", "FAIR", "YES"),
(10, ">40", "MEDIUM", "YES", "FAIR", "YES"),
(11, "<=30", "MEDIUM", "YES", "EXCELLENT", "YES"),
(12, "31..40", "MEDIUM", "NO", "EXCELLENT", "YES"),
(13, "31..40", "HIGH", "YES", "FAIR", "YES"),
(14, ">40", "MEDIUM", "NO", "EXCELLENT", "NO");

INSERT INTO tblBayesian2 VALUES
("Ular",	"Sisik",	"Ya",	10,	"Reptil"),
("Tikus",	"Bulu",	"Ya",	0.8,	"Mamalia"),
("Kambing",	"Rambut",	"Ya",	21,	"Mamalia"),
("Sapi",	"Rambut",	"Ya",	120,	"Mamalia"),
("Kadal",	"Sisik",	"Tidak",	0.4,	"Reptil"),
("Kucing",	"Rambut",	"Ya",	1.5,	"Mamalia"),
("Bekicot",	"Cangkang",	"Tidak",	0.3,	"Reptil"),
("Harimau",	"Rambut",	"Ya",	43,	"Mamalia"),
("Rusa",	"Rambut",	"Ya",	45,	"Mamalia"),
("Kura-Kura",	"Cangkang",	"Tidak",	7,	"Reptil");

INSERT INTO tblBayesian3 VALUES
(1,	"PENJUALAN",	"SENIOR",	"31..35",	"46..50 rb",	30),
(2,	"PENJUALAN",	"JUNIOR",	"26..30",	"26..30 rb",	40),
(3,	"PENJUALAN",	"JUNIOR",	"31..35",	"31..35 rb",	40),
(4,	"SISTEM",	"JUNIOR",	"21..25",	"46..50 rb",	20),
(5,	"SISTEM",	"SENIOR",	"31..35",	"66..70 rb",	5),
-- (6,	"SISTEM",	"?",	"26..30",	"46..50 rb",	3),
(7,	"SISTEM",	"SENIOR",	"41..45",	"66..70 rb",	3),
(8,	"MARKETING",	"SENIOR",	"36..40",	"46..50 rb",	10),
(9,	"MARKETING",	"JUNIOR",	"31..35",	"41..45 rb",	4),
(10,	"SEKRETARIS",	"SENIOR",	"46..50",	"36..40 rb",	4),
(11,	"SEKRETARIS",	"JUNIOR",	"26..30",	"26..30 rb",	6);

-- SELECT * FROM tblBayesian3;
-- SELECT * FROM tblBayesian2;

-- SELECT * FROM tblBayesian;

/*Langkah pertama hitung jumlah data*/
-- SELECT count(*) INTO @jumlahData FROM tblBayesian;

-- SELECT buyscomputer, count(*) as jumlah,
-- ROUND(count(*)/@jumlahData,3) as Class
-- FROM tblBayesian
-- GROUP BY buyscomputer;

-- /*Langkah kedua : menghitung setiap atribut probabilitas*/
-- SELECT A.age, A.buyscomputer, count(A.age) as jumlah,
-- 	ROUND(count(A.age)/
-- 	(
-- 		SELECT COUNT(B.buyscomputer)
-- 		FROM tblBayesian AS B
-- 		WHERE B.buyscomputer=A.buyscomputer
-- 		GROUP BY B.buyscomputer
-- 	),3) AS bayes

-- FROM tblBayesian AS A
-- WHERE age='<=30'
-- GROUP BY buyscomputer;


-- SELECT A.income, A.buyscomputer, count(A.income) as jumlah,
-- 	ROUND(count(A.income)/
-- 	(
-- 		SELECT COUNT(B.buyscomputer)
-- 		FROM tblBayesian AS B
-- 		WHERE B.buyscomputer=A.buyscomputer
-- 		GROUP BY B.buyscomputer
-- 	),3) AS bayes

-- FROM tblBayesian AS A
-- WHERE income='MEDIUM'
-- GROUP BY buyscomputer;


-- SELECT A.student, A.buyscomputer, count(A.student) as jumlah,
-- 	ROUND(count(A.student)/
-- 	(
-- 		SELECT COUNT(B.buyscomputer)
-- 		FROM tblBayesian AS B
-- 		WHERE B.buyscomputer=A.buyscomputer
-- 		GROUP BY B.buyscomputer
-- 	),3) AS bayes

-- FROM tblBayesian AS A
-- WHERE student='YES'
-- GROUP BY buyscomputer;

-- SELECT A.creditrating, A.buyscomputer, count(A.creditrating) as jumlah,
-- 	ROUND(count(A.creditrating)/
-- 	(
-- 		SELECT COUNT(B.buyscomputer)
-- 		FROM tblBayesian AS B
-- 		WHERE B.buyscomputer=A.buyscomputer
-- 		GROUP BY B.buyscomputer
-- 	),3) AS bayes

-- FROM tblBayesian AS A
-- WHERE creditrating='FAIR'
-- GROUP BY buyscomputer;


/*Gabungkan Langkah kedua jadi 1 tabel*/
SELECT A.buyscomputer,
	(
		SELECT ROUND(count(B.buyscomputer)/(SELECT count(*) FROM tblBayesian),3)
		FROM tblBayesian as B
		WHERE B.buyscomputer = A.buyscomputer
	) AS "Probabilitas",
	(
		SELECT ROUND(count(B.age)/count(A.buyscomputer),3)
		FROM tblBayesian as B
		WHERE B.age='<=30'
		AND B.buyscomputer = A.buyscomputer
	) AS 'AGE<=30',
	(
		SELECT ROUND(count(B.income)/count(A.buyscomputer),3)
		FROM tblBayesian as B
		WHERE B.income='MEDIUM'
		AND B.buyscomputer = A.buyscomputer
	) AS 'INCOME=MEDIUM',
	(
		SELECT ROUND(count(B.student)/count(A.buyscomputer),3)
		FROM tblBayesian as B
		WHERE B.student='YES'
		AND B.buyscomputer = A.buyscomputer
	) AS 'Student=YES',
	(
		SELECT ROUND(count(B.creditrating)/count(A.buyscomputer),3)
		FROM tblBayesian as B
		WHERE B.creditrating='FAIR'
		AND B.buyscomputer = A.buyscomputer
	) AS 'CR=FAIR',

	ROUND((
	SELECT ROUND(count(B.age)/count(A.buyscomputer),3)
		FROM tblBayesian as B
		WHERE B.age='<=30'
		AND B.buyscomputer = A.buyscomputer
	) *
	(
		SELECT ROUND(count(B.income)/count(A.buyscomputer),3)
		FROM tblBayesian as B
		WHERE B.income='MEDIUM'
		AND B.buyscomputer = A.buyscomputer
	) *
	(
		SELECT ROUND(count(B.student)/count(A.buyscomputer),3)
		FROM tblBayesian as B
		WHERE B.student='YES'
		AND B.buyscomputer = A.buyscomputer
	) *
	(
		SELECT ROUND(count(B.creditrating)/count(A.buyscomputer),3)
		FROM tblBayesian as B
		WHERE B.creditrating='FAIR'
		AND B.buyscomputer = A.buyscomputer
	),3) AS "POST.PROB",
	ROUND(
	ROUND((
	SELECT ROUND(count(B.age)/count(A.buyscomputer),3)
		FROM tblBayesian as B
		WHERE B.age='<=30'
		AND B.buyscomputer = A.buyscomputer
	) *
	(
		SELECT ROUND(count(B.income)/count(A.buyscomputer),3)
		FROM tblBayesian as B
		WHERE B.income='MEDIUM'
		AND B.buyscomputer = A.buyscomputer
	) *
	(
		SELECT ROUND(count(B.student)/count(A.buyscomputer),3)
		FROM tblBayesian as B
		WHERE B.student='YES'
		AND B.buyscomputer = A.buyscomputer
	) *
	(
		SELECT ROUND(count(B.creditrating)/count(A.buyscomputer),3)
		FROM tblBayesian as B
		WHERE B.creditrating='FAIR'
		AND B.buyscomputer = A.buyscomputer
	),3) *
	(
		SELECT ROUND(count(*)/(SELECT count(*) FROM tblBayesian),3)
		FROM tblBayesian AS B
		WHERE B.buyscomputer=A.buyscomputer
	)
	,3)

	AS "Pasterior Probability"
FROM tblBayesian AS A
GROUP BY A.buyscomputer
ORDER BY A.buyscomputer DESC;

-- SELECT A.buyscomputer,ROUND(
-- 	(
-- 		SELECT ROUND(count(B.age)/count(A.buyscomputer),3)
-- 		FROM tblBayesian as B
-- 		WHERE B.age='<=30'
-- 		AND B.buyscomputer = A.buyscomputer
-- 	) *
-- 	(
-- 		SELECT ROUND(count(C.income)/count(A.buyscomputer),3)
-- 		FROM tblBayesian as C
-- 		WHERE C.income='MEDIUM'
-- 		AND C.buyscomputer = A.buyscomputer
-- 	) *
-- 	(
-- 		SELECT ROUND(count(D.student)/count(A.buyscomputer),3)
-- 		FROM tblBayesian as D
-- 		WHERE D.student='YES'
-- 		AND D.buyscomputer = A.buyscomputer
-- 	) *
-- 	(
-- 		SELECT ROUND(count(E.creditrating)/count(A.buyscomputer),3)
-- 		FROM tblBayesian as E
-- 		WHERE E.creditrating='FAIR'
-- 		AND E.buyscomputer = A.buyscomputer
-- 	),3) AS "POST.PROB"
-- FROM tblBayesian AS A
-- GROUP BY A.buyscomputer;

SELECT A.kelas,
	(
		SELECT ROUND(count(B.kelas)/(SELECT count(*) FROM tblBayesian2),3)
		FROM tblBayesian2 as B
		WHERE B.kelas=A.kelas
	) AS "Probabilitas"
	,
	(
		SELECT ROUND(count(B.kulit)/count(A.kelas),3)
		FROM tblBayesian2 as B
		WHERE B.kulit="Rambut"
		AND B.kelas=A.kelas
	) AS "kulit=Rambut"
	,
	(
		SELECT ROUND(count(B.melahirkan)/count(A.kelas),3)
		FROM tblBayesian2 as B
		WHERE B.melahirkan="Ya"
		AND B.kelas=A.kelas
	) AS "Melahirkan=Ya"
	,
	(
		SELECT ROUND(count(B.berat)/count(A.kelas),3)
		FROM tblBayesian2 as B
		WHERE B.berat<=15
		AND B.kelas=A.kelas
	) AS "Berat<15",

	ROUND(
	(
		SELECT ROUND(count(B.kulit)/count(A.kelas),3)
		FROM tblBayesian2 as B
		WHERE B.kulit="Rambut"
		AND B.kelas=A.kelas
	)
	*
	(
		SELECT ROUND(count(B.melahirkan)/count(A.kelas),3)
		FROM tblBayesian2 as B
		WHERE B.melahirkan="Ya"
		AND B.kelas=A.kelas
	)
	*
	(
		SELECT ROUND(count(B.berat)/count(A.kelas),3)
		FROM tblBayesian2 as B
		WHERE B.berat<=15
		AND B.kelas=A.kelas
	),3) AS "POST. PROB",
	ROUND(
	ROUND(
	(
		SELECT ROUND(count(B.kulit)/count(A.kelas),3)
		FROM tblBayesian2 as B
		WHERE B.kulit="Rambut"
		AND B.kelas=A.kelas
	)
	*
	(
		SELECT ROUND(count(B.melahirkan)/count(A.kelas),3)
		FROM tblBayesian2 as B
		WHERE B.melahirkan="Ya"
		AND B.kelas=A.kelas
	)
	*
	(
		SELECT ROUND(count(B.berat)/count(A.kelas),3)
		FROM tblBayesian2 as B
		WHERE B.berat<=15
		AND B.kelas=A.kelas
	),3) *

	(
		SELECT ROUND(count(B.kelas)/(SELECT count(*) FROM tblBayesian2),3)
		FROM tblBayesian2 as B
		WHERE B.kelas=A.kelas
	) ,3)AS "Pasterior Probability"

FROM tblBayesian2 as A
GROUP BY A.kelas
ORDER BY A.kelas DESC;

SELECT A.status,

	(
		SELECT ROUND(count(B.status)/(SELECT count(*) FROM tblBayesian3),3)
		FROM tblBayesian3 as B
		WHERE B.status=A.status
	) AS "Probabilitas",

	(
		SELECT ROUND(count(B.divisi)/count(A.status),3)
		FROM tblBayesian3 as B
		WHERE divisi="Sistem"
		AND B.status=A.status
	) AS "Divisi=Sistem",
	(
		SELECT ROUND(count(B.umur)/count(A.status),3)
		FROM tblBayesian3 as B
		WHERE umur="26..30"
		AND B.status=A.status
	) AS "Umur=26..30",
	(
		SELECT ROUND(count(B.pendapatan)/count(A.status),3)
		FROM tblBayesian3 as B
		WHERE pendapatan="46..50 rb"
		AND B.status=A.status
	) AS "pendapatan=46..50 rb",
	(
		SELECT ROUND(count(B.jumlahKaryawan)/count(A.status),3)
		FROM tblBayesian3 as B
		WHERE jumlahKaryawan>=3
		AND B.status=A.status
	) AS "jumlahKaryawan>=3",
	ROUND(
	(
		SELECT ROUND(count(B.divisi)/count(A.status),3)
		FROM tblBayesian3 as B
		WHERE divisi="Sistem"
		AND B.status=A.status
	) *
	(
		SELECT ROUND(count(B.umur)/count(A.status),3)
		FROM tblBayesian3 as B
		WHERE umur="26..30"
		AND B.status=A.status
	) *
	(
		SELECT ROUND(count(B.pendapatan)/count(A.status),3)
		FROM tblBayesian3 as B
		WHERE pendapatan="46..50 rb"
		AND B.status=A.status
	) *
	(
		SELECT ROUND(count(B.jumlahKaryawan)/count(A.status),3)
		FROM tblBayesian3 as B
		WHERE jumlahKaryawan>=3
		AND B.status=A.status
	),3) AS "POST. PROB",

	ROUND(
	(
		SELECT ROUND(count(B.divisi)/count(A.status),3)
		FROM tblBayesian3 as B
		WHERE divisi="Sistem"
		AND B.status=A.status
	) *
	(
		SELECT ROUND(count(B.umur)/count(A.status),3)
		FROM tblBayesian3 as B
		WHERE umur="26..30"
		AND B.status=A.status
	) *
	(
		SELECT ROUND(count(B.pendapatan)/count(A.status),3)
		FROM tblBayesian3 as B
		WHERE pendapatan="46..50 rb"
		AND B.status=A.status
	) *
	(
		SELECT ROUND(count(B.jumlahKaryawan)/count(A.status),3)
		FROM tblBayesian3 as B
		WHERE jumlahKaryawan>=3
		AND B.status=A.status
	)*
	(
		SELECT ROUND(count(B.status)/(SELECT count(*) FROM tblBayesian3),3)
		FROM tblBayesian3 as B
		WHERE B.status=A.status
	),3) AS "Pasterior Probability"
FROM tblBayesian3 as A
GROUP BY A.status
ORDER BY A.status DESC;
