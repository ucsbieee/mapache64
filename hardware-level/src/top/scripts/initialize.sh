#!/usr/bin/env bash

CORE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." &> /dev/null && pwd )"
CORES_DIR="$( cd "${CORE_DIR}/.." &> /dev/null && pwd )"

${CORE_DIR}/scripts/clean.sh

mkdir ${CORE_DIR}/fusesoc &> /dev/null
cd ${CORE_DIR}/fusesoc

echo ${CORE_DIR}/fusesoc > ${CORE_DIR}/fusesoc/.fusesoc_path

{       # try to run fusesoc commands
    fusesoc library add top ${CORES_DIR}/top --sync-type=local &&
    fusesoc library add firmware ${CORES_DIR}/firmware --sync-type=local &&
    fusesoc library add gpu_reduced ${CORES_DIR}/gpu --sync-type=local &&
    fusesoc library add address_bus ${CORES_DIR}/address_bus --sync-type=local &&
    fusesoc library add controller ${CORES_DIR}/controller_interface --sync-type=local &&
    fusesoc library add e4tham_ffs https://github.com/E4tHam/find_first_set --sync-type=git
} || {  # if commands failed, clean
    >&2 echo "[ERROR in initialize.sh]: Initialization failed. Maybe FuseSoC isn't installed?"
    ${CORE_DIR}/scripts/clean.sh
    exit 1
}

${CORE_DIR}/../gpu/scripts/initialize.sh

# ${CORE_DIR}/scripts/get_mem.sh
