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

  prePatch = ''
    substituteInPlace videohelpersuite/utils.py \
      --replace-fail \
        '"VHS_FORCE_FFMPEG_PATH" in os.environ' \
        True \
      --replace-fail \
        'os.environ.get("VHS_FORCE_FFMPEG_PATH")' \
        '"${lib.getExe ffmpeg}"' \
      --replace-fail \
        'os.environ.get("VHS_GIFSKI", None)' \
        '"${lib.getExe gifski}"' \
      --replace-fail \
        'os.environ.get("VHS_YTDL", None)' \
        '"${lib.getExe yt-dlp}"'

    find -type f -name "*.py" | while IFS= read -r filename; do
      substituteInPlace "$filename" \
        --replace-quiet \
          'CATEGORY = "Video Helper Suite 🎥🅥🅗🅢' \
          'CATEGORY = "video_helper_suite' \
        --replace-quiet " 🎥🅥🅗🅢" "" \
        --replace-quiet "🎥🅥🅗🅢" ""
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
