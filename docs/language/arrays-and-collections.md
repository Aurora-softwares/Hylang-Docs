# Arrays and Collections

Both routes support arrays of their supported element types. Struct arrays require the SDK. The following allocation and indexing snippets belong inside a method.

## Managed arrays

Hylang supports general managed arrays with C#-style allocation syntax:

```hylang
int[] values = new int[5];
string[] names = new string[3];
```

Rules:

- `count` must be `int`
- `void[]` is invalid
- elements are zero/default-initialized
- arrays are mutable reference types

Supported operations:

```hylang
values[0] = 42;
int first = values[0];
int len = values.Length;
```

Out-of-range access is a runtime error.

## Arrays of structs and objects

Arrays may store:

- primitives like `int` and `bool`
- strings
- classes
- structs

Example:

```hylang
// Inside a method, with a declared Pair(int, string) constructor:
Pair[] pairs = new Pair[2];
pairs[0] = new Pair(9, "pair");
```

## SDK `System.Collections.List<T>`

The SDK supplies a minimal `List<T>` in `System.Collections`. This generic collection is not supported by the native compiler.

Supported API:

- `public List()`
- `public void Add(T value)`
- `public T Get(int index)`
- `public void Set(int index, T value)`
- `public int Count()`

Example:

```hylang
using System.Collections;

public class Program {
    public static int Main() {
        List<int> values = new List<int>();
        values.Add(10);
        values.Add(20);
        System.Console.WriteLine(values.Count());
        System.Console.WriteLine(values.Get(0));
        return 0;
    }
}
```

This complete SDK program prints `2`, then `10`. Maps, sets, and richer collection APIs are not provided by this builtin.
