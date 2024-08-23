{ buildExtension, fetchFromGitHub, lib, python3 }:

buildExtension {
  name = "ellangok-post-processing";
  version = "0.0.0";

  src = fetchFromGitHub {
    owner = "EllangoK";
    repo = "ComfyUI-post-processing-nodes";
    fetchSubmodules = false;
    rev = "b265f36ef5988154bee2aa808d8abe8a2a197847";
    hash = "sha256-FV965Msj0Xnlq/Q+S30zW2lgeCU8wLSGc5TKKO1Ryr8=";
  };

  propagatedBuildInputs = [
    python3.pkgs.numpy
    python3.pkgs.opencv-python
    python3.pkgs.pillow
    python3.pkgs.torch
  ];

  postPatch = ''
    find . -type f -name "*.py" | while IFS= read -r filename; do
      substituteInPlace "$filename" \
        --replace-quiet \
          'CATEGORY = "postprocessing' \
          'CATEGORY = "image/postprocessing'
    done
  '';

  meta = {
    license = lib.licenses.gpl3;
  };
}
