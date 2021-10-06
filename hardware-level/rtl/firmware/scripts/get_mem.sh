#!/usr/bin/env bash

CORE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." &> /dev/null && pwd )"
ASSEMBLY_SRC_DIR="$( cd  "${CORE_DIR}/../../../assembly-level/src" &> /dev/null && pwd )"

cd ${ASSEMBLY_SRC_DIR}
make dump
echo "Assembler complete."


DST_DIR=${CORE_DIR}/rom

mkdir -p ${DST_DIR}
xxd -p -c 1 ${ASSEMBLY_SRC_DIR}/dump/firmware.bin ${DST_DIR}/firmware.mem
cp ${ASSEMBLY_SRC_DIR}/dump/firmware.bin ${DST_DIR}/firmware.bin
xxd -p -c 1 ${ASSEMBLY_SRC_DIR}/dump/vectors.bin ${DST_DIR}/vectors.mem
cp ${ASSEMBLY_SRC_DIR}/dump/vectors.bin ${DST_DIR}/vectors.bin
echo "Rom files copied to \"${DST_DIR}/\"."
