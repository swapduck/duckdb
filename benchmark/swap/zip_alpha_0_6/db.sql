-- Construct the alpha = 0.6 Inner Relation
CREATE OR REPLACE TABLE inner_rel AS
SELECT
    CASE
        -- Rank 1 (1.00x): 33 million rows (~790 MB).
        -- CRITICAL: Because the curve is flatter, Rank 1 stays UNDER 1GB!
        WHEN rownum <= 33_000_000 THEN 1

        -- Rank 2 (0.66x): 22 million rows (~528 MB).
        WHEN rownum <= 55_000_000 THEN 2

        -- Rank 3 (0.52x): 17 million rows (~408 MB).
        WHEN rownum <= 72_000_000 THEN 3

        -- Rank 4 (0.44x): 14 million rows (~336 MB).
        WHEN rownum <= 86_000_000 THEN 4

        -- Rank 5 (0.38x): 13 million rows (~312 MB).
        WHEN rownum <= 99_000_000 THEN 5

        -- The "Long Tail": The remaining 26 million rows.
        ELSE (rownum % 20_000_000) + 100
    END AS join_key,

    -- Payload
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

-- Construct the Outer Relation
CREATE OR REPLACE TABLE outer_rel AS
SELECT
    (rownum % 25_000_100) + 1 AS join_key,
    printf('ORD%012d', rownum) AS order_id,
    chr((65 + (rownum % 26))::INTEGER)  AS region_tag
FROM range(1, 500_000_001) t(rownum);
