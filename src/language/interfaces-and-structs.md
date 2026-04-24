# Interfaces and Structs

## Interfaces

Interfaces are namespace-scope types that declare public instance method signatures.

```hylang
public interface IReadable {
    int Read();
}
```

Current Phase 2/3 rules:

- interface members are method signatures only
- interfaces may inherit from other interfaces
- classes may implement multiple interfaces
- structs may implement interfaces
- no fields, constructors, statics, or default implementations yet

## Structs

Structs are namespace-scope value types in the current bootstrap.

```hylang
public struct TextSpan {
    private int start;
    private int length;

    public TextSpan(int s, int l) {
        start = s;
        length = l;
    }
}
```

Structs may contain:

- fields
- constructors
- instance methods
- static methods

Current semantics:

- struct locals and fields are zero-initialized by default
- assignment copies the value
- parameters and returns use copy semantics
- structs may implement interfaces
- converting a struct to an interface boxes a copy

## Example

```hylang
public interface ISpanView {
    int Start();
    int Length();
}

public struct TextSpan : ISpanView {
    private int start;
    private int length;

    public TextSpan(int s, int l) {
        start = s;
        length = l;
    }

    public int Start() {
        return start;
    }

    public int Length() {
        return length;
    }
}
```
