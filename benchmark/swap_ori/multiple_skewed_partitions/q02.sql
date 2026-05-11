PRAGMA enable_profiling='json';
PRAGMA profiling_output='benchmark/swap/multiple_skewed_partitions/out/q02_150MB_2_JOIN_ORDER_BUILD_SIDE_PROBE_SIDE.json';
PRAGMA custom_profiling_settings='{
    "SYSTEM_PEAK_BUFFER_MEMORY": "true",
    "SYSTEM_PEAK_TEMP_DIR_SIZE": "true",
    "TOTAL_BYTES_WRITTEN": "true",
    "TOTAL_BYTES_READ": "true"
}';
PRAGMA threads=2;
PRAGMA memory_limit='150MB';
PRAGMA disabled_optimizers='JOIN_ORDER,BUILD_SIDE_PROBE_SIDE';

-- 100MB Memory Limit, Single Threaded, Force Join Order

PRAGMA enable_profiling='json';
PRAGMA profiling_output='benchmark/swap/multiple_skewed_partitions/out/profile_q02.json';
PRAGMA profiling_mode='detailed';

PRAGMA custom_profiling_settings='{
    "SYSTEM_PEAK_BUFFER_MEMORY": "true",
    "SYSTEM_PEAK_TEMP_DIR_SIZE": "true",
    "TOTAL_BYTES_WRITTEN": "true",
    "TOTAL_BYTES_READ": "true"
}';

PRAGMA threads=1;
PRAGMA disable_optimizer;
PRAGMA memory_limit='100MB';

SELECT COUNT(*)
FROM t1 p
JOIN t2 b
ON p.join_key = b.join_key;
