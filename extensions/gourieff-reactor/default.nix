{ buildExtension, fetchFromGitHub, lib, python3 }:

buildExtension {
  name = "gourieff-reactor";

  src = fetchFromGitHub {
    owner = "Gourieff";
    repo = "comfyui-reactor-node";
    fetchSubmodules = false;
    rev = "2832357b72d55017ec689f51e2a7738d7eabfa74";
    hash = "sha256-nLdG2uYH3irrZzPahCk6QM9+73el93MXaBrPb1YBSnE=";
  };

  propagatedBuildInputs = [
    python3.pkgs.importlib-metadata
    python3.pkgs.insightface
    python3.pkgs.numpy
    python3.pkgs.onnx
    python3.pkgs.onnxruntime
    python3.pkgs.opencv-python
    python3.pkgs.packaging
    python3.pkgs.pillow
    python3.pkgs.pyyaml
    python3.pkgs.requests
    python3.pkgs.safetensors
    python3.pkgs.scipy
    python3.pkgs.segment-anything
    python3.pkgs.torch
    python3.pkgs.torchvision
    python3.pkgs.tqdm
    python3.pkgs.ultralytics
  ];

  patches = [
    ./0001-fix-paths.patch
  ];

  postPatch = ''
    find . -type f -name "*.py" | while IFS= read -r filename; do
      substituteInPlace "$filename" \
        --replace-quiet \
          'CATEGORY = "🌌 ReActor' \
          'CATEGORY = "reactor' \
        --replace-quiet " 🌌 ReActor" "" \
        --replace-quiet "ReActor 🌌 " ""

      sed --in-place \
        "s/[[:space:]]*🌌[[:space:]]*//g" \
        -- "$filename"
    done
  '';

  passthru = {
    check-pkgs.ignoredPackageNames = [
      "setuptools"
    ];

    check-pkgs.ignoredModuleNames = [
      "^custom_nodes.facerestore(\\..+)?$"
      "^lmdb$"
      "^mc$"
      "^modules(\\..+)?$"
      "^r_basicsr(\\..+)?$"
      "^r_chainner(\\..+)?$"
      "^r_facelib(\\..+)?$"
      "^reactor_patcher$"
      "^reactor_utils$"
      "^scripts(\\..+)?$"
      "^tensorboard(\\..+)?$"
      "^torchvision.transforms.functional_tensor$"
      "^wandb$"
    ];
  };

  meta = {
    license = lib.licenses.gpl3;
  };
}
