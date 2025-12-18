import sqlite3
from sqlite3 import Error


def openConnection(_dbFile):
    print("++++++++++++++++++++++++++++++++++")
    print("Open database: ", _dbFile)

    conn = None
    try:
        conn = sqlite3.connect(_dbFile)
        print("success")
    except Error as e:
        print(e)

    print("++++++++++++++++++++++++++++++++++")

    return conn

def closeConnection(_conn, _dbFile):
    print("++++++++++++++++++++++++++++++++++")
    print("Close database: ", _dbFile)

    try:
        _conn.close()
        print("success")
    except Error as e:
        print(e)

    print("++++++++++++++++++++++++++++++++++")


def create_View1(_conn):
    print("++++++++++++++++++++++++++++++++++")
    print("Create V1")

    try:
        sql = """
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
        """
        _conn.executescript(sql)
        print("success")
    except Error as e:
        print(e)

    print("++++++++++++++++++++++++++++++++++")


def Q1(_conn):
    print("++++++++++++++++++++++++++++++++++")
    print("Q1")

    try:
        sql = """
            select cnation as country, count(*) as cnt
            from orders, V1
            where ccustkey = o_custkey
                and cregion = 'EUROPE'
            group by cnation;
        """
        cur = _conn.cursor()
        cur.execute(sql)
        rows = cur.fetchall()

        output = open('output/1.out', 'w')
        header = "{}|{}"
        output.write((header.format("country", "cnt")) + '\n')
        for row in rows:
            output.write((header.format(row[0], row[1])) + '\n')
        output.close()
    except Error as e:
        print(e)

    print("++++++++++++++++++++++++++++++++++")


def create_View2(_conn):
    print("++++++++++++++++++++++++++++++++++")
    print("Create V2")

    try:
        sql = """
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
        """
        _conn.executescript(sql)
        print("success")
    except Error as e:
        print(e)

    print("++++++++++++++++++++++++++++++++++")


def Q2(_conn):
    print("++++++++++++++++++++++++++++++++++")
    print("Q2")

    try:
        sql = """
            select cname as customer, count(*) as cnt
            from V1, V2
            where ocustkey = ccustkey
                and cnation = 'EGYPT'
                and oorderyear = 1992
            group by cname;
        """
        cur = _conn.cursor()
        cur.execute(sql)
        rows = cur.fetchall()

        output = open('output/2.out', 'w')
        header = "{}|{}"
        output.write((header.format("customer", "cnt")) + '\n')
        for row in rows:
            output.write((header.format(row[0], row[1])) + '\n')
        output.close()
    except Error as e:
        print(e)

    print("++++++++++++++++++++++++++++++++++")


def Q3(_conn):
    print("++++++++++++++++++++++++++++++++++")
    print("Q3")

    try:
        sql = """
            select cname as customer, sum(o_totalprice) as total_price
            from orders, V1
            where o_custkey = ccustkey
                and cnation = 'ARGENTINA'
                and o_orderdate like '1996-%'
            group by cname;
        """
        cur = _conn.cursor()
        cur.execute(sql)
        rows = cur.fetchall()

        output = open('output/3.out', 'w')
        header = "{}|{}"
        output.write((header.format("customer", "total_price")) + '\n')
        for row in rows:
            output.write((header.format(row[0], row[1])) + '\n')
        output.close()
    except Error as e:
        print(e)

    print("++++++++++++++++++++++++++++++++++")


def create_View4(_conn):
    print("++++++++++++++++++++++++++++++++++")
    print("Create V4")

    try:
        sql = """
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
        """
        _conn.executescript(sql)
        print("success")
    except Error as e:
        print(e)

    print("++++++++++++++++++++++++++++++++++")


