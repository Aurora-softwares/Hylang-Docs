# Arrays and Collections

The released compiler supports arrays of its supported element types. The following allocation and indexing snippets belong inside a method.

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

## Arrays of objects

Arrays may store:

- primitives like `int` and `bool`
- strings
- classes

Example:

```hylang
// Inside a method, with a declared Pair(int, string) constructor:
Pair[] pairs = new Pair[2];
pairs[0] = new Pair(9, "pair");
```

The current release has no built-in `List<T>`, map, set, or generic collection
type. Use arrays and explicit counters until the standard library grows those
facilities.
