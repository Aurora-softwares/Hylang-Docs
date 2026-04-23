# Types

## Primitive types

| Type | Description |
|------|-------------|
| `int` | 64-bit signed integer |
| `bool` | Boolean (`true` / `false`) |
| `string` | Managed UTF-8 string |

## Arrays

`string[]` is the only array type in the current bootstrap. Arrays have a `.Length` property.

```hylang
string[] args;
int len = args.Length;
string first = args[0];
```

## String operations

Strings support concatenation with `+` across `string`, `int`, and `bool` operands:

```hylang
string msg = "Count: " + 42;
string flag = "Enabled: " + true;
```

String length:

```hylang
int n = someString.Length;
```

String indexing:

```hylang
string ch = someString[0];   // single-character string
```

## void

`void` is the return type for methods that do not return a value.

## User-defined types

Classes are the only user-defined type in the current bootstrap. Enums, structs, interfaces, and generics are planned for later phases.
