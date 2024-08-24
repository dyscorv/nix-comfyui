# shellcheck shell=bash
set -o errexit
set -o nounset
set -o pipefail

check-all() {
  set -o xtrace

  show-space-usage
  nix develop --quiet --command just check-fmt
  show-space-usage
  collect-garbage

  show-space-usage
  build-derivation 1 krita-with-extensions
  show-space-usage
  remove-roots 1
  collect-garbage

  show-space-usage
  build-derivation 1 comfyui-frontend
  show-space-usage
  collect-garbage

  check-platform cuda
  check-platform rocm
}

check-platform() {
  declare platform="$1"

  show-space-usage
  build-derivation 2 "${platform}.python3.pkgs.torch"
  show-space-usage
  collect-garbage

  show-space-usage
  build-derivation 2 "${platform}.run-check-pkgs"
  show-space-usage
  remove-roots 2
  collect-garbage
}

build-derivation() {
  declare -r prefix="$1"
  declare -r name="$2"
  nix build --out-link "result-$prefix-$name" --quiet ".#$name"
}

remove-roots() {
  declare -r prefix="$1"
  rm result-"$prefix"-*
}

collect-garbage() {
  nix store gc --quiet
}

show-space-usage() {
  df --human-readable
}

check-all
