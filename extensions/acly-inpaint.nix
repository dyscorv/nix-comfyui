{ buildExtension, fetchFromGitHub, lib, python3 }:

buildExtension {
  name = "acly-inpaint";

  src = fetchFromGitHub {
    owner = "Acly";
    repo = "comfyui-inpaint-nodes";
    fetchSubmodules = false;
    rev = "48a8913b584b25db8a9c529be84929be66b1194e";
    hash = "sha256-ShD+446I69xm30+lA3NhEsKg/8NxO2rtnP+A552XraM=";
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
