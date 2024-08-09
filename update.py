import json
import pathlib
import sys

from nix_prefetch_github.dependency_injector import DependencyInjector
from nix_prefetch_github.interfaces import (
    GithubRepository,
    PrefetchedRepository,
    PrefetchOptions,
)

SOURCES_PATH = pathlib.Path("sources.json")


def main():
    prefetcher = DependencyInjector().get_prefetcher()
    sources = load_sources()
    names = sys.argv[1:] if len(sys.argv) > 1 else sources.keys()
    for name in names:
        update_source(prefetcher, sources[name])
    write_sources(sources)


def update_source(prefetcher, source):
    owner = source["owner"]
    repo = source["repo"]
    fetch_submodules = source["fetchSubmodules"]
    print(f"{owner}/{repo}...")

    result = prefetcher.prefetch_github(
        repository=GithubRepository(owner=owner, name=repo),
        rev=None,
        prefetch_options=PrefetchOptions(fetch_submodules=fetch_submodules),
    )

    if isinstance(result, PrefetchedRepository):
        old_rev = source.get("rev", None)
        new_rev = result.rev
        if old_rev is not None and old_rev != new_rev:
            url = f"https://github.com/{owner}/{repo}/compare/{old_rev}...{new_rev}"
            print(url)
        source["rev"] = new_rev
        source["hash"] = result.hash_sum
    else:
        raise result


def load_sources():
    with SOURCES_PATH.open() as f:
        return json.load(f)


def write_sources(sources):
    with SOURCES_PATH.open("w") as f:
        json.dump(sources, f, indent=2)
        f.write("\n")


if __name__ == "__main__":
    main()
