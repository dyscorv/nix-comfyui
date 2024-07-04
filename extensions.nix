{ callPackage }:

{
  acly-inpaint =
    callPackage ./extensions/acly-inpaint.nix { };
  acly-tooling =
    callPackage ./extensions/acly-tooling.nix { };
  cubiq-ipadapter-plus =
    callPackage ./extensions/cubiq-ipadapter-plus.nix { };
  fannovel16-controlnet-aux =
    callPackage ./extensions/fannovel16-controlnet-aux.nix { };
}
