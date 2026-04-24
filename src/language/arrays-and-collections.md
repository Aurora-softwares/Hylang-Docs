# Arrays and Collections

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
Pair[] pairs = new Pair[2];
pairs[0] = new Pair(9, "pair");
```

## Bootstrap `System.Collections.List<T>`

Phase 3 includes a minimal bootstrap `List<T>` in `System.Collections`.

Supported API:

- `public List()`
- `public void Add(T value)`
- `public T Get(int index)`
- `public void Set(int index, T value)`
- `public int Count()`

Example:

```hylang
using System.Collections;

List<int> values = new List<int>();
values.Add(10);
values.Add(20);
System.Console.WriteLine(values.Count());
System.Console.WriteLine(values.Get(0));
```

This is intentionally small. Richer collection types belong to later standard-library phases.
