{ buildExtension, fetchFromGitHub, lib, python3, sources }:

buildExtension {
  name = "cubiq-instantid";
  src = fetchFromGitHub sources.cubiq-instantid;

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
