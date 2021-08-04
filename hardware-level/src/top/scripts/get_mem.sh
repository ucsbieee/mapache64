#!/usr/bin/env bash

CORE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." &> /dev/null && pwd )"

ASSEMBLY_SRC_DIR="$( cd  "${CORE_DIR}/../../../assembly-level/src" &> /dev/null && pwd )"

cd ${ASSEMBLY_SRC_DIR}

make dump

mkdir -p ${CORE_DIR}/fusesoc/rom
xxd -p -c 1 ${ASSEMBLY_SRC_DIR}/dump/firmware.bin ${CORE_DIR}/fusesoc/rom/firmware.mem
