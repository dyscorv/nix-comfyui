{ buildExtension, fetchFromGitHub, ffmpeg, lib, python3 }:

buildExtension {
  name = "kosinkadink-animatediff-evolved";
  version = "0.0.0";

  src = fetchFromGitHub {
    owner = "Kosinkadink";
    repo = "ComfyUI-AnimateDiff-Evolved";
    fetchSubmodules = false;
    rev = "c5c27807f0ba15507b8c9a7a650a04837351753a";
    hash = "sha256-iw2tmqwZXmnTyzWxgtiYDtiEIKENxYS5aYM7rhnR6Ms=";
  };

  propagatedBuildInputs = [
    python3.pkgs.einops
    python3.pkgs.numpy
    python3.pkgs.pillow
    python3.pkgs.torch
    python3.pkgs.torchvision
  ];

  patches = [
    ./0001-fix-paths.patch
    ./0002-subst-executables.patch
  ];

  postPatch = ''
    substituteInPlace animatediff/nodes_deprecated.py \
      --subst-var-by ffmpeg ${lib.getExe ffmpeg}

    find . -type f \( -name "*.py" -o -name "*.js" \) | xargs sed --in-place \
      "s/[[:space:]]*\(🎭🅐🅓①\|🎭🅐🅓\|🎭\|🧪\|🚫\|①\|②\)[[:space:]]*//g" --

    find . -type f -name "*.py" | while IFS= read -r filename; do
      substituteInPlace "$filename" \
        --replace-quiet \
          'CATEGORY = "Animate Diff' \
          'CATEGORY = "animate_diff' \
        --replace-quiet \
          'CATEGORY = ""' \
          'CATEGORY = "animate_diff/deprecated"' \
        --replace-quiet "◆" " - "
    done
  '';

  meta = {
    license = lib.licenses.asl20;
  };
}
