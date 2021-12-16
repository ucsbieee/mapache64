#!/usr/bin/env bash

CORE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." &> /dev/null && pwd )"

FONT_IN="${CORE_DIR}/pmc/font.png"
PMC_OUT="${CORE_DIR}/fusesoc/pmc.mem"

python3 ${CORE_DIR}/pmc/font_converter.py ${FONT_IN} ${PMC_OUT} && echo "Font loaded from \"${FONT_IN}\"." || exit 1
