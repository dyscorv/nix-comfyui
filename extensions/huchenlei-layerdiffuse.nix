{ buildExtension, fetchFromGitHub, lib, python3, sources }:

buildExtension {
  name = "huchenlei-layerdiffuse";
  src = fetchFromGitHub sources.huchenlei-layerdiffuse;

  propagatedBuildInputs = [
    python3.pkgs.diffusers
    python3.pkgs.einops
    python3.pkgs.numpy
    python3.pkgs.opencv-python
    python3.pkgs.packaging
    python3.pkgs.torch
    python3.pkgs.tqdm
  ];

  meta = {
    license = lib.licenses.asl20;
  };
}
