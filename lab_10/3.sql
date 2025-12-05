DROP TRIGGER IF EXISTS t3;

CREATE TRIGGER t3 AFTER UPDATE ON orders
FOR EACH ROW
WHEN (OLD.c_acctbal < 0 AND NEW.c_acctbal > 0)
BEGIN
    UPDATE customer SET c_comment = 'Positive balance!!!' WHERE c_custkey = NEW.c_custkey;
END;

UPDATE customer
SET c_acctbal = 100
WHERE c_custkey IN (
    SELECT c.c_custkey
    FROM customer c
    JOIN nation n ON c.c_nationkey = n.n_nationkey
    WHERE n.n_name = 'MOZAMBIQUE'
);

SELECT COUNT(*) AS num_customers_with_positive_balance_mozambique
FROM customer c
JOIN nation n ON c.c_nationkey = n.n_nationkey
JOIN region r ON n.n_regionkey = r.r_regionkey
WHERE r.r_name = 'AFRICA'
    AND c.c_acctbal < 0;