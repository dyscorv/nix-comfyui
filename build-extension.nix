{ python3, writePyproject }:

attrs:

let
  pyproject = writePyproject {
    inherit (attrs) name;
    version = "0.0.0";
    dependencies = { };
  };
in

python3.pkgs.buildPythonPackage (attrs // {
  format = "pyproject";

  nativeBuildInputs = [
    python3.pkgs.poetry-core
  ];

  prePatch = ''
    cp ${pyproject} pyproject.toml
    ${attrs.prePatch or ""}
  '';

  passthru = {
    originalName = attrs.name;
  } // (attrs.passthru or { });
})
