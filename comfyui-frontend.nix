{ buildNpmPackage, fetchFromGitHub }:

buildNpmPackage {
  name = "comfyui-frontend";

  src = fetchFromGitHub {
    owner = "Comfy-Org";
    repo = "ComfyUI_frontend";
    fetchSubmodules = false;
    rev = "8c40f83b354c6d2c56cf65b7c0ee241b167e0f7b";
    hash = "sha256-pw9ZvlrF7qlun3PEL9H4BFEWsOECqsII54PYFcwFUcA=";
  };

  npmDepsHash = "sha256-JJCsxiepC+I2UkdFKxLWOqLCIwIuJ2xX440gasUZyQY=";

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
