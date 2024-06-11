#!/bin/bash
set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

eval "$(conda shell.bash hook)"
conda activate ${PYTORCH_CONDA_ENV:=pytorch-dev$PYTORCH_BUILD_SUFFIX}
cd ${PYTORCH_BUILD_DIRECTORY:=~/git$PYTORCH_BUILD_SUFFIX}/pytorch

source $SCRIPT_DIR/torch-common.sh

pwd
pip uninstall torch -y
python setup.py develop $@

# comment out if you're developing triton as well
make triton
