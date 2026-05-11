-- Construct the alpha = 0.8 Inner Relation
CREATE OR REPLACE TABLE inner_rel AS
SELECT
    CASE
        -- Rank 1 (Baseline): ~45 million rows (~1.08 GB)
        WHEN rownum <= 45_000_000 THEN 1

        -- Rank 2 (~57% of Rank 1): ~25 million rows (~600 MB)
        WHEN rownum <= 70_000_000 THEN 2

        -- Rank 3 (~41% of Rank 1): ~18 million rows (~430 MB)
        WHEN rownum <= 88_000_000 THEN 3

        -- Rank 4 (~33% of Rank 1): ~14 million rows (~335 MB)
        WHEN rownum <= 102_000_000 THEN 4

        -- The "Long Tail": The remaining 23 million rows are highly diverse
        ELSE (rownum % 20_000_000) + 100
    END AS join_key,

    -- Payload to ensure the row width forces memory limits
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
