{ buildExtension, fetchFromGitHub, lib, python3 }:

buildExtension {
  name = "city96-gguf";
  version = "0.0.0";

  src = fetchFromGitHub {
    owner = "city96";
    repo = "ComfyUI-GGUF";
    fetchSubmodules = false;
    rev = "454955ead3336322215a206edbd7191eb130bba0";
    hash = "sha256-a0dEfgSHI/3GNNXgcAKqpM00JhzfAG9BlTV0v5elkqs=";
  };

  propagatedBuildInputs = [
    python3.pkgs.numpy
    python3.pkgs.gguf
  ];

  passthru = {
    check-pkgs.fromImports = false;
  };

  meta = {
    license = lib.licenses.asl20;
  };
}
