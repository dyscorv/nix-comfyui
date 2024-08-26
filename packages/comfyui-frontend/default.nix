{ buildNpmPackage, fetchFromGitHub }:

buildNpmPackage {
  name = "comfyui-frontend";

  src = fetchFromGitHub {
    owner = "Comfy-Org";
    repo = "ComfyUI_frontend";
    fetchSubmodules = false;
    rev = "298a4744d858b0ae01f232ba186a93a2a73dedd0";
    hash = "sha256-wO9vVSOqf2Q/Lgw7H4uFuEw1xuh7qEvutY+3ubq0kNU=";
  };

  npmDepsHash = "sha256-VGHb6nqqiZbTy8NfLJ792mVSxEuza/S0YIilXgBM9jY=";

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
