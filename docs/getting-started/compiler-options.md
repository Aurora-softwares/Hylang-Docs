# The released Hydrogen compiler

Hydrogen releases ship the self-hosted Hydrogen compiler. This is the compiler
you use to write programs, build native applications, and build Australis OS.
There is no compiler choice in the normal user workflow.

The current release runs on Linux x86-64. Its default output is a standalone
Linux x86-64 executable. It can also emit the deliberately small `uefi-x64`
firmware proof used by Australis. Windows and macOS host executables are future
ports, not requirements for using or understanding the language today.

## Supported language surface

The released compiler supports the following native subset:

| Area | Available now |
| --- | --- |
| Program structure | Namespaces, classes, public/private members, static and instance methods |
| Values | `int`, `byte`, `bool`, strings, arrays, enums, and `var` |
| Control flow | `if`, `while`, `break`, `continue`, and `return` |
| Objects | Constructors, instance fields, field initializers, and recursion |
| Linux services | Console output, file text/bytes, integer parsing, and managed allocation/GC |
| Projects | Executable `.hyproj` projects and source project references |
| UEFI proof | `System.Console.WriteLine` with ASCII literals in `Main`; no general runtime |

The current release does not yet implement `for`, inheritance, interfaces,
struct value semantics, generics, overloads, static fields, exceptions,
pointers, manual memory, a package manager, an interpreter, or editor tooling.
Those pages may appear in older design/history material, but they are not part
of the released compiler's supported surface.

## Use the release

Download the Linux x86-64 compiler release from the
[Hydrogen compiler releases](https://github.com/Aurora-Softwares/Hylang-Compiler/releases).
The current self-hosted executable is named `hydrogen-stage1`. Keep it in a
stable location and use its path directly, or place that directory on `PATH`.

```bash
export HYDROGEN=/path/to/hydrogen-stage1
"$HYDROGEN" tokens hello.hy
"$HYDROGEN" check hello.hy
```

All examples in this guide use `build/self_hosting/hydrogen-stage1` when they
refer to a compiler built from a source checkout. Substitute `$HYDROGEN` when
you are using a release download.

## Targets

Use the default target for Linux native applications:

```bash
"$HYDROGEN" compile hello.hy -o hello
```

Use `--target uefi-x64` only for the current UEFI console proof:

```bash
"$HYDROGEN" compile hello.hy --target uefi-x64 -o BOOTX64.EFI
```

This switch does not make the whole Linux-native runtime available to firmware.
UEFI support currently has no general console API, file I/O, arguments,
keyboard input, allocation API, graphics API, or `Hydrogen.Uefi` library. See
the exact, working [UEFI Hello World guide](uefi-hello.md).
