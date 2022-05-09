#!/bin/bash

fail() {
    echo "[ERROR] $1"
    exit 1
}

shopt -s extglob
rm -f !("tests"|"check.sh"|"Makefile"|"checker.c")
if [ -f ../../task1.asm ]; then
	cp -r ../../task1/task1.asm .
else
	cp -r ../task1.asm .
fi
sleep 1     # to avoid "make: warning:  Clock skew detected."

if [ ! -f Makefile ]; then
    fail "Makefile not found"
fi

make 1>/dev/null || exit 1

if [ ! -f checker ]; then
    fail "checker not found"
fi

if [ ! -e tests/in ]; then
    fail "tests/in not found"
fi

if [ ! -e tests/out ]; then
    mkdir tests/out
fi

if [ ! -e tests/ref ]; then
    fail "tests/ref not found"
fi

echo "====================== Task 1 ======================="

total=0
for i in {1..5}; do
    ./checker < "tests/in/${i}.in" | xargs > "tests/out/${i}.out"
    out=$(diff "tests/ref/${i}.ref" "tests/out/${i}.out")

    if [ -z "$out" ]; then
        total=$(( total + 5 ))
        echo "Test ${i}					  5.00p/5.00p"
    else
        echo "Test ${i}					  0.00p/5.00p"
    fi
done

echo
printf "Total score:				%5.2fp/25.00p\n" ${total} | tr ',' '.'
echo "task-1:$total" >> ../../.results
