#!/bin/bash
set -e

SCRIPT_DIR=$( pushd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

conda env create \
    -f $SCRIPT_DIR/pytorch-dev.yaml \
    -n ${PYTORCH_CONDA_ENV:=pytorch-dev$PYTORCH_BUILD_SUFFIX}

conda activate ${PYTORCH_CONDA_ENV:=pytorch-dev$PYTORCH_BUILD_SUFFIX}}
echo "source ~/git/torch-build/torch-common.sh"             > $CONDA_PREFIX/etc/conda/activate.d/activate-torch.sh
echo "source ~/git/torch-build/deactivate-torch-common.sh"  > $CONDA_PREFIX/etc/conda/activate.d/deactivate-torch.sh

popd
