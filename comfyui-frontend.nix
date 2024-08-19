{ buildNpmPackage, fetchFromGitHub }:

buildNpmPackage {
  name = "comfyui-frontend";

  src = fetchFromGitHub {
    owner = "Comfy-Org";
    repo = "ComfyUI_frontend";
    fetchSubmodules = false;
    rev = "dd1e3f087ddd2001733bc9eb2321bdd9e049917a";
    hash = "sha256-rE594ltLJjpQLd4ZHYkN6x6Nsc20ODBsvRBbAYPi0hw=";
  };

  npmDepsHash = "sha256-kycOWgk13ZFYmfMr6OV16oc++QQsYae+Irz+Ec2xKaw=";

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
