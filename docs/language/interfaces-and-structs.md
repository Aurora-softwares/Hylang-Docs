# Interfaces and structs

Interfaces, struct value semantics, and interface boxing require the C++ SDK. They are not implemented by the direct native Hydrogen backend.

## Complete example

```hylang
public interface ISpanView {
    int Start();
    int Length();
}

public struct TextSpan : ISpanView {
    private int start;
    private int length;
    public TextSpan(int s, int l) { start = s; length = l; }
    public int Start() { return start; }
    public int Length() { return length; }
}

public class Program {
    public static int Main() {
        TextSpan span = new TextSpan(2, 3);
        ISpanView view = span;
        System.Console.WriteLine(view.Start());
        System.Console.WriteLine(view.Length());
        return 0;
    }
}
```

Run with `hy run`, or compile with `hy build`. It prints `2`, then `3`.

## Interfaces

Interfaces are declared at namespace scope. Their members are public instance method signatures. Interfaces may inherit multiple interfaces; classes and structs may implement interfaces and must satisfy inherited signatures.

Fields, constructors, static members, properties, and default implementations are not supported in interfaces.

## Struct values

Structs may contain fields, constructors, and static/instance methods. Structs do not inherit classes, and generic structs are not implemented.

Struct locals/fields default to zero-initialized values. Assignment, parameter passing, and returns copy the value. An instance method on a mutable struct lvalue works on that storage; a method on a temporary works on a temporary copy.

Converting a struct to an interface boxes a copy. Calls through that interface act on the boxed copy, not the original struct variable. Boxing to `object` is not implemented.
