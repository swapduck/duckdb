CREATE TABLE skewed_orders AS
    SELECT 1 AS o_orderkey, range AS o_custkey, random() AS o_totalprice
    FROM range(1500000)
UNION ALL
    SELECT range AS o_orderkey, range AS o_custkey, random() AS o_totalprice
    FROM range(2, 10000);
    
CREATE TABLE skewed_lineitem AS
    SELECT 1 AS l_orderkey, range AS l_partkey
    FROM range(4000000)
UNION ALL
    SELECT range AS l_orderkey, range AS l_partkey
    FROM range(2, 10000);
SET memory_limit = '150MB';

EXPLAIN ANALYZE
SELECT * FROM skewed_lineitem
JOIN skewed_orders ON l_orderkey = o_orderkey;
