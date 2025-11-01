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


def createTable(_conn):
    print("++++++++++++++++++++++++++++++++++")
    print("Create table")
    cur = _conn.execute("""
    CREATE TABLE IF NOT EXISTS warehouse (
        w_warehousekey INTEGER PRIMARY KEY,
        w_name TEXT NOT NULL,
        w_capacity INTEGER NOT NULL,
        w_location TEXT NOT NULL,
        w_suppkey INTEGER NOT NULL,
        w_nationkey INTEGER NOT NULL
    );
    """)
    print("++++++++++++++++++++++++++++++++++")


def dropTable(_conn):
    print("++++++++++++++++++++++++++++++++++")
    print("Drop tables")
    cur = _conn.execute("""
    DROP TABLE IF EXISTS warehouse;
    """)
    print("++++++++++++++++++++++++++++++++++")


def populateTable(_conn):
    print("++++++++++++++++++++++++++++++++++")
    print("Populate table")

    try:
        # Get all suppliers
        suppliers = _conn.execute("""
            SELECT s_suppkey, s_name 
            FROM supplier 
            ORDER BY s_suppkey
        """)
        
        suppliers = suppliers.fetchall()
        
        warehouse_key = 1
        
        for supplier_key, supplier_name in suppliers:
            # Step 1: Find nations with largest number of lineitems supplied by this supplier
            # that are ordered by customers from that nation
            # Group by customer nation, count lineitems, order by count DESC, then by nation name ASC
            nations_query = """
                SELECT 
                    cn.n_nationkey,
                    cn.n_name,
                    COUNT(*) as lineitem_count
                FROM lineitem l
                JOIN orders o ON l.l_orderkey = o.o_orderkey
                JOIN customer c ON o.o_custkey = c.c_custkey
                JOIN nation cn ON c.c_nationkey = cn.n_nationkey
                WHERE l.l_suppkey = ?
                GROUP BY cn.n_nationkey, cn.n_name
                ORDER BY lineitem_count DESC, cn.n_name ASC
                LIMIT 3
            """
            top_nations = _conn.execute(nations_query, (supplier_key,)).fetchall()
            
            if not top_nations:
                continue
            
            # Step 2: Calculate capacity for this supplier
            # For each nation, compute total part size (p_size) supplied by supplier to customers in that nation
            # Then take triple of maximum total part size across all nations
            capacity_query = """
                SELECT 
                    cn.n_nationkey,
                    SUM(p.p_size) as total_part_size
                FROM lineitem l
                JOIN orders o ON l.l_orderkey = o.o_orderkey
                JOIN customer c ON o.o_custkey = c.c_custkey
                JOIN nation cn ON c.c_nationkey = cn.n_nationkey
                JOIN part p ON l.l_partkey = p.p_partkey
                WHERE l.l_suppkey = ?
                GROUP BY cn.n_nationkey
            """
            nation_sizes = _conn.execute(capacity_query, (supplier_key,)).fetchall()
            
            if nation_sizes:
                max_total_size = max(row[1] for row in nation_sizes)
                capacity = max_total_size * 3
            else:
                capacity = 0
            
            # Step 3: Create 3 warehouses (one for each top nation)
            for nation_key, nation_name, _ in top_nations:
                warehouse_name = f"{supplier_name} {nation_name}"
                
                insert_query = """
                    INSERT INTO warehouse (w_warehousekey, w_name, w_capacity, w_location, w_suppkey, w_nationkey)
                    VALUES (?, ?, ?, ?, ?, ?)
                """
                _conn.execute(insert_query, (warehouse_key, warehouse_name, capacity, nation_name, supplier_key, nation_key))
                warehouse_key += 1
        
        _conn.commit()
        
    except Error as e:
        print(e)

    print("++++++++++++++++++++++++++++++++++")


def Q1(_conn):
    print("++++++++++++++++++++++++++++++++++")
    print("Q1")

    try:
        output = open('output/1.out', 'w')

        cur = _conn.execute("""
        SELECT w.w_warehousekey, w.w_name, w.w_capacity, w.w_suppkey, w.w_nationkey
        FROM warehouse w
        ORDER BY w.w_warehousekey
        """)
        
        warehouses = cur.fetchall()
        
        header = "{:>10} {:<40} {:>10} {:>10} {:>10}"
        output.write((header.format("wId", "wName", "wCap", "sId", "nId")) + '\n')
        
        for warehouse in warehouses:
            output.write((header.format(
                warehouse[0], 
                warehouse[1], 
                warehouse[2], 
                warehouse[3], 
                warehouse[4]
            )) + '\n')

        for row in warehouses:
            line = header.format(row[0], row[1], row[2], row[3], row[4])
            print(line)
            output.write(line + '\n')

        output.close()
    except Error as e:
        print(e)

    print("++++++++++++++++++++++++++++++++++")


