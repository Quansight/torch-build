#!/bin/sh
nvidia-smi -i 0 --persistence-mode=1
nvidia-smi -i 0 --lock-gpu-clocks=1350
nvidia-smi -i 0 --lock-memory-clocks=1215
