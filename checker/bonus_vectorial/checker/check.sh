#!/bin/bash

INPUTS="tests/in/"
OUTPUTS="tests/out/"
REFS="tests/ref/"

IN_EXT=".in"
OUT_EXT=".out"
REF_EXT=".ref"

TASK_SCORE=5
MAX_SCORE=15
TOTAL=0

make copy > /dev/null 2>&1 && make > /dev/null 2>&1

echo "============ SIMD instructions bonus task ==========="

for i in 1 2 3; do
	./checker < "${INPUTS}${i}${IN_EXT}" > "${OUTPUTS}${i}${OUT_EXT}"
	diff "${OUTPUTS}${i}${OUT_EXT}" "${REFS}${i}${REF_EXT}" > /dev/null
	if [[ $? == "0" ]]; then
		echo "Test $i					  ${TASK_SCORE}.00p/${TASK_SCORE}.00p"
		TOTAL=$((TOTAL + TASK_SCORE))
	else
		echo "Test $i					  0.00p/${TASK_SCORE}.00p"
	fi
done

echo
printf "Total score:				%5.2fp/%5.2fp\n" ${TOTAL} ${MAX_SCORE} | tr ',' '.'

make clean > /dev/null 2>&1

echo "bonus_vectorial:${TOTAL}" >> ../../.results
