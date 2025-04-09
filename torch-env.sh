#!/bin/bash
set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

conda env create \
    -f $SCRIPT_DIR/pytorch-dev.yaml \
    -n ${PYTORCH_CONDA_ENV:=pytorch-dev$PYTORCH_BUILD_SUFFIX}

conda activate $PYTORCH_CONDA_ENV
conda env config vars set CUDA_HOME=$CONDA_PREFIX
conda env config vars set CUDA_INC_PATH=$CONDA_PREFIX/targets/x86_64-linux/inc
conda deactivate
