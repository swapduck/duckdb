PRAGMA enable_profiling='json';
PRAGMA profiling_output='benchmark/swap/multiple_skewed_partitions/out/q05_100MB_2_JOIN_ORDER_BUILD_SIDE_PROBE_SIDE.json';
PRAGMA custom_profiling_settings='{
    "SYSTEM_PEAK_BUFFER_MEMORY": "true",
    "SYSTEM_PEAK_TEMP_DIR_SIZE": "true",
    "TOTAL_BYTES_WRITTEN": "true",
    "TOTAL_BYTES_READ": "true"
}';
PRAGMA threads=2;
PRAGMA memory_limit='100MB';
PRAGMA disabled_optimizers='JOIN_ORDER,BUILD_SIDE_PROBE_SIDE';

PRAGMA enable_profiling='json';
PRAGMA profiling_output='benchmark/swap/one_skewed_partition/out/profile_q03.json';

PRAGMA custom_profiling_settings='{
    "SYSTEM_PEAK_BUFFER_MEMORY": "true",
    "SYSTEM_PEAK_TEMP_DIR_SIZE": "true",
    "TOTAL_BYTES_WRITTEN": "true",
    "TOTAL_BYTES_READ": "true"
}';


PRAGMA threads=1;
PRAGMA memory_limit='100MB';
PRAGMA disabled_optimizers='BUILD_SIDE_PROBE_SIDE,STATISTICS_PROPAGATION';


SELECT COUNT(*)
FROM t1 p
JOIN t2 b
ON p.join_key = b.join_key;
