{
  buildExtension,
  fetchFromGitHub,
  lib,
  python3,
}:

let
  clip-interrogator = python3.pkgs.callPackage ./clip-interrogator { };
in

buildExtension {
  name = "efficiency-nodes-comfyui";
  version = "1.0.8";

  # https://github.com/jags111/efficiency-nodes-comfyui
  src = fetchFromGitHub {
    owner = "jags111";
    repo = "efficiency-nodes-comfyui";
    rev = "f0971b5553ead8f6e66bb99564431e2590cd3981";
    hash = "sha256-F/n/aDjM/EtOLvnBE1SLJtg+8RSrfZ5yXumyuLetaXQ=";
  };

  propagatedBuildInputs = [
    clip-interrogator
    python3.pkgs.simpleeval
  ];

  meta = {
    license = lib.licenses.gpl3;
  };
}
