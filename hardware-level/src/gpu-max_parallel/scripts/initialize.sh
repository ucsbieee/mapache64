#!/usr/bin/env bash

CORE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )/.."

[ -d "${CORE_DIR}/fusesoc" ]  && rm -rf ${CORE_DIR}/scripts/clean.sh
mkdir ${CORE_DIR}/fusesoc &> /dev/null

cd ${CORE_DIR}/fusesoc
fusesoc library add gpu_max_parallel ${CORE_DIR} --sync-type=local
fusesoc library add e4tham_ffs https://github.com/E4tHam/find_first_set --sync-type=git
