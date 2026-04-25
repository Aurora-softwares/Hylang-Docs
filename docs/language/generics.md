# Generics

Hylang supports invariant generics on classes, interfaces, and methods.

## Generic classes

```hylang
public class Box<T> {
    private T value;

    public Box(T input) {
        value = input;
    }

    public T Value() {
        return value;
    }
}
```

## Generic interfaces

```hylang
public interface IVisitor<T> {
    T Visit(Node node);
}
```

## Generic methods

```hylang
public static T Identity<T>(T value) {
    return value;
}
```

Method type inference currently uses call arguments only:

```hylang
string text = Identity("hello");
```

## Current limits

- generics are invariant
- no constraints
- no variance
- no default type arguments
- no generic structs yet
