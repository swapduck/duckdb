
-- Inner relation: 125 million rows with a heavily Zipfian key distribution.
-- ~40% of rows (50M) share a single join_key value (key = 1).
-- This means partition P2 (which captures key=1 by radix) will hold ~50M rows
-- and require ~1.2 GB to build a hash table — exceeding the 1 GB limit.
CREATE OR REPLACE TABLE inner_rel AS
SELECT
    CASE
        WHEN rownum <= 50_000_000 THEN 1
        WHEN rownum <= 80_000_000 THEN (rownum % 5) + 2
        ELSE (rownum % 40_000_000) + 100
    END AS join_key,
    printf('EMP%012d', rownum) AS employee_id,
    chr((65 + (rownum % 26))::INTEGER)  AS tag,
    concat(
        CASE rownum % 8 WHEN 0 THEN 'lorem ' WHEN 1 THEN 'ipsum '
                        WHEN 2 THEN 'dolor ' WHEN 3 THEN 'sit '
                        WHEN 4 THEN 'amet '  WHEN 5 THEN 'consectetur '
                        WHEN 6 THEN 'adipiscing ' ELSE 'elit ' END,
        CASE (rownum / 8) % 8 WHEN 0 THEN 'lorem' WHEN 1 THEN 'ipsum'
                               WHEN 2 THEN 'dolor' WHEN 3 THEN 'sit'
                               WHEN 4 THEN 'amet'  WHEN 5 THEN 'consectetur'
                               WHEN 6 THEN 'adipiscing' ELSE 'elit' END
    ) AS comment
FROM range(1, 125_000_001) t(rownum);

CREATE OR REPLACE TABLE outer_rel AS
SELECT
    (rownum % 40_000_100) + 1 AS join_key,
    printf('ORD%012d', rownum) AS order_id,
    chr((65 + (rownum % 26))::INTEGER)  AS region_tag
FROM range(1, 500_000_001) t(rownum);
