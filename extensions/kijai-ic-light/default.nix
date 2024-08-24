{ buildExtension, fetchFromGitHub, lib, python3 }:

buildExtension {
  name = "kijai-ic-light";
  version = "0.0.0";

  src = fetchFromGitHub {
    owner = "kijai";
    repo = "ComfyUI-IC-Light";
    fetchSubmodules = false;
    rev = "38b3a033a8baa3a9823aa94cc6371abdca2d31f5";
    hash = "sha256-QDNM/E77XC5EcW0DZ//ZDUjHSsHM452Aj7qaNBoNtZI=";
  };

  propagatedBuildInputs = [
    python3.pkgs.numpy
    python3.pkgs.opencv-python
    python3.pkgs.torch
    python3.pkgs.torchvision
  ];

  postPatch = ''
    find . -type f -name "*.py" | while IFS= read -r filename; do
      substituteInPlace "$filename" \
        --replace-quiet \
          'CATEGORY = "IC-Light' \
          'CATEGORY = "ic_light'
    done
  '';

  passthru = {
    check-pkgs.ignoredModuleNames = [
      "^model_management$"
    ];
  };

  meta = {
    license = lib.licenses.asl20;
  };
}
