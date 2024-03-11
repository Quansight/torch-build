# Compiling PyTorch

### Setting up the environment

- Set the correct CUDA version in `pytorch-dev.yaml` by changing the line `cuda-version=12.2`

- Create the conda environment: `conda env create -f pytorch-dev.yaml`

- [If you don't have them] Install the Nvidia drivers from https://www.nvidia.com/download/index.aspx

**Python version**. We set python=3.8 in `pytorch-dev.yaml`, as this is the minimum required version in PyTorch, and this disallows us from using features that are "too new".
To debug some issues that may not reproduce on Python 3.8, you may need to create a different env with a newer Python version.


### Building PyTorch and due diligence

- Have a read through the `pytorch-*` and `torch-*` scripts and edit them as needed.
  - You will at least need to set `CUDA_PATH` and `TORCH_CUDA_ARCH_LIST` correctly in `torch-common.sh`.
  - These scripts give you "sane defaults", but feel free to tailor them to your liking.
- Running `torch-clone.sh` will download PyTorch and all the domain libraries. If you just want PyTorch, you can edit the script accordingly.
- Running `pytorch-build.sh` will compile PyTorch.
- Running `torch-build.sh` will compile PyTorch, the domain libs, and torchbench. Most people won't need this.
- Running `torch-update.sh` checks out the last `main` in all the libraries. Useful if you haven't compiled in a while.


# Running torchbench

Without making some of the following changes, benchmarks you run can be highly unstable, varying as much as 10% from run to run, even if you are running each benchmark multiple times. Note that you require root to be able to enact most of them.

In the `torchbench` repo there is a script to do the configuration for a specific AWS instance that the Meta team uses for the benchmarks (g4dn.metal). You can run it with the command

```
sudo $(which python) torchbenchmark/util/machine_config.py --configure
```

Unfortunately, this is unlikely to work if you use other machines and you'll have to do the steps manually.

## GPU benchmarks

Here the main thing is to set the GPU clock frequency to a fixed value. Without this it might be scaling in response to workload. You need `nvidia-smi` installed. For A100 GPU you can use the ``lock-clock-a100.sh` script:

```sh
sudo ./lock-clock-a100.sh
```

For other GPUs, the correct clock speeds will vary. You can check
[this AWS page](https://docs.amazonaws.cn/en_us/AWSEC2/latest/UserGuide/optimize_gpu.html) for combinations for a few different GPU models.

Note that you may need to rerun this command every time the machine is rebooted, unless you enable option persistance with

`sudo nvidia-smi --persistence-mode=1`

## CPU benchmarks

You need to:

1. Disable hyperthreading. Look at what the `set_hyper_threading` function in the `torchbenchmark/util/machine_config.py` does.
2. Disable Turbo Boost. The CPU might not have it, if the directory `/sys/devices/system/cpu/intel_pstate` does not exist, no need to do anything. If it does exist, look at `set_intel_no_turbo_state` and `set_pstate_frequency` in `machine_config.py`.
3. Set Intel c-state to 1. You need to edit `/etc/default/grub` and add `intel_idle.max_cstate=1` to the `GRUB_CMDLINE_LINUX_DEFAULT` variable. Then run `sudo update-grub` and reboot.
3. CPU core isolation. This might not be strictly necessary if you can make sure there are no other processes running in the machine when running the benchmarks. The idea is to tell the OS not use some CPU cores at all unless they are specifically requested by `taskset`. Note that if you do this it will make all other workflows (such as compilation) slower since they will have less cores they can use.  To do this follow the same steps as in previous point but instead of `intel_idle.max_cstate=1` add `isolcpus=6-11` where `6-11` is the range of cores you want to isolate.

