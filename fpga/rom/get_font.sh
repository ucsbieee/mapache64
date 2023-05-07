#!/usr/bin/env bash

set -e

MAPACHE64_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../.." &> /dev/null && pwd )"

FONT_IN="${MAPACHE64_DIR}/txbl_font/font.png"
PMC_OUT="${MAPACHE64_DIR}/fpga/rom/build/pmc.mem"

python3 ${MAPACHE64_DIR}/txbl_font/to_rtl_mem.py ${FONT_IN} ${PMC_OUT}
echo "Font loaded from \"${FONT_IN}\" to \"${PMC_OUT}\"."
