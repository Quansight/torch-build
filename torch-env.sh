#!/bin/bash
set -e

SCRIPT_DIR=$( pushd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

conda env create \
    -f $SCRIPT_DIR/pytorch-dev.yaml \
    -n ${PYTORCH_CONDA_ENV:=pytorch-dev$PYTORCH_BUILD_SUFFIX}
popd
