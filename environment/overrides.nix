# References:
# - https://raw.githubusercontent.com/nix-community/poetry2nix/master/overrides/build-systems.json
# - https://raw.githubusercontent.com/nix-community/poetry2nix/master/overrides/default.nix

{ basePython, ffmpeg, lib, sox }:

final: prev:

let
  inherit (lib) pipe;
  inherit (final.python) sitePackages;

  mkFailingPackage = { pname, message }:
    final.buildPythonPackage {
      inherit pname;
      version = "0.0.0";
      buildCommand = ''
        printf "%s\n" ${lib.escapeShellArg message} >&2
        false
      '';
    };

  addAutoPatchelfSearchPath = paths: package:
    package.overridePythonAttrs (old: {
      preFixup = ''
        ${old.preFixup or ""}
        ${builtins.concatStringsSep "\n"
          (map (path: "addAutoPatchelfSearchPath ${path}") paths)}
      '';
    });

  addBuildInputs = inputs: package:
    package.overridePythonAttrs (old: {
      buildInputs = (old.buildInputs or [ ]) ++ inputs;
    });

  addPropagatedBuildInputs = inputs: package:
    package.overridePythonAttrs (old: {
      propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ inputs;
    });

  addRunpaths = runpaths: package:
    package.overridePythonAttrs (old: {
      appendRunpaths = (old.appendRunpaths or [ ]) ++ runpaths;
    });

  ignoreMissingDeps = deps: package:
    package.overridePythonAttrs (old: {
      autoPatchelfIgnoreMissingDeps = deps;
    });

  removeFiles = paths: package:
    package.overridePythonAttrs (old: {
      postFixup = ''
        ${old.postFixup or ""}
        ${builtins.concatStringsSep "\n" (map (path:
          "rm -rf $out/${sitePackages}/${lib.escapeShellArg path}") paths)}
      '';
    });

  replaceOpenCV = package:
    package.overridePythonAttrs (old: {
      propagatedBuildInputs =
        let
          originalInputs = old.propagatedBuildInputs;
          filteredInputs = (builtins.filter
            (x: !(builtins.elem x.pname [
              "opencv-contrib-python"
              "opencv-contrib-python-headless"
              "opencv-python-headless"
            ]))
            originalInputs);
        in
        if builtins.length originalInputs == builtins.length filteredInputs then
          throw "Package ${package.pname} does not depend on opencv-*"
        else
          filteredInputs ++ [ final.opencv-python ];
    });
in

