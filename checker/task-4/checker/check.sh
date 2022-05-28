#!/bin/bash

OUTPUT_INTEL="cpuid_intel.out"
OUTPUT_AMD="cpuid_amd.out"

SMALL_TASK_SCORE=1
BIG_TASK_SCORE=2
BIGGER_TASK_SCORE=4
BONUS_TASK_SCORE=5

MAX_SCORE=15
TOTAL=0

make > /dev/null 2>&1

echo "====================== Task 4 ======================="

CPU=$(cat /proc/cpuinfo | grep "vendor_id" | uniq | cut -d':' -f2 | cut -d' ' -f2)
if [ "$CPU" == "GenuineIntel" ]; then
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

if [ "$VENDOR_ID_INTEL" == "$REF_VENDOR_ID_INTEL" ]; then
    echo "Vendor ID Intel				  ${BIG_TASK_SCORE}.00p/${BIG_TASK_SCORE}.00p"
    TOTAL=$((TOTAL + BIG_TASK_SCORE))
else
    echo "Vendor ID Intel				  0.00p/${BIG_TASK_SCORE}.00p"
    echo "Expected: $REF_VENDOR_ID_INTEL, received: $VENDOR_ID_INTEL"
fi

if [ "$VENDOR_ID_AMD" == "$REF_VENDOR_ID_AMD" ]; then
    echo "Vendor ID AMD				  ${BIG_TASK_SCORE}.00p/${BIG_TASK_SCORE}.00p"
    TOTAL=$((TOTAL + BIG_TASK_SCORE))
else
    echo "Vendor ID AMD				  0.00p/${BIG_TASK_SCORE}.00p"
    echo "Expected: $REF_VENDOR_ID_AMD, received: $VENDOR_ID_AMD"
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

if [ $CPU == "GenuineIntel" ]; then
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

if [ "$HAVE_APIC" == "$APIC" ]; then
    echo "APIC					  ${SMALL_TASK_SCORE}.00p/${SMALL_TASK_SCORE}.00p"
    TOTAL=$((TOTAL + SMALL_TASK_SCORE))
else
    echo "APIC					  0.00p/${SMALL_TASK_SCORE}.00p"
    echo "Expected: $HAVE_APIC, received: $APIC"
fi

if [ "$HAVE_RDRAND" == "$RDRAND" ]; then
    echo "RDRAND					  ${SMALL_TASK_SCORE}.00p/${SMALL_TASK_SCORE}.00p"
    TOTAL=$((TOTAL + SMALL_TASK_SCORE))
else
    echo "RDRAND					  0.00p/${SMALL_TASK_SCORE}.00p"
    echo "Expected: $HAVE_RDRAND, received: $RDRAND"
fi

if [ "$HAVE_MPX" == "$MPX" ]; then
    echo "MPX					  ${BIG_TASK_SCORE}.00p/${BIG_TASK_SCORE}.00p"
    TOTAL=$((TOTAL + BIG_TASK_SCORE))
else
    echo "MPX					  0.00p/${BIG_TASK_SCORE}.00p"
    echo "Expected: $HAVE_MPX, received: $MPX"
fi

if [ "$HAVE_SVM" == "$SVM" ]; then
    echo "SVM					  3.00p/3.00p"
    TOTAL=$((TOTAL + 3))
else
    echo "SVM					  0.00p/3.00p"
    echo "Expected: $HAVE_SVM, received: $SVM"
fi

CACHE_LINE_REF=$(cat /sys/devices/system/cpu/cpu0/cache/index2/coherency_line_size)
CACHE_SIZE_REF=$(cat /sys/devices/system/cpu/cpu0/cache/index2/size | tr 'K' '\n')

if [ "$CPU" == "GenuineIntel" ]; then
    CACHE=$(cat $OUTPUT_INTEL | tail -n 1)
else
    CACHE=$(cat $OUTPUT_AMD | tail -n 1)
fi
CACHE_LINE=$(echo $CACHE | cut -d',' -f1 | cut -d' ' -f3)
CACHE_SIZE=$(echo $CACHE | cut -d',' -f2 | cut -d' ' -f4)

if [ "$CACHE_LINE_REF" == "$CACHE_LINE" ]; then
    echo "Cache Line				  ${BIGGER_TASK_SCORE}.00p/${BIGGER_TASK_SCORE}.00p"
    TOTAL=$((TOTAL + BIGGER_TASK_SCORE))
else
    echo "Cache Line				  0.00p/${BIGGER_TASK_SCORE}.00p"
    echo "Expected: $CACHE_LINE_REF, received: $CACHE_LINE"
fi

if [ "$CACHE_SIZE_REF" == "${CACHE_SIZE}" ]; then
    echo "[BONUS] Cache Size			  ${BONUS_TASK_SCORE}.00p/${BONUS_TASK_SCORE}.00p"
    TOTAL=$((TOTAL + BONUS_TASK_SCORE))
else
    echo "[BONUS] Cache Size			  0.00p/${BONUS_TASK_SCORE}.00p"
    echo "Expected: $CACHE_SIZE_REF, received: ${CACHE_SIZE}"
fi

echo
printf "Total score:				%5.2fp/%5.2fp\n" ${TOTAL} ${MAX_SCORE}

echo "task-4:${TOTAL}" >> ../../.results
