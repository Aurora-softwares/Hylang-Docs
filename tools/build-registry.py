#!/usr/bin/env python3
"""Build the reviewed, source-only Hydrogen registry from approved archives."""

import argparse
import hashlib
import json
import pathlib
import re
import sys

ROOT = pathlib.Path(__file__).resolve().parents[1]
SOURCE = ROOT / "registry" / "sources"
PUBLIC = ROOT / "public" / "registry" / "v1"
PART = re.compile(r"[A-Za-z0-9][A-Za-z0-9._-]*\Z")
FILE = re.compile(r"[A-Za-z0-9][A-Za-z0-9._-]*\.(?:hy|hyproj)\Z")
HASH = "hydrogen-registry-v1\n"


def parse_manifest(data: bytes) -> tuple[str, str, list[str]]:
    text = data.decode("utf-8")
    section = ""
    values: dict[tuple[str, str], str] = {}
    dependencies: list[str] = []
    for raw in text.splitlines():
        line = raw.strip()
        if not line or line.startswith(("#", "//")):
            continue
        if line.startswith("["):
            section = line
            continue
        if "=" not in line:
            continue
        key, value = (part.strip() for part in line.split("=", 1))
        values[(section, key)] = value
        if section == "[dependencies]":
            if not PART.fullmatch(key) or not re.fullmatch(r'"[A-Za-z0-9][A-Za-z0-9._-]*"', value):
                raise ValueError("invalid exact dependency")
            if key in dependencies:
                raise ValueError("duplicate dependency")
            dependencies.append(key)
    def string(section: str, key: str) -> str:
        raw = values.get((section, key), "")
        return raw[1:-1] if raw.startswith('"') and raw.endswith('"') else ""
    package_id = string("[package]", "id")
    version = string("", "version")
    if values.get(("", "format")) != "2" or string("", "type") != "lib":
        raise ValueError("package must be a format 2 library")
    if not PART.fullmatch(package_id) or not PART.fullmatch(version):
        raise ValueError("invalid package ID or version")
    if values.get(("", "project_references"), "[]") != "[]":
        raise ValueError("package project references are unsupported")
    sources = values.get(("", "sources"), "")
    if not sources.startswith("[") or not sources.endswith("]"):
        raise ValueError("missing source list")
    names = re.findall(r'"([^"\n]+)"', sources)
    if not names or any(not name.endswith(".hy") or not FILE.fullmatch(name) for name in names):
        raise ValueError("invalid source list")
    return package_id, version, names


def inspect_archive(data: bytes) -> tuple[str, str]:
    if len(data) > 16 * 1024 * 1024 or not data.startswith(b"HYLANG_PACKAGE_V1\n"):
        raise ValueError("invalid or oversized package archive")
    at = len(b"HYLANG_PACKAGE_V1\n")
    files: dict[str, bytes] = {}
    while at < len(data):
        end = data.find(b"\n", at)
        if end < 0:
            raise ValueError("incomplete file header")
        header = data[at:end].decode("ascii")
        match = re.fullmatch(r"FILE ([A-Za-z0-9][A-Za-z0-9._-]*\.(?:hy|hyproj)) ([0-9]{1,8})", header)
        if not match:
            raise ValueError("invalid file header")
        name, length = match.group(1), int(match.group(2))
        if not FILE.fullmatch(name) or name in files or length > 1024 * 1024:
            raise ValueError("unsafe package file")
        start = end + 1
        if start + length >= len(data) or data[start + length] != 10:
            raise ValueError("truncated package file")
        files[name] = data[start:start + length]
        at = start + length + 1
    manifests = [name for name in files if name.endswith(".hyproj")]
    if len(manifests) != 1:
        raise ValueError("expected one package manifest")
    package_id, version, sources = parse_manifest(files[manifests[0]])
    if manifests[0] != f"{package_id}.hyproj" or list(files) != [manifests[0], *sources]:
        raise ValueError("archive and manifest file lists differ")
    return package_id, version


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    manifest = json.loads((ROOT / "registry" / "approved.json").read_text())
    approved = manifest["packages"]
    if not isinstance(approved, list) or len(set(approved)) != len(approved):
        raise ValueError("approved packages must be unique paths")
    entries: list[tuple[str, str, str, bytes]] = []
    for relative in approved:
        path = ROOT / relative
        if path.parent != SOURCE or path.suffix != ".hypkg" or not path.is_file() or path.is_symlink():
            raise ValueError(f"unapproved source path: {relative}")
        data = path.read_bytes()
        package_id, version = inspect_archive(data)
        entries.append((package_id, version, hashlib.sha256(data).hexdigest(), data))
    entries.sort(key=lambda item: (item[0], item[1]))
    if len({(item[0], item[1]) for item in entries}) != len(entries):
        raise ValueError("duplicate package ID and version")
    expected: dict[pathlib.Path, bytes] = {PUBLIC / "index.txt":
        (HASH + "".join(f"{item[0]} {item[1]} {item[2]}\n" for item in entries)).encode()}
    for package_id, version, _, data in entries:
        expected[PUBLIC / "packages" / package_id / version / f"{package_id}-{version}.hypkg"] = data
    existing = {path for path in PUBLIC.rglob("*") if path.is_file()}
    if args.check:
        if existing != set(expected) or any(path.read_bytes() != data for path, data in expected.items()):
            raise ValueError("generated registry differs; run tools/build-registry.py")
        return 0
    for stale in existing - set(expected):
        stale.unlink()
    for path, data in expected.items():
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_bytes(data)
    print(f"Wrote {len(entries)} curated packages to {PUBLIC}")
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except (ValueError, KeyError, UnicodeError, OSError) as error:
        print(f"registry: {error}", file=sys.stderr)
        sys.exit(1)
