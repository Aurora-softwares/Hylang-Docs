# Hylang

Hylang is a C#-inspired programming language aimed at [Australis OS](https://aurora-softwares.github.io/Australis-Docs/) and general x64 systems.

It features a full compiler pipeline — lexer, parser, AST, binder, type checker, and a bound IR — shared by both the interpreter and the C code emitter.

## Current status

- Phase 2 is complete.
- Phase 3 is active.
- The current bootstrap can interpret and compile multi-file console applications and can also build static libraries through `hyc build --target lib`.
- `hyrun` and `hyc build` share the same semantic pipeline, so the interpreted and compiled paths stay aligned at the language-semantics level.
- The compiler now supports a compiler-flavored proof project (`mini_frontend_model`) and a runtime-heavy proof project (`managed_collections`).

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

| Tool        | Purpose                                                           |
|-------------|-------------------------------------------------------------------|
| `hyrun`     | Run `.hy` scripts and `.hyproj` projects directly                 |
| `hyc build` | Compile to a native executable or static library via a C backend  |

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
- Array and string `.Length`, array indexing, string character indexing
- Minimal bootstrap `System.Collections.List<T>`

See the [Getting Started](getting-started/building.md) chapter to build and run the compiler, the [Runtime Model](runtime/runtime-model.md) page for Phase 3 behavior, and the [Roadmap](roadmap.md) page for the current phase breakdown.
