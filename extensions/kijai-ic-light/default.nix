{ buildExtension, fetchFromGitHub, lib, python3 }:

buildExtension {
  name = "kijai-ic-light";
  version = "0.0.0";

  src = fetchFromGitHub {
    owner = "kijai";
    repo = "ComfyUI-IC-Light";
    fetchSubmodules = false;
    rev = "419b7e004fba69e86461838c3214a370bd33b1b7";
    hash = "sha256-ZIiGOaUzygjVXA+nE9DQYgejaB9SZUnUzELZvsM9Flw=";
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
