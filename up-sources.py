import dataclasses
import json
import os
import pathlib
import re
import subprocess
import sys

from nix_prefetch_github.dependency_injector import DependencyInjector
from nix_prefetch_github.interfaces import (
    GithubRepository,
    PrefetchedRepository,
    PrefetchOptions,
)

prefetcher = DependencyInjector().get_prefetcher()


@dataclasses.dataclass(frozen=True)
class GitHubSource:
    owner: str
    repo: str
    fetch_submodules: bool
    rev: str
    hash: str


def main():
    if len(sys.argv) > 1:
        for arg in sys.argv[1:]:
            process_file(pathlib.Path(arg))
    else:
        for dir_path, dir_names, file_names in os.walk("."):
            for file_name in file_names:
                file_path = pathlib.Path(dir_path).joinpath(file_name)
                if file_path.suffix == ".nix":
                    process_file(file_path)


def process_file(file_path):
    print(file_path)

    text = file_path.read_text()
    old_text = text
    changed_source = None
    package_lock_file_path = None

    def replace_github_source(match):
        nonlocal changed_source

        old_source = github_source_from_match(match)
        new_source = update_github_source(old_source)

        if old_source != new_source:
            if changed_source is None:
                changed_source = new_source
            print(f"  {get_github_compare_url(old_source, new_source)}")

        return expression_from_github_source(new_source)

    text = re.sub(github_source_pattern, replace_github_source, text)

    def replace_npm_deps_hash(match):
        nonlocal changed_source

        drv_out = build_github_source(changed_source)

        package_lock_file_path = drv_out.joinpath("package-lock.json")
        new_hash = calc_npm_deps_hash(package_lock_file_path)

        return key_value_from_npm_deps_hash(new_hash)

    if changed_source is not None:
        text = re.sub(npm_deps_hash_pattern, replace_npm_deps_hash, text)

    if text != old_text:
        file_path.write_text(format_nix(text))


github_source_pattern = re.compile(
    r"""
        fetchFromGitHub\s*{\s*
          owner\s*=\s*\"(?P<owner>[^\"]*)\"\s*;\s*
          repo\s*=\s*\"(?P<repo>[^\"]*)\"\s*;\s*
          fetchSubmodules\s*=\s*(?P<fetch_submodules>true|false)\s*;\s*
          rev\s*=\s*\"(?P<rev>[^\"]*)\"\s*;\s*
          hash\s*=\s*\"(?P<hash>[^\"]*)\"\s*;\s*
        }
    """,
    re.VERBOSE,
)


def github_source_from_match(match):
    return GitHubSource(
        owner=match.group("owner"),
        repo=match.group("repo"),
        fetch_submodules=match.group("fetch_submodules") == "true",
        rev=match.group("rev"),
        hash=match.group("hash"),
    )


def update_github_source(source):
    options = PrefetchOptions(fetch_submodules=source.fetch_submodules)
    result = prefetcher.prefetch_github(
        repository=GithubRepository(owner=source.owner, name=source.repo),
        rev=None,
        prefetch_options=options,
    )

    if isinstance(result, PrefetchedRepository):
        return GitHubSource(
            owner=source.owner,
            repo=source.repo,
            fetch_submodules=source.fetch_submodules,
            rev=result.rev,
            hash=result.hash_sum,
        )
    else:
        raise result


def build_github_source(source):
    expr = f"""
        let
          nixpkgs = builtins.getFlake "{get_locked_url("nixpkgs")}";
          system = builtins.currentSystem;
          inherit (nixpkgs.legacyPackages."${{system}}") fetchFromGitHub;
        in
        {expression_from_github_source(source)}
    """
    output = subprocess.check_output(
        ["nix", "build", "--expr", expr, "--impure", "--json"])
    return pathlib.Path(json.loads(output)[0]["outputs"]["out"])


def expression_from_github_source(source):
    fs = "true" if source.fetch_submodules else "false"
    return "fetchFromGitHub {\n" + \
        f"  owner = \"{source.owner}\";\n" + \
        f"  repo = \"{source.repo}\";\n" + \
        f"  fetchSubmodules = {fs};\n" + \
        f"  rev = \"{source.rev}\";\n" + \
        f"  hash = \"{source.hash}\";\n" + \
        "}"


def get_github_compare_url(s1, s2):
    return f"https://github.com/{s1.owner}/{s1.repo}/compare/{s1.rev}...{s2.rev}"


npm_deps_hash_pattern = re.compile(
    r"npmDepsHash\s*=\s*\"(?P<hash>[^\"]*)\"\s*;")


def calc_npm_deps_hash(package_lock_file_path):
    cmd = ["prefetch-npm-deps", str(package_lock_file_path)]
    output = subprocess.check_output(cmd, encoding="utf-8")
    return output.strip()


def key_value_from_npm_deps_hash(hash):
    return f"npmDepsHash = \"{hash}\";"


def get_locked_url(name):
    cmd = ["nix", "flake", "metadata", "--inputs-from", ".", "--json", name]
    output = subprocess.check_output(cmd)
    return json.loads(output)["url"]


def format_nix(text):
    return subprocess.check_output(
        ["nixpkgs-fmt"],
        input=text,
        encoding="utf-8",
    )


if __name__ == "__main__":
    main()
