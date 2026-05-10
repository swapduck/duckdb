PRAGMA debug_force_external=true;

SELECT COUNT(*)
FROM t1 p
JOIN t2 b
ON p.join_key = b.join_key;