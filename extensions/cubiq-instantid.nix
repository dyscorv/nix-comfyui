{ buildExtension, fetchFromGitHub, lib, python3 }:

buildExtension {
  name = "cubiq-instantid";

  src = fetchFromGitHub {
    owner = "cubiq";
    repo = "ComfyUI_InstantID";
    fetchSubmodules = false;
    rev = "6d95aa6758e58dab550725e59dcefbd426c160c7";
    hash = "sha256-6WOJ8wSwrVaFYERmmJJA/em/AcBrqeGaJ1fgLHxEwRs=";
  };

  propagatedBuildInputs = [
    python3.pkgs.insightface
    python3.pkgs.numpy
    python3.pkgs.onnxruntime
    python3.pkgs.opencv-python
    python3.pkgs.pillow
    python3.pkgs.torch
    python3.pkgs.torchvision
  ];

  prePatch = ''
    substituteInPlace InstantID.py \
      --replace-quiet \
        'CATEGORY = "InstantID"' \
        'CATEGORY = "instantid"'
  '';

  passthru = {
    check-pkgs.ignoredPackageNames = [
      "onnxruntime-gpu"
    ];
  };

  meta = {
    license = lib.licenses.asl20;
  };
}
