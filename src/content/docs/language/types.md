---
title: Types and strings
description: Core values, strings, arrays, null, and local type inference.
---

| Type | Meaning |
| --- | --- |
| `int` | Signed 64-bit integer |
| `byte` | Unsigned byte, useful for file contents |
| `bool` | `true` or `false` |
| `string` | Immutable managed byte string |
| `void` | A method returns no value |
| `T[]` | Mutable managed array |

Class instances are reference values. `null` is assignable to strings, classes,
and arrays. Accessing a null receiver is a runtime error. Enums provide named
numeric constants. The current release has no floating-point values or wider
integer types.

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
classes and enums, not structs, interfaces, inheritance, or generics.
