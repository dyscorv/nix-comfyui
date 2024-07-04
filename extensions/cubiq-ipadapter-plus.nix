{ buildExtension, fetchFromGitHub, lib, python3, sources }:

buildExtension {
  name = "cubiq-ipadapter-plus";
  src = fetchFromGitHub sources.cubiq-ipadapter-plus;

  propagatedBuildInputs = [
    python3.pkgs.einops
    python3.pkgs.insightface
    python3.pkgs.pillow
    python3.pkgs.torch
    python3.pkgs.torchvision
  ];

  meta = {
    license = lib.licenses.gpl3;
  };
}
