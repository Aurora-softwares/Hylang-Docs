---
title: macOS x64 release archive
description: Build, verify, install, update, and remove the Hydrogen compiler on macOS.
---

The Development branch can produce a self-hosted Intel macOS compiler and a
`hydrogen-<version>-macos-x86_64.tar.gz` release archive. The compiler,
runtime, archive, update, and uninstall pass the
[macOS integration job](https://github.com/Aurora-softwares/Hylang-Compiler/actions/workflows/hydrogen-ci.yml).
No macOS archive has been published on GitHub Releases yet.

## Build a candidate

From the Hylang-Compiler checkout, pass a verified self-hosted compiler:

```bash
cmake -DSOURCE_DIR="$PWD" -DHOST_COMPILER="/path/to/verified/hy" \
  -DVERSION="alpha-0.0.3" -DRELEASES_DIR="$PWD/releases" \
  -P cmake/MakeHydrogenMacOSRelease.cmake
```

The script checks the Mach-O header and writes the `.tar.gz` archive plus a
`.tar.gz.sha256` sidecar. The full release candidate script builds Linux,
Windows, and macOS archives together. The macOS archive, installer, and
lifecycle fixture checks are green. The remaining release gate is a live
install from a published GitHub release asset.

## Install a published archive

Once a matching archive has been published, the website installer uses the
macOS asset automatically on Intel macOS:

```bash
curl -fsSL https://hylang.co.uk/install.sh | HYDROGEN_CHANNEL=alpha bash
```

It verifies the GitHub release digest, the SHA-256 sidecar, and every installed
file before activating `~/.local/share/hydrogen`. The launcher is
`~/.local/bin/hy`. Add that directory to `PATH` if needed. These commands are
available from a packaged release:

```bash
hy --version
hy update-check
hy update
hy uninstall
```

For a Homebrew-owned compiler, the launcher delegates updates and removal to
Homebrew. The current target is x86-64; native arm64 output is not implemented.
