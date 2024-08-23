{ buildExtension, fetchFromGitHub, lib, python3 }:

buildExtension {
  name = "cubiq-essentials";
  version = "0.0.0";

  src = fetchFromGitHub {
    owner = "cubiq";
    repo = "ComfyUI_essentials";
    fetchSubmodules = false;
    rev = "635322c1e49fac6c23a56131078be45f64edc193";
    hash = "sha256-4iBwTLIkJlcu8up/LEGx7Kwe19yHzO99rZoeHAnsCSg=";
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
