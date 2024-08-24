{ buildExtension, fetchFromGitHub, lib, python3 }:

buildExtension {
  name = "acly-tooling";
  version = "0.0.0";

  src = fetchFromGitHub {
    owner = "Acly";
    repo = "comfyui-tooling-nodes";
    fetchSubmodules = false;
    rev = "f5ec9d830cc78ec766616627fc1951cdb4897413";
    hash = "sha256-9s29sVNt/AZYiXGnkUDMCO0yHw+coBkbJCVnRkmt118=";
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
