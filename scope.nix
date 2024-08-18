{ pkgs, poetry2nix }:

pkgs.lib.makeScope pkgs.newScope (self: {
  inherit poetry2nix;

  basePython = pkgs.python311;

  poetry = pkgs.poetry.override {
    python3 = self.basePython;
  };

  inherit (import ./toml.nix) toTOML;

  writePyproject = self.callPackage
    (
      { toTOML, writeText }:
      { dependencies, name, version }:

      writeText "pyproject.toml"
        (toTOML {
          build-system = {
            build-backend = "poetry.core.masonry.api";
            requires = [ "poetry-core" ];
          };
          tool.poetry = {
            inherit dependencies name version;
            description = "";
            authors = [ ];
            packages = [{ include = "**/*"; }];
          };
        })
    )
    { };

  dependencies = import ./dependencies.nix {
    inherit (self) basePython;
  };

  pyproject = self.writePyproject {
    name = "comfyui";
    version = "0.0.0";
    inherit (self) dependencies;
  };

  call-poetry = self.callPackage
    (
      { coreutils
      , lib
      , lockfile ? "poetry.lock"
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
    { };

  poetrylock = ./poetry.lock;

  overrides = self.callPackage ./overrides.nix { };

  python3 = self.callPackage
    (
      { basePython, overrides, poetry2nix, poetrylock, pyproject }:

      let
        poetryResult = poetry2nix.mkPoetryPackages {
          inherit poetrylock pyproject;
          # poetry2nix doesn't work well with functors.
          overrides = x: overrides x;
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

  comfyui-unwrapped = self.callPackage ./comfyui-unwrapped.nix { };

  comfyui = self.callPackage ./comfyui.nix {
    commandLineArgs = [ ];
    extensions = [ ];
  };

  buildExtension = self.callPackage ./build-extension.nix { };

  extensions = import ./extensions.nix {
    inherit (self) callPackage;
  };

  comfyui-with-extensions = self.comfyui.override {
    extensions = builtins.attrValues self.extensions;
  };

  krita-ai-diffusion = self.callPackage ./krita-ai-diffusion.nix { };

  krita-with-extensions = self.callPackage
    (
      { krita, krita-ai-diffusion, qt5 }:

      # qtimageformats is a runtime dependency of krita-ai-diffusion.
      # https://github.com/NixOS/nixpkgs/issues/304523
      # https://github.com/Acly/krita-ai-diffusion/issues/582

      krita.overrideAttrs (old: {
        buildCommand = ''
          ${old.buildCommand or ""}

          wrapProgram $out/bin/krita \
            --prefix QT_PLUGIN_PATH : ${qt5.qtimageformats}/${qt5.qtbase.qtPluginPrefix} \
            --prefix XDG_DATA_DIRS : ${krita-ai-diffusion}/share
        '';
      })
    )
    { };

  check-pkgs = self.callPackage ./check-pkgs.nix { };
})
