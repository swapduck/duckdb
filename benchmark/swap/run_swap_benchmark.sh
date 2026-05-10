#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="benchmark/swap"
OUTPUT_FILE="swap_results.csv"

echo "folder,name,run,timing" > "$OUTPUT_FILE"

find "$BASE_DIR" -type f -name "*.benchmark" | sort | while read -r bench; do

    bench_dir=$(dirname "$bench")
    rel_folder=${bench_dir#"$BASE_DIR/"}

    bench_file=$(basename "$bench")

    echo "Running: $bench"

    # IMPORTANT: capture BOTH stdout and stderr
    output=$(build/release/benchmark/benchmark_runner "$bench" 2>&1)

    # DEBUG: uncomment if needed
    # echo "$output"

    echo "$output" | awk -v fld="$rel_folder" '
        BEGIN { OFS="," }

        # skip header lines
        $1 == "name" || $1 == "Running:" { next }

        # must contain timing (last column numeric)
        NF >= 3 {

            # extract filename from full path
            n = split($1, p, "/")
            file = p[n]

            print fld, file, $2, $3
        }
    ' >> "$OUTPUT_FILE"

done

echo "Done -> $OUTPUT_FILE"