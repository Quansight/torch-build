# Compiling PyTorch

If you don't have gcc, g++, install them from apt-get.

**Note: Installing a previous compiler at your own risk**
If you want to go the extra mile, you can install gcc-9, g++-9, as this is the minimum required version.
This will help you make sure the code you write works on these compilers.
Note that to do this you might need to do something along the lines of https://askubuntu.com/a/26518
At the time of this writing, I got some errors when compiling cublasLt as it was using a custom g++10


Install the Nvidia drivers from https://www.nvidia.com/download/index.aspx

Then create the conda environment
```bash
conda env create -f pytorch-dev.yaml
```
We also set python=3.8 in `pytorch-dev.yaml`, as this is the minimum required version in PyTorch, and this disallows us from using features that are "too new".

Have a read through the `pytorch-*` and `torch-*` scripts and change them as needed.

Finally, running `torch-clone.sh` and `torch-build.sh` should give you a working torchbench installation.

The folder structure is defined in `torch-clone.py` and is given by `~/git/{pytorch,torch-audio,torch-benchmark,torch-data,torch-text,torch-vision}`.

If you are just working on PyTorch, you probably won't need `torch-build.sh` but simply `pytorch-build.sh`.


# Running torchbench

Without making some of the following changes, benchmarks you run can be highly unstable, varying as much as 10% from run to run, even if you are running each benchmark multiple times. Note that you require root to be able to enact most of them.

In the `torchbench` repo there is a script to do the configuration for a specific AWS instance that the Meta team uses for the benchmarks (g4dn.metal). You can run it with the command

```
sudo $(which python) torchbenchmark/util/machine_config.py --configure
```

Unfortunately, this is unlikely to work if you use other machines and you'll have to do the steps manually.

## GPU benchmarks

Here the main thing is to set the GPU clock frequency to a fixed value. Without this it might be scaling in response to workload. You need `nvidia-smi` installed. For A100 GPU the correct command is:

`sudo nvidia-smi -ac 1215,1410`

For other GPUs, the numbers in last argument will vary. You can check
[this AWS page](https://docs.amazonaws.cn/en_us/AWSEC2/latest/UserGuide/optimize_gpu.html) for combinations for a few different GPU models.

Note that you may need to rerun this command every time the machine is rebooted, unless you enable option persistance with

`sudo nvidia-smi --persistence-mode=1`

## CPU benchmarks

You need to:

1. Disable hyperthreading. Look at what the `set_hyper_threading` function in the `torchbenchmark/util/machine_config.py` does.
2. Disable Turbo Boost. The CPU might not have it, if the directory `/sys/devices/system/cpu/intel_pstate` does not exist, no need to do anything. If it does exist, look at `set_intel_no_turbo_state` and `set_pstate_frequency` in `machine_config.py`.
3. Set Intel c-state to 1. You need to edit `/etc/default/grub` and add `intel_idle.max_cstate=1` to the `GRUB_CMDLINE_LINUX_DEFAULT` variable. Then run `sudo update-grub` and reboot.
3. CPU core isolation. This might not be strictly necessary if you can make sure there are no other processes running in the machine when running the benchmarks. The idea is to tell the OS not use some CPU cores at all unless they are specifically requested by `taskset`. Note that if you do this it will make all other workflows (such as compilation) slower since they will have less cores they can use.  To do this follow the same steps as in previous point but instead of `intel_idle.max_cstate=1` add `isolcpus=6-11` where `6-11` is the range of cores you want to isolate.
