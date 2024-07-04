{ buildExtension, fetchFromGitHub, lib, python3, sources }:

buildExtension {
  name = "acly-inpaint";
  src = fetchFromGitHub sources.acly-inpaint;

  propagatedBuildInputs = [
    python3.pkgs.kornia
    python3.pkgs.numpy
    python3.pkgs.opencv-python
    python3.pkgs.spandrel
    python3.pkgs.torch
    python3.pkgs.tqdm
  ];

  meta = {
    license = lib.licenses.gpl3;
  };
}
