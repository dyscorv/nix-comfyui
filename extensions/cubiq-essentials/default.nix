{ buildExtension, fetchFromGitHub, lib, python3 }:

buildExtension {
  name = "cubiq-essentials";
  version = "0.0.0";

  src = fetchFromGitHub {
    owner = "cubiq";
    repo = "ComfyUI_essentials";
    fetchSubmodules = false;
    rev = "138073f1b2ce1e4b13c1b7ebcc267182dc1547f3";
    hash = "sha256-STtnVw0XOzZ9Ote22cESixF3ZMK86KWk5aqw9YzTxrA=";
  };

  propagatedBuildInputs = [
    python3.pkgs.colour-science
    python3.pkgs.kornia
    python3.pkgs.numba
    python3.pkgs.numpy
    python3.pkgs.opencv-python
    python3.pkgs.pillow
    python3.pkgs.pixeloe
    python3.pkgs.rembg
    python3.pkgs.scikit-image
    python3.pkgs.scipy
    python3.pkgs.torch
    python3.pkgs.torchvision
    python3.pkgs.transformers
    python3.pkgs.transparent-background
  ];

  patches = [
    ./0001-fix-paths.patch
  ];

  postPatch = ''
    find . -type f -name "*.py" | xargs sed --in-place \
      "s/[[:space:]]*🔧[[:space:]]*//g" --
  '';

  meta = {
    license = lib.licenses.mit;
  };
}
