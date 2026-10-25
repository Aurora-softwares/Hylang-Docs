---
title: Arrays and collections
description: Allocate, index, and share managed arrays.
---

The released compiler supports managed arrays of its supported element types.

```csharp
int[] values = new int[5];
string[] names = new string[3];

values[0] = 42;
int first = values[0];
int length = values.Length;
```

Array counts must be `int`; `void[]` is invalid. Elements are zero/default
initialized. Arrays are mutable reference types, so assignment and passing to a
method retain the same underlying array. Out-of-range access is a runtime error.

Arrays may contain primitive values, strings, enums, structs, and class references:

```csharp
Pair[] pairs = new Pair[2];
pairs[0] = new Pair(9, "pair");
```

The current release has no built-in `List<T>`, map, set, or generic collection.
Use arrays and explicit counters until the standard library provides them.
