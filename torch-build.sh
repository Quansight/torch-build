#!/bin/bash
set -e

# conda and the env vars are set correctly in pytorch-build.py
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/pytorch-build.sh $@


PKGS=(data vision audio)

export BUILD_SOX=0

cd ${PYTORCH_BUILD_DIRECTORY:=~/git$PYTORCH_BUILD_SUFFIX}
rm -rf torch-vision/build

for pkg in ${PKGS[@]}; do
  pip uninstall -y "torch${pkg}"
  pushd "torch-${pkg}"
  pip install -e . --no-build-isolation -v
  popd
done

pip uninstall -y torchbenchmark
pushd torchbenchmark
python install.py
