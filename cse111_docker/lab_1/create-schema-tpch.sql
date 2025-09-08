-- TPC-H Schema for SQLite
-- This file contains the CREATE TABLE statements for all TPC-H benchmark tables

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
