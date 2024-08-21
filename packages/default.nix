{ callPackage, comfyui-frontend }:

{
  check-pkgs =
    callPackage ./check-pkgs { };

  comfyui =
    callPackage ./comfyui {
      commandLineArgs = [ ];
      extensions = [ ];
      frontend = comfyui-frontend;
    };

  comfyui-frontend =
    callPackage ./comfyui-frontend { };

  comfyui-unwrapped =
    callPackage ./comfyui-unwrapped { };

  krita-ai-diffusion =
    callPackage ./krita-ai-diffusion { };
}