def Q4(_conn):
    print("++++++++++++++++++++++++++++++++++")
    print("Q4")

    try:
        sql = """
            select sname as supplier, count(*) as cnt
            from partsupp, V4, part
            where ps_partkey = p_partkey
                and ps_suppkey = ssuppkey
                and snation = 'KENYA'
                and p_container LIKE '%BOX%'
            group by sname;
        """
        cur = _conn.cursor()
        cur.execute(sql)
        rows = cur.fetchall()

        output = open('output/4.out', 'w')
        header = "{}|{}"
        output.write((header.format("supplier", "cnt")) + '\n')
        for row in rows:
            output.write((header.format(row[0], row[1])) + '\n')
        output.close()
    except Error as e:
        print(e)

    print("++++++++++++++++++++++++++++++++++")


def Q5(_conn):
    print("++++++++++++++++++++++++++++++++++")
    print("Q5")

    try:
        sql = """
            select snation as country, count(*) as cnt
            from V4
            where snation = 'ARGENTINA' OR snation = 'BRAZIL'
            group by snation;
        """
        cur = _conn.cursor()
        cur.execute(sql)
        rows = cur.fetchall()

        output = open('output/5.out', 'w')
        header = "{}|{}"
        output.write((header.format("country", "cnt")) + '\n')
        for row in rows:
            output.write((header.format(row[0], row[1])) + '\n')
        output.close()
    except Error as e:
        print(e)

    print("++++++++++++++++++++++++++++++++++")


def Q6(_conn):
    print("++++++++++++++++++++++++++++++++++")
    print("Q6")

    try:
        sql = """
            select s_name as supplier, oorderpriority as priority, count(distinct ps_partkey) as parts
            from V2, lineitem, partsupp, supplier, nation
            where l_orderkey = oorderkey
                and l_partkey = ps_partkey
                and l_suppkey = ps_suppkey
                and ps_suppkey = s_suppkey
                and s_nationkey = n_nationkey
                and n_name = 'INDONESIA'
            group by s_name, oorderpriority;
        """
        cur = _conn.cursor()
        cur.execute(sql)
        rows = cur.fetchall()

        output = open('output/6.out', 'w')
        header = "{}|{}|{}"
        output.write((header.format("supplier", "priority", "parts")) + '\n')
        for row in rows:
            output.write((header.format(row[0], row[1], row[2])) + '\n')
        output.close()
    except Error as e:
        print(e)

    print("++++++++++++++++++++++++++++++++++")


def Q7(_conn):
    print("++++++++++++++++++++++++++++++++++")
    print("Q7")

    try:
        sql = """
            select cnation as country, oorderstatus as status, count(*) as orders
            from V1, V2
            where ocustkey = ccustkey
                and cregion = 'AFRICA'
            group by cnation, oorderstatus;
        """
        cur = _conn.cursor()
        cur.execute(sql)
        rows = cur.fetchall()

        output = open('output/7.out', 'w')
        header = "{}|{}|{}"
        output.write((header.format("country", "status", "orders")) + '\n')
        for row in rows:
            output.write((header.format(row[0], row[1], row[2])) + '\n')
        output.close()
    except Error as e:
        print(e)

    print("++++++++++++++++++++++++++++++++++")


def Q8(_conn):
    print("++++++++++++++++++++++++++++++++++")
    print("Q8")

    try:
        sql = """
            select count(distinct oclerk) as clerks
            from V2, V4, lineitem
            where oorderkey = l_orderkey
                and l_suppkey = ssuppkey
                and snation = 'PERU';
        """
        cur = _conn.cursor()
        cur.execute(sql)
        rows = cur.fetchall()

        output = open('output/8.out', 'w')
        header = "{}"
        output.write((header.format("clerks")) + '\n')
        for row in rows:
            output.write((header.format(row[0])) + '\n')
        output.close()
    except Error as e:
        print(e)

    print("++++++++++++++++++++++++++++++++++")


