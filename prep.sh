# shellcheck shell=bash
set -o errexit
set -o nounset
set -o pipefail

declare ro_src="" rw_src="" user="" email=""
ro_src="$(nix build --no-link --print-out-paths ".#$1".src)"
rw_src="result-$1.src"
user="$(git config user.name)"
email="$(git config user.email)"

rm --force --recursive -- "$rw_src" &>/dev/null || :
cp --recursive -- "$ro_src" "$rw_src"
chmod --recursive u+w -- "$rw_src"

cd -- "$rw_src"

git init --quiet
git config user.name "$user"
git config user.email "$email"

git add .
GIT_COMMITTER_DATE=1970-01-01T00:00:00.000Z \
GIT_AUTHOR_DATE=1970-01-01T00:00:00.000Z \
  git commit --message init --quiet
git branch upstream

# shellcheck disable=SC2038
find "../${1//./\/}" -type f -name "*.patch" |
  xargs git am --committer-date-is-author-date --keep-cr --quiet --
