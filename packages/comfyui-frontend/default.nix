{ buildNpmPackage, fetchFromGitHub }:

buildNpmPackage {
  name = "comfyui-frontend";

  src = fetchFromGitHub {
    owner = "Comfy-Org";
    repo = "ComfyUI_frontend";
    fetchSubmodules = false;
    rev = "0466c797253caba83c357c5dca7f9138a5d805b7";
    hash = "sha256-T0Z7zf2r1bbP4AXlN9Ymy2g3dAB2ClS8CxvkvzUyIeU=";
  };

  npmDepsHash = "sha256-uWnpu4BMyDKc5ZvUhoKe7aIY7KV1xns823LSdLoVwEM=";

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
