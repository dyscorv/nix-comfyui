import ast
import dataclasses
import functools
import importlib.metadata
import importlib.util
import json
import logging
import os
import pathlib
import re
import sys

import requirements

reset = "\033[0m"
bold = "\033[01m"
dim = "\033[02m"
red = "\033[31m"


@dataclasses.dataclass(frozen=True)
class PackageSpec:
    output: pathlib.Path
    from_requirements_file: bool
    from_imports: bool
    required_package_names: set
    forced_package_names: set
    ignored_package_names: set
    ignored_module_names: set


@dataclasses.dataclass(frozen=True)
class PackageRequirements:
    required_package_names: set
    unresolved_module_names: set


def main():
    # Living in a /homeless-shelter...
    os.environ["HOME"] = os.environ.get("TEMPDIR", "/tmp")
    os.environ["NO_ALBUMENTATIONS_UPDATE"] = "1"
    logging.getLogger("matplotlib.font_manager").setLevel(logging.WARNING)

    has_errors = False

    specs_path = pathlib.Path(sys.argv[1])
    specs = read_package_specs(specs_path)

    for drv_name, spec in specs.items():

        def err(message):
            nonlocal has_errors
            print(f"{bold}{red}{drv_name}{reset}: {message}", file=sys.stderr)
            has_errors = True

        reqs = read_package_requirements(
            drv_output=spec.output,
            from_requirements_file=spec.from_requirements_file,
            from_imports=spec.from_imports,
        )

        for package_name in spec.required_package_names:
            if package_name not in reqs.required_package_names:
                if package_name not in spec.forced_package_names:
                    err(f"remove {bold}{package_name}{reset} " +
                        f"from propagatedBuildInputs {dim}[1]{reset}")

        for package_name in spec.forced_package_names:
            if package_name not in spec.required_package_names:
                err(f"remove {bold}{package_name}{reset} from " +
                    f"passthru.check-pkgs.forcedPackageNames {dim}[2]{reset}")

        for package_name in spec.ignored_package_names:
            if package_name in spec.required_package_names:
                err(f"remove {bold}{package_name}{reset} from " +
                    f"passthru.check-pkgs.ignoredPackageNames {dim}[3]{reset}")

        for package_name in spec.ignored_package_names:
            if package_name not in reqs.required_package_names:
                err(f"remove {bold}{package_name}{reset} from " +
                    f"passthru.check-pkgs.ignoredPackageNames {dim}[4]{reset}")

        for pattern in spec.ignored_module_names:
            if not match([pattern], reqs.unresolved_module_names):
                err(f"remove {bold}{pattern}{reset} from " +
                    f"passthru.check-pkgs.ignoredModuleNames {dim}[5]{reset}")

        for package_name in reqs.required_package_names:
            if package_name == "comfyui-unwrapped":
                continue
            if package_name not in spec.required_package_names:
                if package_name not in spec.ignored_package_names:
                    err(f"add {bold}{package_name}{reset} " +
                        f"to propagatedBuildInputs {dim}[6]{reset}")

        for module_name in reqs.unresolved_module_names:
            if not match(spec.ignored_module_names, [module_name]):
                err(f"unresolved module {bold}{module_name}{reset} " +
                    f"{dim}[7]{reset}")

    if has_errors:
        exit(1)


def read_package_specs(file_path):
    with file_path.open() as f:
        result = json.load(f)

    specs = {}
    for k, v in result.items():
        output = pathlib.Path(v["output"])
        from_requirements_file = v["from_requirements_file"]
        from_imports = v["from_imports"]
        required_package_names = set(v["required_package_names"])
        forced_package_names = set(v["forced_package_names"])
        ignored_package_names = set(v["ignored_package_names"])
        ignored_module_names = set(map(re.compile, v["ignored_module_names"]))
        specs[k] = PackageSpec(
            output=output,
            from_requirements_file=from_requirements_file,
            from_imports=from_imports,
            required_package_names=required_package_names,
            forced_package_names=forced_package_names,
            ignored_package_names=ignored_package_names,
            ignored_module_names=ignored_module_names,
        )

    return specs


def read_package_requirements(
    drv_output,
    from_requirements_file,
    from_imports,
):
    package_path = drv_output.joinpath("lib/python3.11/site-packages")

    required_package_names = set()
    unresolved_module_names = set()

    if from_requirements_file:
        requirements_file_path = package_path.joinpath("requirements.txt")
        try:
            package_names = read_requirements_file(requirements_file_path)
            required_package_names.update(package_names)
        except FileNotFoundError:
            pass

    if from_imports:
        imported_module_names = read_imports_from_dir(package_path)
        for module_name in imported_module_names:
            if is_python_module_name(module_name):
                continue
            package_name = resolve_external_package_name(module_name)
            if package_name is None:
                unresolved_module_names.add(module_name)
            else:
                required_package_names.add(package_name)

    return PackageRequirements(
        required_package_names=required_package_names,
        unresolved_module_names=unresolved_module_names,
    )


def is_python_module_name(module_name):
    root_name = module_name.split(".")[0]

    return (root_name in sys.builtin_module_names
            or root_name in sys.stdlib_module_names)


def resolve_external_package_name(module_name):
    try:
        spec = importlib.util.find_spec(module_name)
    except (ModuleNotFoundError, ValueError):
        return None

    if spec is None:
        return None

    if spec.origin is not None:
        module_path = pathlib.Path(spec.origin)
        return get_module_index().get(module_path, None)

    if spec.submodule_search_locations is not None:
        module_path = pathlib.Path(spec.submodule_search_locations[0])
        return get_module_index().get(module_path, None)

    return None


@functools.lru_cache(maxsize=1)
def get_module_index():
    index = {}

    for dist in importlib.metadata.distributions():
        package_name = normalize_package_name(dist.metadata["Name"])

        for package_file in dist.files:
            abs_file = package_file.locate()
            index[abs_file.parent] = package_name
            index[abs_file] = package_name

    return index


def read_requirements_file(file_path):
    package_names = set()

    with file_path.open() as f:
        for requirement in requirements.parse(f):
            package_name = normalize_package_name(requirement.name)
            package_names.add(package_name)

    return package_names


def read_imports_from_dir(dir_path):
    module_names = set()

    for dir_path, dir_names, file_names in os.walk(dir_path):
        for file_name in file_names:
            file_path = pathlib.Path(dir_path).joinpath(file_name)
            if file_path.suffix == ".py":
                module_names.update(read_imports_from_file(file_path))

    return module_names


def read_imports_from_file(file_path):
    module_names = set()
    tree = ast.parse(file_path.read_bytes(), filename=file_path)

    for node in ast.walk(tree):
        if isinstance(node, ast.Import):
            for alias in node.names:
                module_names.add(alias.name)

        elif isinstance(node, ast.ImportFrom):
            if node.module is not None and node.level == 0:
                module_names.add(node.module)

    return module_names


def normalize_package_name(package_name):
    return re.sub(r"[-_.]+", "-", package_name).lower()


def match(patterns, strings):
    for pattern in patterns:
        for string in strings:
            if pattern.match(string):
                return True
    return False


if __name__ == "__main__":
    main()
