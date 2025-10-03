-- TPC-H Schema for SQLite - Lab 3
-- This file contains the CREATE TABLE statements for all TPC-H benchmark tables
-- Lab 3 specific schema file

-- nation
CREATE TABLE IF NOT EXISTS nation (
  n_nationkey  INTEGER PRIMARY KEY,
  n_name       TEXT NOT NULL,
  n_regionkey  INTEGER NOT NULL,
  n_comment    TEXT
);

-- region
CREATE TABLE IF NOT EXISTS region (
  r_regionkey  INTEGER PRIMARY KEY,
  r_name       TEXT NOT NULL,
  r_comment    TEXT
);

-- supplier
CREATE TABLE IF NOT EXISTS supplier (
  s_suppkey     INTEGER PRIMARY KEY,
  s_name        TEXT NOT NULL,
  s_address     TEXT NOT NULL,
  s_nationkey   INTEGER NOT NULL,
  s_phone       TEXT NOT NULL,
  s_acctbal     REAL NOT NULL,
  s_comment     TEXT
);

-- customer
CREATE TABLE IF NOT EXISTS customer (
  c_custkey     INTEGER PRIMARY KEY,
  c_name        TEXT NOT NULL,
  c_address     TEXT NOT NULL,
  c_nationkey   INTEGER NOT NULL,
  c_phone       TEXT NOT NULL,
  c_acctbal     REAL NOT NULL,
  c_mktsegment  TEXT NOT NULL,
  c_comment     TEXT
);

-- part
CREATE TABLE IF NOT EXISTS part (
  p_partkey     INTEGER PRIMARY KEY,
  p_name        TEXT NOT NULL,
  p_mfgr        TEXT NOT NULL,
  p_brand       TEXT NOT NULL,
  p_type        TEXT NOT NULL,
  p_size        INTEGER NOT NULL,
  p_container   TEXT NOT NULL,
  p_retailprice REAL NOT NULL,
  p_comment     TEXT
);

-- partsupp
CREATE TABLE IF NOT EXISTS partsupp (
  ps_partkey     INTEGER NOT NULL,
  ps_suppkey     INTEGER NOT NULL,
  ps_availqty    INTEGER NOT NULL,
  ps_supplycost  REAL NOT NULL,
  ps_comment     TEXT,
  PRIMARY KEY (ps_partkey, ps_suppkey)
);

-- orders
CREATE TABLE IF NOT EXISTS orders (
  o_orderkey       INTEGER PRIMARY KEY,
  o_custkey        INTEGER NOT NULL,
  o_orderstatus    TEXT NOT NULL,
  o_totalprice     REAL NOT NULL,
  o_orderdate      TEXT NOT NULL,
  o_orderpriority  TEXT NOT NULL,
  o_clerk          TEXT NOT NULL,
  o_shippriority   INTEGER NOT NULL,
  o_comment        TEXT
);

-- lineitem
CREATE TABLE IF NOT EXISTS lineitem (
  l_orderkey       INTEGER NOT NULL,
  l_partkey        INTEGER NOT NULL,
  l_suppkey        INTEGER NOT NULL,
  l_linenumber     INTEGER NOT NULL,
  l_quantity       REAL NOT NULL,
  l_extendedprice  REAL NOT NULL,
  l_discount       REAL NOT NULL,
  l_tax            REAL NOT NULL,
  l_returnflag     TEXT NOT NULL,
  l_linestatus     TEXT NOT NULL,
  l_shipdate       TEXT NOT NULL,
  l_commitdate     TEXT NOT NULL,
  l_receiptdate    TEXT NOT NULL,
  l_shipinstruct   TEXT NOT NULL,
  l_shipmode       TEXT NOT NULL,
  l_comment        TEXT,
  PRIMARY KEY (l_orderkey, l_linenumber)
);

SELECT COUNT(*) AS num_line_items 
FROM lineitem 
WHERE l_shipdate < l_commitdate;"
29219

SELECT 
    MIN(c_acctbal) AS min_account_balance,
    MAX(c_acctbal) AS max_account_balance,
    SUM(c_acctbal) AS total_account_balance
FROM customer
WHERE c_mktsegment = 'FURNITURE';
-982.32|9889.89|1265282.8

SELECT 
    c_address AS address,
    c_phone AS phone_number,
    c_acctbal AS account_balance
