---
title: The released Hydrogen compiler
description: The supported language surface and output targets in the current release.
---

This guide describes the published [Hydrogen `alpha-0.0.2`](https://github.com/Aurora-Softwares/Hylang-Compiler/releases/tag/alpha-0.0.2) release.
Hydrogen releases ship the self-hosted Hydrogen compiler. This is the compiler you
use to write programs and build Linux-native applications. The current Australis
OS tree requires a newer development compiler checkout for raw `AUKR` kernels
and AUEX `.exec` applications.

The current release runs on Linux x86-64. Its default output is a standalone Linux
x86-64 executable. It can also emit PE32+ `uefi-x64` firmware images for a
constrained bootloader and early kernel sequence. Windows and macOS host
executables are future ports.

## Supported language surface

| Area | Available now |
| --- | --- |
| Program structure | Namespaces, classes, structs, interfaces, access modifiers, static and instance members |
| Values | Signed and unsigned integral widths, `bool`, strings, arrays, enums, and `var` |
| Control flow | `if`, `while`, `for`, `break`, `continue`, and `return` |
| Objects | Constructors, inheritance, virtual dispatch, interface calls, overloads, static fields, and recursion |
| Linux services | Console output, file text/bytes, integer parsing, and managed allocation/GC |
| Projects | Executable, EFI, kernel, and OS `.hyproj` projects with source references |
| UEFI | Literal console output, screen clearing, key wait, image launch, boot-services exit, and a fixed early-kernel initialization sequence |

Generics, exceptions, a general pointer/foreign-function model, a package manager,
and an interpreter are still outside this release. See the language pages for
examples of the supported subset.

## Targets

```bash
# Linux-native executable
hy compile hello.hy -o hello

# UEFI application
hy compile hello.hy --target uefi-x64 -o BOOTX64.EFI
```

`uefi-x64` has a restricted entry-point profile rather than the Linux runtime.
It supports the built-in `System.Uefi` and `System.Kernel` calls documented in
[Builtin APIs](/runtime/builtins/), but not arbitrary methods, file I/O, or a
general-purpose UEFI library.
