---
title: Program structure
description: Organize Hydrogen programs with namespaces, classes, and an entry point.
---

Hydrogen programs contain namespaces and types; executable statements belong inside
methods. There are no top-level statements or free functions.

```csharp
namespace MyApp {
    public class Program {
        public static int Main(string[] args) {
            System.Console.WriteLine("Hello, Hydrogen!");
            return 0;
        }
    }
}
```

Namespaces use braces. A source can also declare a class in the global namespace.

## Imports

```csharp
using MyLibrary;
```

Place imports before declarations. They let a file use simple names for types in
that namespace but do not leak to other files. Use fully qualified builtin names,
such as `System.Console.WriteLine`; this is the stable spelling recognized by the
released compiler.

## Entry point

The released compiler accepts static `Main` methods returning `void` or `int`,
with either no parameters or one `string[]` parameter. Project source files are
listed in a `.hyproj` manifest; namespaces do not require a directory layout.
