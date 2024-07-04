{ buildExtension, fetchFromGitHub, lib, python3, sources }:

buildExtension {
  name = "acly-tooling";
  src = fetchFromGitHub sources.acly-tooling;

  propagatedBuildInputs = [
    python3.pkgs.aiohttp
    python3.pkgs.kornia
    python3.pkgs.numpy
    python3.pkgs.pillow
    python3.pkgs.torch
  ];

  meta = {
    license = lib.licenses.gpl3;
  };
}
