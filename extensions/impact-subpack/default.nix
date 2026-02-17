{ buildExtension, fetchFromGitHub, lib, python3 }:

buildExtension {
  name = "impact-subpack";
  version = "1.2.7";

  src = fetchFromGitHub {
    owner = "ltdrdata";
    repo = "ComfyUI-Impact-Subpack";
    fetchSubmodules = false;
    rev = "f5467e1a375275ed31fd175826832a8b84332759";
    hash = "sha256-z4s3liPzFDsd6GLyWIA3zBxidTvnQ4atI82SMp8Z4xA=";
  };

  propagatedBuildInputs = [
    python3.pkgs.numpy
    python3.pkgs.opencv-python
    python3.pkgs.dill
    python3.pkgs.matplotlib
    python3.pkgs.ultralytics
  ];

  meta = {
    license = lib.licenses.gpl3;
  };
}
