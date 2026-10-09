---
title: Install the released compiler
description: Download and use the self-hosted Hydrogen compiler on Linux x86-64.
---

Hydrogen is distributed as a self-hosted compiler binary. For normal language and
Australis development, download that release binary; you do not need the older
C++ SDK or a C++ compiler.

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
