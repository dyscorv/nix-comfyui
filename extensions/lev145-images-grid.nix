{ buildExtension, fetchFromGitHub, lib, python3 }:

buildExtension {
  name = "lev145-images-grid";

  src = fetchFromGitHub {
    owner = "LEv145";
    repo = "images-grid-comfy-plugin";
    fetchSubmodules = false;
    rev = "852db490ef93702e1c68fe9774bdf65aaa7d3574";
    hash = "sha256-jVzA2sITIbWPV7gdH5XsxX7zvLNU4/sggc+ruCmo1GA=";
  };

  propagatedBuildInputs = [
    python3.pkgs.numpy
    python3.pkgs.pillow
    python3.pkgs.torch
  ];

  postPatch = ''
    find . -type f -name "*.py" | while IFS= read -r filename; do
      substituteInPlace "$filename" \
        --replace-quiet \
          'CATEGORY: str = "ImagesGrid' \
          'CATEGORY: str = "images_grid'
    done
  '';

  meta = {
    license = lib.licenses.mit;
  };
}
