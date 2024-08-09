{ callPackage }:

{
  acly-inpaint =
    callPackage ./extensions/acly-inpaint.nix { };
  acly-tooling =
    callPackage ./extensions/acly-tooling.nix { };
  cubiq-instantid =
    callPackage ./extensions/cubiq-instantid.nix { };
  cubiq-ipadapter-plus =
    callPackage ./extensions/cubiq-ipadapter-plus.nix { };
  fannovel16-controlnet-aux =
    callPackage ./extensions/fannovel16-controlnet-aux.nix { };
  fannovel16-frame-interpolation =
    callPackage ./extensions/fannovel16-frame-interpolation.nix { };
  fizzledorf-fizz =
    callPackage ./extensions/fizzledorf-fizz.nix { };
  gourieff-reactor =
    callPackage ./extensions/gourieff-reactor.nix { };
  huchenlei-layerdiffuse =
    callPackage ./extensions/huchenlei-layerdiffuse.nix { };
  kijai-ic-light =
    callPackage ./extensions/kijai-ic-light.nix { };
  kosinkadink-advanced-controlnet =
    callPackage ./extensions/kosinkadink-advanced-controlnet.nix { };
  kosinkadink-animatediff-evolved =
    callPackage ./extensions/kosinkadink-animatediff-evolved.nix { };
  kosinkadink-video-helper-suite =
    callPackage ./extensions/kosinkadink-video-helper-suite.nix { };
  lev145-images-grid =
    callPackage ./extensions/lev145-images-grid.nix { };
  ssitu-ultimate-sd-upscale =
    callPackage ./extensions/ssitu-ultimate-sd-upscale.nix { };
}
