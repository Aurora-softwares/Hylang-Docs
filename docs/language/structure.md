# Program structure

Hydrogen programs contain namespaces and types; executable statements belong inside methods. There are no top-level statements or free functions.

## Complete program

```hylang
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

```hylang
using MyLibrary;
```

Put namespace imports before declarations. Imports let a file use simple names for types from those namespaces. Imports do not leak to other files. Use fully qualified names when simple names are ambiguous.

Use fully qualified builtin API names such as `System.Console.WriteLine`. That is the stable spelling recognized by the released compiler.

## Types and members

Classes contain instance fields, constructors, and static/instance methods. See [methods and objects](methods-and-objects.md) for a runnable example. Enums declare named constants at namespace scope.

The current release does not support structs, interfaces, generic types or methods, inheritance, overloads, or static fields. Keep programs within the [released compiler surface](../getting-started/compiler-options.md).

## Entry point

The released compiler accepts these static class entry signatures:

```hylang
public static void Main()
public static void Main(string[] args)
public static int Main()
public static int Main(string[] args)
```

These are signatures, not complete declarations: add a method body. Arguments exclude the executable name. An integer return becomes the process exit status.

## Multi-file programs

List source files in a [project manifest](../tools/projects.md). Referenced projects contribute types across their source closure. Namespaces organize symbols; they do not require a particular directory layout.
