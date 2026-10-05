---
title: The released Hydrogen compiler
description: The supported language surface and output targets in the current release.
---

Hydrogen releases ship the self-hosted Hydrogen compiler. This is the compiler you
use to write programs, build native applications, and build Australis OS. There is
no compiler choice in the normal user workflow.

The current release runs on Linux x86-64. Its default output is a standalone Linux
x86-64 executable. It can also emit the deliberately small `uefi-x64` firmware
proof used by Australis. Windows and macOS host executables are future ports.

## Supported language surface

| Area | Available now |
| --- | --- |
| Program structure | Namespaces, classes, public/private members, static and instance methods |
| Values | `int`, `byte`, `bool`, strings, arrays, enums, and `var` |
| Control flow | `if`, `while`, `break`, `continue`, and `return` |
| Objects | Constructors, instance fields, field initializers, and recursion |
| Linux services | Console output, file text/bytes, integer parsing, and managed allocation/GC |
| Projects | Executable `.hyproj` projects and source project references |
| UEFI proof | ASCII literals passed to `System.Console.WriteLine` in `Main` |

The current release does not yet implement `for`, inheritance, interfaces, struct
value semantics, generics, overloads, static fields, exceptions, pointers, manual
memory, a package manager, an interpreter, or editor tooling.

## Targets

```bash
# Linux-native executable
hy compile hello.hy -o hello

# Current UEFI console proof
hy compile hello.hy --target uefi-x64 -o BOOTX64.EFI
```

`uefi-x64` is not the Linux runtime in a different file format. It currently has
no general console API, file I/O, arguments, keyboard input, allocation API,
graphics API, or `Hydrogen.Uefi` library.