def Q9(_conn):
    print("++++++++++++++++++++++++++++++++++")
    print("Q9")

    try:
        sql = """
            select snation as country, count(distinct l_orderkey) as cnt
            from V2, V4, lineitem
            where oorderkey = l_orderkey
                and l_suppkey = ssuppkey
                and snation = 'PERU'
            group by snation
            having cnt > 200;
        """
        cur = _conn.cursor()
        cur.execute(sql)
        rows = cur.fetchall()

        output = open('output/9.out', 'w')
        header = "{}|{}"
        output.write((header.format("country", "cnt")) + '\n')
        for row in rows:
            output.write((header.format(row[0], row[1])) + '\n')
        output.close()
    except Error as e:
        print(e)

    print("++++++++++++++++++++++++++++++++++")


def create_View10(_conn):
    print("++++++++++++++++++++++++++++++++++")
    print("Create V10")

    try:
        sql = """
            DROP VIEW IF EXISTS V10;
            CREATE VIEW V10 AS 
            SELECT
                part.p_type as ptype,
                MIN(l_discount) as mindiscount,
                MAX(l_discount) as maxdiscount
            FROM part, lineitem
            WHERE part.p_partkey = lineitem.l_partkey
            GROUP BY part.p_type;
        """
        _conn.executescript(sql)
        print("success")
    except Error as e:
        print(e)

    print("++++++++++++++++++++++++++++++++++")


def Q10(_conn):
    print("++++++++++++++++++++++++++++++++++")
    print("Q10")

    try:
        sql = """
            select ptype as part_type, mindiscount as min_disc, maxdiscount as max_disc
            from V10
            where ptype like '%ECONOMY%'
                or ptype like '%COPPER%'
            group by ptype;
        """
        cur = _conn.cursor()
        cur.execute(sql)
        rows = cur.fetchall()

        output = open('output/10.out', 'w')
        header = "{}|{}|{}"
        output.write((header.format("part_type", "min_disc", "max_disc")) + '\n')
        for row in rows:
            output.write((header.format(row[0], row[1], row[2])) + '\n')
        output.close()
    except Error as e:
        print(e)

    print("++++++++++++++++++++++++++++++++++")


def create_View111(_conn):
    print("++++++++++++++++++++++++++++++++++")
    print("Create V111")

    try:
        sql = """
            DROP VIEW IF EXISTS V111;
            CREATE VIEW V111 AS
            SELECT
                c.c_custkey as ccustkey,
                c.c_name as cname,
                c.c_nationkey as cnationkey,
                c.c_acctbal as cacctbal
            FROM customer c
            WHERE c.c_acctbal < 0;
        """
        _conn.executescript(sql)
        print("success")
    except Error as e:
        print(e)

    print("++++++++++++++++++++++++++++++++++")


def create_View112(_conn):
    print("++++++++++++++++++++++++++++++++++")
    print("Create V112")

    try:
        sql = """
            DROP VIEW IF EXISTS V112;
            CREATE VIEW V112 AS
            SELECT
                s.s_suppkey as ssuppkey,
                s.s_name as sname,
                s.s_nationkey as snationkey,
                s.s_acctbal as sacctbal
            FROM supplier s
            WHERE s.s_acctbal > 0;
        """
        _conn.executescript(sql)
        print("success")
    except Error as e:
        print(e)

    print("++++++++++++++++++++++++++++++++++")


def Q11(_conn):
    print("++++++++++++++++++++++++++++++++++")
    print("Q11")

    try:
        sql = """
            select count(distinct l_orderkey) as order_cnt
            from lineitem, V111, V112, V2
            where l_suppkey = ssuppkey
                and l_orderkey = oorderkey
                and ocustkey = ccustkey
                and cacctbal < 0
                and sacctbal > 0;
        """
        cur = _conn.cursor()
        cur.execute(sql)
        rows = cur.fetchall()

        output = open('output/11.out', 'w')
        header = "{}"
        output.write((header.format("order_cnt")) + '\n')
        for row in rows:
            output.write((header.format(row[0])) + '\n')
        output.close()
    except Error as e:
        print(e)

    print("++++++++++++++++++++++++++++++++++")


