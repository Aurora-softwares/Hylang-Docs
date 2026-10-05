# Inheritance and dispatch

Inheritance, base-constructor chaining, and virtual dispatch require the C++ SDK. The native Hydrogen compiler does not emit these features.

## Complete example

```hylang
namespace Demo {
    public class Reader {
        protected int value;
        public Reader(int initial) { value = initial; }
        public virtual int Read() { return value; }
    }

    public class BetterReader : Reader {
        public BetterReader(int initial) : base(initial) { }
        public override int Read() { return base.Read() + 1; }
    }

    public class Program {
        public static int Main() {
            Reader reader = new BetterReader(41);
            System.Console.WriteLine(reader.Read());
            return 0;
        }
    }
}
```

Run with `hy run`, or compile with `hy build`. It prints `42`: a base-typed reference invokes the derived override.

## Base classes and constructors

Declare one base class with `class Derived : Base`. A class may also implement multiple interfaces. Constructors are not inherited. `: base(args)` selects a base constructor; without an explicit initializer, the SDK chains to a parameterless base constructor.

Inherited accessible instance/static members can be used by a derived class. Private members remain restricted to their declaring class; protected members are accessible in subclasses. A derived reference is assignable to its base type, including when passed or returned by methods.

## Virtual methods

Mark a non-static instance method `virtual` to enable replacement. A matching derived method must use `override`; invalid overrides produce diagnostics. `base.Member` is available inside instance methods/constructors and binds directly to the base implementation, bypassing virtual dispatch.

The SDK does not implement multiple base classes, `abstract`, `sealed`, or a member-hiding keyword. Interfaces contain method signatures only; see [interfaces and structs](interfaces-and-structs.md).
