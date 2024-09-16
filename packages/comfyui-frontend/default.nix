{ buildNpmPackage, fetchFromGitHub }:

buildNpmPackage rec {
  name = "comfyui-frontend";
  version = "1.2.55";

  src = fetchFromGitHub {
    owner = "Comfy-Org";
    repo = "ComfyUI_frontend";
    fetchSubmodules = false;
    rev = "v1.2.55";
    hash = "sha256-4sJ3l+az1RHe+OyTONjClHLeglpid/CYsNnAPBEcaQk=";
  };

  npmDepsHash = "sha256-vwVvUpZ/W1xcSgtbc0U7XdmwCbIbfzPQljIpXpTSN/E=";

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
