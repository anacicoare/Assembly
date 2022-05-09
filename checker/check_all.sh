#!/bin/bash

cd "$(dirname "$0")" || exit 1

TOTAL=0
RESULTS=".results"

# do the mandatory tasks first
for dir in task*; do
	if [ -d "$dir" ]; then
		make --no-print-directory --silent -C ${dir}/checker check 2> /dev/null
		RESULT=$(cat "$RESULTS" 2> /dev/null | grep "$dir" | cut -d ':' -f2)
		[ -z "$RESULT" ] && RESULT=0
		TOTAL=$(echo "scale=2; $TOTAL + $RESULT" | bc)
	fi
done

# then do the bonus tasks
for dir in bonus*; do
	if [ -d "$dir" ]; then
		make --no-print-directory --silent -C ${dir}/checker check 2> /dev/null
		RESULT=$(cat "$RESULTS" 2> /dev/null | grep "$dir" | cut -d ':' -f2)
		[ -z "$RESULT" ] && RESULT=0
		TOTAL=$(echo "scale=2; $TOTAL + $RESULT" | bc)
	fi
done

echo "====================================================="
if [[ $(echo "$TOTAL > 0" | bc) == "1" ]]; then
	echo "Coding-style points:			10.00p/10.00p"
	TOTAL=$(echo "scale=2; $TOTAL + 10" | bc)
else
	echo "Coding-style points:			 0.00p/10.00p"
fi

echo "====================================================="
printf "Total:                                        %6.2fp\n" ${TOTAL} | tr ',' '.'

rm $RESULTS