FROM customer
WHERE c_name = 'Customer#000000227';
7wlpEBswtXBPNODASgCUt8OZQ|23-951-816-2439|1808.23

SELECT s_name AS supplier_name
FROM supplier
WHERE s_acctbal > 8000;

SELECT 
    l_receiptdate,
    l_returnflag, 
    l_extendedprice,
    l_tax
FROM lineitem
WHERE l_returnflag != 'Y' 
    AND l_receiptdate = '1995-09-22';

SELECT n_name, SUM(s_acctbal) AS total_acctbal 
FROM supplier 
JOIN nation ON supplier.s_nationkey = nation.n_nationkey 
GROUP BY n_name;

SELECT SUM(o_totalprice) AS total_price_america_1995
FROM orders o
JOIN customer c ON o.o_custkey = c.c_custkey
JOIN nation n ON c.c_nationkey = n.n_nationkey
JOIN region r ON n.n_regionkey = r.r_regionkey
WHERE r.r_name = 'AMERICA'
    AND o.o_orderdate LIKE '1995%';

SELECT DISTINCT n.n_name AS nation
FROM orders o
JOIN customer c ON o.o_custkey = c.c_custkey
JOIN nation n ON c.c_nationkey = n.n_nationkey
WHERE o.o_orderdate LIKE '1994-12%'
ORDER BY n.n_name;

SELECT 
    strftime('%Y-%m', l_receiptdate) AS year_month,
    COUNT(*) AS line_items_received
FROM customer c
JOIN orders o ON c.c_custkey = o.o_custkey
JOIN lineitem l ON o.o_orderkey = l.l_orderkey
WHERE c.c_name = 'Customer#000000227'
GROUP BY strftime('%Y-%m', l_receiptdate)
ORDER BY year_month;

SELECT 
    s.s_name AS supplier_name,
    n.n_name AS nation,
    s.s_acctbal AS account_balance
FROM supplier s
JOIN nation n ON s.s_nationkey = n.n_nationkey
JOIN region r ON n.n_regionkey = r.r_regionkey
WHERE r.r_name = 'ASIA'
    AND s.s_acctbal > 5000
ORDER BY s.s_acctbal DESC;

SELECT COUNT(*) AS urgent_orders_romania_1993_1997
FROM orders o
JOIN customer c ON o.o_custkey = c.c_custkey
JOIN nation n ON c.c_nationkey = n.n_nationkey
WHERE n.n_name = 'ROMANIA'
    AND o.o_orderpriority = '1-URGENT'
    AND (o.o_orderdate LIKE '1993%' 
         OR o.o_orderdate LIKE '1994%' 
         OR o.o_orderdate LIKE '1995%' 
         OR o.o_orderdate LIKE '1996%' 
         OR o.o_orderdate LIKE '1997%');

SELECT 
    substr(o.o_orderdate, 1, 4) AS year,
    n.n_name AS country,
    COUNT(*) AS line_items_count
FROM orders o
JOIN lineitem l ON o.o_orderkey = l.l_orderkey
JOIN supplier s ON l.l_suppkey = s.s_suppkey
JOIN nation n ON s.s_nationkey = n.n_nationkey
WHERE o.o_orderpriority = '3-MEDIUM'
    AND (n.n_name = 'ARGENTINA' OR n.n_name = 'BRAZIL')
GROUP BY substr(o.o_orderdate, 1, 4), n.n_name
ORDER BY year, country;

SELECT 
    s.s_name AS supplier_name,
    COUNT(*) AS discounted_line_items_count
FROM lineitem l
JOIN supplier s ON l.l_suppkey = s.s_suppkey
WHERE l.l_discount = 0.10
GROUP BY s.s_suppkey, s.s_name
ORDER BY discounted_line_items_count DESC;

SELECT 
    r.r_name AS region_name,
    COUNT(*) AS status_f_orders_count
FROM orders o
JOIN customer c ON o.o_custkey = c.c_custkey
JOIN nation n ON c.c_nationkey = n.n_nationkey
JOIN region r ON n.n_regionkey = r.r_regionkey
WHERE o.o_orderstatus = 'F'
GROUP BY r.r_regionkey, r.r_name
ORDER BY status_f_orders_count DESC;

