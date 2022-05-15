#!/bin/bash
TASK_SCORE=5
TOTAL=0
ZERO_FOUND=0
NONZERO_FOUND=0

make > /dev/null 2>&1

echo "====================== Timegate bonus task  ======================="

for i in 1 2 3 4 5; do
	OUTPUT=$(./checker)
	if [[ $OUTPUT == "0" ]]; then
		ZERO_FOUND="1"
		break
	fi
done
for i in 1 2 3 4 5; do
	OUTPUT=$(gdb ./checker -x gdb_commands | tail -n 2 | head -n 1)
	if [[ $OUTPUT != "0" ]]; then
		NONZERO_FOUND="1"
		break
	fi
done
if [[ $ZERO_FOUND == "1" ]]; then
	echo "Error: You didn't generate a random number, but you should have"
fi
if [[ $NONZERO_FOUND == "1" ]]; then
	echo "Error: You generated a random number, but you shouldn't have"
fi
if [[ $ZERO_FOUND == "0" ]] && [[ $NONZERO_FOUND == "0" ]]; then
	TOTAL=$TASK_SCORE
fi

echo
printf "Total score:				%3.2fp/%3.2fp\n" ${TOTAL} ${TASK_SCORE} | tr ',' '.'

make clean > /dev/null 2>&1

echo "bonus_timegate:${TOTAL}" >> ../../.results
