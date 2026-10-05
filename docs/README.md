---
slug: /
title: Hydrogen language guide
---

# Hydrogen language guide · [Request a feature](https://github.com/Aurora-Softwares/Hylang-Compiler/issues/new/choose)

Hydrogen, also called Hylang, is a self-hosted, C#-inspired language for programs built around namespaces, classes, and methods. It uses `.hy` sources and `.hyproj` manifests. The released compiler is written in Hydrogen and is the compiler used to build Hydrogen programs and the Australis OS proof of concept.

## Start here

1. [Install the released compiler](getting-started/installing.md).
2. [Learn the current supported surface](getting-started/compiler-options.md).
3. [Write and run your first program](getting-started/running.md).
4. [Build with Hydrogen](getting-started/building.md), including executable projects and contributor rebuilds.
5. [Compile an executable](getting-started/compiling.md) or [organize a project](tools/projects.md).
6. [Make a bootable UEFI Hello World](getting-started/uefi-hello.md), the current firmware proof of concept.

```hylang
public class Program {
    public static int Main(string[] args) {
        System.Console.WriteLine("Hello, Hydrogen!");
        return 0;
    }
}
```

The release runs on Linux x86-64 and emits standalone Linux x86-64 ELF executables. Its `uefi-x64` target also emits a PE32+ EFI application, currently a deliberately small firmware proof: a `Main` method can write ASCII string literals with `System.Console.WriteLine` through the UEFI console. It is not yet a general UEFI runtime or standard library.

Australis OS and native Australis applications are Hydrogen's primary direction. Linux is the current development host and application target; Windows and macOS support are planned ports. See the [roadmap](roadmap.md) for the order of work, or [request a feature](https://github.com/Aurora-Softwares/Hylang-Compiler/issues/new/choose).

## Learn the language

Read [program structure](language/structure.md), [methods and objects](language/methods-and-objects.md), [types and strings](language/types.md), [arrays](language/arrays-and-collections.md), and [control flow](language/control-flow.md). Code fragments on reference pages belong inside the class or method described there unless shown as complete programs.

Use the [builtin API reference](runtime/builtins.md) for console, files, conversion, and memory services. Runtime behavior is described in the [runtime guide](runtime/runtime-model.md).

## Work with tools

The [Hydrogen compiler](tools/hydrogen.md) checks and compiles sources and executable projects. [Project manifests](tools/projects.md) describe source files and references.

Architecture notes and the [roadmap](roadmap.md) are separate from the language and usage guides.
