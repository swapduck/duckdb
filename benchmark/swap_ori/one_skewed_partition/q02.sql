PRAGMA enable_profiling='json';
PRAGMA profiling_output='benchmark/swap/one_skewed_partition/out/profile_q02.json';

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