{
  albucore = pipe prev.albucore [
    replaceOpenCV
  ];

  albumentations = pipe prev.albumentations [
    replaceOpenCV
  ];

  antlr4-python3-runtime = pipe prev.antlr4-python3-runtime [
    (addBuildInputs [
      final.setuptools
    ])
  ];

  cupy-cuda12x = pipe prev.cupy-cuda12x [
    (ignoreMissingDeps [
      "libcutensor.so.2"
    ])

    (addAutoPatchelfSearchPath [
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

  fvcore = pipe prev.fvcore [
    (addBuildInputs [
      final.setuptools
    ])
  ];

  insightface = pipe prev.insightface [
    (addBuildInputs [
      final.setuptools
    ])

    (addPropagatedBuildInputs [
      final.onnxruntime
    ])
  ];

  iopath = pipe prev.iopath [
    (addBuildInputs [
      final.setuptools
    ])
  ];

  mediapipe = pipe prev.mediapipe [
    replaceOpenCV
  ];

  nvidia-cublas-cu12 = pipe prev.nvidia-cublas-cu12 [
    (removeFiles [
      "nvidia/__init__.py"
      "nvidia/__pycache__"
    ])
  ];

  nvidia-cuda-cupti-cu12 = pipe prev.nvidia-cuda-cupti-cu12 [
    (removeFiles [
      "nvidia/__init__.py"
      "nvidia/__pycache__"
    ])
  ];

  nvidia-cuda-nvrtc-cu12 = pipe prev.nvidia-cuda-nvrtc-cu12 [
    (removeFiles [
      "nvidia/__init__.py"
      "nvidia/__pycache__"
    ])
  ];

  nvidia-cuda-runtime-cu12 = pipe prev.nvidia-cuda-runtime-cu12 [
    (removeFiles [
      "nvidia/__init__.py"
      "nvidia/__pycache__"
    ])
  ];

  nvidia-cudnn-cu12 = pipe prev.nvidia-cudnn-cu12 [
    (addRunpaths [
      # libcudnn.so.8 performs `dlopen("libcudnn_ops_infer.so.8")`
      "${placeholder "out"}/${sitePackages}/nvidia/cudnn/lib"
    ])

    (removeFiles [
      "nvidia/__init__.py"
      "nvidia/__pycache__"
    ])
  ];

  nvidia-cufft-cu12 = pipe prev.nvidia-cufft-cu12 [
    (removeFiles [
      "nvidia/__init__.py"
      "nvidia/__pycache__"
    ])
  ];

  nvidia-curand-cu12 = pipe prev.nvidia-curand-cu12 [
    (removeFiles [
      "nvidia/__init__.py"
      "nvidia/__pycache__"
    ])
  ];

  nvidia-cusolver-cu12 = pipe prev.nvidia-cusolver-cu12 [
    (addAutoPatchelfSearchPath [
      # libcublas.so.12
      # libcublasLt.so.12
      "${final.nvidia-cublas-cu12}/${sitePackages}/nvidia/cublas/lib"

      # libcusparse.so.12
      "${final.nvidia-cusparse-cu12}/${sitePackages}/nvidia/cusparse/lib"

      # libnvJitLink.so.12
      "${final.nvidia-nvjitlink-cu12}/${sitePackages}/nvidia/nvjitlink/lib"
    ])

    (removeFiles [
      "nvidia/__init__.py"
      "nvidia/__pycache__"
    ])
  ];

  nvidia-cusparse-cu12 = pipe prev.nvidia-cusparse-cu12 [
    (addAutoPatchelfSearchPath [
      # libnvJitLink.so.12
      "${final.nvidia-nvjitlink-cu12}/${sitePackages}/nvidia/nvjitlink/lib"
    ])

    (removeFiles [
      "nvidia/__init__.py"
      "nvidia/__pycache__"
    ])
  ];

  nvidia-nccl-cu12 = pipe prev.nvidia-nccl-cu12 [
    (removeFiles [
      "nvidia/__init__.py"
      "nvidia/__pycache__"
    ])
  ];

  nvidia-nvjitlink-cu12 = pipe prev.nvidia-nvjitlink-cu12 [
    (removeFiles [
      "nvidia/__init__.py"
      "nvidia/__pycache__"
    ])
  ];

  nvidia-nvtx-cu12 = pipe prev.nvidia-nvtx-cu12 [
    (removeFiles [
      "nvidia/__init__.py"
      "nvidia/__pycache__"
    ])
  ];

  opencv-contrib-python = mkFailingPackage {
    pname = "opencv-contrib-python";
    message = "Use opencv-python instead of opencv-contrib-python";
  };

  opencv-contrib-python-headless = mkFailingPackage {
    pname = "opencv-contrib-python-headless";
    message = "Use opencv-python instead of opencv-contrib-python-headless";
  };

  opencv-python-headless = mkFailingPackage {
    pname = "opencv-python-headless";
    message = "Use opencv-python instead of opencv-python-headless";
  };

  # > do not know how to unpack source archive /nix/store/*.whl
  inherit (basePython.pkgs) packaging tomli;

  sacremoses = pipe prev.sacremoses [
    (addBuildInputs [
      final.setuptools
    ])
  ];

  svglib = pipe prev.svglib [
    (addBuildInputs [
      final.setuptools
    ])
  ];

  torch = pipe prev.torch [
    (addPropagatedBuildInputs [
      # https://github.com/pytorch/pytorch/blob/dacc33d/torch/utils/cpp_extension.py#L10
      final.setuptools
    ])

    (ignoreMissingDeps [
      "libcuda.so.1"
    ])

    (addAutoPatchelfSearchPath [
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

  torchaudio = pipe prev.torchaudio [
    (ignoreMissingDeps [
      "libavcodec.so.58"
      "libavcodec.so.59"
      "libavdevice.so.58"
      "libavdevice.so.59"
      "libavfilter.so.7"
      "libavfilter.so.8"
      "libavformat.so.58"
      "libavformat.so.59"
      "libavutil.so.56"
      "libavutil.so.57"
    ])

    (addAutoPatchelfSearchPath [
      # libavcodec.so.60
      # libavdevice.so.60
      # libavfilter.so.9
      # libavformat.so.60
      # libavutil.so.58
      "${ffmpeg.lib}/lib"

      # libsox.so
      "${sox.lib}/lib"

      # libc10_cuda.so
      # libc10.so
      # libtorch_cpu.so
      # libtorch_cuda.so
      # libtorch_python.so
      # libtorch.so
      "${final.torch}/${sitePackages}/torch/lib"

      # libcudart.so.12
      "${final.nvidia-cuda-runtime-cu12}/${sitePackages}/nvidia/cuda_runtime/lib"
    ])
  ];

  torchvision = pipe prev.torchvision [
    (addAutoPatchelfSearchPath [
      # libc10_cuda.so
      # libc10.so
      # libtorch_cpu.so
      # libtorch_cuda.so
      # libtorch_python.so
      # libtorch.so
      "${final.torch}/${sitePackages}/torch/lib"

      # libcudart.so.12
      "${final.nvidia-cuda-runtime-cu12}/${sitePackages}/nvidia/cuda_runtime/lib"
    ])
  ];
}
