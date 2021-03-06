#!/usr/bin/env bash

CORE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." &> /dev/null && pwd )"
MAPACHE64_DIR="$( cd "$( dirname "${CORE_DIR}" )/../.." &> /dev/null && pwd )"

FONT_IN="${MAPACHE64_DIR}/txbl_font/font.png"
PMC_OUT="${CORE_DIR}/fusesoc/pmc.mem"

python3 ${MAPACHE64_DIR}/txbl_font/to_rtl_mem.py ${FONT_IN} ${PMC_OUT} && echo "Font loaded from \"${FONT_IN}\" to \"${PMC_OUT}\"." || exit 1
