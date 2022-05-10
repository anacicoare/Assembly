#!/bin/bash

INPUTS="tests/in/"
OUTPUTS="tests/out/"
REFS="tests/ref/"

IN_EXT=".in"
OUT_EXT=".out"
REF_EXT=".ref"

TASK_SCORE=$(echo "scale=2; 25 / 10" | bc)
MAX_SCORE=25
TOTAL=0

make copy > /dev/null 2>&1 && make > /dev/null 2>&1

echo "====================== Task 2 ======================="

for i in 1 2 3 4 5; do
	./checker 0 < "${INPUTS}${i}${IN_EXT}" > "${OUTPUTS}${i}${OUT_EXT}"
	diff "${OUTPUTS}${i}${OUT_EXT}" "${REFS}${i}${REF_EXT}" > /dev/null
	if [[ $? == "0" ]]; then
		echo "Test $i					  ${TASK_SCORE}p/${TASK_SCORE}p"
		TOTAL=$(echo "scale=2; $TOTAL + $TASK_SCORE" | bc)
	else
		echo "Test $i					  0.00p/${TASK_SCORE}p"
	fi
done

for i in 6 7 8 9 10; do
	./checker 1 < "${INPUTS}${i}${IN_EXT}" > "${OUTPUTS}${i}${OUT_EXT}"
	diff "${OUTPUTS}${i}${OUT_EXT}" "${REFS}${i}${REF_EXT}" > /dev/null
	if [[ $? == "0" ]]; then
		echo "Test $i					  ${TASK_SCORE}p/${TASK_SCORE}p"
		TOTAL=$(echo "scale=2; $TOTAL + $TASK_SCORE" | bc)
	else

		echo "Test $i					  0.00p/${TASK_SCORE}p"
	fi
done

echo
printf "Total score:				%5.2fp/%5.2fp\n" ${TOTAL} ${MAX_SCORE} | tr ',' '.'

make clean > /dev/null 2>&1

echo "task-2:${TOTAL}" >> ../../.results
