{ buildExtension, fetchFromGitHub, lib, python3, sources }:

buildExtension {
  name = "lev145-images-grid";
  src = fetchFromGitHub sources.lev145-images-grid;

  propagatedBuildInputs = [
    python3.pkgs.numpy
    python3.pkgs.pillow
    python3.pkgs.torch
  ];

  prePatch = ''
    substituteInPlace src/base.py \
      --replace-quiet \
        'CATEGORY: str = "ImagesGrid"' \
        'CATEGORY: str = "images_grid"'
  '';

  meta = {
    license = lib.licenses.mit;
  };
}
