DROP TRIGGER IF EXISTS t5;

-- Trigger t5: Remove all tuples from partsupp and lineitem when a part is deleted
CREATE TRIGGER t5 BEFORE DELETE ON part
FOR EACH ROW
BEGIN
    DELETE FROM partsupp WHERE ps_partkey = OLD.p_partkey;
    DELETE FROM lineitem WHERE l_partkey = OLD.p_partkey;
END;

-- Delete all parts supplied by suppliers from KENYA or MOROCCO
DELETE FROM part
WHERE p_partkey IN (
    SELECT DISTINCT ps.ps_partkey
    FROM partsupp ps
    JOIN supplier s ON ps.ps_suppkey = s.s_suppkey
    JOIN nation n ON s.s_nationkey = n.n_nationkey
    WHERE n.n_name IN ('KENYA', 'MOROCCO')
);

-- Query to return the number of parts supplied by every supplier in AFRICA grouped by country in increasing order
SELECT n.n_name AS country, COUNT(DISTINCT ps.ps_partkey) AS num_parts
FROM partsupp ps
JOIN supplier s ON ps.ps_suppkey = s.s_suppkey
JOIN nation n ON s.s_nationkey = n.n_nationkey
JOIN region r ON n.n_regionkey = r.r_regionkey
WHERE r.r_name = 'AFRICA'
GROUP BY n.n_name
ORDER BY n.n_name ASC;

