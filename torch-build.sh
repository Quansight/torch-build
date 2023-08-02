#!/bin/bash
set -e

# conda and the env vars are set correctly in pytorch-build.py
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/pytorch-build.sh $@

pip uninstall -y torchvision torchtext torchaudio torchdata torchbenchmark

PKGS=(data vision text audio)

export BUILD_SOX=0

cd ~/git/
rm -rf torch-vision/build

for pkg in ${PKGS[@]}; do
  pushd "torch-${pkg}"
  python setup.py install
  popd
done

pushd torch-benchmark
python install.py
