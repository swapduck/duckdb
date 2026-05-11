#!/usr/bin/env bash
set -euo pipefail

RUNNER="${1:-build/release/benchmark/benchmark_runner}"
PATTERN="${2:-benchmark/swap/.*}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

TS="$(date +%Y%m%d_%H%M%S)"
OUT_DIR="$SCRIPT_DIR/results/$TS"
mkdir -p "$OUT_DIR"

TIMINGS="$OUT_DIR/timings.out"    # --out:  one value/line (float or ERROR/TIMEOUT/INCORRECT)
PROFILE="$OUT_DIR/profiles.log"   # --log:  profiler JSON per hot run
TABLE="$OUT_DIR/results.tsv"      # stderr: full name TAB run TAB timing table

echo "Results directory : $OUT_DIR"
echo "Running           : $RUNNER $PATTERN"

cd "$REPO_ROOT"
"$RUNNER" "$PATTERN" \
    "--out=$TIMINGS" \
    "--log=$PROFILE" \
    2>"$TABLE"

echo "Done."
echo "  Structured table : $TABLE"
echo "  Timing values    : $TIMINGS"
echo "  Profiler JSON    : $PROFILE"
