# Cores used during compilation
# Use this logic, or simply set the JOBS variable manually
# If you are sharing a box, be mindful of not choking the computer during compilation
if [[ "$(uname)" == "Linux" ]]; then
  CORES_PER_SOCKET=$(lscpu | grep 'Core(s) per socket' | awk '{print $NF}')
  NUMBER_OF_SOCKETS=$(lscpu | grep 'Socket(s)' | awk '{print $NF}')
  export NCORES=$((CORES_PER_SOCKET * NUMBER_OF_SOCKETS))
  export MAX_JOBS=${MAX_JOBS:-$NCORES}
fi

# Compilation type
export CMAKE_BUILD_TYPE=Release
# CMAKE_BUILD_TYPE=RelWithDebInfo gives you line numbers on gdb,
# but makes the symbol loading phase in gdb and the linking phase in compilation much slower.

# CUDA
if [[ "$(uname)" == "Darwin" ]]; then
  export USE_CUDA=0
else
  export USE_CUDA=1
fi

if [[ -n "$TORCH_CUDA_ARCH_LIST" ]]; then
    :
elif [[ $(hostname) = qgpu* ]]; then
    export TORCH_CUDA_ARCH_LIST="7.5"  # qgpu server
else
    export TORCH_CUDA_ARCH_LIST="8.0"  # A100 architecture
fi

# Faster recompilation
export USE_PRECOMPILED_HEADERS=1
export USE_PER_OPERATOR_HEADERS=1
export CCACHE_COMPRESS=true
export CCACHE_SLOPPINESS=pch_defines,time_macros  # Necessary for precompiled headers
# General utils
export USE_KINETO=1                               # profiler
export USE_CUDNN=1                                # CNNs
export USE_FBGEMM=1                               # GEMMs
# Don't build what we don't need
export BUILD_TEST=0                               # C++ tests
export BUILD_CAFFE2=0                             # caffe2
export BUILD_CAFFE2_OPS=0                         # caffe2
export USE_DISTRIBUTED=0                          # distributed
export USE_NCCL=0                                 # distributed
export USE_GLOO=0                                 # distributed
export USE_QNNPACK=0                              # quantized
export USE_XNNPACK=0                              # quantized
# Disable these unless you are going to benchmark them
export USE_FLASH_ATTENTION=0
export USE_MEM_EFF_ATTENTION=0



# cmake from conda
export CMAKE_PREFIX_PATH=$CONDA_PREFIX

# Use cudatoolkit from conda (see pytorch-dev.yaml)
# If you have it installed system-wide (e.g. in qgpu) and you want to use it,
# point CUDA_PATH and CMAKE_CUDA_COMPILER to the right folder
export CUDA_PATH=$CONDA_PREFIX
export CUDA_HOME=$CUDA_PATH
export CMAKE_CUDA_COMPILER=$CONDA_PREFIX/bin/nvcc

# Note: targets/x86_64-linux is added because of the use of deprecated find_package(CUDA).
# Usually `cuda_runtime.h` is found in CUDA_HOME and find_package(CUDA) expects that.
# However with conda, cuda headers are in $CUDA_HOME/targets/x86_64-linux/include
# instead of $CUDA_HOME/include to avoid cloberring the top level directory with names like
# mma.h. The new way `enable_languages(CUDA)` knows about this, but pytorch uses both
# mechanisms.
export CUDA_INC_PATH="$CUDA_PATH/targets/x86_64-linux/include"

# ccache
export CMAKE_C_COMPILER_LAUNCHER=ccache
export CMAKE_CXX_COMPILER_LAUNCHER=ccache
export CMAKE_CUDA_COMPILER_LAUNCHER=ccache
