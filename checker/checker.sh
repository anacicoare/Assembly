#!/bin/bash

cd "$(dirname "$0")" || exit 1

cp -ar ./* ../src

[ -n "$CI" ] && echo "VMCHECKER_TRACE_CLEANUP\n"

if [ -z "$1" ] ; then
    make --no-print-directory --silent -C ../src
else
    make --no-print-directory --silent -C "../src/$1/checker" check
fi
