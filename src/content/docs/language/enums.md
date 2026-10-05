---
title: Enums
description: Define named numeric constants.
---

Enums are declared alongside classes at namespace scope:

```csharp
namespace Demo {
    public enum Direction { North, South, East, West }

    public class Program {
        public static int Main() {
            Direction direction = Direction.North;
            if (direction == Direction.North) {
                System.Console.WriteLine("Heading north");
            }
            return 0;
        }
    }
}
```

Members without an explicit value begin at zero and increase by one. Enums can be
fields, locals, parameters, return values, and array elements. Compare members of
the same enum with `==` or `!=`. Console output formats an enum numerically, so
select a string explicitly when human-readable output matters.
