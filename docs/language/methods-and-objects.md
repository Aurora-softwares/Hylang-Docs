# Methods and objects

Methods belong to classes. The released compiler supports static methods, instance methods, constructors, instance fields, parameters, return values, and recursion.

## Complete example

```hylang
namespace Counters {
    public class Counter {
        private int value;

        public Counter(int initial) { value = initial; }

        public int Add(int amount) {
            value = value + amount;
            return value;
        }
    }

    public class Program {
        public static int Double(int value) { return value * 2; }

        public static int Main() {
            Counter counter = new Counter(10);
            System.Console.WriteLine(counter.Add(Double(3)));
            return 0;
        }
    }
}
```

Save as `counter.hy`, compile using the [native compilation guide](../getting-started/compiling.md), and run. It prints `16`.

## Fields and constructors

`new Counter(10)` allocates a managed reference object and invokes its constructor. Field initializers run before the constructor body. A class with no declared constructor has a parameterless default constructor. Fields otherwise start with their default values: zero, false, or null.

Class assignment copies a reference. Two variables referring to the same instance see the same field changes. Private fields can be accessed from the declaring class; use methods to expose controlled operations.

`this` refers to the current instance. `this.value` disambiguates a field when a parameter/local has the same name. Static methods have no `this`; pass an object explicitly to access its instance members.

## Calls and returns

Call a static method through its class, such as `Program.Double(3)`, or directly from another method in that class. Call an instance method through a value, such as `counter.Add(6)`.

Parameters are local mutable variables initialized from arguments. Class and array parameters retain reference identity. `return expression;` supplies a value; `return;` exits a `void` method. Non-void methods should return on all paths; the native checker uses conservative return-path analysis.

Native arguments are evaluated left to right. Native calls use an internal stack convention and do not expose C ABI interoperability.

## Recursion

```hylang
public class Factorials {
    public static int Calculate(int n) {
        if (n <= 1) { return 1; }
        return n * Calculate(n - 1);
    }
}
```

Each invocation has its own parameters and local frame. Direct and mutual recursion are supported. Recursive calls consume stack space.

The current release does not support overloads, inheritance, interfaces, structs,
generic methods, or static fields.
