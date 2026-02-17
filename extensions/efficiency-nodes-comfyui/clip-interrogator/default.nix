{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  accelerate,
  open-clip-torch,
  pillow,
  requests,
  safetensors,
  torch,
  torchvision,
  tqdm,
  transformers,
}:

buildPythonPackage rec {
  pname = "clip-interrogator";
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pharmapsychotic";
    repo = "clip-interrogator";
    rev = "v${version}";
    hash = "sha256-cccVl689afyBf5EDrlGQAfjUJbxE3CoOqoWrHtPRhPM=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    accelerate
    open-clip-torch
    pillow
    requests
    safetensors
    torch
    torchvision
    tqdm
    transformers
  ];

  pythonImportsCheck = [
    "clip_interrogator"
  ];

  meta = {
    description = "Image to prompt with BLIP and CLIP";
    homepage = "https://github.com/pharmapsychotic/clip-interrogator";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}
