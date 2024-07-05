{ extensions, fetchFromGitHub, lib, python3, sources, writePyproject }:

let
  emptyPyproject = writePyproject {
    name = "comfyui";
    version = "0.0.0";
    dependencies = { };
  };

  ownPropagatedBuildInputs = [
    python3.pkgs.aiohttp
    python3.pkgs.einops
    python3.pkgs.kornia
    python3.pkgs.numpy
    python3.pkgs.pillow
    python3.pkgs.psutil
    python3.pkgs.pyyaml
    python3.pkgs.safetensors
    python3.pkgs.scipy
    python3.pkgs.soundfile
    python3.pkgs.spandrel
    python3.pkgs.spandrel-extra-arches
    python3.pkgs.torch
    python3.pkgs.torchaudio
    python3.pkgs.torchsde
    python3.pkgs.torchvision
    python3.pkgs.tqdm
    python3.pkgs.transformers
  ];

  propagatedBuildInputs = builtins.foldl'
    (acc: extension: acc ++ (extension.propagatedBuildInputs or [ ]))
    ownPropagatedBuildInputs
    extensions;

  pythonpath = python3.pkgs.makePythonPath
    (python3.pkgs.requiredPythonModules propagatedBuildInputs);
in

python3.pkgs.buildPythonApplication {
  name = "comfyui";
  format = "pyproject";
  src = fetchFromGitHub sources.comfyui;

  nativeBuildInputs = [
    python3.pkgs.poetry-core
  ];

  inherit propagatedBuildInputs;

  makeWrapperArgs = [
    "--prefix"
    "PYTHONPATH"
    ":"
    pythonpath

    # "RuntimeError: Found no NVIDIA driver on your system..."
    "--prefix"
    "LD_LIBRARY_PATH"
    ":"
    "/run/opengl-driver/lib"

    # Some dependencies try to dlopen() libnvrtc.so.12 at runtime, namely torch
    # and cupy-cuda12x.
    "--prefix"
    "LD_LIBRARY_PATH"
    ":"
    "${python3.pkgs.nvidia-cuda-nvrtc-cu12}/${python3.sitePackages}/nvidia/cuda_nvrtc/lib"
  ];

  prePatch = ''
    cp ${emptyPyproject} pyproject.toml

    substituteInPlace folder_paths.py \
      --replace-fail \
        "os.path.dirname(os.path.realpath(__file__))" \
        "os.getcwd()" \
      --replace-fail \
        'os.path.join(base_path, "custom_nodes")' \
        'os.path.join(os.path.dirname(__file__), "custom_nodes")'
  '';

  postInstall = ''
    makeWrapper ${lib.getExe python3} $out/bin/comfyui \
      --inherit-argv0 \
      --add-flags $out/${python3.sitePackages}/main.py \
      ''${makeWrapperArgs[@]}

    ${builtins.concatStringsSep "\n" (map (extension: ''
      ln --symbolic ${extension}/${python3.sitePackages} \
        $out/${python3.sitePackages}/custom_nodes/${extension.passthru.originalName}
    '') extensions)}
  '';

  meta = {
    license = lib.licenses.gpl3;
  };
}
