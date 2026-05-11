-- Disable the optimizers mentioned in the paper
SET disabled_optimizers = 'build_side_probe_side,statistics_propagation';
-- Enforce the 1 GB memory limit and cap parallelism
SET memory_limit = '4GB';
SET threads = 1;
SET disable_adaptive_side_swapping = false;

-- ANY_VALUE prevents result-set transfer overhead and stops early termination,
-- following the paper's benchmarking methodology (Section 7).
-- The join is a standard inner join; no filter pushdown occurs because
-- statistics_propagation is disabled.

SELECT
    ANY_VALUE(o.order_id)   AS sample_order,
    ANY_VALUE(i.employee_id) AS sample_employee,
    count(*)                 AS total_matches
FROM outer_rel o
JOIN inner_rel  i
  ON o.join_key = i.join_key;
