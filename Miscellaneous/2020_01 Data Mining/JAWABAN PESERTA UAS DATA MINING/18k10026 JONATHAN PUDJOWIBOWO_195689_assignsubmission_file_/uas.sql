drop database if exists dbuas;
create database dbuas;
use dbuas;
set sql_safe_updates = 0;

create table tbldata(patient varchar(5), fever varchar(10), headache varchar(10),
sore varchar(10), limp varchar(10), fatigue varchar(10), 
nasalcongestion varchar(10), sneeze varchar(10), throat_s varchar(10), 
breathless varchar(10), diagnosis varchar(10));

create table tblcount(atribute varchar(20), info varchar(20), sumdata int,
fever int, flu int, entropy decimal(8,4), gain double);

insert into tbldata values
("P1", "no", "low", "no", "no", "no", "low", "high", "high", "low", "fever"),
("P2", "high", "high", "high", "high", "high", "no", "no", "high", "high", "flu"),
("P3", "high", "high", "low", "high", "high", "high", "no", "high", "high", "flu"),
("P4", "no", "no", "no", "low", "no", "high", "no", "low", "low", "fever"),
("P5", "high", "high", "low", "high", "high", "high", "no", "high", "high", "flu"),
("P6", "no", "no", "no", "low", "no", "high", "high", "high", "no", "fever"),
("P7", "high", "high", "high", "high", "high", "no", "no", "no", "high", "flu"),
("P8", "no", "no", "no", "no", "no", "high", "high", "no", "low", "fever"),
("P9", "no", "low", "low", "no", "no", "high", "high", "high", "high", "fever"),
("P10", "high", "high", "high", "low", "low", "no", "high", "no", "high", "flu"),
("P11", "no", "no", "no", "low", "no", "high", "low", "high", "no", "fever"),
("P12", "high", "low", "high", "low", "high", "no", "high", "no", "low", "flu"),
("P13", "no", "no", "low", "low", "no", "high", "high", "high", "no", "fever"),
("P14", "high", "high", "high", "high", "low", "no", "high", "high", "high", "flu"),
("P15", "low", "no", "no", "low", "no", "high", "no", "high", "low", "fever"),
("P16", "no", "no", "no", "no", "no", "high", "high", "high", "high", "fever"),
("p17", "high", "low", "high", "low", "low", "no", "no", "no", "high", "flu");

delimiter $$
create function sfEntropy(fe int, fl int, sumz int)
returns decimal(8, 4)
begin
    declare e decimal(8, 4);
    select (-(fl/sumz) * log2(fl/sumz)) + (-(fe/sumz) * log2(fe/sumz)) into e;
    return(e); 
end $$
delimiter ;

