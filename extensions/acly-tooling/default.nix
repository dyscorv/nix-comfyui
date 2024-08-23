{ buildExtension, fetchFromGitHub, lib, python3 }:

buildExtension {
  name = "acly-tooling";
  version = "0.0.0";

  src = fetchFromGitHub {
    owner = "Acly";
    repo = "comfyui-tooling-nodes";
    fetchSubmodules = false;
    rev = "d1dcf12f1007f3067b3128361dd5729d244fb25f";
    hash = "sha256-6FPv+UutUkI5IQpL+4FDKLq5G2/zsRXd/YtiDjK2/Pc=";
  };

  propagatedBuildInputs = [
    python3.pkgs.aiohttp
    python3.pkgs.argostranslate
    python3.pkgs.kornia
    python3.pkgs.numpy
    python3.pkgs.pillow
    python3.pkgs.requests
    python3.pkgs.torch
    python3.pkgs.tqdm
    python3.pkgs.transformers
  ];

  patches = [
    ./0001-fix-paths.patch
  ];

  meta = {
    license = lib.licenses.gpl3;
  };
}
