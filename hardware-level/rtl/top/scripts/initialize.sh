#!/usr/bin/env bash

CORE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." &> /dev/null && pwd )"
CORES_DIR="$( cd "${CORE_DIR}/.." &> /dev/null && pwd )"

${CORE_DIR}/scripts/clean.sh

mkdir ${CORE_DIR}/fusesoc &> /dev/null
cd ${CORE_DIR}/fusesoc

echo ${CORE_DIR}/fusesoc > ${CORE_DIR}/fusesoc/.fusesoc_path

{       # try to run fusesoc commands
    ( ${CORES_DIR}/gpu/scripts/verify.sh || ${CORES_DIR}/gpu/scripts/initialize.sh ) &&
    fusesoc library add top ${CORES_DIR}/top --sync-type=local &&
    fusesoc library add firmware ${CORES_DIR}/firmware --sync-type=local &&
    fusesoc library add gpu ${CORES_DIR}/gpu --sync-type=local &&
    fusesoc library add address_bus ${CORES_DIR}/address_bus --sync-type=local &&
    fusesoc library add controller_interface ${CORES_DIR}/controller_interface --sync-type=local &&
    fusesoc library add e4tham_ffs ${CORES_DIR}/gpu/fusesoc/fusesoc_libraries/e4tham_ffs --sync-type=local &&
    fusesoc library add misc ${CORES_DIR}/misc --sync-type=local
} || {  # if commands failed, clean
    >&2 echo "[ERROR in initialize.sh]: Initialization failed. Maybe FuseSoC isn't installed?"
    ${CORE_DIR}/scripts/clean.sh
    exit 1
}

# ${CORE_DIR}/scripts/get_mem.sh