delimiter $$
create procedure spInsert(x varchar(20))
begin
    declare sumdatax int;
    declare sumfever int;
    declare sumflu int;
    declare x1 varchar(20);
    declare e decimal(8,4);
    set x1 = x;
    if x1 = 'totaldata' then
        select count(*) into sumdatax from tbldata;
        select count(*) into sumfever from tbldata where diagnosis = 'fever';
        select count(*) into sumflu from tbldata where diagnosis = 'flu';
        set e = sfEntropy(sumfever, sumflu, sumdatax);
        insert into tblcount(atribute, info, sumdata, fever, flu)
        values(x1, NULL, sumdatax, sumfever, sumflu);
    end if;
    if x1 = 'fever' then
        insert into tblcount(info ,sumdata, fever, flu)
	        select a.fever as fever, count(*) as sumdatax,
		    (
		        select count(*) 
		        from tbldata as b
		        where b.diagnosis = 'fever' and b.fever = a.fever
		    ) as fever, 
		    (
		        select count(*)
		        from tbldata as c
		        where c.diagnosis = 'flu' and c.fever =a.fever
		    )as flu
	        from tbldata as a
	        group by a.fever;
        update tblcount set atribute = 'fever' where atribute is null;
    end if;
    update tblcount set entropy = sfEntropy(fever, flu, sumdata);
    if x1 = 'headache' then
        insert into tblcount(info ,sumdata, fever, flu)
	        select a.headache as headache, count(*) as sumdatax,
		    (
		        select count(*) 
		        from tbldata as b
		        where b.diagnosis = 'fever' and b.headache = a.headache
		    ) as fever, 
		    (
		        select count(*)
		        from tbldata as c
		        where c.diagnosis = 'flu' and c.headache =a.headache
		    )as flu
	        from tbldata as a
	        group by a.headache;
        update tblcount set atribute = 'headache' where atribute is null;
    end if;
    if x1 = 'sore' then
        insert into tblcount(info ,sumdata, fever, flu)
	        select a.sore as sore, count(*) as sumdatax,
		    (
		        select count(*) 
		        from tbldata as b
		        where b.diagnosis = 'fever' and b.sore = a.sore
		    ) as fever, 
		    (
		        select count(*)
		        from tbldata as c
		        where c.diagnosis = 'flu' and c.sore =a.sore
		    )as flu
	        from tbldata as a
	        group by a.sore;
        update tblcount set atribute = 'sore' where atribute is null;
    end if;
    if x1 = 'limp' then
        insert into tblcount(info ,sumdata, fever, flu)
	        select a.limp as limp, count(*) as sumdatax,
		    (
		        select count(*) 
		        from tbldata as b
		        where b.diagnosis = 'fever' and b.limp = a.limp
		    ) as fever, 
		    (
		        select count(*)
		        from tbldata as c
		        where c.diagnosis = 'flu' and c.limp =a.limp
		    )as flu
	        from tbldata as a
	        group by a.limp;
        update tblcount set atribute = 'limp' where atribute is null;
    end if;
    if x1 = 'fatigue' then
        insert into tblcount(info ,sumdata, fever, flu)
	        select a.fatigue as fatigue, count(*) as sumdatax,
		    (
		        select count(*) 
		        from tbldata as b
		        where b.diagnosis = 'fever' and b.fatigue = a.fatigue
		    ) as fever, 
		    (
		        select count(*)
		        from tbldata as c
		        where c.diagnosis = 'flu' and c.fatigue = a.fatigue
		    )as flu
	        from tbldata as a
	        group by a.fatigue;
        update tblcount set atribute = 'fatigue' where atribute is null;
    end if;
    if x1 = 'nasalcongestion' then
        insert into tblcount(info ,sumdata, fever, flu)
	        select a.nasalcongestion as nasalcongestion, count(*) as sumdatax,
		    (
		        select count(*) 
		        from tbldata as b
		        where b.diagnosis = 'fever' and b.nasalcongestion = a.nasalcongestion
		    ) as fever, 
		    (
		        select count(*)
		        from tbldata as c
		        where c.diagnosis = 'flu' and c.nasalcongestion =a.nasalcongestion
		    )as flu
	        from tbldata as a
	        group by a.nasalcongestion;
        update tblcount set atribute = 'nasalcongestion' where atribute is null;
    end if;
    if x1 = 'sneeze' then
        insert into tblcount(info ,sumdata, fever, flu)
	        select a.sneeze as sneeze, count(*) as sumdatax,
		    (
		        select count(*) 
		        from tbldata as b
		        where b.diagnosis = 'fever' and b.sneeze = a.sneeze
		    ) as fever, 
		    (
		        select count(*)
		        from tbldata as c
		        where c.diagnosis = 'flu' and c.sneeze =a.sneeze
		    )as flu
	        from tbldata as a
	        group by a.sneeze;
        update tblcount set atribute = 'sneeze' where atribute is null;
    end if;
    if x1 = 'throat_s' then
        insert into tblcount(info ,sumdata, fever, flu)
	        select a.throat_s as throat_s, count(*) as sumdatax,
		    (
		        select count(*) 
		        from tbldata as b
		        where b.diagnosis = 'fever' and b.throat_s = a.throat_s
		    ) as fever, 
		    (
		        select count(*)
		        from tbldata as c
		        where c.diagnosis = 'flu' and c.throat_s =a.throat_s
		    )as flu
	        from tbldata as a
	        group by a.throat_s;
        update tblcount set atribute = 'throat_s' where atribute is null;
    end if;
    if x1 = 'breathless' then
        insert into tblcount(info ,sumdata, fever, flu)
	        select a.breathless as breathless, count(*) as sumdatax,
		    (
		        select count(*) 
		        from tbldata as b
		        where b.diagnosis = 'fever' and b.breathless = a.breathless
		    ) as fever, 
		    (
		        select count(*)
		        from tbldata as c
		        where c.diagnosis = 'flu' and c.breathless =a.breathless
		    )as flu
	        from tbldata as a
	        group by a.breathless;
        update tblcount set atribute = 'breathless' where atribute is null;
    end if;
    update tblcount set entropy = sfEntropy(fever, flu, sumdata);
    update tblcount set entropy = 0.000 where entropy is null;
end $$
delimiter ;

-- drop table if exists tbltemp;
-- create temporary table tbltemp
-- (
-- atribute varchar(20), 
-- gain double
-- ); 
-- select entropy into @entropy from tblcount where atribute = 'total';
-- select sumdata into @sumdata from tblcount where atribute = 'total';
-- insert into tbltemp(atribute, gain)
-- select atribute, @entropy - sum((sumdata/@sumdata) * entropy) as gain
-- from tblcount
-- group by atribute;

-- update tblcount set gain =
-- 	(
-- 	select gain
-- 	from tbltemp
-- 	where atribute = tblcount.atribut
-- 	);

delimiter ##
create procedure spGain()
begin
    drop table if exists tbltemp;
    create temporary table tbltemp
    (
    atribute varchar(20), 
    gain double
    ); 
    select entropy into @entropy from tblcount where atribute = 'totaldata';
    select sumdata into @sumdata from tblcount where atribute = 'totaldata';
    insert into tbltemp(atribute, gain)
    select atribute, @entropy - sum((sumdata/@sumdata) * entropy) as gain
    from tblcount
    group by atribute;

    update tblcount set gain =
	    (
	    select gain
	    from tbltemp
	    where atribute = tblcount.atribute
	    );
end##
delimiter ;

call spInsert('totaldata');
call spInsert('fever');
call spInsert('headache');
call spInsert('sore');
call spInsert('limp');
call spInsert('fatigue');
call spInsert('nasalcongestion');
call spInsert('sneeze');
call spInsert('throat_s');
call spInsert('breathless');
call spGain();

select patient as "[1]", fever as "[2]", headache as "[3]",
sore as "[4]", limp as "[5]", fatigue as "[6]", 
nasalcongestion as "[7]", sneeze as "[8]", throat_s as "[9]", 
breathless as "[10]", diagnosis from tbldata;

select * from tblcount;

select max(tblcount.gain) as maximal
from tblcount;

-- delimiter $$
-- create procedure spCount()
-- begin
--     declare vContinue varchar(5) default 'true';
--     declare vIteration int default 1;

--     while vContinue = 'true' do 
--         begin
--             truncate tblcount;
            
--     end while;
-- end $$
-- delimiter ;