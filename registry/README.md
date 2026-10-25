# Curated Hydrogen source registry

The public catalog is `public/registry/v1/index.txt`. Each entry is an exact
`id version sha256` tuple. The archive URL is derived as
`packages/<id>/<version>/<id>-<version>.hypkg`; the catalog cannot redirect a
client to another host. The registry contains source archives only. It has no
install hooks.

To propose a package, add its `.hypkg` under `registry/sources/`, add its
repository-relative path to `registry/approved.json`, and run
`python3 tools/build-registry.py`. Review the generated catalog and assets
before merging. Run `python3 tools/build-registry.py --check` in CI to catch
stale or manually changed generated files. Package IDs, versions, archive file
lists, manifest identity, declared dependencies, and file sizes are validated.

The first curated package is `hydrogen.math@0.1.0`, built from the compiler
repository's `samples/packages/hydrogen.math` example under the repository's
MIT license. Only committed assets appear on the website; users cannot publish
packages directly.
