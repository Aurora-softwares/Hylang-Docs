# Generics

Generic classes, interfaces, and methods require the C++ SDK. The native Hydrogen compiler does not support generic declarations or specialization.

## Complete example

```hylang
public class Box<T> {
    private T value;
    public Box(T input) { value = input; }
    public T Value() { return value; }
}

public class Program {
    public static T Identity<T>(T value) { return value; }

    public static int Main() {
        Box<string> box = new Box<string>("boxed");
        System.Console.WriteLine(box.Value());
        System.Console.WriteLine(Identity("hello"));
        return 0;
    }
}
```

Save as `generics.hy` and run with `./build/hy run generics.hy`, or compile with `./build/hy build generics.hy -o build/generics`. It prints `boxed`, then `hello`.

Type parameters such as `T` are substituted with concrete types for each closed use. Generic methods belong inside a class. The SDK infers method type arguments from call arguments, as with `Identity("hello")`; it does not infer them from the expected return type.

## Generic interfaces

At namespace scope:

```hylang
public interface IProvider<T> {
    T Get();
}
```

A class can implement a closed interface such as `IProvider<int>` by providing its required method. Classes and interfaces are invariant: an instance using one type argument is not automatically interchangeable with an instance using a related type argument.

## Restrictions

Constraints, variance annotations, default type arguments, and generic structs are not implemented. Ambiguous inference or invalid type-argument counts produce diagnostics.

The SDK interpreter supports numeric generic instantiations, but C emission still erases some generic signatures to `void*`. For example, `Box<int>` constructor arguments can fail host C compilation with an integer/pointer mismatch. Use the tested reference-valued example above for C-backed output; generic support in binding does not guarantee every representation is emitted correctly.
