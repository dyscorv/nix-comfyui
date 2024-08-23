{ buildExtension, fetchFromGitHub, lib, python3 }:

buildExtension {
  name = "extraltodeus-skimmed-cfg";
  version = "0.0.0";

  src = fetchFromGitHub {
    owner = "Extraltodeus";
    repo = "Skimmed_CFG";
    fetchSubmodules = false;
    rev = "bc083b352f1b3d580c5167071cf81f7d36e3e4e6";
    hash = "sha256-xpApC2cR4liTH4K0S99WT0G0j8eNimKfJLV3SdaHPNo=";
  };

  propagatedBuildInputs = [
    python3.pkgs.torch
  ];

  meta = {
    license = lib.licenses.unfree; # not specified
  };
}
