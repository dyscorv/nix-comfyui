{ buildExtension, fetchFromGitHub, lib, python3, sources }:

buildExtension {
  name = "fizzledorf-fizz";
  src = fetchFromGitHub sources.fizzledorf-fizz;

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
