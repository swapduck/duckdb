-- 1. Single thread
PRAGMA threads=1;

-- 3. Force join order
PRAGMA disable_optimizer;

-- 2. 100MB Limit
PRAGMA memory_limit='100MB';

SELECT COUNT(*)
FROM t1 p
JOIN t2 b
ON p.join_key = b.join_key;