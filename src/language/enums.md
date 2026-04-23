# Enums

Enums define a named set of constant values. They are declared at the namespace level alongside classes.

## Declaration

```hylang
namespace Demo;

public enum Direction {
    North,
    South,
    East,
    West
}
```

## Using enum values

Reference members through the enum type name:

```hylang
Direction d = Direction.North;
```

## Enums as field, parameter, and return types

```hylang
public class Navigator {
    public static Direction Last;

    public static Direction Echo(Direction value) {
        Last = value;
        return Last;
    }
}
```

## Equality

Enum values support `==` and `!=`. Both operands must be the same enum type:

```hylang
if (d == Direction.North) {
    System.Console.WriteLine("Heading north");
}
```

## Printing

Enum values can be passed directly to `Console.Write` and `Console.WriteLine`, which will print the member name:

```hylang
System.Console.WriteLine(Direction.North);   // prints: North
```

## Using directives

With `using System;` at the top of the file, you can shorten `System.Console` to just `Console`:

```hylang
using System;

namespace Demo;

public enum Mode { Scan, Dump }

public class Program {
    public static void Main(string[] args) {
        Mode m = Mode.Scan;
        Console.Write(m);          // prints: Scan
        Console.WriteLine(m == Mode.Scan);  // prints: True
    }
}
```
