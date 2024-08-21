{ buildExtension, fetchFromGitHub, lib, python3 }:

buildExtension {
  name = "cubiq-ipadapter-plus";
  version = "0.0.0";

  src = fetchFromGitHub {
    owner = "cubiq";
    repo = "ComfyUI_IPAdapter_plus";
    fetchSubmodules = false;
    rev = "ce9b62165b89fbf8dd3be61057d62a5f8bc29e19";
    hash = "sha256-SFAmwwdDXSplvxgmulszSVTg8GsdpCntGxKWvMMSIQI=";
  };

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
