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

poetry *args:
    nix run .#call-poetry -- "$@"

prep name:
    bash prep.sh {{ quote(name) }}

refresh name:
    git -C result-{{ quote(name) }}.src format-patch --no-signature --no-stat \
      --output-directory ../{{ quote(replace(name, ".", "/")) }} --quiet \
      --zero-commit upstream...master

repl:
    nix repl --extra-experimental-features "flakes repl-flake" .

up: up-flake up-lock up-sources up-patches

up-flake:
    nix flake update

up-lock: (poetry "lock")

up-patches:
    #! /usr/bin/env bash
    set -euo pipefail
    declare -a args=()
    declare dirname=""
    while IFS= read -r dirname; do
      dirname="${dirname#./}"
      dirname="${dirname/\//.}"
      args+=(prep "$dirname" refresh "$dirname")
    done < <(find . -type f -name "*.patch" -printf "%h\n" | sort | uniq)
    exec just "${args[@]}"

up-sources *files:
    python3 up-sources.py "$@"
