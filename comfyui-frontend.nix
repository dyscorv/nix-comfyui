{ buildNpmPackage, fetchFromGitHub }:

buildNpmPackage {
  name = "comfyui-frontend";

  src = fetchFromGitHub {
    owner = "Comfy-Org";
    repo = "ComfyUI_frontend";
    fetchSubmodules = false;
    rev = "a45851d7a6689a2e31b7b9a32fe654e4c32b896f";
    hash = "sha256-GbQhS1JFbRdLMAOz1y2Ce4X+UDw9xO3qLBzKcTYyf20=";
  };

  npmDepsHash = "sha256-3kzJL0skLtgEy4WA9M1/NpfaY/fRrs9BDPcFz8hHCvY=";

  prePatch = ''
    substituteInPlace src/main.ts \
      --replace-fail \
        "primary: Aura['primitive'].blue" \
        "primary: Aura['primitive'].blue, colorScheme: { dark: { surface: Aura['primitive'].neutral } }"
  '';

  installPhase = ''
    runHook preInstall

    mkdir --parents $out/share/comfyui
    cp --archive dist $out/share/comfyui/web

    runHook postInstall
  '';
}
