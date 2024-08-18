{ buildExtension, fetchFromGitHub, lib, python3 }:

buildExtension {
  name = "kijai-ic-light";

  src = fetchFromGitHub {
    owner = "kijai";
    repo = "ComfyUI-IC-Light";
    fetchSubmodules = false;
    rev = "476303a5a9926e7cf61b2b18567a416d0bdd8d8c";
    hash = "sha256-5s2liguOHNwIV9PywFCCbYzROd6KscwYtk+RHEAmPFs=";
  };

  propagatedBuildInputs = [
    python3.pkgs.numpy
    python3.pkgs.opencv-python
    python3.pkgs.torch
    python3.pkgs.torchvision
  ];

  prePatch = ''
    substituteInPlace nodes.py \
      --replace-quiet \
        'CATEGORY = "IC-Light"' \
        'CATEGORY = "ic_light"'
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
