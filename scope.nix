{ pkgs, poetry2nix }:

pkgs.lib.makeScope pkgs.newScope (self:
(import ./environment pkgs self)
  //
{
  inherit poetry2nix;

  inherit (import ./toml.nix) toTOML;

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
      { emptyPyproject, python3 }:

      attrs:

      let
        pyproject = emptyPyproject.override {
          content = {
            tool.poetry = { inherit (attrs) name version; };
          };
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
