#!/bin/bash

cd "$(dirname "$0")" || exit 1

cp -r ./* ../src

make -C ../src
