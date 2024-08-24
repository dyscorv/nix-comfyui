{ buildExtension, fetchFromGitHub, ffmpeg, lib, python3 }:

buildExtension {
  name = "kosinkadink-animatediff-evolved";
  version = "0.0.0";

  src = fetchFromGitHub {
    owner = "Kosinkadink";
    repo = "ComfyUI-AnimateDiff-Evolved";
    fetchSubmodules = false;
    rev = "675241cd64931943be9030a1e67743817ab526de";
    hash = "sha256-EL0NFPNtw5sP8Q0T3fnfAsQ07RpzMylG6Qp6uRp7h4E=";
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
