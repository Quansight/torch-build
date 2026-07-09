#!/bin/bash
set -e

# conda and the env vars are set correctly in pytorch-build.py
SCRIPT_DIR=$( pushd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/pytorch-build.sh $@
pushd ${PYTORCH_BUILD_DIRECTORY:=~/git$PYTORCH_BUILD_SUFFIX}

PKGS=(data vision audio)
for pkg in ${PKGS[@]}; do
  pip uninstall -y "torch${pkg}"
  pushd "torch-${pkg}"
  pip install . --no-build-isolation -v
  popd
done

pip uninstall -y torchbenchmark
pushd torchbenchmark
python install.py --continue_on_fail
popd

# leave build directory
popd
