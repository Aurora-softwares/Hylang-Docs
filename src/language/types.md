# Types

## Primitive types

| Type     | Description                                        |
|----------|----------------------------------------------------|
| `int`    | 64-bit signed integer                              |
| `bool`   | Boolean (`true` / `false`)                         |
| `string` | Managed UTF-8 string                               |
| `null`   | The null literal; assignable to any reference type |

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

Classes and enums are the currently supported user-defined types. Structs, interfaces, and generics are planned for later phases.

Class values are reference types, so `null` is valid and derived classes can be used anywhere a base class is expected:

```hylang
Animal value = new Dog();
Animal maybe = null;
```
