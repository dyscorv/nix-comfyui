{ comfyui-unwrapped
, dependencies
, extensions
, lib
, makeBinaryWrapper
, python3
, stdenv
, writeText
}:

let
  scriptDependencies =
    (map
      (name: python3.pkgs."${name}")
      (builtins.attrNames dependencies))
    ++
    [
      comfyui-unwrapped
      python3.pkgs.requirements-parser
    ];

  scriptPythonPath = python3.pkgs.makePythonPath
    (python3.pkgs.requiredPythonModules scriptDependencies);

  mkSpec = package:
    let
      check-pkgs = package.passthru.check-pkgs or { };
    in
    {
      output = "${package}";
      from_requirements_file = check-pkgs.fromRequirementsFile or true;
      from_imports = check-pkgs.fromImports or true;
      required_package_names = builtins.filter (p: p != "python3")
        (map (p: p.pname) package.propagatedBuildInputs);
      forced_package_names = check-pkgs.forcedPackageNames or [ ];
      ignored_package_names = check-pkgs.ignoredPackageNames or [ ];
      ignored_module_names = check-pkgs.ignoredModuleNames or [ ];
    };

  specs =
    {
      "comfyui-unwrapped" = mkSpec comfyui-unwrapped;
    }
    //
    builtins.listToAttrs (map
      (name: {
        name = "extensions.${name}";
        value = mkSpec extensions."${name}";
      })
      (builtins.attrNames extensions));

  specsJson = writeText "check-pkgs-specs.json" (builtins.toJSON specs);
in

stdenv.mkDerivation {
  name = "check-pkgs";

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  dontUnpack = true;

  preInstall = ''
    mkdir --parents $out/bin
    makeWrapper ${lib.getExe python3} $out/bin/check-pkgs \
      --inherit-argv0 \
      --add-flags ${./check-pkgs.py} \
      --add-flags ${specsJson} \
      --prefix PYTHONPATH : ${scriptPythonPath}
  '';
}
