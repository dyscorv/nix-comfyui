{ buildExtension, fetchFromGitHub, lib, python3, sources }:

buildExtension {
  name = "badcafecode-execution-inversion-demo";
  src = fetchFromGitHub sources.badcafecode-execution-inversion-demo;

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
