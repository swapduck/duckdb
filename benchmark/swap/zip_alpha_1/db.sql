-- Construct the alpha = 1.0 Inner Relation
CREATE OR REPLACE TABLE inner_rel AS
SELECT
    CASE
        -- Rank 1 (1/1): 55 million rows (~1.32 GB).
        -- Guaranteed to exceed the 1GB RAM limit during probing.
        WHEN rownum <= 55_000_000 THEN 1

        -- Rank 2 (1/2): 27.5 million rows (~660 MB).
        WHEN rownum <= 82_500_000 THEN 2

        -- Rank 3 (1/3): 18.3 million rows (~440 MB).
        WHEN rownum <= 100_800_000 THEN 3

        -- Rank 4 (1/4): 13.7 million rows (~330 MB).
        WHEN rownum <= 114_500_000 THEN 4

        -- The "Long Tail": The remaining 10.5 million rows.
        ELSE (rownum % 10_000_000) + 100
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
