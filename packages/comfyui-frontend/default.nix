{ buildNpmPackage, fetchFromGitHub }:

buildNpmPackage {
  name = "comfyui-frontend";

  src = fetchFromGitHub {
    owner = "Comfy-Org";
    repo = "ComfyUI_frontend";
    fetchSubmodules = false;
    rev = "f2b02dd10b833c633e1e033ff8b437539ac06358";
    hash = "sha256-6zRtPdDj8+kyDJNlvw93XpNDnkJ/qkOjQOXshPP4SbA=";
  };

  npmDepsHash = "sha256-cUcFWg8+xVI3ndzJ6LVEdAqpCtdFnm9ORlSoRJco/Zc=";

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
