{ buildExtension, fetchFromGitHub, lib, python3 }:

buildExtension {
  name = "huchenlei-layerdiffuse";

  src = fetchFromGitHub {
    owner = "huchenlei";
    repo = "ComfyUI-layerdiffuse";
    fetchSubmodules = false;
    rev = "2cbfe3972c18f3bce49d6bf9631d5fd49d9d81d0";
    hash = "sha256-cNYPMlev7DcY9sDle8/uWGhHZSP04uoghzP20biQh9o=";
  };

  propagatedBuildInputs = [
    python3.pkgs.diffusers
    python3.pkgs.einops
    python3.pkgs.numpy
    python3.pkgs.opencv-python
    python3.pkgs.packaging
    python3.pkgs.torch
    python3.pkgs.tqdm
  ];

  passthru = {
    check-pkgs.ignoredModuleNames = [
      "^diffusers.models.unet_2d_blocks$"
    ];
  };

  meta = {
    license = lib.licenses.asl20;
  };
}
