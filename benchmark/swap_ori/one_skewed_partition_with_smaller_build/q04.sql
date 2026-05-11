-- 100MB Memory Limit, Single Threaded, Enabled Optimizers, Enabled Adaptive Side Swapping

PRAGMA enable_profiling='json';
PRAGMA profiling_output='benchmark/swap/one_skewed_partition_with_smaller_build/out/profile_q03.json';

PRAGMA custom_profiling_settings='{
    "SYSTEM_PEAK_BUFFER_MEMORY": "true",
    "SYSTEM_PEAK_TEMP_DIR_SIZE": "true",
    "TOTAL_BYTES_WRITTEN": "true",
    "TOTAL_BYTES_READ": "true"
}';

-- 1. Single thread
PRAGMA threads=1;

-- 2. 100MB Limit
PRAGMA memory_limit='100MB';
PRAGMA disabled_optimizers='JOIN_ORDER,BUILD_SIDE_PROBE_SIDE';


SELECT COUNT(*)
FROM t1 p
JOIN t2 b
ON p.join_key = b.join_key;