{ callPackage }:

{
  acly-inpaint =
    callPackage ./extensions/acly-inpaint.nix { };
  acly-tooling =
    callPackage ./extensions/acly-tooling.nix { };
  badcafecode-execution-inversion-demo =
    callPackage ./extensions/badcafecode-execution-inversion-demo { };
  cubiq-instantid =
    callPackage ./extensions/cubiq-instantid.nix { };
  cubiq-ipadapter-plus =
    callPackage ./extensions/cubiq-ipadapter-plus.nix { };
  fannovel16-controlnet-aux =
    callPackage ./extensions/fannovel16-controlnet-aux { };
  fannovel16-frame-interpolation =
    callPackage ./extensions/fannovel16-frame-interpolation { };
  fizzledorf-fizz =
    callPackage ./extensions/fizzledorf-fizz { };
  gourieff-reactor =
    callPackage ./extensions/gourieff-reactor { };
  huchenlei-layerdiffuse =
    callPackage ./extensions/huchenlei-layerdiffuse.nix { };
  kijai-ic-light =
    callPackage ./extensions/kijai-ic-light.nix { };
  kosinkadink-advanced-controlnet =
    callPackage ./extensions/kosinkadink-advanced-controlnet.nix { };
  kosinkadink-animatediff-evolved =
    callPackage ./extensions/kosinkadink-animatediff-evolved.nix { };
  kosinkadink-video-helper-suite =
    callPackage ./extensions/kosinkadink-video-helper-suite { };
  lev145-images-grid =
    callPackage ./extensions/lev145-images-grid.nix { };
  ssitu-ultimate-sd-upscale =
    callPackage ./extensions/ssitu-ultimate-sd-upscale.nix { };
}
