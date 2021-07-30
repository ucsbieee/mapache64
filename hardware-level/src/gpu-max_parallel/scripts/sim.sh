#!/usr/bin/env bash

CORE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )/.."

if [ ! -d "${CORE_DIR}/fusesoc" ]
then
    ${CORE_DIR}/scripts/initialize.sh
fi

cd ${CORE_DIR}/fusesoc
fusesoc run --target sim ucsbieee:arcade:gpu_max_parallel
