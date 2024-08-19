{ buildExtension, fetchFromGitHub, ffmpeg, gifski, lib, python3, yt-dlp }:

buildExtension {
  name = "kosinkadink-video-helper-suite";

  src = fetchFromGitHub {
    owner = "Kosinkadink";
    repo = "ComfyUI-VideoHelperSuite";
    fetchSubmodules = false;
    rev = "6bffe8b90f4464f76f1606bd93b94f1ac8d38041";
    hash = "sha256-C5Nkrnyush5xf6yqInkSfSs/PNCpDonTlA3+HHaLsS8=";
  };

  propagatedBuildInputs = [
    python3.pkgs.numpy
    python3.pkgs.opencv-python
    python3.pkgs.pillow
    python3.pkgs.psutil
    python3.pkgs.torch
  ];

  patches = [
    ./0001-subst-executables.patch
  ];

  postPatch = ''
    substituteInPlace videohelpersuite/utils.py \
      --subst-var-by ffmpeg ${lib.getExe ffmpeg} \
      --subst-var-by gifski ${lib.getExe gifski} \
      --subst-var-by yt-dlp ${lib.getExe yt-dlp}

    find . -type f \( -name "*.py" -o -name "*.js" \) | xargs sed --in-place \
      "s/[[:space:]]*🎥🅥🅗🅢[[:space:]]*//g" --

    find . -type f -name "*.py" | while IFS= read -r filename; do
      substituteInPlace "$filename" \
        --replace-quiet \
          'CATEGORY = "Video Helper Suite' \
          'CATEGORY = "video_helper_suite'
    done
  '';

  passthru = {
    check-pkgs.ignoredPackageNames = [
      "imageio-ffmpeg"
    ];

    check-pkgs.ignoredModuleNames = [
      "^imageio_ffmpeg$"
    ];
  };

  meta = {
    license = lib.licenses.gpl3;
  };
}
