{ buildExtension, fetchFromGitHub, lib, python3 }:

buildExtension {
  name = "kijai-ic-light";
  version = "0.0.0";

  src = fetchFromGitHub {
    owner = "kijai";
    repo = "ComfyUI-IC-Light";
    fetchSubmodules = false;
    rev = "a9365865c1e4c4037e623e6916a7d3dbe11d64a5";
    hash = "sha256-p2tw4ANsFVqSuIGOVe4XxRS/8aaa4lDzw1lG8PEhNpU=";
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
