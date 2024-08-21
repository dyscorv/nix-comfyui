{ fetchFromGitHub, lib, python3, writePyproject }:

let
  pyproject = writePyproject {
    name = "comfyui-unwrapped";
    version = "0.0.0";
    dependencies = { };
  };
in

python3.pkgs.buildPythonPackage {
  name = "comfyui-unwrapped";
  version = "0.0.0";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "comfyanonymous";
    repo = "ComfyUI";
    fetchSubmodules = false;
    rev = "ea63b1c092e2974be9bcf4753d5305213f188e25";
    hash = "sha256-s+8FyMoK+V2xwuSd1T5QhLKcX7hWkwrU8COnDcEMskg=";
  };

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
    python3.pkgs.requests
    python3.pkgs.safetensors
    python3.pkgs.scipy
    python3.pkgs.sentencepiece
    python3.pkgs.soundfile
    python3.pkgs.spandrel
    python3.pkgs.spandrel-extra-arches
    python3.pkgs.tokenizers
    python3.pkgs.torch
    python3.pkgs.torchaudio
    python3.pkgs.torchsde
    python3.pkgs.torchvision
    python3.pkgs.tqdm
    python3.pkgs.transformers
    python3.pkgs.typing-extensions
  ];

  patches = [
    ./0001-fix-paths.patch
  ];

  postPatch = ''
    cp ${pyproject} pyproject.toml
    rm --force --recursive .ci script_examples tests-unit web
  '';

  pythonImportsCheck = [
    "folder_paths"
  ];

  passthru = {
    check-pkgs.ignoredModuleNames = [
      "^intel_extension_for_pytorch$"
      "^torch_directml$"
      "^xformers(\\..+)?$"
    ];
  };

  meta = {
    license = lib.licenses.gpl3;
  };
}