SELECT SUM(c.c_acctbal) AS total_account_balance_america_furniture
FROM customer c
JOIN nation n ON c.c_nationkey = n.n_nationkey
JOIN region r ON n.n_regionkey = r.r_regionkey
WHERE r.r_name = 'AMERICA'
    AND c.c_mktsegment = 'FURNITURE';

SELECT 
    n.n_name AS country,
    COUNT(*) AS orders_count
FROM orders o
JOIN customer c ON o.o_custkey = c.c_custkey
JOIN nation n ON c.c_nationkey = n.n_nationkey
JOIN region r ON n.n_regionkey = r.r_regionkey
WHERE r.r_name = 'EUROPE'
GROUP BY n.n_nationkey, n.n_name
ORDER BY orders_count DESC;

SELECT COUNT(*) AS total_orders_EGYPT
FROM orders O
JOIN customer c ON o.o_custkey = c.c_custkey
JOIN nation n ON c.c_nationkey = n.n_nationkey
WHERE n.n_name = 'EGYPT' 
  AND o.o_orderdate LIKE '1992%';

SELECT 
  c.c_name AS customer_name,
  COUNT(*) AS num_orders,
  SUM(o.o_totalprice) AS total_price
FROM orders o
JOIN customer c ON o.o_custkey = c.c_custkey
JOIN nation n ON c.c_nationkey = n.n_nationkey
WHERE n.n_name = 'ARGENTINA'
  AND o.o_orderdate LIKE '1996%'
GROUP BY c.c_custkey, c.c_name
ORDER BY total_price DESC;


SELECT 
    s.s_name AS supplier_name,
    COUNT(*) AS box_parts_count
FROM part p
JOIN partsupp ps ON p.p_partkey = ps.ps_partkey
JOIN supplier s ON ps.ps_suppkey = s.s_suppkey
JOIN nation n ON s.s_nationkey = n.n_nationkey
WHERE n.n_name = 'KENYA'
    AND p.p_container LIKE '%BOX%'
GROUP BY s.s_suppkey, s.s_name
ORDER BY box_parts_count DESC;

SELECT 
  n.n_name AS nation_name,
  s.s_suppkey AS supplier_id
FROM supplier s
JOIN nation n ON s.s_nationkey = n.n_nationkey
WHERE n.n_name IN ('ARGENTINA', 'BRAZIL');

SELECT 
    s.s_name AS supplier_name,
    o.o_orderpriority AS order_priority,
    COUNT(DISTINCT p.p_partkey) AS unique_parts_count
FROM supplier s
JOIN nation n ON s.s_nationkey = n.n_nationkey
JOIN partsupp ps ON s.s_suppkey = ps.ps_suppkey
JOIN part p ON ps.ps_partkey = p.p_partkey
JOIN lineitem l ON p.p_partkey = l.l_partkey AND s.s_suppkey = l.l_suppkey
JOIN orders o ON l.l_orderkey = o.o_orderkey
WHERE n.n_name = 'INDONESIA'
GROUP BY s.s_suppkey, s.s_name, o.o_orderpriority
ORDER BY s.s_name, o.o_orderpriority;

SELECT 
    n.n_name AS nation_name,
    o.o_orderstatus AS order_status,
    COUNT(*) AS order_count
FROM orders o
JOIN customer c ON o.o_custkey = c.c_custkey
JOIN nation n ON c.c_nationkey = n.n_nationkey
JOIN region r ON n.n_regionkey = r.r_regionkey
WHERE r.r_name = 'AFRICA'
GROUP BY n.n_nationkey, n.n_name, o.o_orderstatus
ORDER BY n.n_name, o.o_orderstatus;

SELECT COUNT(DISTINCT o.o_clerk) AS different_clerks_count
FROM supplier s
JOIN nation n ON s.s_nationkey = n.n_nationkey
JOIN lineitem l ON s.s_suppkey = l.l_suppkey
JOIN orders o ON l.l_orderkey = o.o_orderkey
WHERE n.n_name = 'PERU';

SELECT 
    n.n_name AS nation_name,
    COUNT(DISTINCT o.o_orderkey) AS completed_orders_1993
FROM supplier s
JOIN nation n ON s.s_nationkey = n.n_nationkey
JOIN region r ON n.n_regionkey = r.r_regionkey
JOIN lineitem l ON s.s_suppkey = l.l_suppkey
JOIN orders o ON l.l_orderkey = o.o_orderkey
WHERE r.r_name = 'AFRICA'
    AND o.o_orderstatus = 'F'
    AND o.o_orderdate LIKE '1993%'
