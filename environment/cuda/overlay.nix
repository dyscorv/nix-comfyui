{ lib }:

final: prev:

let
  ops = import ../ops.nix;

  inherit (final.python) sitePackages;

  removeConflictingNvidiaFiles = ops.removeFiles [
    "$out/${sitePackages}/nvidia/__init__.py"
    "$out/${sitePackages}/nvidia/__pycache__"
  ];
in

{
  cupy-cuda12x = lib.pipe prev.cupy-cuda12x [
    (ops.ignoreMissingDeps [
      "libcutensor.so.2"
    ])

    (ops.addSearchPaths [
      # libcublas.so.12
      "${final.nvidia-cublas-cu12}/${sitePackages}/nvidia/cublas/lib"

      # libcudnn.so.8
      "${final.nvidia-cudnn-cu12}/${sitePackages}/nvidia/cudnn/lib"

      # libcufft.so.11
      "${final.nvidia-cufft-cu12}/${sitePackages}/nvidia/cufft/lib"

      # libcurand.so.10
      "${final.nvidia-curand-cu12}/${sitePackages}/nvidia/curand/lib"

      # libcusolver.so.11
      "${final.nvidia-cusolver-cu12}/${sitePackages}/nvidia/cusolver/lib"

      # libcusparse.so.12
      "${final.nvidia-cusparse-cu12}/${sitePackages}/nvidia/cusparse/lib"

      # libnccl.so.2
      "${final.nvidia-nccl-cu12}/${sitePackages}/nvidia/nccl/lib"

      # libnvrtc.so.12
      "${final.nvidia-cuda-nvrtc-cu12}/${sitePackages}/nvidia/cuda_nvrtc/lib"
    ])
  ];

  nvidia-cublas-cu12 = lib.pipe prev.nvidia-cublas-cu12 [
    removeConflictingNvidiaFiles
  ];

  nvidia-cuda-cupti-cu12 = lib.pipe prev.nvidia-cuda-cupti-cu12 [
    removeConflictingNvidiaFiles
  ];

  nvidia-cuda-nvrtc-cu12 = lib.pipe prev.nvidia-cuda-nvrtc-cu12 [
    removeConflictingNvidiaFiles
  ];

  nvidia-cuda-runtime-cu12 = lib.pipe prev.nvidia-cuda-runtime-cu12 [
    removeConflictingNvidiaFiles
  ];

  nvidia-cudnn-cu12 = lib.pipe prev.nvidia-cudnn-cu12 [
    (ops.addRunpaths [
      # libcudnn.so.8 performs `dlopen("libcudnn_ops_infer.so.8")`
      "${placeholder "out"}/${sitePackages}/nvidia/cudnn/lib"
    ])

    removeConflictingNvidiaFiles
  ];

  nvidia-cufft-cu12 = lib.pipe prev.nvidia-cufft-cu12 [
    removeConflictingNvidiaFiles
  ];

  nvidia-curand-cu12 = lib.pipe prev.nvidia-curand-cu12 [
    removeConflictingNvidiaFiles
  ];

  nvidia-cusolver-cu12 = lib.pipe prev.nvidia-cusolver-cu12 [
    (ops.addSearchPaths [
      # libcublas.so.12
      # libcublasLt.so.12
      "${final.nvidia-cublas-cu12}/${sitePackages}/nvidia/cublas/lib"

      # libcusparse.so.12
      "${final.nvidia-cusparse-cu12}/${sitePackages}/nvidia/cusparse/lib"

      # libnvJitLink.so.12
      "${final.nvidia-nvjitlink-cu12}/${sitePackages}/nvidia/nvjitlink/lib"
    ])

    removeConflictingNvidiaFiles
  ];

  nvidia-cusparse-cu12 = lib.pipe prev.nvidia-cusparse-cu12 [
    (ops.addSearchPaths [
      # libnvJitLink.so.12
      "${final.nvidia-nvjitlink-cu12}/${sitePackages}/nvidia/nvjitlink/lib"
    ])

    removeConflictingNvidiaFiles
  ];

  nvidia-nccl-cu12 = lib.pipe prev.nvidia-nccl-cu12 [
    removeConflictingNvidiaFiles
  ];

  nvidia-nvjitlink-cu12 = lib.pipe prev.nvidia-nvjitlink-cu12 [
    removeConflictingNvidiaFiles
  ];

  nvidia-nvtx-cu12 = lib.pipe prev.nvidia-nvtx-cu12 [
    removeConflictingNvidiaFiles
  ];

  torch = lib.pipe prev.torch [
    (ops.addPropagatedBuildInputs [
      # https://github.com/pytorch/pytorch/blob/dacc33d/torch/utils/cpp_extension.py#L10
      final.setuptools
    ])

    (ops.ignoreMissingDeps [
      "libcuda.so.1"
    ])

    (ops.addSearchPaths [
      # libcublas.so.12
      # libcublasLt.so.12
      "${final.nvidia-cublas-cu12}/${sitePackages}/nvidia/cublas/lib"

      # libcudart.so.12
      "${final.nvidia-cuda-runtime-cu12}/${sitePackages}/nvidia/cuda_runtime/lib"

      # libcudnn.so.8
      "${final.nvidia-cudnn-cu12}/${sitePackages}/nvidia/cudnn/lib"

      # libcufft.so.11
      "${final.nvidia-cufft-cu12}/${sitePackages}/nvidia/cufft/lib"

      # libcupti.so.12
      "${final.nvidia-cuda-cupti-cu12}/${sitePackages}/nvidia/cuda_cupti/lib"

      # libcurand.so.10
      "${final.nvidia-curand-cu12}/${sitePackages}/nvidia/curand/lib"

      # libcusolver.so.11
      "${final.nvidia-cusolver-cu12}/${sitePackages}/nvidia/cusolver/lib"

      # libcusparse.so.12
      "${final.nvidia-cusparse-cu12}/${sitePackages}/nvidia/cusparse/lib"

      # libnccl.so.2
      "${final.nvidia-nccl-cu12}/${sitePackages}/nvidia/nccl/lib"

      # libnvrtc.so.12
      "${final.nvidia-cuda-nvrtc-cu12}/${sitePackages}/nvidia/cuda_nvrtc/lib"

      # libnvToolsExt.so.1
      "${final.nvidia-nvtx-cu12}/${sitePackages}/nvidia/nvtx/lib"
    ])
  ];

  torchaudio = lib.pipe prev.torchaudio [
    (ops.addSearchPaths [
      # libc10_cuda.so
      # libtorch_cuda.so
      "${final.torch}/${sitePackages}/torch/lib"

      # libcudart.so.12
      "${final.nvidia-cuda-runtime-cu12}/${sitePackages}/nvidia/cuda_runtime/lib"
    ])
  ];

  torchvision = lib.pipe prev.torchvision [
    (ops.addSearchPaths [
      # libc10_cuda.so
      # libtorch_cuda.so
      "${final.torch}/${sitePackages}/torch/lib"

      # libcudart.so.12
      "${final.nvidia-cuda-runtime-cu12}/${sitePackages}/nvidia/cuda_runtime/lib"
    ])
  ];
}
