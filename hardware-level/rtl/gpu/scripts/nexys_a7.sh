#!/usr/bin/env bash

CORE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." &> /dev/null && pwd )"

${CORE_DIR}/scripts/verify.sh || ${CORE_DIR}/scripts/initialize.sh

cd ${CORE_DIR}/fusesoc
fusesoc run --target nexys_a7 ucsbieee:mapache64:gpu
