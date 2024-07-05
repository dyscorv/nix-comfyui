{ buildExtension, fetchFromGitHub, lib, python3, sources }:

buildExtension {
  name = "gourieff-reactor";
  src = fetchFromGitHub sources.gourieff-reactor;

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

  prePatch = ''
    find -type f -name "*.py" | while IFS= read -r filename; do
      substituteInPlace "$filename" \
        --replace-quiet \
          'CATEGORY = "🌌 ReActor' \
          'CATEGORY = "reactor' \
        --replace-quiet " 🌌 ReActor" "" \
        --replace-quiet "ReActor 🌌 " ""
    done
  '';

  meta = {
    license = lib.licenses.gpl3;
  };
}
