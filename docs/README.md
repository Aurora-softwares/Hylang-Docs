---
slug: /
title: Hydrogen language guide
---

# Hydrogen language guide

Hydrogen, also called Hylang, is a C#-inspired language for programs built around namespaces, classes, and methods. It uses `.hy` sources and `.hyproj` manifests. Managed objects, strings, and arrays provide the application programming model; the SDK also exposes explicit low-level memory operations.

## Start here

1. [Choose a compiler](getting-started/compiler-options.md): direct native Hydrogen compilation or the broader C++ SDK.
2. [Build the tools](getting-started/building.md).
3. [Write and run your first program](getting-started/running.md).
4. [Compile an executable](getting-started/compiling.md) or [organize a project](tools/projects.md).

```hylang
public class Program {
    public static int Main(string[] args) {
        System.Console.WriteLine("Hello, Hydrogen!");
        return 0;
    }
}
```

The native compiler emits standalone Linux x86-64 ELF executables and compiles its own source/project closure. The SDK supplies an interpreter, a host C backend, additional language features, and development tools. Their supported surfaces differ; use the [compiler support table](getting-started/compiler-options.md) when choosing features.

## Learn the language

Read [program structure](language/structure.md), [methods and objects](language/methods-and-objects.md), [types and strings](language/types.md), [arrays](language/arrays-and-collections.md), and [control flow](language/control-flow.md). Code fragments on reference pages belong inside the class or method described there unless shown as complete programs.

Use the [builtin API reference](runtime/builtins.md) for console, files, conversion, and memory services. Runtime behavior is described in the [runtime guide](runtime/runtime-model.md).

## Work with tools

The [native compiler](tools/hydrogen.md) checks and compiles sources and executable projects. The [SDK CLI](tools/hy.md) adds scaffolding, interpreted execution, testing, formatting, packages, and editor services. [Project manifests](tools/projects.md) describe source files and references.

Architecture notes and the [roadmap](roadmap.md) are separate from the language and usage guides.
