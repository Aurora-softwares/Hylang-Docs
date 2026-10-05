---
title: Methods and objects
description: Use classes, fields, constructors, instance methods, and recursion.
---

Methods belong to classes. The released compiler supports static methods, instance
methods, constructors, instance fields, parameters, return values, and recursion.

```csharp
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

`new Counter(10)` allocates a managed reference object and invokes its constructor.
Field initializers run before the constructor body. A class without a declared
constructor has a parameterless default constructor. Fields start at zero, `false`,
or `null` when not initialized.

Class assignment copies a reference, not an object. `this` refers to the current
instance. Static methods have no `this`; pass an object explicitly to access its
instance members.

The current release does not support overloads, inheritance, interfaces, structs,
generic methods, or static fields.
