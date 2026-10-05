# Types and strings

## Core types

| Type | Meaning |
| --- | --- |
| `int` | Signed 64-bit integer; this differs from C#'s 32-bit `int` |
| `byte` | Unsigned byte, useful for file contents |
| `bool` | `true` or `false` |
| `string` | Immutable managed byte string |
| `void` | A method returns no value |
| `T[]` | Mutable managed array |

Class instances are reference values. `null` is assignable to reference types, including strings, class references, and arrays. Accessing a null receiver is a runtime error. Enums provide named numeric constants.

The current release does not provide floating-point values or wider integer types.
Use the types in this table for executable native code. See [the released
compiler guide](../getting-started/compiler-options.md).

## Strings

Inside a method:

```hylang
string message = "Count: " + 42 + ", active: " + true;
int size = message.Length;
string firstByte = message[0];
bool same = "hello" == "hel" + "lo";
```

`+` concatenates strings with strings, integers, and booleans. Equality compares string contents. Length and indexing operate on bytes, not Unicode code points; an indexed value is a one-byte string. Strings are immutable, so assigning to a string index is invalid.

Native source literals accept ASCII and escapes `\n`, `\r`, `\t`, `\\`, and `\"`. Non-ASCII literals are rejected by native emission. File contents and command-line arguments preserve raw bytes, which can contain UTF-8; byte indexing may split an encoded character.

## Local inference

```hylang
var count = 42;
var text = "hello";
```

`var` is local type inference, not a dynamic type. It requires an initializer with a usable type; do not use it for parameters, fields, or method returns.

## User-defined types

The released compiler supports classes and enums. It does not yet support
structs, interfaces, inheritance, or generics. Class assignment copies
references.

Native numeric casts support integers, bytes, and enums. An explicit cast does not make unsupported object layouts or numeric signatures executable.
