# Program Structure

A Hylang program is organized into namespaces and classes. Every executable entry point is a `public static void Main` method, with or without the `string[] args` parameter.

## Using directives

```hylang
using System;
```

`using` imports a namespace into scope, allowing you to reference its types without the full qualifier. For example, `using System;` lets you write `Console.WriteLine(...)` instead of `System.Console.WriteLine(...)`.

Using directives must appear before the namespace declaration.

## Namespaces

```hylang
namespace MyApp {
}
```

Namespaces group related classes together. The current parser uses block-style namespace declarations.

## Classes

```hylang
class Calculator {
    private int value;

    public Calculator(int initial) {
        this.value = initial;
    }

    public int Add(int n) {
        return this.value + n;
    }
}
```

Classes may contain:

- Fields (instance and static)
- Constructors
- Methods (instance and static)

Hylang also supports basic single inheritance:

```hylang
class CalculatorBase {
    protected int value;
}

class AdvancedCalculator : CalculatorBase {
    public AdvancedCalculator(int initial) {
        value = initial;
    }
}
```

Current inheritance support is intentionally narrow:

- One base class only
- No `base(...)` constructor chaining syntax yet
- No `base.Member`
- No `virtual` / `override`

## Entry point

```hylang
namespace MyApp {
    class Program {
        public static void Main(string[] args) {
            System.Console.WriteLine("Hello, Hylang!");
        }
    }
}
```

## Multi-file projects

Larger programs are organized as `.hyproj` projects. A project file lists the source files to compile together, allowing classes to reference each other across files.
