{ buildExtension, fetchFromGitHub, lib, python3 }:

buildExtension {
  name = "badcafecode-execution-inversion-demo";

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

  prePatch = ''
    substituteInPlace __init__.py \
      --replace-fail \
        'setup_js()' \
        'WEB_DIRECTORY = "./js"'

    substituteInPlace components.py \
      --replace-fail \
        'os.path.dirname(folder_paths.__file__)' \
        'os.getcwd()' \
      --replace-fail \
        'CATEGORY = "Custom Components"' \
        'CATEGORY = "components"'

    find -type f -name "*.py" | while IFS= read -r filename; do
      substituteInPlace "$filename" \
        --replace-quiet \
          'CATEGORY = "InversionDemo Nodes' \
          'CATEGORY = "inversion_demo'
    done
  '';

  meta = {
    license = lib.licenses.unfree; # not specified
  };
}
