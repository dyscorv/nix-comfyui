{ buildExtension, fetchFromGitHub, lib, python3 }:

buildExtension {
  name = "ssitu-ultimate-sd-upscale";
  version = "0.0.0";

  src = fetchFromGitHub {
    owner = "ssitu";
    repo = "ComfyUI_UltimateSDUpscale";
    fetchSubmodules = true;
    rev = "70083f5d449c498ee0fb35f5293c91cebac4b758";
    hash = "sha256-/DdjDkqSI9OkNOavYeTqjLwfrjLTx3mvTZapi4snXjc=";
  };

  propagatedBuildInputs = [
    python3.pkgs.numpy
    python3.pkgs.pillow
    python3.pkgs.torch
    python3.pkgs.torchvision
  ];

  passthru = {
    check-pkgs.ignoredModuleNames = [
      "^gradio$"
      "^modules(\\..+)?$"
      "^repositories$"
      "^usdu_patch$"
      "^utils$"
    ];
  };

  meta = {
    license = lib.licenses.gpl3;
  };
}
