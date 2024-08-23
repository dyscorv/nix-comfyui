{ buildExtension, fetchFromGitHub, lib, python3 }:

buildExtension {
  name = "kijai-supir";
  version = "0.0.0";

  src = fetchFromGitHub {
    owner = "kijai";
    repo = "ComfyUI-SUPIR";
    fetchSubmodules = false;
    rev = "53fc4f82f139e0875e1f4f3716fbeafa073e4242";
    hash = "sha256-gCi4KSExqvqC1XUdQNlRetBKt/A9E/UOp75WrfeFcIc=";
  };

  propagatedBuildInputs = [
    python3.pkgs.accelerate
    python3.pkgs.einops
    python3.pkgs.numpy
    python3.pkgs.omegaconf
    python3.pkgs.open-clip-torch
    python3.pkgs.packaging
    python3.pkgs.pillow
    python3.pkgs.pytorch-lightning
    python3.pkgs.requests
    python3.pkgs.safetensors
    python3.pkgs.scipy
    python3.pkgs.torch
    python3.pkgs.torchvision
    python3.pkgs.tqdm
    python3.pkgs.transformers
  ];

  postPatch = ''
    find -type f -name "*.py" | while IFS= read -r filename; do
      substituteInPlace "$filename" \
        --replace-quiet \
          'CATEGORY = "SUPIR' \
          'CATEGORY = "supir'
    done
  '';

  passthru = {
    check-pkgs.ignoredModuleNames = [
      "^modules$"
      "^pytorch_fid$"
      "^xformers(\\..+)?$"
    ];
  };

  meta = {
    license = lib.licenses.unfree; # non-commercial
  };
}
