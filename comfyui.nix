{ comfyui-unwrapped
, commandLineArgs
, extensions
, lib
, makeBinaryWrapper
, python3
, stdenv
}:

let
  inherit (python3) sitePackages;

  propagatedBuildInputs = builtins.foldl'
    (acc: extension: acc ++ (extension.propagatedBuildInputs or [ ]))
    comfyui-unwrapped.propagatedBuildInputs
    extensions;

  pythonpath = python3.pkgs.makePythonPath
    (python3.pkgs.requiredPythonModules propagatedBuildInputs);
in

stdenv.mkDerivation {
  name = "comfyui";

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  dontUnpack = true;

  makeWrapperArgs = [
    (lib.getExe python3)
    "${placeholder "out"}/bin/comfyui"

    "--inherit-argv0"

    "--set-default"
    "NIX_COMFYUI_CUSTOM_NODES"
    "${placeholder "out"}/share/comfyui/custom_nodes"

    "--prefix"
    "PYTHONPATH"
    ":"
    pythonpath

    # "RuntimeError: Found no NVIDIA driver on your system..."
    "--prefix"
    "LD_LIBRARY_PATH"
    ":"
    "/run/opengl-driver/lib"

    # Some dependencies try to dlopen() libnvrtc.so.12 at runtime, namely torch
    # and cupy-cuda12x.
    "--prefix"
    "LD_LIBRARY_PATH"
    ":"
    "${python3.pkgs.nvidia-cuda-nvrtc-cu12}/${sitePackages}/nvidia/cuda_nvrtc/lib"

    "--add-flags"
    "${comfyui-unwrapped}/${sitePackages}/main.py"
  ]
  ++
  lib.flatten (map (arg: [ "--add-flags" arg ]) commandLineArgs);

  preInstall = ''
    mkdir --parents $out/share/comfyui/custom_nodes

    ln --symbolic \
      ${comfyui-unwrapped}/${sitePackages}/custom_nodes/websocket_image_save.py \
      $out/share/comfyui/custom_nodes/websocket-image-save.py

    ${builtins.concatStringsSep "\n" (map (extension: ''
      ln --symbolic ${extension}/${sitePackages} \
        $out/share/comfyui/custom_nodes/${extension.passthru.originalName}
    '') extensions)}

    mkdir --parents $out/bin

    makeWrapper ''${makeWrapperArgs[@]}
  '';

  meta = {
    license = lib.licenses.gpl3;
  };
}
