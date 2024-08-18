{ buildExtension, fetchFromGitHub, lib, python3 }:

buildExtension {
  name = "kosinkadink-animatediff-evolved";

  src = fetchFromGitHub {
    owner = "Kosinkadink";
    repo = "ComfyUI-AnimateDiff-Evolved";
    fetchSubmodules = false;
    rev = "fb904a326cc66d20f60f9a474176811ae8baf210";
    hash = "sha256-NRdSFWvmRf7twhYOIskPqWqD/ziuMFYQra+PozUlDQU=";
  };

  propagatedBuildInputs = [
    python3.pkgs.einops
    python3.pkgs.numpy
    python3.pkgs.pillow
    python3.pkgs.torch
    python3.pkgs.torchvision
  ];

  prePatch = ''
    find -type f -name "*.py" | while IFS= read -r filename; do
      substituteInPlace "$filename" \
        --replace-quiet \
          'CATEGORY = "Animate Diff 🎭🅐🅓' \
          'CATEGORY = "animate_diff' \
        --replace-quiet \
          'CATEGORY = ""' \
          'CATEGORY = "animate_diff/deprecated"' \
        --replace-quiet "① Gen1 nodes ①" "Gen1 nodes" \
        --replace-quiet "② Gen2 nodes ②" "Gen2 nodes" \
        --replace-quiet "◆" " - " \
        --replace-quiet " 🎭🅐🅓①" "" \
        --replace-quiet " 🎭🅐🅓②" "" \
        --replace-quiet " 🎭🅐🅓" "" \
        --replace-quiet "🧪" "" \
        --replace-quiet "🚫" ""
    done
  '';

  meta = {
    license = lib.licenses.asl20;
  };
}
