{ callPackage }:

{
  acly-inpaint =
    callPackage ./acly-inpaint { };
  acly-tooling =
    callPackage ./acly-tooling { };
  badcafecode-execution-inversion-demo =
    callPackage ./badcafecode-execution-inversion-demo { };
  cubiq-instantid =
    callPackage ./cubiq-instantid { };
  cubiq-ipadapter-plus =
    callPackage ./cubiq-ipadapter-plus { };
  fannovel16-controlnet-aux =
    callPackage ./fannovel16-controlnet-aux { };
  fannovel16-frame-interpolation =
    callPackage ./fannovel16-frame-interpolation { };
  fizzledorf-fizz =
    callPackage ./fizzledorf-fizz { };
  gourieff-reactor =
    callPackage ./gourieff-reactor { };
  huchenlei-layerdiffuse =
    callPackage ./huchenlei-layerdiffuse { };
  kijai-ic-light =
    callPackage ./kijai-ic-light { };
  kosinkadink-advanced-controlnet =
    callPackage ./kosinkadink-advanced-controlnet { };
  kosinkadink-animatediff-evolved =
    callPackage ./kosinkadink-animatediff-evolved { };
  kosinkadink-video-helper-suite =
    callPackage ./kosinkadink-video-helper-suite { };
  lev145-images-grid =
    callPackage ./lev145-images-grid { };
  ssitu-ultimate-sd-upscale =
    callPackage ./ssitu-ultimate-sd-upscale { };
}
