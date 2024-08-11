{ buildExtension, fetchFromGitHub, lib, python3, sources }:

buildExtension {
  name = "fannovel16-controlnet-aux";
  src = fetchFromGitHub sources.fannovel16-controlnet-aux;

  propagatedBuildInputs = [
    python3.pkgs.addict
    python3.pkgs.albumentations
    python3.pkgs.einops
    python3.pkgs.filelock
    python3.pkgs.ftfy
    python3.pkgs.fvcore
    python3.pkgs.huggingface-hub
    python3.pkgs.importlib-metadata
    python3.pkgs.mediapipe
    python3.pkgs.numpy
    python3.pkgs.omegaconf
    python3.pkgs.opencv-python
    python3.pkgs.pillow
    python3.pkgs.python-dateutil
    python3.pkgs.pyyaml
    python3.pkgs.scikit-image
    python3.pkgs.scikit-learn
    python3.pkgs.scipy
    python3.pkgs.svglib
    python3.pkgs.torch
    python3.pkgs.torchvision
    python3.pkgs.trimesh
    python3.pkgs.yacs
    python3.pkgs.yapf
  ];

  prePatch = ''
    substituteInPlace utils.py \
      --replace-fail \
        'annotator_ckpts_path = str(Path(here, "./ckpts"))' \
        'import folder_paths; annotator_ckpts_path = str(Path(folder_paths.models_dir) / "controlnet_aux" / "ckpts")' \
      --replace-fail \
        'TEMP_DIR = tempfile.gettempdir()' \
        'import folder_paths; TEMP_DIR = str(Path(folder_paths.models_dir) / "controlnet_aux" / "temp")'

    find -type f -name "*.py" | while IFS= read -r filename; do
      substituteInPlace "$filename" \
        --replace-quiet \
          'CATEGORY = "ControlNet Preprocessors' \
          'CATEGORY = "controlnet_preprocessors'
    done
  '';

  passthru = {
    check-pkgs.fromImports = false;
  };

  meta = {
    license = lib.licenses.asl20;
  };
}
