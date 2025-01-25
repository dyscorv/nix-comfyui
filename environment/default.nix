pkgs: self:

{
  platform =
    if pkgs.config.rocmSupport then
      "rocm"
    else
      "cuda";

  cuda = self.overrideScope (_: _: { platform = "cuda"; });

  rocm = self.overrideScope (_: _: { platform = "rocm"; });

  basePython = pkgs.python312;

  poetry = pkgs.poetry.override {
    python3 = self.basePython;
  };

  emptyPyproject = self.callPackage
    (
      { content, lib, toTOML, writeText }:

      let
        finalContent = lib.recursiveUpdate
          {
            build-system = {
              build-backend = "poetry.core.masonry.api";
              requires = [ "poetry-core" ];
            };
            tool.poetry = {
              name = "";
              version = "0.0.0";
              description = "";
              authors = [ ];
              packages = [{ include = "**/*"; }];
              dependencies = { };
            };
          }
          content;

        drv = writeText "pyproject.toml" (toTOML finalContent);
      in

      drv // {
        passthru = (drv.passthru or { }) // {
          content = finalContent;
        };
      }
    )
    { content = { }; };

  basePyproject = self.callPackage ./pyproject.nix { content = { }; };

  pyproject =
    if self.platform == "cuda" then
      self.callPackage ./cuda/pyproject.nix { }
    else if self.platform == "rocm" then
      self.callPackage ./rocm/pyproject.nix { }
    else
      throw "Unsupported platform ${self.platform}";

  call-poetry = self.callPackage
    (
      { coreutils
      , lib
      , lockfile
      , poetry
      , pyproject
      , writeShellApplication
      }:

      writeShellApplication {
        name = "call-poetry";
        runtimeInputs = [ coreutils poetry ];
        text = ''
          declare -r lockfile=${lib.escapeShellArg lockfile}

          declare runtime_dir=
          runtime_dir="$(mktemp --directory)"

          cleanup() {
            rm --recursive --force -- "$runtime_dir"
          }
          trap cleanup EXIT

          cp -- ${pyproject} "$runtime_dir/pyproject.toml"
          cp -- "$lockfile" "$runtime_dir/poetry.lock" || :

          pushd -- "$runtime_dir" >/dev/null
          poetry "$@"
          popd >/dev/null

          cp -- "$runtime_dir/poetry.lock" "$lockfile"
        '';
      }
    )
    {
      lockfile =
        if self.platform == "cuda" then
          "environment/cuda/poetry.lock"
        else if self.platform == "rocm" then
          "environment/rocm/poetry.lock"
        else
          throw "Unsupported platform ${self.platform}";
    };

  poetrylock =
    if self.platform == "cuda" then
      ./cuda/poetry.lock
    else if self.platform == "rocm" then
      ./rocm/poetry.lock
    else
      throw "Unsupported platform ${self.platform}";

  baseOverlay = self.callPackage ./overlay.nix { };

  platformOverlay =
    if self.platform == "cuda" then
      self.callPackage ./cuda/overlay.nix { }
    else if self.platform == "rocm" then
      self.callPackage ./rocm/overlay.nix { }
    else
      throw "Unsupported platform ${self.platform}";

  python3 = self.callPackage
    (
      { baseOverlay
      , basePython
      , poetry2nix
      , poetrylock
      , platformOverlay
      , pyproject
      }:

      let
        finalOverlays = [
          (x: baseOverlay x)
          (x: platformOverlay x)
        ];

        poetryResult = poetry2nix.mkPoetryPackages {
          inherit poetrylock;
          pyProject = pyproject.passthru.content;
          overrides = finalOverlays;
          python = basePython;
          preferWheels = true;
          groups = [ ];
          checkGroups = [ ];
          extras = [ ];
        };
      in

      poetryResult.python
    )
    { };
}
