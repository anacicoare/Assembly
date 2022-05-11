#!/bin/bash

cd "$(dirname "$0")" || exit 1

cp -ar ./* ../src

if [ -z "$1" ] ; then
    make --no-print-directory --silent -C ../src
else
    make --no-print-directory --silent -C "../src/$1/checker" check
fi
