{ buildExtension, fetchFromGitHub, lib, python3 }:

buildExtension {
  name = "badcafecode-execution-inversion-demo";
  version = "0.0.0";

  src = fetchFromGitHub {
    owner = "BadCafeCode";
    repo = "execution-inversion-demo-comfyui";
    fetchSubmodules = false;
    rev = "b0b489659684a1b69221db48cabb9dce5f7bb6fb";
    hash = "sha256-KXaMrBhmIfYxv+uXytXSh2/kei/ULICliVfg5zaJqVw=";
  };

  propagatedBuildInputs = [
    python3.pkgs.torch
  ];

  patches = [
    ./0001-fix-paths.patch
    ./0002-use-web-directory.patch
  ];

  postPatch = ''
    find . -type f -name "*.py" | while IFS= read -r filename; do
      substituteInPlace "$filename" \
        --replace-quiet \
          'CATEGORY = "Custom Components' \
          'CATEGORY = "components' \
        --replace-quiet \
          'CATEGORY = "InversionDemo Nodes' \
          'CATEGORY = "inversion_demo'
    done
  '';

  meta = {
    license = lib.licenses.unfree; # not specified
  };
}
