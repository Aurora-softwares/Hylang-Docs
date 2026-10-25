---
title: Types and strings
description: Core values, strings, arrays, null, and local type inference.
---

| Type | Meaning |
| --- | --- |
| `sbyte`, `byte` | Signed and unsigned 8-bit integers |
| `short`, `ushort` | Signed and unsigned 16-bit integers |
| `int`, `uint` | Signed and unsigned 32-bit integers |
| `long`, `ulong` | Signed and unsigned 64-bit integers |
| `nint`, `nuint` | Signed and unsigned native-size integers (64-bit on the current target) |
| `byte` | Unsigned byte, useful for file contents |
| `bool` | `true` or `false` |
| `string` | Immutable managed byte string |
| `void` | A method returns no value |
| `T[]` | Mutable managed array |

Class instances are reference values; structs have value semantics. `null` is
assignable to strings, classes, and arrays. Accessing a null receiver is a runtime
error. Enums provide named numeric constants. Floating-point values are not in
this release.

## Strings

```csharp
string message = "Count: " + 42 + ", active: " + true;
int size = message.Length;
string firstByte = message[0];
bool same = "hello" == "hel" + "lo";
```

`+` concatenates strings with strings, integers, and booleans. Equality compares
contents. Length and indexing work on bytes, not Unicode code points. Native
source literals support ASCII plus `\n`, `\r`, `\t`, `\\`, and `\"` escapes.

## Local inference

```csharp
var count = 42;
var text = "hello";
```

`var` is local type inference, not a dynamic type. It needs an initializer and is
not valid for parameters, fields, or method returns. The released compiler supports
classes, structs, enums, interfaces, and inheritance, but not generics.
