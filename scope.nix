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

  dependencies = import ./environment/dependencies.nix {
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
      , lockfile ? "environment/poetry.lock"
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

  poetrylock = ./environment/poetry.lock;

  overrides = self.callPackage ./environment/overrides.nix { };

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

  inherit (import ./packages {
    inherit (self) callPackage comfyui-frontend;
  })
    check-pkgs
    comfyui
    comfyui-frontend
    comfyui-unwrapped
    krita-ai-diffusion
    ;

  buildExtension = self.callPackage
    (
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

        postPatch = ''
          cp ${pyproject} pyproject.toml
          ${attrs.postPatch or ""}
        '';

        passthru = {
          originalName = attrs.name;
        } // (attrs.passthru or { });
      })
    )
    { };

  extensions = import ./extensions {
    inherit (self) callPackage;
  };

  comfyui-with-extensions = self.comfyui.override {
    extensions = builtins.attrValues self.extensions;
  };

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
})
