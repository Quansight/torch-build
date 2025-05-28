#!/bin/bash
set -e

PKGS=(pytorch torch-data torch-vision torch-text torch-audio torchbenchmark)

pushd ${PYTORCH_BUILD_DIRECTORY:=~/git$PYTORCH_BUILD_SUFFIX}

for pkg in ${PKGS[@]}; do
  if [ ! -d $pkg ]; then
    echo "Directory $pkg does not exist. Please run torch-clone.sh first!"
    exit 1
  fi
done

for pkg in ${PKGS[@]}; do
  pushd ${pkg}
  git fetch origin --prune
  git checkout main
  git rebase origin/main
  git submodule update --init --recursive
  popd
done

popd
