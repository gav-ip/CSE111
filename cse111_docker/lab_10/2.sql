DROP TRIGGER IF EXISTS t2;

-- Trigger t2: Set warning "Negative balance!!!" in c_comment when c_acctbal is updated 
-- from positive to negative
CREATE TRIGGER t2 AFTER UPDATE ON customer
FOR EACH ROW
WHEN (OLD.c_acctbal > 0 AND NEW.c_acctbal < 0)
BEGIN
    UPDATE customer SET c_comment = 'Negative balance!!!' WHERE c_custkey = NEW.c_custkey;
END;

-- Set balance to -100 for all customers in AFRICA
UPDATE customer
SET c_acctbal = -100
WHERE c_custkey IN (
    SELECT c.c_custkey
    FROM customer c
    JOIN nation n ON c.c_nationkey = n.n_nationkey
    JOIN region r ON n.n_regionkey = r.r_regionkey
    WHERE r.r_name = 'AFRICA'
);

-- Query to return the number of customers with negative balance from EGYPT
SELECT COUNT(*) AS num_negative_balance_egypt
FROM customer c
JOIN nation n ON c.c_nationkey = n.n_nationkey
WHERE n.n_name = 'EGYPT'
    AND c.c_acctbal < 0;
