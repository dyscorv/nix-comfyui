{ buildExtension, fetchFromGitHub, lib }:

buildExtension {
  name = "florestefano1975-portrait-master";
  version = "0.0.0";

  src = fetchFromGitHub {
    owner = "florestefano1975";
    repo = "comfyui-portrait-master";
    fetchSubmodules = false;
    rev = "0eccf8e8ccb6a337a43e613d8634d298280ae496";
    hash = "sha256-nBOzcPwCx1JOMuS2k4TmYMJMTziyL7yRINsi06X+VJ0=";
  };

  postPatch = ''
    find . -type f -name "*.py" | while IFS= read -r filename; do
      substituteInPlace "$filename" \
        --replace-quiet \
          'CATEGORY = "AI WizArt/Portrait Master' \
          'CATEGORY = "portrait_master' \
        --replace-quiet "'random 🎲'" "'Random'"
    done
  '';

  meta = {
    license = lib.licenses.gpl3;
  };
}
