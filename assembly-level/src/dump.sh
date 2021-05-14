#!/usr/bin/env bash

ASSEMBLY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
DUMP_PATH=dump
PY65=py65mon

# Ensure py65ucsbieee is installed
${PY65} -h > /dev/null 2>&1 || {
    echo "[ERROR]: Could not run \$${PY65}.
Please install it from ${ASSEMBLY_DIR}/tools/py65/py65ucsbieee.";
    exit 1
}

# Dump Vectors
${PY65} --mpu 65C02 --load ${DUMP_PATH}/arcade.bin <<EOF
save ${DUMP_PATH}/rom.bin       8000 ffff
save ${DUMP_PATH}/vectors.bin   fffa ffff
quit
EOF

# Get Addreses for Interrupt/Reset Vectors
vectors="${DUMP_PATH}/vectors.bin"
nmi=`   xxd -p -l 1 -seek 1 ${vectors}``xxd -p -l 1 -seek 0 ${vectors}`
reset=` xxd -p -l 1 -seek 3 ${vectors}``xxd -p -l 1 -seek 2 ${vectors}`
irq=`   xxd -p -l 1 -seek 5 ${vectors}``xxd -p -l 1 -seek 4 ${vectors}`
echo "nmi   : ${nmi}"
echo "reset : ${reset}"
echo "irq   : ${irq}"

# Run py65mon
${PY65} --mpu 65C02 --load ${DUMP_PATH}/arcade.bin --goto ${reset} <<EOF
save ${DUMP_PATH}/zero.bin      0000 00ff
save ${DUMP_PATH}/vram.bin      3700 3fff
save ${DUMP_PATH}/ram.bin       0000 3fff
save ${DUMP_PATH}/final.bin     0000 ffff
quit
EOF
