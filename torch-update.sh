#!/bin/bash
set -e

PKGS=(pytorch torch-data torch-vision torch-text torch-audio torch-benchmark)

cd ~/git
for pkg in ${PKGS[@]}; do
  if [ ! -d $pkg ]; then
    echo "Directory $pkg does not exist. Please run torch-clone.py first!"
    exit 1
  fi
done

for pkg in ${PKGS[@]}; do
  pushd ${pkg}
  git fetch origin
  git checkout main
  git rebase origin/main
  git submodule update --init --recursive --jobs 0
  git prune
  popd
done
