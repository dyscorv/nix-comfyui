{ buildExtension, fetchFromGitHub, lib, python3, sources }:

buildExtension {
  name = "ssitu-ultimate-sd-upscale";
  src = fetchFromGitHub sources.ssitu-ultimate-sd-upscale;

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
