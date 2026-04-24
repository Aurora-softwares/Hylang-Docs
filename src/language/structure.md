# Program Structure

A Hylang program is organized into namespaces and types. Executable entry points are class-based `Main` methods.

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

Namespaces group related classes, structs, interfaces, and enums together. The current parser uses block-style namespace declarations.

## Classes, structs, interfaces, and enums

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

Structs may also declare fields, constructors, and methods:

```hylang
public struct Point {
    private int x;
    private int y;

    public Point(int px, int py) {
        x = px;
        y = py;
    }
}
```

Interfaces declare public instance method signatures:

```hylang
public interface IPrintable {
    string Text();
}
```

Enums are namespace-scope named constants:

```hylang
public enum Color {
    Red,
    Green,
    Blue
}
```

Hylang supports single inheritance plus interfaces:

```hylang
class CalculatorBase {
    protected int value;
}

interface IReadable {
    int Read();
}

class AdvancedCalculator : CalculatorBase, IReadable {
    public AdvancedCalculator(int initial) : base() {
        value = initial;
    }

    public int Read() {
        return value;
    }
}
```

- One base class only
- Multiple interfaces are allowed
- `base(...)`, `base.Member`, `virtual`, and `override` are supported
- `abstract`, `sealed`, and member-hiding keywords are still deferred

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

The bootstrap currently accepts:

- `public static void Main()`
- `public static void Main(string[] args)`
- `public static int Main()`
- `public static int Main(string[] args)`

## Multi-file projects

Larger programs are organized as `.hyproj` projects. A project file lists the source files to compile together, allowing classes to reference each other across files.
