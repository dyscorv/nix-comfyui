{ fetchFromGitHub, lib, makeWrapper, python3, stdenv }:

let
  pythonpath = python3.pkgs.makePythonPath (python3.pkgs.requiredPythonModules [
    python3.pkgs.aiohttp
    python3.pkgs.tqdm
  ]);
in

stdenv.mkDerivation {
  name = "krita-ai-diffusion";

  src = fetchFromGitHub {
    owner = "Acly";
    repo = "krita-ai-diffusion";
    fetchSubmodules = true;
    rev = "5c8303e3ca961e4a761e6d8b8ef8a8e5ba1d2f2a";
    hash = "sha256-ixcKRJWJ7ajRxGEMwzBNaO4wjaxllRqhY7BwJFvJxts=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    mkdir --parents $out/bin
    makeWrapper \
      ${lib.getExe python3} \
      $out/bin/krita-ai-diffusion-download-models \
      --inherit-argv0 \
      --add-flags $out/share/krita/pykrita/scripts/download_models.py \
      --prefix PYTHONPATH : ${pythonpath}

    mkdir --parents $out/share/krita/pykrita
    cp --archive ai_diffusion ai_diffusion.desktop scripts \
      $out/share/krita/pykrita

    cat <<EOF >$out/share/krita/pykrita/ai_diffusion/manual.html
    <!DOCTYPE html>
    <html lang="en">
      <head>
        <meta charset="utf-8"/>
        <title>Generative AI for Krita</title>
      </head>
      <body>
        <h1>Generative AI for Krita</h1>
        <p>
          See
          <a href="https://github.com/Acly/krita-ai-diffusion">GitHub repository</a>
          for more details.
        </p>
      </body>
    </html>
    EOF

    runHook postInstall
  '';

  meta = {
    license = lib.licenses.gpl3;
    mainProgram = "krita-ai-diffusion-download-models";
  };
}
