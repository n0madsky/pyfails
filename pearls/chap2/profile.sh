set -u
set -e

perf stat -d -i $1 $2 $3 $4
