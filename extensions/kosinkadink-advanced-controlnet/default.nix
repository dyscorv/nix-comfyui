{ buildExtension, fetchFromGitHub, lib, python3 }:

buildExtension {
  name = "kosinkadink-advanced-controlnet";
  version = "0.0.0";

  src = fetchFromGitHub {
    owner = "Kosinkadink";
    repo = "ComfyUI-Advanced-ControlNet";
    fetchSubmodules = false;
    rev = "949843e2c007d0c947b0ad10ad8900a5df359aa7";
    hash = "sha256-RDjnhDFMmvwLc74MrSVh6mu70qoluoHKixztEjhkV+w=";
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
