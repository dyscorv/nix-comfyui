{ buildExtension, fetchFromGitHub, lib, python3 }:

buildExtension {
  name = "kosinkadink-advanced-controlnet";

  src = fetchFromGitHub {
    owner = "Kosinkadink";
    repo = "ComfyUI-Advanced-ControlNet";
    fetchSubmodules = false;
    rev = "1b3cb5f48cc2bd7601eb59585444ab6749d030b2";
    hash = "sha256-/ZDdvWWukMNfRX5QskfI3mp6+0qP6rww7J7BRk7V7ac=";
  };

  propagatedBuildInputs = [
    python3.pkgs.einops
    python3.pkgs.numpy
    python3.pkgs.pillow
    python3.pkgs.torch
  ];

  postPatch = ''
    find . -type f -name "*.py" | while IFS= read -r filename; do
      sed --in-place \
        "s/[[:space:]]*\(🛂🅐🅒🅝\|🛂\|🧪\|🚫\)[[:space:]]*//g" \
        -- "$filename"

      substituteInPlace "$filename" \
        --replace-quiet \
          'CATEGORY = "Adv-ControlNet' \
          'CATEGORY = "adv_controlnet' \
        --replace-quiet \
          'CATEGORY = ""' \
          'CATEGORY = "adv_controlnet/deprecated"'
    done
  '';

  meta = {
    license = lib.licenses.gpl3;
  };
}
