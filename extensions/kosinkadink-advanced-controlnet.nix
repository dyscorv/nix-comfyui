{ buildExtension, fetchFromGitHub, lib, python3, sources }:

buildExtension {
  name = "kosinkadink-advanced-controlnet";
  src = fetchFromGitHub sources.kosinkadink-advanced-controlnet;

  propagatedBuildInputs = [
    python3.pkgs.einops
    python3.pkgs.numpy
    python3.pkgs.pillow
    python3.pkgs.torch
  ];

  prePatch = ''
    find -type f -name "*.py" | while IFS= read -r filename; do
      substituteInPlace "$filename" \
        --replace-quiet \
          'CATEGORY = "Adv-ControlNet 🛂🅐🅒🅝' \
          'CATEGORY = "adv_controlnet' \
        --replace-quiet " 🛂🅐🅒🅝" "" \
        --replace-quiet "🛂🅐🅒🅝" "" \
        --replace-quiet "🧪" "" \
        --replace-quiet "🚫" ""
    done
  '';

  meta = {
    license = lib.licenses.gpl3;
  };
}
