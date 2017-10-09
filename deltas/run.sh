#!/bin/sh

set -o errexit

output=/dev/null

while getopts 'v' flag; do
    case "${flag}" in
    v) output=/dev/stdout ;;
    *) error "Unexpected option ${flag}" ;;
    esac
done

for testcase in fixtures/*; do
	echo "> Running test: $testcase"

	echo "  Building old image.."
	balaena build -f "$testcase/Dockerfile.old" -t "$testcase-old" . > $output

	echo "  Building new image.."
	balaena build -f "$testcase/Dockerfile.new" -t "$testcase-new" . > $output

	echo "  Creating delta image.."
	echo "--> Result: $(balaena image delta "$testcase-old" "$testcase-new" | tail -n2 | head -n1)"
done
