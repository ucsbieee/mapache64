#!/usr/bin/env bash

CORE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." &> /dev/null && pwd )"

PATH_FILE=`cat ${CORE_DIR}/fusesoc/.fusesoc_path 2> /dev/null`

if [ ""$PATH_FILE = ${CORE_DIR}/fusesoc ];
then
    exit 0
else
    exit 1
fi
