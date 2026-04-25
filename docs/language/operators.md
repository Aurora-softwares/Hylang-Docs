# Operators

## Arithmetic

| Operator | Description | Example |
|----------|-------------|---------|
| `+` | Addition (also string concatenation) | `a + b` |
| `-` | Subtraction | `a - b` |
| `*` | Multiplication | `a * b` |
| `/` | Division | `a / b` |
| `%` | Modulo (remainder) | `a % b` |

```hylang
int x = 10 % 3;   // 1
int y = 2 * 5;     // 10
```

> Note: compound assignment operators (`+=`, `-=`, `*=`, etc.) are not yet supported. Use `i = i + 1` instead of `i += 1`.

## Comparison

| Operator | Description |
|----------|-------------|
| `==` | Equal |
| `!=` | Not equal |
| `<` | Less than |
| `<=` | Less than or equal |
| `>` | Greater than |
| `>=` | Greater than or equal |

These work on `int` values and produce a `bool`. Enum values also support `==` and `!=` between members of the same enum type.

## Logical

| Operator | Description |
|----------|-------------|
| `&&` | Logical AND |
| `\|\|` | Logical OR |
| `!` | Logical NOT (unary) |

```hylang
bool inRange = x > 0 && x < 100;
bool either = a || b;
bool flipped = !active;
```

## Unary negation

```hylang
int neg = -x;
```

## String concatenation

`+` concatenates strings with `int` or `bool` operands automatically:

```hylang
string msg = "Count: " + 42 + ", active: " + true;
```
