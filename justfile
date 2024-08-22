set positional-arguments := true

[private]
@default:
    just --list --unsorted

build name:
    nix build --out-link result-{{ quote(name) }} --print-build-logs \
      --verbose "${@:2}" .#{{ quote(name) }}

check:
    nix flake check --keep-going --print-build-logs --verbose

clean:
    rm --force --recursive result*

fmt:
    just --unstable --fmt
    nixpkgs-fmt .
    yapf --recursive --parallel --in-place .

poetry platform *args:
    nix run .#{{ quote(platform) }}.call-poetry -- "${@:2}"

prep name:
    bash scripts/patch-tool.sh prep {{ quote(name) }}

refresh name:
    bash scripts/patch-tool.sh refresh {{ quote(name) }}

repl:
    nix repl --extra-experimental-features "flakes repl-flake" .

up: up-flake up-lock up-sources up-patches

up-flake:
    nix flake update

up-lock: (poetry "cuda" "lock") (poetry "rocm" "lock")

up-patches *names:
    bash scripts/patch-tool.sh up "$@"

up-sources *files:
    python3 scripts/up-sources.py "$@"
