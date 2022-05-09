#!/bin/bash

OUTPUT_INTEL="cpuid_intel.out"
OUTPUT_AMD="cpuid_amd.out"

SMALL_TASK_SCORE=1
BIG_TASK_SCORE=2
MAX_SCORE=15
TOTAL=0

make copy > /dev/null 2>&1 && make > /dev/null 2>&1

echo "====================== Task 4 ======================="

CPU=$(cat /proc/cpuinfo | grep "vendor_id" | uniq | cut -d':' -f2 | cut -d' ' -f2)
if [[ $CPU == "GenuineIntel" ]]; then
    ./checker > "$OUTPUT_INTEL"
    qemu-i386 -cpu EPYC,+rdrand,+apic,+svm ./checker > "$OUTPUT_AMD" 2> /dev/null
else
    ./checker > "$OUTPUT_AMD"
    qemu-i386 -cpu Skylake-Server,+rdrand,+apic,+mpx ./checker > "$OUTPUT_INTEL" 2> /dev/null
fi

VENDOR_ID_INTEL=$(cat $OUTPUT_INTEL | head -n 1 | cut -d':' -f 2)
REF_VENDOR_ID_INTEL=" GenuineIntel"
VENDOR_ID_AMD=$(cat $OUTPUT_AMD | head -n 1 | cut -d':' -f 2)
REF_VENDOR_ID_AMD=" AuthenticAMD"

if [[ "$VENDOR_ID_INTEL" == "$REF_VENDOR_ID_INTEL" ]]; then
    echo "Vendor ID Intel				  ${BIG_TASK_SCORE}.00p/${BIG_TASK_SCORE}.00p"
    TOTAL=$((TOTAL + BIG_TASK_SCORE))
else
    echo "Vendor ID Intel				  0.00p/${BIG_TASK_SCORE}.00p"
fi

if [[ "$VENDOR_ID_AMD" == "$REF_VENDOR_ID_AMD" ]]; then
    echo "Vendor ID AMD				  ${BIG_TASK_SCORE}.00p/${BIG_TASK_SCORE}.00p"
    TOTAL=$((TOTAL + BIG_TASK_SCORE))
else
    echo "Vendor ID AMD				  0.00p/${BIG_TASK_SCORE}.00p"
fi

HAVE_MPX=0
HAVE_RDRAND=0
HAVE_APIC=0
HAVE_SVM=0

# Check if APIC is supported
if [ -n "$(cat /proc/cpuinfo | grep -o "apic" | uniq)" ]; then
    HAVE_APIC=1
fi

# Check if RDRAND is supported
if [ -n "$(cat /proc/cpuinfo | grep -o "rdrand" | uniq)" ]; then
    HAVE_RDRAND=1
fi

if [[ $CPU == "GenuineIntel" ]]; then
    # Check if MPX is supported
    if [ -n "$(cat /proc/cpuinfo | grep -o "mpx" | uniq)" ]; then
        HAVE_MPX=1
    fi

    # SVM is emulated
    HAVE_SVM=1

    CPU_FEATURES_INTEL=$(cat $OUTPUT_INTEL | head -n 2 | tail -n 1)
    APIC=$(echo $CPU_FEATURES_INTEL | cut -d',' -f1 | cut -d' ' -f2)
    RDRAND=$(echo $CPU_FEATURES_INTEL | cut -d',' -f2 | cut -d' ' -f3)
    MPX=$(echo $CPU_FEATURES_INTEL | cut -d',' -f3 | cut -d' ' -f3)

    CPU_FEATURES_AMD=$(cat $OUTPUT_AMD | head -n 2 | tail -n 1)
    SVM=$(echo $CPU_FEATURES_AMD | cut -d',' -f4 | cut -d' ' -f3)
