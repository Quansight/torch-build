#!/bin/bash
set -e

mkdir -p ${PYTORCH_BUILD_DIRECTORY:=~/git$PYTORCH_BUILD_SUFFIX}
pushd $PYTORCH_BUILD_DIRECTORY

# PyTorch
git clone git@github.com:${PYTORCH_GIT_USER:=pytorch}/pytorch.git
pushd pytorch
git submodule update --init --recursive
if [ "$PYTORCH_GIT_USER" != "pytorch" ]; then
  git remote add upstream git@github.com:pytorch/pytorch.git
fi

popd

# Domain Libraries
PKGS=(data vision text audio)
for pkg in ${PKGS[@]}; do
	git clone git@github.com:pytorch/${pkg}.git "torch-${pkg}"
done

# torch/benchmarkBenchmark
# torchbenchmark needs to have this name and be in the same folder as
# PyTorch, otherwise benchmarks/dynamo/torchbench.py won't find it
git clone git@github.com:pytorch/benchmark.git "torchbenchmark"

popd
