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
    rev = "dafbe321d2dfbe2cabd9eb32e88f8088996cd524";
    hash = "sha256-ciJ2s5lhTtLWpG4b+MZZS21lrNE/rJn7wJ84PTQ+uhE=";
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
