# shellcheck shell=bash
set -o errexit
set -o nounset
set -o pipefail
shopt -s extglob

main() {
  case "${1:-}" in
    prep | refresh | up)
      "$@"
      ;;
    *)
      printf "bad arguments\n" >&2
      false
      ;;
  esac
}

prep() {
  declare -r drv_name="$1"

  printf "prep %Q\n" "$drv_name"

  declare drv_dir="" ro_src="" rw_src="" user="" email=""
  drv_dir="$(get-drv-dir "$drv_name")"
  ro_src="$(nix build --no-link --print-out-paths ".#$drv_name.src")"
  rw_src="result-$drv_name.src"
  user="$(git config user.name)"
  email="$(git config user.email)"

  rm --force --recursive -- "$rw_src" &>/dev/null || :
  cp --recursive -- "$ro_src" "$rw_src"
  chmod --recursive u+w -- "$rw_src"

  pushd -- "$rw_src" &>/dev/null

  git init --quiet
  git config user.name "$user"
  git config user.email "$email"

  git add .
  GIT_COMMITTER_DATE=1970-01-01T00:00:00.000Z \
  GIT_AUTHOR_DATE=1970-01-01T00:00:00.000Z \
    git commit --message init --quiet
  git branch upstream

  # shellcheck disable=SC2038
  find "../$drv_dir" -type f -name "*.patch" |
    xargs git am --committer-date-is-author-date --keep-cr --

  popd &>/dev/null
}

refresh() {
  declare -r drv_name="$1"

  printf "refresh %Q\n" "$drv_name"

  declare drv_dir=""
  drv_dir="$(get-drv-dir "$drv_name")"
  rw_src="result-$drv_name.src"

  git -C "$rw_src" format-patch --no-signature --no-stat \
    --output-directory "../$drv_dir" --quiet --zero-commit upstream...master
}

up() {
  if [[ "$#" -eq 0 ]]; then
    declare drv_dir="" drv_name=""
    while IFS= read -r drv_dir; do
      drv_name="$(get-drv-name "$drv_dir")"
      up-1 "$drv_name"
    done < <(
      find extensions packages -type f -name "*.patch" -printf "%h\n" |
      sort | uniq
    )
  else
    declare drv_name=""
    for drv_name in "$@"; do
      up-1 "$drv_name"
    done
  fi
}

up-1() {
  declare -r drv_name="$1"
  prep "$drv_name"
  refresh "$drv_name"
}

get-drv-dir() {
  declare -r drv_name="$1"
  if [[ "$drv_name" == extensions.* ]]; then
    printf "%s\n" "${drv_name/./\/}"
  else
    printf "packages/%s\n" "$drv_name"
  fi
}

get-drv-name() {
  declare -r drv_dir="$1"
  declare drv_name="${drv_dir#packages/}"
  printf "%s\n" "${drv_name/\//.}"
}

main "$@"
