#!/usr/bin/env bash

CORE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." &> /dev/null && pwd )"
CORES_DIR="$( cd "${CORE_DIR}/.." &> /dev/null && pwd )"

${CORE_DIR}/scripts/clean.sh

mkdir ${CORE_DIR}/fusesoc &> /dev/null
cd ${CORE_DIR}/fusesoc

echo ${CORE_DIR}/fusesoc > ${CORE_DIR}/fusesoc/.fusesoc_path

{       # try to run fusesoc commands
    fusesoc library add gpu ${CORE_DIR} --sync-type=local &&
    fusesoc library add e4tham_ffs https://github.com/E4tHam/find_first_set --sync-type=git &&
    fusesoc library add misc ${CORES_DIR}/misc --sync-type=local &&
    ${CORE_DIR}/scripts/font.sh
    exit 0
} || {  # if commands failed, clean
    >&2 echo "[ERROR in initialize.sh]: Initialization failed. Maybe FuseSoC isn't installed?"
    ${CORE_DIR}/scripts/clean.sh
    exit 1
}
