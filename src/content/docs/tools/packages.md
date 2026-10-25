---
title: Packages and the registry
description: Install exact source dependencies into a Hydrogen project.
---

The development compiler has a project-local source package manager. The
published `alpha-0.0.2` compiler does not include it yet. Packages contain a
format 2 library manifest and flat `.hy` source files. Installation runs no
package hooks or scripts.

```bash
hy package search math
hy package add App.hyproj hydrogen.math@0.1.0
hy build App.hyproj -o app
```

The first curated sample is `hydrogen.math@0.1.0`, which provides
`HydrogenMath.IntegerMath.Min`, `Max`, and `Clamp`. The registry lives at
`https://hylang.co.uk/registry/v1/`. Versions are exact; an unversioned add
does not silently select a release.

`add` writes a `[dependencies]` entry to the project, downloads its transitive
source dependencies into `.hylang/packages`, and writes `hy.lock`. Commit the
manifest and lockfile. Builds verify the package archives, manifests and source
file hashes against the lockfile.

```bash
hy package restore App.hyproj
hy package upgrade App.hyproj hydrogen.math@0.2.0
hy package remove App.hyproj hydrogen.math
```

`restore` downloads the exact archives in `hy.lock` and checks the resulting
file hashes. `upgrade` requires an explicit target version and rolls back the
project manifest and lockfile on failure. `remove` drops a direct dependency
and refreshes the lockfile; cached archive files can remain on disk.

For local development, `hy package pack Library/Library.hyproj -o Library.hypkg`
creates a source archive and `hy package add App.hyproj Library.hypkg` adds it
without using the website. The `--registry <origin>` option on search, remote
add, restore, and upgrade can point to another HTTPS registry or a `file://`
test registry. Packages submitted to the official registry are reviewed and
committed with their SHA-256 digests; there is no open upload endpoint.
