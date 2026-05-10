PRAGMA memory_limit='1GB';
PRAGMA temp_directory='./skew.db';

CREATE TABLE t1 AS
SELECT
    1 AS join_key,
    hash(i)::UBIGINT AS p1, hash(i+1)::UBIGINT AS p2,
    hash(i+2)::UBIGINT AS p3, hash(i+3)::UBIGINT AS p4,
    hash(i+4)::UBIGINT AS p5, hash(i+5)::UBIGINT AS p6,
    hash(i+6)::UBIGINT AS p7, hash(i+7)::UBIGINT AS p8,
    hash(i+8)::UBIGINT AS p9
FROM range(100) t(i)
UNION ALL
SELECT
     AS join_key,
    hash(i)::UBIGINT AS p1, hash(i+1)::UBIGINT AS p2,
    hash(i+2)::UBIGINT AS p3, hash(i+3)::UBIGINT AS p4,
    hash(i+4)::UBIGINT AS p5, hash(i+5)::UBIGINT AS p6,
    hash(i+6)::UBIGINT AS p7, hash(i+7)::UBIGINT AS p8,
    hash(i+8)::UBIGINT AS p9
FROM range(10000) t(i);

CREATE TABLE t2 AS
SELECT
    1 AS join_key,
    hash(i)::UBIGINT AS b1, hash(i+1)::UBIGINT AS b2,
    hash(i+2)::UBIGINT AS b3, hash(i+3)::UBIGINT AS b4,
    hash(i+4)::UBIGINT AS b5, hash(i+5)::UBIGINT AS b6,
    hash(i+6)::UBIGINT AS b7, hash(i+7)::UBIGINT AS b8,
    hash(i+8)::UBIGINT AS b9
FROM range(2000000) t(i)
UNION ALL
SELECT
    i + 2 AS join_key,
    hash(i)::UBIGINT AS b1, hash(i+1)::UBIGINT AS b2,
    hash(i+2)::UBIGINT AS b3, hash(i+3)::UBIGINT AS b4,
    hash(i+4)::UBIGINT AS b5, hash(i+5)::UBIGINT AS b6,
    hash(i+6)::UBIGINT AS b7, hash(i+7)::UBIGINT AS b8,
    hash(i+8)::UBIGINT AS b9
FROM range(13000000) t(i);