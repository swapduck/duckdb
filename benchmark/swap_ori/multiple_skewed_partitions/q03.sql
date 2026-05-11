PRAGMA enable_profiling='json';
PRAGMA profiling_output='benchmark/swap/multiple_skewed_partitions/out/profile_q03.json';

PRAGMA custom_profiling_settings='{
    "SYSTEM_PEAK_BUFFER_MEMORY": "true",
    "SYSTEM_PEAK_TEMP_DIR_SIZE": "true",
    "TOTAL_BYTES_WRITTEN": "true",
    "TOTAL_BYTES_READ": "true"
}';


PRAGMA threads=1;
PRAGMA memory_limit='100MB';

SELECT COUNT(*)
FROM t1 p
JOIN t2 b
ON p.join_key = b.join_key;