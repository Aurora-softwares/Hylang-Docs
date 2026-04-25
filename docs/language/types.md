# Types

## Primitive types

| Type     | Description                                        |
|----------|----------------------------------------------------|
| `int`    | 64-bit signed integer                              |
| `bool`   | Boolean (`true` / `false`)                         |
| `string` | Managed immutable UTF-8 byte string                |
| `null`   | The null literal; assignable to any reference type |

## Arrays

Any non-`void` element type can form an array: `T[]`.

Arrays are created with `new T[count]` and have a `.Length` property.

```hylang
int[] values = new int[4];
string[] names = new string[2];
int len = values.Length;
values[0] = 42;
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

String indexing is byte-based in the current bootstrap:

```hylang
string ch = someString[0];   // single-character string
```

## void

`void` is the return type for methods that do not return a value.

## User-defined types

Hylang currently supports:

- classes
- structs
- interfaces
- enums
- generic classes, interfaces, and methods

Class and interface values are reference types, so `null` is valid and derived classes can be used anywhere a base class is expected:

```hylang
Animal value = new Dog();
Animal maybe = null;
```

Structs use bootstrap by-value semantics:

```hylang
Point p = new Point(2, 3);
Point copy = p;
```

`var` is also supported for local variables when an initializer is present:

```hylang
var box = new Box<int>(42);
```
