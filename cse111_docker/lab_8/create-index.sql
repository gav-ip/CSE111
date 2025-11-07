-- Test 2: customer(c_mktsegment)
CREATE INDEX customeridxcmktsegment ON customer(c_mktsegment);

-- Test 3: customer(c_name)
CREATE INDEX customeridxcname ON customer(c_name);

-- Test 4: supplier(s_acctbal)
CREATE INDEX supplieridxsacctbal ON supplier(s_acctbal);

-- Test 5: lineitem(l_receiptdate, l_returnflag)
CREATE INDEX lineitemidxlreceiptdatelreturnflag ON lineitem(l_receiptdate, l_returnflag);

-- Test 6: supplier(s_nationkey)
CREATE INDEX supplieridxsnationkey ON supplier(s_nationkey);

-- Test 7: orders(o_custkey, o_orderdate)
CREATE INDEX ordersidxocustkeyoorderdate ON orders(o_custkey, o_orderdate);

-- Test 8: nation(n_nationkey, n_name)
CREATE INDEX nationidxnnationkeynname ON nation(n_nationkey, n_name);

-- Test 9: lineitem(l_orderkey)
CREATE INDEX lineitemidxlorderkey ON lineitem(l_orderkey);

-- Test 10: supplier(s_nationkey, s_acctbal)
CREATE INDEX supplieridxsnationkeysacctbal ON supplier(s_nationkey, s_acctbal);

-- Test 11: customer(c_custkey, c_nationkey)
CREATE INDEX customeridxccustkeycnationkey ON customer(c_custkey, c_nationkey);

-- Test 12: nation(n_nationkey, n_name) - duplicate of test 8, but creating anyway
-- CREATE INDEX nationidxnnationkeynname ON nation(n_nationkey, n_name);

-- Test 13: supplier(s_suppkey, s_name)
CREATE INDEX supplieridxssuppkeysname ON supplier(s_suppkey, s_name);

-- Test 14: region(r_regionkey, r_name)
CREATE INDEX regionidxrregionkeyrname ON region(r_regionkey, r_name);

-- Test 15: nation(n_regionkey, n_nationkey)
CREATE INDEX nationidxnregionkeynnationkey ON nation(n_regionkey, n_nationkey);
