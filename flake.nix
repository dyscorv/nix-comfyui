{
  description = "ComfyUI as a Nix expression";

  inputs = {
    flake-utils = {
      url = "flake-utils";
    };

    nixpkgs = {
      url = "nixpkgs";
    };

    poetry2nix = {
      url = "poetry2nix";
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
        systems.follows = "flake-utils/systems";
      };
    };
  };

  outputs = inputs:
    let
      mkComfyuiPackages = pkgs: pkgs.callPackage ./scope.nix {
        poetry2nix = inputs.poetry2nix.lib.mkPoetry2Nix { inherit pkgs; };
      };
    in
    {
      lib = {
        inherit mkComfyuiPackages;
      };

      overlays.default = final: prev: {
        comfyuiPackages = mkComfyuiPackages prev;
      };
    }
    //
    inputs.flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import inputs.nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
          };
        };

        comfyuiPackages = mkComfyuiPackages pkgs;

        mkPackageEntry = path:
          {
            name = builtins.concatStringsSep "-" path;
            value = pkgs.lib.getAttrFromPath path comfyuiPackages;
          };

        packages = builtins.listToAttrs (pkgs.lib.flatten (
          (map
            (name: mkPackageEntry [ name ])
            [ "krita-with-extensions" ])
          ++
          (map
            (
              platform:
              (map
                (name: mkPackageEntry [ platform name ])
                [ "comfyui" "comfyui-with-extensions" ])
            )
            [ "cuda" "rocm" ])
        ));
      in
      {
        formatter = pkgs.nixpkgs-fmt;

        devShells.default = pkgs.mkShell {
          name = "default";
          buildInputs = [
            pkgs.bash
            pkgs.coreutils
            pkgs.findutils
            pkgs.git
            pkgs.just
            pkgs.nix-prefetch-git
            pkgs.nixpkgs-fmt
            pkgs.prefetch-npm-deps
            pkgs.yapf
            (pkgs.python3.withPackages (p: [ p.nix-prefetch-github ]))
          ];
        };

        inherit packages;

        checks = packages // {
          nix-comfyui-sources = pkgs.runCommand "nix-comfyui-sources"
            {
              nativeBuildInputs = [
                pkgs.just
                pkgs.nixpkgs-fmt
                pkgs.yapf
              ];
            }
            ''
              cd ${./.}
              just check-fmt
              touch $out
            '';

          cuda-run-check-pkgs = comfyuiPackages.cuda.run-check-pkgs;
          rocm-run-check-pkgs = comfyuiPackages.rocm.run-check-pkgs;
        };

        legacyPackages = comfyuiPackages;
      }
    );
}
