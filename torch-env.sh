#!/bin/bash
set -e

SCRIPT_DIR=$( pushd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if [[ $OSTYPE =~ darwin ]]; then
  conda env create \
      -f $SCRIPT_DIR/pytorch-dev-macos.yaml \
      -n ${PYTORCH_CONDA_ENV:=pytorch-dev$PYTORCH_BUILD_SUFFIX}
else
  conda env create \
      -f $SCRIPT_DIR/pytorch-dev.yaml \
      -n ${PYTORCH_CONDA_ENV:=pytorch-dev$PYTORCH_BUILD_SUFFIX}
fi

eval "$(conda shell.bash hook)"
conda activate ${PYTORCH_CONDA_ENV:=pytorch-dev${PYTORCH_BUILD_SUFFIX}}

# Pin the BLAS type, so that future package installs don't inadvertently switch it.
if [[ $OSTYPE =~ darwin ]]; then
  echo "libblas=*=*_newaccelerate" >> $CONDA_PREFIX/conda-meta/pinned
else
  echo "libblas=*=*_blis" >> $CONDA_PREFIX/conda-meta/pinned
fi

echo "source $SCRIPT_DIR/torch-common.sh" > $CONDA_PREFIX/etc/conda/activate.d/activate-torch.sh
echo "source $SCRIPT_DIR/deactivate-torch-common.sh" > $CONDA_PREFIX/etc/conda/deactivate.d/deactivate-torch.sh
