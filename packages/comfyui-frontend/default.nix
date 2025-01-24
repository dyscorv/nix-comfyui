{ buildNpmPackage, fetchFromGitHub }:

buildNpmPackage {
  name = "comfyui-frontend";

  src = fetchFromGitHub {
    owner = "Comfy-Org";
    repo = "ComfyUI_frontend";
    fetchSubmodules = false;
    rev = "44aa1bf8c36f7ab11d9167fbf31ed9a1f18cd197";
    hash = "sha256-c4dlS7rPrhzXZ6ikgfGwJuoNz5bR64vaEhu9eCvE7jI=";
  };

  npmDepsHash = "sha256-DtUdY7QaCaAlqkxlawlSGFGHoNA+TWvhMVDgytvLanA=";

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
