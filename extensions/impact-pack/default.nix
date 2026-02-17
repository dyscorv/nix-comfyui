{ buildExtension, fetchFromGitHub, lib, python3 }:

buildExtension {
  name = "impact-pack";
  version = "8.3.1";

  src = fetchFromGitHub {
    owner = "ltdrdata";
    repo = "ComfyUI-Impact-Pack";
    fetchSubmodules = false;
    rev = "70d0540895e5eb15b672db65b4c24662127d0f6e";
    hash = "sha256-62X7fgVvXYRfDDaBzQ1lWiMehezikwqrEnsuGa2rmlk=";
  };

  propagatedBuildInputs = [
    python3.pkgs.numpy
    python3.pkgs.opencv-python
    python3.pkgs.dill
    python3.pkgs.matplotlib
    python3.pkgs.scipy
    python3.pkgs.segment-anything
    python3.pkgs.scikit-image
    python3.pkgs.piexif
  ];

  meta = {
    license = lib.licenses.gpl3;
  };
}
