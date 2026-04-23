# Hylang

Hylang is a C#-inspired programming language aimed at [Aura OS](https://github.com/Aurora-Softwares) and general x64 systems.

It features a full compiler pipeline — lexer, parser, AST, binder, type checker, and a bound IR — shared by both the interpreter and the C code emitter.

## What Hylang looks like

```hylang
namespace Greeter;

class Program {
    public static void Main(string[] args) {
        string name = args[0];
        System.Console.WriteLine("Hello, " + name + "!");
    }
}
```

## Key tools

| Tool | Purpose |
|------|---------|
| `hyrun` | Run `.hy` scripts and `.hyproj` projects directly |
| `hyc build` | Compile to a native executable or static library via a C backend |

## Current language subset

- `using`, `namespace`, `class`
- `public`, `private`, `internal`, `protected` access modifiers
- Static methods and fields
- Fields, constructors, methods
- `int`, `bool`, `string`, `string[]`
- `if`, `while`, `for`, `break`, `continue`, `return`
- Object creation, method calls, field access, assignment
- String concatenation for `string`, `int`, and `bool` combinations
- `System.Console.Write` / `WriteLine`
- `System.IO.File.Exists`, `ReadAllText`, `WriteAllText`
- Array and string `.Length`, array indexing

See the [Getting Started](getting-started/building.md) chapter to build and run the compiler.
