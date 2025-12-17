DROP TRIGGER IF EXISTS t1;
-- Trigger t1: Automatically set o_orderdate to '2025-12-01' for every new order entry
CREATE TRIGGER t1 AFTER INSERT ON orders
FOR EACH ROW
BEGIN
    UPDATE orders SET o_orderdate = '2025-12-01' WHERE o_orderkey = NEW.o_orderkey;
END;

-- Insert all orders from December 1995, preserving o_orderkey
INSERT OR REPLACE INTO orders
SELECT * FROM orders
WHERE strftime('%Y', o_orderdate) = '1995' AND strftime('%m', o_orderdate) = '12';

-- Query to return the number of orders from 2025
SELECT COUNT(*) AS num_orders_2025
FROM orders
WHERE strftime('%Y', o_orderdate) = '2025';
