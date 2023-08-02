# Cores used during compilation
# Use this logic, or simpyl set the JOBS variable manually
# If you're sharing a box, be mindful of not choking the computer during compilation
CORES_PER_SOCKET=`lscpu | grep 'Core(s) per socket' | awk '{print $NF}'`
NUMBER_OF_SOCKETS=`lscpu | grep 'Socket(s)' | awk '{print $NF}'`
export NCORES=$((CORES_PER_SOCKET * NUMBER_OF_SOCKETS))
# If hyperthreading is on, we use all the cores, otherwise, we leave a core unused to avoid choking the box
THREADS_PER_CORE=`lscpu | grep 'Thread(s) per core' | awk '{print $NF}'`
if ((THREADS_PER_CORE > 1)); then JOBS=$NCORES; else JOBS=$((NCORES - 1)); fi
export MAX_JOBS=${MAX_JOBS:-$JOBS}


# Compilation type
export CMAKE_BUILD_TYPE=Release
# CMAKE_BUILD_TYPE=RelWithDebInfo gives you line numbers on gdb,
# but makes the symbol loading phase in gdb and the linking phase in compilation much slower.

# CUDA
export USE_CUDA=1
export TORCH_CUDA_ARCH_LIST="8.0"                 # A100. Set to 7.5 for qgpu
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
export USE_XNNPACK=0                              # quantized


# cmake from conda
export CMAKE_PREFIX_PATH=$CONDA_PREFIX

# nvidia-toolkit from conda. If you have it installed system-wide point CUDA_PATH to the right folder
export CUDA_PATH=$CONDA_PREFIX
export CUDA_HOME=$CUDA_PATH
export CMAKE_CUDA_COMPILER=$CUDA_PATH/bin/nvcc

# ccache
export CMAKE_C_COMPILER_LAUNCHER=ccache
export CMAKE_CXX_COMPILER_LAUNCHER=ccache
export CMAKE_CUDA_COMPILER_LAUNCHER=ccache
