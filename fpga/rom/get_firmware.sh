#!/usr/bin/env bash

set -e

MAPACHE64_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../.." &> /dev/null && pwd )"
ASSEMBLY_DIR="$( cd  "${MAPACHE64_DIR}/assembly-level/src" &> /dev/null && pwd )"

# compile to bin files
cd ${ASSEMBLY_DIR}
make
cd template
make dump
cd dump
echo "Assembler complete."

SRC_DIR="$( pwd )"
DST_DIR=${MAPACHE64_DIR}/fpga/rom/build

# convert to mem files
mkdir -p ${DST_DIR}
cp ${SRC_DIR}/firmware.bin ${DST_DIR}/firmware.bin
xxd -p -c 1 ${DST_DIR}/firmware.bin ${DST_DIR}/firmware.mem
cp ${SRC_DIR}/vectors.bin ${DST_DIR}/vectors.bin
xxd -p -c 1 ${DST_DIR}/vectors.bin ${DST_DIR}/vectors.mem
echo "Firmware rom files copied to \"${DST_DIR}/\"."
