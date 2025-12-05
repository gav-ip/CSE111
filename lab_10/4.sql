DROP TRIGGER IF EXISTS t3;
DROP TRIGGER IF EXISTS t4_insert;
DROP TRIGGER IF EXISTS t4_delete;

-- Trigger t4: Update o_orderpriority to '2-HIGH' when a lineitem is added or deleted
-- (Implemented as two triggers: t4_insert and t4_delete)
CREATE TRIGGER t4_insert AFTER INSERT ON lineitem
FOR EACH ROW
BEGIN
    UPDATE orders SET o_orderpriority = '2-HIGH' WHERE o_orderkey = NEW.l_orderkey;
END;

CREATE TRIGGER t4_delete AFTER DELETE ON lineitem
FOR EACH ROW
BEGIN
    UPDATE orders SET o_orderpriority = '2-HIGH' WHERE o_orderkey = OLD.l_orderkey;
END;

-- Delete all lineitems corresponding to orders from December 1995
DELETE FROM lineitem
WHERE l_orderkey IN (
    SELECT o.o_orderkey
    FROM orders o
    WHERE strftime('%Y', o.o_orderdate) = '1995' AND strftime('%m', o.o_orderdate) = '12'
);

-- Query to return the number of HIGH priority orders in September-December 1995
SELECT COUNT(*) AS num_high_priority_orders
FROM orders
WHERE o_orderpriority = '2-HIGH'
    AND strftime('%Y', o_orderdate) = '1995'
    AND strftime('%m', o_orderdate) IN ('09', '10', '11', '12');

