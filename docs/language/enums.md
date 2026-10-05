# Enums

Enums define named numeric constants and are declared alongside classes at namespace scope.

```hylang
namespace Demo {
    public enum Direction { North, South, East, West }

    public class Program {
        public static Direction Echo(Direction value) { return value; }

        public static int Main() {
            Direction direction = Echo(Direction.North);
            if (direction == Direction.North) {
                System.Console.WriteLine("Heading north");
            }
            return 0;
        }
    }
}
```

This complete program prints `Heading north`. Members without explicit values start at zero and increase by one. Enums can be field, local, parameter, return, and array element types. Compare members of the same enum with `==` or `!=`.

## Formatting

The console formats an enum value numerically. Select a string explicitly, as in
the example above, when human-readable output matters.
