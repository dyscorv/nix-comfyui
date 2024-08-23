{ autoPatchelfHook, basePython, ffmpeg, lib, sox, tbb_2021_11 }:

final: prev:

let
  ops = import ./ops.nix;

  inherit (final.python) sitePackages;

  bootstrappingBase = basePython.pythonOnBuildForHost.pkgs;

  mkFailingPackage = { pname, message }:
    final.buildPythonPackage {
      inherit pname;
      version = "0.0.0";
      buildCommand = ''
        printf "%s\n" ${lib.escapeShellArg message} >&2
        false
      '';
    };

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
  albucore = lib.pipe prev.albucore [
    replaceOpenCV
  ];

  albumentations = lib.pipe prev.albumentations [
    replaceOpenCV
  ];

  antlr4-python3-runtime = lib.pipe prev.antlr4-python3-runtime [
    (ops.addBuildInputs [
      final.setuptools
    ])
  ];

  fvcore = lib.pipe prev.fvcore [
    (ops.addBuildInputs [
      final.setuptools
    ])
  ];

  insightface = lib.pipe prev.insightface [
    (ops.addBuildInputs [
      final.setuptools
    ])

    (ops.addPropagatedBuildInputs [
      final.onnxruntime
    ])
  ];

  iopath = lib.pipe prev.iopath [
    (ops.addBuildInputs [
      final.setuptools
    ])
  ];

  mediapipe = lib.pipe prev.mediapipe [
    replaceOpenCV
  ];

  # Add autoPatchelfHook to all packages.
  # https://github.com/nix-community/poetry2nix/issues/1589
  mkPoetryDep = attrs:
    let
      originalPoetryDep = prev.mkPoetryDep attrs;
    in
    originalPoetryDep.overridePythonAttrs (old: {
      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
        autoPatchelfHook
      ];
    });

  numba = lib.pipe prev.numba [
    (ops.addBuildInputs [
      # libtbb.so.12
      tbb_2021_11
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

  inherit (bootstrappingBase) packaging;

  pixeloe = lib.pipe prev.pixeloe [
    (ops.addBuildInputs [
      final.setuptools
    ])
  ];

  rembg = lib.pipe prev.rembg [
    replaceOpenCV
  ];

  sacremoses = lib.pipe prev.sacremoses [
    (ops.addBuildInputs [
      final.setuptools
    ])
  ];

  svglib = lib.pipe prev.svglib [
    (ops.addBuildInputs [
      final.setuptools
    ])
  ];

  inherit (bootstrappingBase) tomli;

  torchaudio = lib.pipe prev.torchaudio [
    (ops.addBuildInputs [
      # libavcodec.so.60
      # libavdevice.so.60
      # libavfilter.so.9
      # libavformat.so.60
      # libavutil.so.58
      ffmpeg

      # libsox.so
      sox
    ])

    (ops.ignoreMissingDeps [
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

    (ops.addSearchPaths [
      # libc10.so
      # libtorch_cpu.so
      # libtorch_python.so
      # libtorch.so
      "${final.torch}/${sitePackages}/torch/lib"
    ])
  ];

  torchvision = lib.pipe prev.torchvision [
    (ops.addSearchPaths [
      # libc10.so
      # libtorch_cpu.so
      # libtorch_python.so
      # libtorch.so
      "${final.torch}/${sitePackages}/torch/lib"
    ])
  ];

  wget = lib.pipe prev.wget [
    (ops.addBuildInputs [
      final.setuptools
    ])
  ];
}
