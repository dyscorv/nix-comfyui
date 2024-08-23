{ buildNpmPackage, fetchFromGitHub }:

buildNpmPackage {
  name = "comfyui-frontend";

  src = fetchFromGitHub {
    owner = "Comfy-Org";
    repo = "ComfyUI_frontend";
    fetchSubmodules = false;
    rev = "57c5a78af34b33e5c99172ccbf3ca026b7a0ac9f";
    hash = "sha256-Dgerjf4o3thSIixwmH5FIDwfLF3aEG6PfvL+SHD/BzY=";
  };

  npmDepsHash = "sha256-EAVM/ur4ClDt4qNZCESq6X2fDIsm66wgeWh/0yKKOVc=";

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
