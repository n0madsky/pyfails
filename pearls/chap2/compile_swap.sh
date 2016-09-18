set -u
set -e

echo "$1"
g++ -O3 -g -Wall -D $1 swap.cpp -o $1
