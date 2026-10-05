---
title: Build with Hydrogen
description: Compile files and executable projects with the released compiler.
---

The release compiler directly emits supported programs. It does not invoke a C++
compiler, host C compiler, assembler, or linker.

## Compile a source file

```bash
hy check hello.hy
hy compile hello.hy -o hello
chmod +x hello
./hello
```

The default output is a standalone Linux x86-64 ELF executable. `check` finds
syntax and type errors; `compile` is the final authority because it also rejects
features the current backend cannot emit.

## Build a project

```bash
hy build app/App.hyproj -o app/bin/app
chmod +x app/bin/app
./app/bin/app
```

Executable project references contribute source files to one native compilation.
The current release does not produce library archives, build workspaces, resolve
packages, or run tests for you.

## Rebuild the compiler

Contributors can use a verified release binary as a seed to rebuild the compiler's
Hydrogen project closure. This is Hydrogen-only; a clean source-only checkout still
needs a trusted initial seed.