GROUP BY n.n_nationkey, n.n_name
HAVING COUNT(DISTINCT o.o_orderkey) > 200
ORDER BY completed_orders_1993 DESC;

SELECT 
    p.p_partkey AS part_key,
    p.p_name AS part_name,
    p.p_type AS part_type,
    MIN(l.l_discount) AS min_discount,
    MAX(l.l_discount) AS max_discount
FROM part p
JOIN lineitem l ON p.p_partkey = l.l_partkey
WHERE p.p_type LIKE '%ECONOMY%' OR p.p_type LIKE '%COPPER%'
GROUP BY p.p_partkey, p.p_name, p.p_type
ORDER BY p.p_partkey;

SELECT COUNT(DISTINCT o.o_orderkey) AS distinct_orders_negative_customer_positive_supplier
FROM orders o
JOIN customer c ON o.o_custkey = c.c_custkey
JOIN lineitem l ON o.o_orderkey = l.l_orderkey
JOIN supplier s ON l.l_suppkey = s.s_suppkey
WHERE c.c_acctbal < 0 
    AND s.s_acctbal > 0;

SELECT 
    r.r_name AS region_name,
    MAX(s.s_acctbal) AS max_account_balance
FROM supplier s
JOIN nation n ON s.s_nationkey = n.n_nationkey
JOIN region r ON n.n_regionkey = r.r_regionkey
GROUP BY r.r_regionkey, r.r_name
HAVING MAX(s.s_acctbal) > 9000
ORDER BY max_account_balance DESC;

SELECT MIN(o.o_totalprice) AS min_order_total_price_cross_region
FROM orders o
JOIN customer c ON o.o_custkey = c.c_custkey
JOIN nation cn ON c.c_nationkey = cn.n_nationkey
JOIN region cr ON cn.n_regionkey = cr.r_regionkey
JOIN lineitem l ON o.o_orderkey = l.l_orderkey
JOIN supplier s ON l.l_suppkey = s.s_suppkey
JOIN nation sn ON s.s_nationkey = sn.n_nationkey
JOIN region sr ON sn.n_regionkey = sr.r_regionkey
WHERE cr.r_regionkey != sr.r_regionkey;

SELECT COUNT(*) AS line_items_asia_suppliers_kenya_customers
FROM lineitem l
JOIN supplier s ON l.l_suppkey = s.s_suppkey
JOIN nation sn ON s.s_nationkey = sn.n_nationkey
JOIN region sr ON sn.n_regionkey = sr.r_regionkey
JOIN orders o ON l.l_orderkey = o.o_orderkey
JOIN customer c ON o.o_custkey = c.c_custkey
JOIN nation cn ON c.c_nationkey = cn.n_nationkey
WHERE sr.r_name = 'ASIA'
    AND cn.n_name = 'KENYA';

WITH ranked_suppliers AS (
    SELECT 
        r.r_name AS region_name,
        s.s_name AS supplier_name,
        s.s_acctbal AS account_balance,
        ROW_NUMBER() OVER (PARTITION BY r.r_regionkey ORDER BY s.s_acctbal DESC) as rn
    FROM supplier s
    JOIN nation n ON s.s_nationkey = n.n_nationkey
    JOIN region r ON n.n_regionkey = r.r_regionkey
)
SELECT region_name, supplier_name, account_balance
FROM ranked_suppliers
WHERE rn = 1
ORDER BY region_name;


SELECT 
    n.n_name AS nation_name,
    COUNT(DISTINCT c.c_custkey) AS customer_count,
    COUNT(DISTINCT s.s_suppkey) AS supplier_count
FROM nation n
JOIN region r ON n.n_regionkey = r.r_regionkey
LEFT JOIN customer c ON n.n_nationkey = c.c_nationkey
LEFT JOIN supplier s ON n.n_nationkey = s.s_nationkey
WHERE r.r_name = 'AMERICA'
GROUP BY n.n_nationkey, n.n_name
ORDER BY n.n_name;

SELECT
    o.o_orderpriority AS order_priority,
    COUNT(*) AS line_item_count
FROM lineitem l
JOIN orders o ON l.l_orderkey = o.o_orderkey
WHERE l_receiptdate < l_commitdate AND o.o_orderdate LIKE '1995%' 
GROUP BY o.o_orderpriority
ORDER BY o.o_orderpriority;

