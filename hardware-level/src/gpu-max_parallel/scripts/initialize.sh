#!/usr/bin/env bash

CORE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )/.."

[ -d "${CORE_DIR}/fusesoc" ]  && ${CORE_DIR}/scripts/clean.sh
mkdir ${CORE_DIR}/fusesoc &> /dev/null

cd ${CORE_DIR}/fusesoc

{       # try to run fusesoc commands
    fusesoc library add gpu_max_parallel ${CORE_DIR} --sync-type=local &&
    fusesoc library add e4tham_ffs https://github.com/E4tHam/find_first_set --sync-type=git
} || {  # if commands failed, clean
    >&2 echo "[ERROR in initialize.sh]: Initialization failed."
    ${CORE_DIR}/scripts/clean.sh
    exit 1
}
