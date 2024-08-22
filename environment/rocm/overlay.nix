{ lib, zlib }:

final: prev:

let
  ops = import ../ops.nix;

  inherit (final.python) sitePackages;
in

{
  pytorch-triton-rocm = lib.pipe prev.pytorch-triton-rocm [
    (ops.addBuildInputs [
      # libz.so.1
      zlib
    ])
  ];

  torch = lib.pipe prev.torch [
    (ops.addBuildInputs [
      # libz.so.1
      zlib
    ])

    (ops.makeSymlinks {
      "$out/${sitePackages}/torch/lib/libhipblaslt.so.0" =
        "$out/${sitePackages}/torch/lib/libhipblaslt.so";

      "$out/${sitePackages}/torch/lib/libamdhip64.so.6" =
        "$out/${sitePackages}/torch/lib/libamdhip64.so";

      "$out/${sitePackages}/torch/lib/libhipblas.so.2" =
        "$out/${sitePackages}/torch/lib/libhipblas.so";

      "$out/${sitePackages}/torch/lib/libhipfft.so.0" =
        "$out/${sitePackages}/torch/lib/libhipfft.so";

      "$out/${sitePackages}/torch/lib/libhipsolver.so.0" =
        "$out/${sitePackages}/torch/lib/libhipsolver.so";

      "$out/${sitePackages}/torch/lib/libhipsparse.so.1" =
        "$out/${sitePackages}/torch/lib/libhipsparse.so";

      "$out/${sitePackages}/torch/lib/libMIOpen.so.1" =
        "$out/${sitePackages}/torch/lib/libMIOpen.so";
    })

    (ops.addSearchPaths [
      # libhipblaslt.so.0
      "$out/${sitePackages}/torch/lib"
    ])
  ];

  torchaudio = lib.pipe prev.torchaudio [
    (ops.addSearchPaths [
      # libamdhip64.so.6
      # libc10_hip.so
      # libhipblas.so.2
      # libhipblaslt.so.0
      # libhipfft.so.0
      # libhipsolver.so.0
      # libhipsparse.so.1
      # libMIOpen.so.1
      # libtorch_hip.so
      "${final.torch}/${sitePackages}/torch/lib"
    ])
  ];

  torchvision = lib.pipe prev.torchvision [
    (ops.addSearchPaths [
      # libamdhip64.so.6
      # libc10_hip.so
      # libtorch_hip.so
      "${final.torch}/${sitePackages}/torch/lib"
    ])
  ];
}
