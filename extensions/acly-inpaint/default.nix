{ buildExtension, fetchFromGitHub, lib, python3 }:

buildExtension {
  name = "acly-inpaint";
  version = "0.0.0";

  src = fetchFromGitHub {
    owner = "Acly";
    repo = "comfyui-inpaint-nodes";
    fetchSubmodules = false;
    rev = "6ce66ff1b5ed4e5819b23ccf1feb976ef479528a";
    hash = "sha256-D/I874z0dTKn9B75b8hNxYnHiRKS6ki5CVz6N115NOI=";
  };

  propagatedBuildInputs = [
    python3.pkgs.kornia
    python3.pkgs.numpy
    python3.pkgs.opencv-python
    python3.pkgs.spandrel
    python3.pkgs.torch
    python3.pkgs.tqdm
  ];

  meta = {
    license = lib.licenses.gpl3;
  };
}