def Q2(_conn):
    print("++++++++++++++++++++++++++++++++++")
    print("Q2")

    try:
        output = open('output/2.out', 'w')

        cur = _conn.execute("""
            SELECT 
                n.n_name,
                COUNT(*) as numW,
                SUM(w.w_capacity) as totCap
            FROM warehouse w
            JOIN nation n ON w.w_nationkey = n.n_nationkey
            GROUP BY n.n_nationkey, n.n_name
            ORDER BY numW DESC, totCap DESC, n.n_name ASC
        """)
        
        results = cur.fetchall()
        
        header = "{:<40} {:>10} {:>10}"
        output.write((header.format("nation", "numW", "totCap")) + '\n')
        
        for row in results:
            output.write((header.format(row[0], row[1], row[2])) + '\n')

    
        for row in results:
            line = header.format(row[0], row[1], row[2])
            print(line)
            output.write(line + '\n')

        output.close()
    except Error as e:
        print(e)

    print("++++++++++++++++++++++++++++++++++")


def Q3(_conn):
    print("++++++++++++++++++++++++++++++++++")
    print("Q3")

    try:
        input_file = open("input/3.in", "r")
        nation = input_file.readline().strip()
        input_file.close()

        output = open('output/3.out', 'w')

        cur = _conn.execute("""
            SELECT 
                s.s_name,
                sn.n_name,
                w.w_name
            FROM warehouse w
            JOIN nation wn ON w.w_nationkey = wn.n_nationkey
            JOIN supplier s ON w.w_suppkey = s.s_suppkey
            JOIN nation sn ON s.s_nationkey = sn.n_nationkey
            WHERE wn.n_name = ?
            ORDER BY s.s_name ASC
        """, (nation,))
        
        results = cur.fetchall()
        
        header = "{:<20} {:<20} {:<40}"
        header_line = header.format("supplier", "nation", "warehouse")
        print(header_line)
        output.write(header_line + '\n')
        
        for row in results:
            line = header.format(row[0], row[1], row[2])
            print(line)
            output.write(line + '\n')

        output.close()
    except Error as e:
        print(e)

    print("++++++++++++++++++++++++++++++++++")


def Q4(_conn):
    print("++++++++++++++++++++++++++++++++++")
    print("Q4")

    try:
        input_file = open("input/4.in", "r")
        region = input_file.readline().strip()
        cap = int(input_file.readline().strip())
        input_file.close()

        cur = _conn.execute("""
            SELECT 
                w.w_name,
                w.w_capacity
            FROM warehouse w
            JOIN nation n ON w.w_nationkey = n.n_nationkey
            JOIN region r ON n.n_regionkey = r.r_regionkey
            WHERE r.r_name = ? AND w.w_capacity > ?
            ORDER BY w.w_capacity DESC
        """, (region, cap))

        results = cur.fetchall()

        output = open('output/4.out', 'w')

        header = "{:<40} {:>10}"
        header_line = header.format("warehouse", "capacity")
        print(header_line)
        output.write(header_line + '\n')
        
        for row in results:
            line = header.format(row[0], row[1])
            print(line)
            output.write(line + '\n')

        output.close()
    except Error as e:
        print(e)

    print("++++++++++++++++++++++++++++++++++")


def Q5(_conn):
    print("++++++++++++++++++++++++++++++++++")
    print("Q5")

    try:
        input_file = open("input/5.in", "r")
        nation = input_file.readline().strip()
        input_file.close()

        cur = _conn.execute("""
            SELECT 
                r.r_name,
                COALESCE(SUM(w.w_capacity), 0) as capacity
            FROM region r
            LEFT JOIN nation n ON r.r_regionkey = n.n_regionkey
            LEFT JOIN (
                SELECT w.w_nationkey, w.w_capacity
                FROM warehouse w
                JOIN supplier s ON w.w_suppkey = s.s_suppkey
                JOIN nation sn ON s.s_nationkey = sn.n_nationkey
                WHERE sn.n_name = ?
            ) w ON n.n_nationkey = w.w_nationkey
            GROUP BY r.r_regionkey, r.r_name
            ORDER BY r.r_name ASC
        """, (nation,))

        results = cur.fetchall()

        output = open('output/5.out', 'w')

        header = "{:<20} {:>20}"
        header_line = header.format("region", "capacity")
        print(header_line)
        output.write(header_line + '\n')
        
        for row in results:
            line = header.format(row[0], row[1])
            print(line)
            output.write(line + '\n')

        output.close()
    except Error as e:
        print(e)

    print("++++++++++++++++++++++++++++++++++")


def main():
    database = r"data/tpch.sqlite"

    # create a database connection
    conn = openConnection(database)
    with conn:
        dropTable(conn)
        createTable(conn)
        populateTable(conn)

        Q1(conn)
        Q2(conn)
        Q3(conn)
        Q4(conn)
        Q5(conn)

    closeConnection(conn, database)


if __name__ == '__main__':
    main()
