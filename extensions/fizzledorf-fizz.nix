{ buildExtension, fetchFromGitHub, lib, python3 }:

buildExtension {
  name = "fizzledorf-fizz";

  src = fetchFromGitHub {
    owner = "FizzleDorf";
    repo = "ComfyUI_FizzNodes";
    fetchSubmodules = false;
    rev = "0e30c12400064de068ab599b045b430e3c0ff3cf";
    hash = "sha256-FklAx1yN88+TTT0h1SPw4FVMN3XXDgGlTWaVDjczK5k=";
  };

  propagatedBuildInputs = [
    python3.pkgs.numexpr
    python3.pkgs.numpy
    python3.pkgs.pandas
    python3.pkgs.torch
  ];

  prePatch = ''
    substituteInPlace __init__.py \
      --replace-fail \
        "os.path.exists(extentions_folder)" \
        True \
      --replace-fail \
        "result.left_only or result.diff_files" \
        False

    find -type f -name "*.py" | while IFS= read -r filename; do
      substituteInPlace "$filename" \
        --replace-quiet \
          'CATEGORY = "FizzNodes 📅🅕🅝' \
          'CATEGORY = "fizz_nodes' \
        --replace-quiet " 📅🅕🅝" "" \
        --replace-quiet "📅🅕🅝" ""
    done
  '';

  passthru = {
    check-pkgs.ignoredModuleNames = [
      "^__main__$"
    ];
  };

  meta = {
    license = lib.licenses.mit;
  };
}
