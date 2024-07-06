{ buildExtension, fetchFromGitHub, lib, python3, sources }:

buildExtension {
  name = "kijai-ic-light";
  src = fetchFromGitHub sources.kijai-ic-light;

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

  meta = {
    license = lib.licenses.asl20;
  };
}
