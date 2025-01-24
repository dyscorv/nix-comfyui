{ emptyPyproject, fetchFromGitHub, lib, python3 }:

let
  pyproject = emptyPyproject.override {
    content = {
      tool.poetry.name = "comfyui-unwrapped";
      tool.poetry.version = "0.0.0";
    };
  };

  src = fetchFromGitHub {
    owner = "comfyanonymous";
    repo = "ComfyUI";
    fetchSubmodules = false;
    rev = "55add502206ed5511a04215db4ab8f1cfa3d99ae";
    hash = "sha256-QwdgUhOrTYD4D5lqfayoTVCwORE/I5s6NL/+iWHpOlw=";
  };

  shortRev = builtins.substring 0 8 src.rev;
in

python3.pkgs.buildPythonPackage {
  name = "comfyui-unwrapped";
  version = "0.0.0";

  format = "pyproject";

  inherit src;

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

  postPatch = ''
    cp ${pyproject} pyproject.toml

    printf "{}\n" >extra_model_paths.yaml

    substituteInPlace server.py \
      --subst-var-by version ${lib.escapeShellArg shortRev}

    rm --force --recursive \
      .ci \
      .gitattributes \
      .github \
      .gitignore \
      .pylintrc \
      CODEOWNERS \
      comfyui_screenshot.png \
      CONTRIBUTING.md \
      custom_nodes \
      extra_model_paths.yaml.example \
      input \
      LICENSE \
      models \
      new_updater.py \
      notebooks \
      output \
      pytest.ini \
      README.md \
      script_examples \
      tests-unit \
      web
  '';

  pythonImportsCheck = [
    "folder_paths"
  ];

  passthru = {
    comfyui.stateDirs = [
      "input"
      "models"
      "output"
      "temp"
      "user"
    ];

    comfyui.prepopulatedStateFiles = [
      "extra_model_paths.yaml"
    ];

    check-pkgs.ignoredModuleNames = [
      "^comfy_types$"
      "^intel_extension_for_pytorch$"
      "^new_updater$"
      "^torch_directml$"
      "^xformers(\\..+)?$"
    ];
  };

  meta = {
    license = lib.licenses.gpl3;
  };
}
