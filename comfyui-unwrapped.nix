{ fetchFromGitHub, lib, python3, sources, writePyproject }:

let
  pyproject = writePyproject {
    name = "comfyui-unwrapped";
    version = "0.0.0";
    dependencies = { };
  };
in

python3.pkgs.buildPythonPackage {
  name = "comfyui-unwrapped";
  format = "pyproject";
  src = fetchFromGitHub sources.comfyui;

  nativeBuildInputs = [
    python3.pkgs.poetry-core
  ];

  propagatedBuildInputs = [
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

  prePatch = ''
    cp ${pyproject} pyproject.toml

    substituteInPlace folder_paths.py \
      --replace-fail \
        "os.path.dirname(os.path.realpath(__file__))" \
        "os.getcwd()" \
      --replace-fail \
        'os.path.join(base_path, "custom_nodes")' \
        'os.getenv("NIX_COMFYUI_CUSTOM_NODES", os.path.join(os.getcwd(), "custom_nodes"))'
  '';

  meta = {
    license = lib.licenses.gpl3;
  };
}