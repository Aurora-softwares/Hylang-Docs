---
slug: /
---

# Hylang

Hylang is a C#-inspired programming language aimed at [Australis OS](https://aurora-softwares.github.io/Australis-Docs/) and general x64 systems.

It features a full compiler pipeline — lexer, parser, AST, binder, type checker, and a bound IR — shared by both the interpreter and the C code emitter.

## Current status

- Phase 2 is complete.
- Phase 3 runtime foundations are landed.
- Phase 4 workflow and tooling work is complete at local-first bootstrap scope.
- Phase 5 self-hosting preparation is complete at prototype scope.
- The current bootstrap can interpret and compile multi-file console applications, build static libraries, run workspaces through `hy`, use a local filesystem package registry, and exercise a real build/test/fmt/check/package/LSP flow.
- `hyrun`, `hyc build`, and `hy` share the same semantic pipeline, so interpreted and compiled behavior stays aligned at the language-semantics level.
- The compiler now supports proof projects including `mini_frontend_model`, `managed_collections`, the systems showcase `hexlab`, the SDK tooling proof `sdk_demo`, and the Hydrogen compiler-library proof `self_hosting`.

## What Hylang looks like

```hylang
namespace Greeter {
    public class Program {
        public static void Main(string[] args) {
            string name = args[0];
            System.Console.WriteLine("Hello, " + name + "!");
        }
    }
}
```

## Key tools

| Tool        | Purpose                                                                                               |
|-------------|-------------------------------------------------------------------------------------------------------|
| `hy`        | Primary workflow CLI for scaffolding, building, running, testing, formatting, checking, and packaging |
| `hyrun`     | Run `.hy` scripts and `.hyproj` projects directly                                                     |
| `hyc build` | Compile to a native executable or static library via a C backend                                      |

## Current language subset

- `using`, `namespace`, `class`, `struct`, `interface`, `enum`
- `public`, `private`, `internal`, `protected`, `static`, `virtual`, `override`
- Static methods and static fields
- Fields, constructors, methods — with overloading
- Single inheritance with `base(...)`, `base.Member`, `virtual`, and `override`
- Interfaces, interface inheritance, and interface dispatch
- Structs with bootstrap by-value semantics and boxing to interfaces
- Generic classes, interfaces, and methods, plus `var` local inference
- `int`, `bool`, `string`, `T[]`, `null`
- Arithmetic (`+`, `-`, `*`, `/`, `%`), comparison (`==`, `!=`, `<`, `<=`, `>`, `>=`), logical (`&&`, `||`, `!`)
- `if`, `while`, `for`, `break`, `continue`, `return`
- Object creation (`new`), array creation (`new T[count]`), method calls, field access, `this`, assignment
- String concatenation for `string`, `int`, and `bool` combinations
- `System.Console.Write` / `WriteLine` (also accessible as `Console.*` with `using System;`)
- `System.IO.File.Exists`, `ReadAllText`, `WriteAllText`
- `System.IO.File.ReadAllBytes`, `WriteAllBytes`
- Array and string `.Length`, array indexing, string character indexing
- Minimal bootstrap `System.Collections.List<T>`
- Safe bootstrap `System.Runtime.Buffer`
- Executable `unsafe`, pointers, `stackalloc`, `sizeof`, and `System.Runtime.Memory`
- Bootstrap `System.Runtime.BinaryPrimitives` through 64-bit read/write helpers

See the [Getting Started](getting-started/building.md) chapter to build and run the compiler, the [hy](tools/hy.md) page for the current workflow CLI, the [Runtime Model](runtime/runtime-model.md) page for Phase 3 behavior, the [Phase 5 Self-Hosting Preparation](implementation/phase5-self-hosting-prep.md) page for the Hydrogen compiler prototype, and the [Roadmap](roadmap.md) page for the current phase breakdown.
