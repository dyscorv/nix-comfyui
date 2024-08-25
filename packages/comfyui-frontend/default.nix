{ buildNpmPackage, fetchFromGitHub }:

buildNpmPackage {
  name = "comfyui-frontend";

  src = fetchFromGitHub {
    owner = "Comfy-Org";
    repo = "ComfyUI_frontend";
    fetchSubmodules = false;
    rev = "7a7188aeb0c0c64e7f0d621654a279120a99bd0a";
    hash = "sha256-Lr9AHAR/GDk/o/ZcW2GtM+aBJNnHmLALxmyPyn+Q9sc=";
  };

  npmDepsHash = "sha256-P9g2ppPY9yL9s3A4TDkHegwF3zH/mZXKc5Uchu2iJ/s=";

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
