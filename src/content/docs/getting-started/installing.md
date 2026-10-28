---
title: Install the released compiler
description: Download and use the self-hosted Hydrogen compiler on Linux, Windows, and macOS x64.
---

Hydrogen is distributed as a self-hosted compiler binary. Use the documented
release for its Linux-native and constrained UEFI features. Building the current
Australis OS tree requires the newer compiler source checkout; its Makefile
builds a local application compiler from that source.

## One-line installers for the next preview

The website now serves the installer scripts below. They require a newer,
manifest-bearing GitHub release asset. The current `alpha-0.0.2` release does
not contain those assets, so the scripts will report that no compatible release
is available until the next preview is published.

Linux x86-64:

```bash
curl -fsSL https://hylang.co.uk/install.sh | HYDROGEN_CHANNEL=alpha bash
```

Windows x64 PowerShell:

```powershell
$env:HYDROGEN_CHANNEL='alpha'; irm https://hylang.co.uk/install.ps1 | iex
```

macOS Intel (or an Apple Silicon Mac with Rosetta 2):

```bash
curl -fsSL https://hylang.co.uk/install.sh | HYDROGEN_CHANNEL=alpha bash
```

The scripts download an official platform-specific release archive, verify the release digest
and SHA-256 sidecar, then install to a user-owned directory. The Linux script
creates `~/.local/bin/hy`; add that directory to `PATH` if necessary. The
Windows script adds the new `bin` directory to the user `PATH` for new
terminals; the command is provided by `hy.cmd`. Stable-channel installers omit
the `HYDROGEN_CHANNEL` setting once a stable release exists. Packaged Linux
and macOS builds have update and uninstall commands. The macOS release is in
development; use the source build until a macOS archive is published.

## Linux x86-64

Download the `hydrogen-alpha-0.0.2-linux-x86_64.tar.gz` asset from the
[Hydrogen alpha-0.0.2 release](https://github.com/Aurora-Softwares/Hylang-Compiler/releases/tag/alpha-0.0.2),
extract it, and add its `bin` directory to your shell `PATH`. The release command
is named `hy`. (`.hy` remains the extension for Hydrogen source files.)

```bash
export PATH="/path/to/hydrogen-alpha-0.0.2-linux-x86_64/bin:$PATH"
```

The companion `.tar.gz.sha256` file verifies the downloaded archive with
`sha256sum -c hydrogen-alpha-0.0.2-linux-x86_64.tar.gz.sha256` before extraction.

Add the same `PATH` entry to your shell profile (for example `~/.profile`) to make
`hy` available in new terminals. Compile the program below to confirm the
release works.

## First program

Create `hello.hy`:

```csharp
public class Program {
    public static int Main(string[] args) {
        System.Console.WriteLine("Hello, Hydrogen!");
        return 0;
    }
}
```

Compile and run it:

```bash
hy check hello.hy
hy compile hello.hy -o hello
chmod +x hello
./hello
```

## Building from source

This is only needed when contributing to Hydrogen or creating a new trusted seed.
A source-only checkout needs a verified Hydrogen compiler; the historical C++
bootstrap is maintainer infrastructure, not part of using a release.
