# nix-comfyui

ComfyUI as a Nix expression. Give it a try:

```sh
# ComfyUI is patched to keep models and other runtime data in $PWD.
mkdir comfyui && cd comfyui
# Run ComfyUI with all custom nodes packaged by this flake.
nix run github:dyscorv/nix-comfyui#comfyui-with-extensions
```

Then setup and run Krita with ComfyUI integration:

```sh
# Change to the same directory in another terminal window.
cd comfyui
# Download the models required by "Generative AI for Krita".
nix run github:dyscorv/nix-comfyui#krita-ai-diffusion -- --recommended --verbose .
# Run Krita with ComfyUI integration.
nix run github:dyscorv/nix-comfyui#krita-with-extensions
```

## Usage with Nix Flakes

This project is a Nix flake which can be used as an input for another flake.

```nix
{
  inputs = {
    nix-comfyui.url = "github:dyscorv/nix-comfyui";
    # nix-comfyui.inputs.flake-utils.follows = "flake-utils";
    # nix-comfyui.inputs.nixpkgs.follows = "nixpkgs";
    # nix-comfyui.inputs.poetry2nix.follows = "poetry2nix";
  };
}
```

The flake provides a nixpkgs overlay, which simply adds the `comfyuiPackages`
scope without modifying any other thing in the original pkgs.

```nix
let
  pkgs = import inputs.nixpkgs {
    system = "x86_64-linux";
    overlays = [
      inputs.nix-comfyui.overlays.default
    ];
  };
in
```

## ComfyUI and Custom Nodes

`comfyui` is vanilla ComfyUI without any custom nodes. This derivation can be
used as a starting point for building an installation containing only a selected
few nodes.

```nix
{ pkgs, ... }:

let
  my-comfyui = pkgs.comfyuiPackages.comfyui.override {
    extensions = [
      pkgs.comfyuiPackages.extensions.acly-inpaint
      pkgs.comfyuiPackages.extensions.acly-tooling
      pkgs.comfyuiPackages.extensions.cubiq-ipadapter-plus
      pkgs.comfyuiPackages.extensions.fannovel16-controlnet-aux
    ];

    commandLineArgs = [
      "--preview-method"
      "auto"
    ];
  };
in

{
  environment.systemPackages = [
    my-comfyui
  ];
}
```

## Krita with ComfyUI Integration

The Krita plugin is available from `krita-ai-diffusion`. The variant of Krita
which comes with this plugin is called `krita-with-extensions`.

```diff
 { pkgs, ... }:
 
 {
   environment.systemPackages = [
-    pkgs.krita
+    pkgs.comfyuiPackages.krita-with-extensions
   ];
 }
```
