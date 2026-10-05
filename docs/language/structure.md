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

Use fully qualified builtin API names such as `System.Console.WriteLine` in portable native code. The SDK also resolves shortened builtin names with imports such as `using System;`; that spelling is not guaranteed by the native intrinsic recognizer.

## Types and members

Classes contain instance fields, constructors, and static/instance methods. See [methods and objects](methods-and-objects.md) for a runnable example. Enums declare named constants at namespace scope.

The SDK additionally supports structs, interfaces, generic classes/interfaces/methods, inheritance, overloads, and static fields. Refer to [compiler options](../getting-started/compiler-options.md) before using these features with the native route.

## Entry point

Both routes accept these static class entry signatures:

```hylang
public static void Main()
public static void Main(string[] args)
public static int Main()
public static int Main(string[] args)
```

These are signatures, not complete declarations: add a method body. Arguments exclude the executable name. An integer return becomes the process exit status.

## Multi-file programs

List source files in a [project manifest](../tools/projects.md). Referenced projects contribute types across their source closure. Namespaces organize symbols; they do not require a particular directory layout.
