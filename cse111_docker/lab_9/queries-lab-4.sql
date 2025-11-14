-- SQLite

DROP VIEW IF EXISTS V1;
CREATE VIEW V1 AS
SELECT 
    c.c_custkey as ccustkey,
    c.c_name as cname,
    c.c_address as caddress,
    c.c_phone as cphone,
    c.c_acctbal as cacctbal,
    c.c_mktsegment as cmktsegment,
    c.c_comment as ccomment,
    n.n_name as cnation,
    r.r_name as cregion
FROM customer c
JOIN nation n ON c.c_nationkey = n.n_nationkey
JOIN region r ON n.n_regionkey = r.r_regionkey;

DROP VIEW IF EXISTS V2;
CREATE VIEW V2 AS
SELECT 
    o.o_orderkey as oorderkey,
    o.o_custkey as ocustkey,
    o.o_orderstatus as oorderstatus,
    o.o_totalprice as ototalprice,
    CAST(strftime('%Y', o.o_orderdate) AS INTEGER) as oorderyear,
    o.o_orderpriority as oorderpriority,
    o.o_clerk as oclerk,
    o.o_shippriority as oshippriority,
    o.o_comment as ocomment
FROM orders o;

DROP VIEW IF EXISTS V4;
CREATE VIEW V4 AS 
SELECT 
    s.s_suppkey as ssuppkey,
    s.s_name as sname,
    s.s_address as saddress,
    s.s_phone as sphone,
    s.s_acctbal as sacctbal,
    s.s_comment as scomment,
    n.n_name as snation,
    r.r_name as sregion
FROM supplier s
JOIN nation n ON s.s_nationkey = n.n_nationkey
JOIN region r ON n.n_regionkey = r.r_regionkey;

DROP VIEW IF EXISTS V10;
CREATE VIEW V10 AS 
SELECT
    part.p_type as ptype,
    MIN(l_discount) as mindiscount,
    MAX(l_discount) as maxdiscount
FROM part, lineitem
WHERE part.p_partkey = lineitem.l_partkey
GROUP BY part.p_type;

DROP VIEW IF EXISTS V111;
CREATE VIEW V111 AS
SELECT
    c.c_custkey as ccustkey,
    c.c_name as cname,
    c.c_nationkey as cnationkey,
    c.c_acctbal as cacctbal
FROM customer c
WHERE c.c_acctbal < 0;

DROP VIEW IF EXISTS V112;
CREATE VIEW V112 AS
SELECT
    s.s_suppkey as ssuppkey,
    s.s_name as sname,
    s.s_nationkey as snationkey,
    s.s_acctbal as sacctbal
FROM supplier s
WHERE s.s_acctbal > 0;

--1
select cnation as country, count(*) as cnt
from orders, V1
where ccustkey = o_custkey
    and cregion = 'EUROPE'
group by cnation;

--2
select cname as customer, count(*) as cnt
from V1, V2
where ocustkey = ccustkey
    and cnation = 'EGYPT'
    and oorderyear = 1992
group by cname;

--3
select cname as customer, sum(o_totalprice) as total_price
from orders, V1
where o_custkey = ccustkey
    and cnation = 'ARGENTINA'
    and o_orderdate like '1996-%'
group by cname;

--4
select sname as supplier, count(*) as cnt
from partsupp, V4, part
where ps_partkey = p_partkey
    and ps_suppkey = ssuppkey
    and snation = 'KENYA'
    and p_container LIKE '%BOX%'
group by sname;

--5
select snation as country, count(*) as cnt
from V4
where snation = 'ARGENTINA' OR snation = 'BRAZIL'
group by snation;

--6
select s_name as supplier, oorderpriority as priority, count(distinct ps_partkey) as parts
from V2, lineitem, partsupp, supplier, nation
where l_orderkey = oorderkey
    and l_partkey = ps_partkey
    and l_suppkey = ps_suppkey
    and ps_suppkey = s_suppkey
    and s_nationkey = n_nationkey
    and n_name = 'INDONESIA'
group by s_name, oorderpriority;

--7
select cnation as country, oorderstatus as status, count(*) as orders
from V1, V2
where ocustkey = ccustkey
    and cregion = 'AFRICA'
group by cnation, oorderstatus;

--8
select count(distinct oclerk) as clerks
from V2, V4, lineitem
where oorderkey = l_orderkey
    and l_suppkey = ssuppkey
    and snation = 'PERU';

--9
select snation as country, count(distinct l_orderkey) as cnt
from V2, V4, lineitem
where oorderkey = l_orderkey
    and l_suppkey = ssuppkey
    and snation = 'PERU'
group by snation
having cnt > 200;

--10
select ptype as part_type, mindiscount as min_disc, maxdiscount as max_disc
from V10
where ptype like '%ECONOMY%'
    or ptype like '%COPPER%'
group by ptype;

--11
select count(distinct l_orderkey) as order_cnt
from lineitem, V111, V112, V2
where l_suppkey = ssuppkey
    and l_orderkey = oorderkey
    and ocustkey = ccustkey
    and cacctbal < 0
    and sacctbal > 0;

--12
select sregion as region, max(sacctbal) as max_bal
from V4
group by sregion
having max_bal > 9000;

--13
select sregion as supp_region, cregion as cust_region, min(o_totalprice) as min_price
from V1, V4, orders, lineitem
where l_suppkey = ssuppkey
    and l_orderkey = o_orderkey
    and o_custkey = ccustkey
group by sregion, cregion;

--14
select count(*) as items
from V1, V4, orders, lineitem
where o_custkey = ccustkey
    and l_orderkey = o_orderkey
    and l_suppkey = ssuppkey
    and sregion = 'ASIA'
    and cnation = 'KENYA';

--15
select sregion as region, sname as supplier, sacctbal as acct_bal
from V4 v1
where sacctbal = (select max(sacctbal) 
                  from V4 v2 
                  where v2.sregion = v1.sregion);
