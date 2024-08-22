{
  addBuildInputs = inputs: package:
    package.overridePythonAttrs (old: {
      buildInputs = (old.buildInputs or [ ]) ++ inputs;
    });

  addPropagatedBuildInputs = inputs: package:
    package.overridePythonAttrs (old: {
      propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ inputs;
    });

  addRunpaths = runpaths: package:
    package.overridePythonAttrs (old: {
      appendRunpaths = (old.appendRunpaths or [ ]) ++ runpaths;
    });

  addSearchPaths = paths: package:
    let
      commands = map
        (path: "addAutoPatchelfSearchPath ${path}")
        paths;
    in
    package.overridePythonAttrs (old: {
      preFixup = ''
        ${old.preFixup or ""}
        ${builtins.concatStringsSep "\n" commands}
      '';
    });

  ignoreMissingDeps = deps: package:
    package.overridePythonAttrs (old: {
      autoPatchelfIgnoreMissingDeps =
        (old.autoPatchelfIgnoreMissingDeps or [ ]) ++ deps;
    });

  makeSymlinks = mapping: package:
    let
      commands = map
        (target:
          let
            source = mapping."${target}";
          in
          "ln --symbolic ${source} ${target}"
        )
        (builtins.attrNames mapping);
    in
    package.overridePythonAttrs (old: {
      preFixup = ''
        ${old.preFixup or ""}
        ${builtins.concatStringsSep "\n" commands}
      '';
    });

  removeFiles = paths: package:
    let
      commands = map
        (path: "rm --force --recursive ${path}")
        paths;
    in
    package.overridePythonAttrs (old: {
      postFixup = ''
        ${old.postFixup or ""}
        ${builtins.concatStringsSep "\n" commands}
      '';
    });
}
