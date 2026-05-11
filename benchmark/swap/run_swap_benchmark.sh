#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="benchmark/swap"
OUTPUT_FILE="swap_results.csv"

MEMORY_LIMITS=("100MB" "150MB")
THREAD_COUNTS=(1 2)

# "enabled" = all optimizers on (no PRAGMA disabled_optimizers emitted)
# Otherwise: exact comma-separated optimizer names, no spaces
OPTIMIZER_CONFIGS=(
    "BUILD_SIDE_PROBE_SIDE,STATISTICS_PROPAGATION"
    "enabled"
)

echo "folder,benchmark,timing,memory_limit,threads,disabled_optimizers,profile_file" \
    > "$OUTPUT_FILE"

find "$BASE_DIR" -type f -name "*.benchmark" | sort | while read -r bench; do

    bench_dir=$(dirname "$bench")
    rel_folder=${bench_dir#"$BASE_DIR/"}
    BENCH_NAME=$(basename "$bench")

    RUN_LINE=$(grep -E '^run ' "$bench" || true)
    if [ -z "$RUN_LINE" ]; then
        echo "[SKIP] No run line found in $bench"
        continue
    fi

    QUERY_FILE=$(echo "$RUN_LINE" | awk '{print $2}')
    if [ ! -f "$QUERY_FILE" ]; then
        echo "[SKIP] Query file not found: $QUERY_FILE"
        continue
    fi

    QUERY_NAME=$(basename "$QUERY_FILE" .sql)
    ORIGINAL_SQL=$(cat "$QUERY_FILE")

    for MEMORY_LIMIT in "${MEMORY_LIMITS[@]}"; do
    for THREADS in "${THREAD_COUNTS[@]}"; do
    for DISABLED_OPTIMIZERS in "${OPTIMIZER_CONFIGS[@]}"; do

        echo ""
        echo "========================================="
        echo "Benchmark            : $bench"
        echo "Query                : $QUERY_FILE"
        echo "Memory limit         : $MEMORY_LIMIT"
        echo "Threads              : $THREADS"
        echo "Disabled optimizers  : $DISABLED_OPTIMIZERS"
        echo "========================================="

        SAFE_MEM=$(echo "$MEMORY_LIMIT" | tr -d ' ')
        SAFE_OPT=$(echo "$DISABLED_OPTIMIZERS" | tr ',' '_' | tr -d ' ')

        PROFILE_DIR="${bench_dir}/out"
        mkdir -p "$PROFILE_DIR"

        PROFILE_FILE="${PROFILE_DIR}/${QUERY_NAME}_${SAFE_MEM}_${THREADS}_${SAFE_OPT}.json"

        {
            echo "PRAGMA enable_profiling='json';"
            echo "PRAGMA profiling_output='${PROFILE_FILE}';"
            echo "PRAGMA custom_profiling_settings='{"
            echo "    \"SYSTEM_PEAK_BUFFER_MEMORY\": \"true\","
            echo "    \"SYSTEM_PEAK_TEMP_DIR_SIZE\": \"true\","
            echo "    \"TOTAL_BYTES_WRITTEN\": \"true\","
            echo "    \"TOTAL_BYTES_READ\": \"true\""
            echo "}';"
            echo "PRAGMA threads=${THREADS};"
            echo "PRAGMA memory_limit='${MEMORY_LIMIT}';"

            if [ "$DISABLED_OPTIMIZERS" = "enabled" ]; then
                echo "-- all optimizers enabled"
            else
                echo "PRAGMA disabled_optimizers='${DISABLED_OPTIMIZERS}';"
            fi

            echo ""
            echo "$ORIGINAL_SQL"

        } > "$QUERY_FILE"

        echo "--- Query being run ---"
        cat "$QUERY_FILE"
        echo "--- End query ---"

        output=$(build/release/benchmark/benchmark_runner "$bench" 2>&1)
        echo "$output"

        echo "$ORIGINAL_SQL" > "$QUERY_FILE"

        echo "$output" | awk \
            -v fld="$rel_folder" \
            -v bench="$BENCH_NAME" \
            -v mem="$MEMORY_LIMIT" \
            -v thr="$THREADS" \
            -v opts="$DISABLED_OPTIMIZERS" \
            -v prof="$PROFILE_FILE" \
            '
            BEGIN { OFS="," }
            $1 == "name" || $1 == "Running:" { next }
            NF >= 3 {
                print fld, bench, $3, mem, thr, opts, prof
            }
        ' >> "$OUTPUT_FILE"

    done
    done
    done

    echo "$ORIGINAL_SQL" > "$QUERY_FILE"

done

echo ""
echo "Done -> $OUTPUT_FILE"