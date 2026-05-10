PRAGMA enable_profiling='json';
PRAGMA profiling_output='profile_q01.json';

PRAGMA custom_profiling_settings='{
    "SYSTEM_PEAK_BUFFER_MEMORY": "true",
    "SYSTEM_PEAK_TEMP_DIR_SIZE": "true",
    "TOTAL_BYTES_WRITTEN": "true",
    "TOTAL_BYTES_READ": "true"
}';

PRAGMA debug_force_external=true;
PRAGMA disabled_optimizers='join_order';

SELECT COUNT(*)
FROM t1 p
JOIN t2 b
ON p.join_key = b.join_key;