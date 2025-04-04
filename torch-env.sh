#!/bin/bash
set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

conda env create \
    -f $SCRIPT_DIR/pytorch-dev.yaml \
    -n ${PYTORCH_CONDA_ENV:=pytorch-dev$PYTORCH_BUILD_SUFFIX}

conda activate $PYTORCH_CONDA_ENV
echo "source $SCRIPT_DIR/torch-common.sh"             > $CONDA_PREFIX/etc/conda/activate.d/activate-torch.sh
echo "source $SCRIPT_DIR/deactivate-torch-common.sh"  > $CONDA_PREFIX/etc/conda/activate.d/deactivate-torch.sh
