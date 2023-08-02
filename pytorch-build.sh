#!/bin/bash
set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

eval "$(conda shell.bash hook)"
conda activate pytorch-dev
cd ~/git/pytorch


source $SCRIPT_DIR/torch-common.sh

pip uninstall torch -y
python setup.py develop $@

# comment out if you're developing triton as well
make triton