else
    # Check if SVM is supported
    if [ -n "$(cat /proc/cpuinfo | grep -o "svm" | uniq)" ]; then
        HAVE_SVM=1
    fi

    # MPX is emulated
    HAVE_MPX=1

    CPU_FEATURES_AMD=$(cat $OUTPUT_AMD | head -n 2 | tail -n 1)
    APIC=$(echo $CPU_FEATURES_AMD | cut -d',' -f1 | cut -d' ' -f2)
    RDRAND=$(echo $CPU_FEATURES_AMD | cut -d',' -f2 | cut -d' ' -f3)
    SVM=$(echo $CPU_FEATURES_AMD | cut -d',' -f4 | cut -d' ' -f3)

    CPU_FEATURES_INTEL=$(cat $OUTPUT_INTEL | head -n 2 | tail -n 1)
    MPX=$(echo $CPU_FEATURES_INTEL | cut -d',' -f3 | cut -d' ' -f3)
fi

if [[ "$HAVE_APIC" == "$APIC" ]]; then
    echo "APIC					  ${SMALL_TASK_SCORE}.00p/${SMALL_TASK_SCORE}.00p"
    TOTAL=$((TOTAL + SMALL_TASK_SCORE))
else
    echo "APIC					  0.00p/${SMALL_TASK_SCORE}.00p"
fi

if [[ "$HAVE_RDRAND" == "$RDRAND" ]]; then
    echo "RDRAND					  ${SMALL_TASK_SCORE}.00p/${SMALL_TASK_SCORE}.00p"
    TOTAL=$((TOTAL + SMALL_TASK_SCORE))
else
    echo "RDRAND					  0.00p/${SMALL_TASK_SCORE}.00p"
fi

if [[ "$HAVE_MPX" == "$MPX" ]]; then
    echo "MPX					  ${BIG_TASK_SCORE}.00p/${BIG_TASK_SCORE}.00p"
    TOTAL=$((TOTAL + BIG_TASK_SCORE))
else
    echo "MPX					  0.00p/${BIG_TASK_SCORE}.00p"
fi

if [[ "$HAVE_SVM" == "$SVM" ]]; then
    echo "SVM					  3.00p/3.00p"
    TOTAL=$((TOTAL + 3))
else
    echo "SVM					  0.00p/3.00p"
fi

CACHE_LINE_REF=$(getconf -a | grep LEVEL2_CACHE_LINESIZE | cut -d' ' -f15)
CACHE_SIZE_REF=$((`getconf -a | grep LEVEL2_CACHE_SIZE | cut -d' ' -f19 | tr -d '\n'` / 1024 ))

if [[ $CPU == "GenuineIntel" ]]; then
    CACHE=$(cat $OUTPUT_INTEL | tail -n 1)
else
    CACHE=$(cat $OUTPUT_AMD | tail -n 1)
fi
CACHE_LINE=$(echo $CACHE | cut -d',' -f1 | cut -d' ' -f3)
CACHE_SIZE=$(echo $CACHE | cut -d',' -f2 | cut -d' ' -f4)

if [[ "$CACHE_LINE_REF" == "$CACHE_LINE" ]]; then
    echo "Cache Line				  ${BIG_TASK_SCORE}.00p/${BIG_TASK_SCORE}.00p"
    TOTAL=$((TOTAL + BIG_TASK_SCORE))
else
    echo "Cache Line				  0.00p/${BIG_TASK_SCORE}.00p"
fi

if [[ "$CACHE_SIZE_REF" == "$CACHE_SIZE" ]]; then
    echo "Cache Size				  ${BIG_TASK_SCORE}.00p/${BIG_TASK_SCORE}.00p"
    TOTAL=$((TOTAL + BIG_TASK_SCORE))
else
    echo "Cache Size				  0.00p/${BIG_TASK_SCORE}.00p"
fi

echo
printf "Total score:				%5.2fp/%5.2fp\n" ${TOTAL} ${MAX_SCORE} | tr ',' '.'

echo "task-4:${TOTAL}" >> ../../.results