def Q12(_conn):
    print("++++++++++++++++++++++++++++++++++")
    print("Q12")

    try:
        sql = """
            select sregion as region, max(sacctbal) as max_bal
            from V4
            group by sregion
            having max_bal > 9000;
        """
        cur = _conn.cursor()
        cur.execute(sql)
        rows = cur.fetchall()

        output = open('output/12.out', 'w')
        header = "{}|{}"
        output.write((header.format("region", "max_bal")) + '\n')
        for row in rows:
            output.write((header.format(row[0], row[1])) + '\n')
        output.close()
    except Error as e:
        print(e)

    print("++++++++++++++++++++++++++++++++++")


def Q13(_conn):
    print("++++++++++++++++++++++++++++++++++")
    print("Q13")

    try:
        sql = """
            select sregion as supp_region, cregion as cust_region, min(o_totalprice) as min_price
            from V1, V4, orders, lineitem
            where l_suppkey = ssuppkey
                and l_orderkey = o_orderkey
                and o_custkey = ccustkey
            group by sregion, cregion;
        """
        cur = _conn.cursor()
        cur.execute(sql)
        rows = cur.fetchall()

        output = open('output/13.out', 'w')
        header = "{}|{}|{}"
        output.write((header.format("supp_region", "cust_region", "min_price")) + '\n')
        for row in rows:
            output.write((header.format(row[0], row[1], row[2])) + '\n')
        output.close()
    except Error as e:
        print(e)

    print("++++++++++++++++++++++++++++++++++")


def Q14(_conn):
    print("++++++++++++++++++++++++++++++++++")
    print("Q14")

    try:
        sql = """
            select count(*) as items
            from V1, V4, orders, lineitem
            where o_custkey = ccustkey
                and l_orderkey = o_orderkey
                and l_suppkey = ssuppkey
                and sregion = 'ASIA'
                and cnation = 'KENYA';
        """
        cur = _conn.cursor()
        cur.execute(sql)
        rows = cur.fetchall()

        output = open('output/14.out', 'w')
        header = "{}"
        output.write((header.format("items")) + '\n')
        for row in rows:
            output.write((header.format(row[0])) + '\n')
        output.close()
    except Error as e:
        print(e)

    print("++++++++++++++++++++++++++++++++++")


def Q15(_conn):
    print("++++++++++++++++++++++++++++++++++")
    print("Q15")

    try:
        sql = """
            select sregion as region, sname as supplier, sacctbal as acct_bal
            from V4 v1
            where sacctbal = (select max(sacctbal) 
                              from V4 v2 
                              where v2.sregion = v1.sregion);
        """
        cur = _conn.cursor()
        cur.execute(sql)
        rows = cur.fetchall()

        output = open('output/15.out', 'w')
        header = "{}|{}|{}"
        output.write((header.format("region", "supplier", "acct_bal")) + '\n')
        for row in rows:
            output.write((header.format(row[0], row[1], row[2])) + '\n')
        output.close()
    except Error as e:
        print(e)

    print("++++++++++++++++++++++++++++++++++")


def main():
    database = r"tpch.sqlite"

    # create a database connection
    conn = openConnection(database)
    with conn:
        create_View1(conn)
        Q1(conn)

        create_View2(conn)
        Q2(conn)

        Q3(conn)

        create_View4(conn)
        Q4(conn)

        Q5(conn)
        Q6(conn)
        Q7(conn)
        Q8(conn)
        Q9(conn)

        create_View10(conn)
        Q10(conn)

        create_View111(conn)
        create_View112(conn)
        Q11(conn)

        Q12(conn)
        Q13(conn)
        Q14(conn)
        Q15(conn)

    closeConnection(conn, database)


if __name__ == '__main__':
    main()
