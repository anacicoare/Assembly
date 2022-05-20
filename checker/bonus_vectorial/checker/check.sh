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

make > /dev/null 2>&1

echo "============ SIMD instructions bonus task ==========="

echo "Checking available vectorial instruction sets..."
MMX=$(grep -o mmx /proc/cpuinfo | uniq)
SSE=$(grep -o sse /proc/cpuinfo | uniq)
SSE2=$(grep -o sse2 /proc/cpuinfo | uniq)
SSE4="$(grep -o sse4_1 /proc/cpuinfo | uniq) $(grep -o sse4_2 /proc/cpuinfo | uniq)"
AVX=$(grep -o avx /proc/cpuinfo | uniq)
AVX2=$(grep -o avx2 /proc/cpuinfo | uniq)
AVX512=$(grep -o avx512 /proc/cpuinfo | uniq)
echo "Found $MMX $SSE $SSE2 $SSE4 $AVX $AVX2 $AVX512"
echo

for i in 1 2 3; do
	./checker < "${INPUTS}${i}${IN_EXT}" > "${OUTPUTS}${i}${OUT_EXT}"
	diff "${OUTPUTS}${i}${OUT_EXT}" "${REFS}${i}${REF_EXT}" > /tmp/diff_out
	if [ "$?" == "0" ]; then
		echo "Test $i					  ${TASK_SCORE}.00p/${TASK_SCORE}.00p"
		TOTAL=$((TOTAL + TASK_SCORE))
	else
		echo "Test $i					  0.00p/${TASK_SCORE}.00p"
		cat /tmp/diff_out
	fi
done

echo
printf "Total score:				%5.2fp/%5.2fp\n" ${TOTAL} ${MAX_SCORE}

make clean > /dev/null 2>&1

echo "bonus_vectorial:${TOTAL}" >> ../../.results