SELECT 
    r.r_name AS region_name,
    COUNT(DISTINCT c.c_custkey) AS customer_count
FROM customer c
JOIN nation n ON c.c_nationkey = n.n_nationkey
JOIN region r ON n.n_regionkey = r.r_regionkey
JOIN orders o ON c.c_custkey = o.o_custkey
WHERE c.c_acctbal > (SELECT AVG(c_acctbal) FROM customer)
GROUP BY r.r_regionkey, r.r_name
ORDER BY r.r_name;

SELECT 
    COUNT(DISTINCT s.s_suppkey) AS supplier_count
FROM supplier s
JOIN partsupp ps ON s.s_suppkey = ps.ps_suppkey
JOIN part p ON ps.ps_partkey = p.p_partkey
WHERE p.p_type LIKE '%POLISHED%' 
    AND p.p_size IN (10, 20, 30, 40);

SELECT 
    (l.l_extendedprice * (1 - l.l_discount)) AS highest_value_line_item,
    p.p_name AS part_name
FROM lineitem l
JOIN part p ON l.l_partkey = p.p_partkey
WHERE l.l_shipdate > '1993-10-02'
    AND (l.l_extendedprice * (1 - l.l_discount)) = (
        SELECT MAX(l2.l_extendedprice * (1 - l2.l_discount))
        FROM lineitem l2
        WHERE l2.l_shipdate > '1993-10-02'
    )
ORDER BY p.p_name;

SELECT 
    s.s_name AS supplier_name,
    p.p_size AS part_size,
    ps.ps_supplycost AS max_supply_cost
FROM part p
JOIN partsupp ps ON p.p_partkey = ps.ps_partkey
JOIN supplier s ON ps.ps_suppkey = s.s_suppkey
JOIN nation n ON s.s_nationkey = n.n_nationkey
JOIN region r ON n.n_regionkey = r.r_regionkey
WHERE p.p_type LIKE '%STEEL%' 
    AND r.r_name = 'AMERICA'
    AND ps.ps_supplycost = (
        SELECT MAX(ps2.ps_supplycost)
        FROM part p2
        JOIN partsupp ps2 ON p2.p_partkey = ps2.ps_partkey
        JOIN supplier s2 ON ps2.ps_suppkey = s2.s_suppkey
        JOIN nation n2 ON s2.s_nationkey = n2.n_nationkey
        JOIN region r2 ON n2.n_regionkey = r2.r_regionkey
        WHERE p2.p_type LIKE '%STEEL%' 
            AND r2.r_name = 'AMERICA'
            AND p2.p_size = p.p_size
    )
ORDER BY p.p_type, s.s_name;

SELECT DISTINCT p.p_name AS part_name
FROM part p
JOIN partsupp ps ON p.p_partkey = ps.ps_partkey
JOIN supplier s ON ps.ps_suppkey = s.s_suppkey
JOIN nation n ON s.s_nationkey = n.n_nationkey
WHERE n.n_name = 'FRANCE'
    AND (ps.ps_supplycost * ps.ps_availqty) >= (
        SELECT MIN(total_value)
        FROM (
            SELECT (ps2.ps_supplycost * ps2.ps_availqty) AS total_value
            FROM partsupp ps2
            ORDER BY total_value DESC
            LIMIT (SELECT CAST(COUNT(*) * 0.05 AS INTEGER) FROM partsupp)
        ) top_5_percent
    )
ORDER BY p.p_name;

SELECT p.p_mfgr AS manufacturer_name
FROM supplier s 
JOIN partsupp ps ON s.s_suppkey = ps.ps_suppkey
JOIN part p ON ps.ps_partkey = p.p_partkey
WHERE s.s_name = 'Supplier#000000040'
    AND ps.ps_availqty = (
        SELECT MIN(ps2.ps_availqty) 
        FROM supplier s2
        JOIN partsupp ps2 ON s2.s_suppkey = ps2.ps_suppkey
        WHERE s2.s_name = 'Supplier#000000040'        
    );

SELECT 
    r.r_name AS region_name,
    COUNT(*) AS supplier_above_region_avg
