# Overloading

Hylang supports overloading for both methods and constructors. Multiple members may share the same name as long as their parameter types differ.

## Method overloading

```hylang
public class Printer {
    public static void Show(string value) {
        System.Console.WriteLine("string");
    }

    public static void Show(bool value) {
        System.Console.WriteLine("bool");
    }
}

public class Program {
    public static void Main(string[] args) {
        Printer.Show("demo");   // prints: string
        Printer.Show(true);     // prints: bool
    }
}
```

The compiler selects the overload whose parameter types match the argument types at the call site.

## Constructor overloading

```hylang
public class Box {
    private int value;

    public Box(string text) {
        value = 1;
    }

    public Box(bool enabled) {
        value = 2;
    }

    public int Value() {
        return value;
    }
}

public class Program {
    public static void Main(string[] args) {
        Box a = new Box("demo");   // calls the string constructor
        Box b = new Box(true);     // calls the bool constructor
        System.Console.WriteLine(a.Value());   // 1
        System.Console.WriteLine(b.Value());   // 2
    }
}
```

## Limitations

- Overloads must differ by parameter types, not just parameter names.
- Exact matches are preferred over derived-to-base matches.
- Implicit conversions between unrelated types are not performed.
