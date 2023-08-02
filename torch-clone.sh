#!/bin/bash
set -e

PKGS=(data vision text audio benchmark)

mkdir -p ~/git
cd ~/git
git clone git@github.com:pytorch/pytorch.git
for pkg in ${PKGS[@]}; do
	git clone git@github.com:pytorch/${pkg}.git "torch-${pkg}"
done