FROM supplier s
JOIN nation n ON s.s_nationkey = n.n_nationkey
JOIN region r ON n.n_regionkey = r.r_regionkey
WHERE s.s_acctbal > (
    SELECT AVG(s2.s_acctbal) 
    FROM supplier s2
    JOIN nation n2 ON s2.s_nationkey = n2.n_nationkey
    WHERE n2.n_regionkey = r.r_regionkey
)
GROUP BY r.r_regionkey, r.r_name
ORDER BY r.r_name;

SELECT 
    COUNT (*) AS customer_not_from_europe_or_asia
FROM customer c
JOIN nation n ON c.c_nationkey = n.n_nationkey
JOIN region r ON n.n_regionkey = r.r_regionkey
WHERE r.r_name NOT IN ('EUROPE', 'ASIA');

SELECT SUM(ps.ps_supplycost) AS total_supply_cost
FROM part p
JOIN partsupp ps ON p.p_partkey = ps.ps_partkey
JOIN supplier s ON ps.ps_suppkey = s.s_suppkey
JOIN lineitem l ON p.p_partkey = l.l_partkey AND ps.ps_suppkey = l.l_suppkey
WHERE p.p_retailprice < 2000 
    AND l.l_shipdate LIKE '1994%'
    AND s.s_suppkey NOT IN (
        SELECT DISTINCT l2.l_suppkey
        FROM lineitem l2
        WHERE l2.l_extendedprice < 1000
            AND l2.l_shipdate LIKE '1997%'
);

SELECT 
    o.o_orderpriority AS order_priority,
    COUNT(DISTINCT o.o_orderkey) AS orders_with_late_receipt
FROM orders o
WHERE o.o_orderdate LIKE '1995%'
    AND EXISTS (
        SELECT 1
        FROM lineitem l
        WHERE l.l_orderkey = o.o_orderkey
            AND l.l_receiptdate > l.l_commitdate
    )
GROUP BY o.o_orderpriority
ORDER BY o.o_orderpriority;

SELECT 
    sr.r_name AS supplier_region,
    cr.r_name AS customer_region,
    strftime('%Y', l.l_shipdate) AS year,
    SUM(l.l_extendedprice * (1 - l.l_discount)) AS revenue
FROM lineitem l
JOIN supplier s ON l.l_suppkey = s.s_suppkey
JOIN nation sn ON s.s_nationkey = sn.n_nationkey
JOIN region sr ON sn.n_regionkey = sr.r_regionkey
JOIN orders o ON l.l_orderkey = o.o_orderkey
JOIN customer c ON o.o_custkey = c.c_custkey
JOIN nation cn ON c.c_nationkey = cn.n_nationkey
JOIN region cr ON cn.n_regionkey = cr.r_regionkey
WHERE strftime('%Y', l.l_shipdate) IN ('1994', '1995')
    AND sr.r_regionkey != cr.r_regionkey
GROUP BY sr.r_regionkey, sr.r_name, cr.r_regionkey, cr.r_name, strftime('%Y', l.l_shipdate)
ORDER BY supplier_region, customer_region, year;

SELECT 
    ROUND(
        (france_revenue * 100.0 / total_america_revenue), 4
    ) AS france_market_share_percentage
FROM (
    SELECT 
        SUM(CASE 
            WHEN sn.n_name = 'FRANCE' 
            THEN l.l_extendedprice * (1 - l.l_discount) 
            ELSE 0 
        END) AS france_revenue,
        SUM(l.l_extendedprice * (1 - l.l_discount)) AS total_america_revenue
    FROM lineitem l
    JOIN supplier s ON l.l_suppkey = s.s_suppkey
    JOIN nation sn ON s.s_nationkey = sn.n_nationkey
    JOIN orders o ON l.l_orderkey = o.o_orderkey
    JOIN customer c ON o.o_custkey = c.c_custkey
    JOIN nation cn ON c.c_nationkey = cn.n_nationkey
    JOIN region cr ON cn.n_regionkey = cr.r_regionkey
    WHERE cr.r_name = 'AMERICA'
        AND strftime('%Y', l.l_shipdate) = '1994'
) market_data;

SELECT MAX(l.l_discount) AS largest_discount_below_average
FROM lineitem l
JOIN orders o ON l.l_orderkey = o.o_orderkey
WHERE o.o_orderdate LIKE '1994-10%'
    AND l.l_discount < (
        SELECT AVG(l2.l_discount)
        FROM lineitem l2
    );