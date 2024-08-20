{ buildNpmPackage, fetchFromGitHub }:

buildNpmPackage {
  name = "comfyui-frontend";

  src = fetchFromGitHub {
    owner = "Comfy-Org";
    repo = "ComfyUI_frontend";
    fetchSubmodules = false;
    rev = "7487c565c8e35cec661935df11d841894bbaa5c9";
    hash = "sha256-agKEFLVyWkBLUcc/ouvO5k+YiiHbiZpC+ySYqDoQoQE=";
  };

  npmDepsHash = "sha256-J/kAXKCm3vCXOwgDBEJKtXBkgssjZIXAtAzPuXLF8nE=";

  patches = [
    ./0001-use-neutral-colors.patch
  ];

  installPhase = ''
    runHook preInstall

    mkdir --parents $out/share/comfyui
    cp --archive dist $out/share/comfyui/web

    runHook postInstall
  '';
}
