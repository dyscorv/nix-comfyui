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
        pkgs = inputs.nixpkgs.legacyPackages."${system}";
      in
      {
        formatter = pkgs.nixpkgs-fmt;

        devShells.default = pkgs.mkShell {
          name = "default";
          buildInputs = [
            pkgs.just
            pkgs.nix-prefetch-git
            pkgs.nixpkgs-fmt
            pkgs.yapf
            (pkgs.python3.withPackages (p: [ p.nix-prefetch-github ]))
          ];
        };

        legacyPackages = mkComfyuiPackages pkgs;
      }
    );
}
