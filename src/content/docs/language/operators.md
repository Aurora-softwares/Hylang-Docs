---
title: Operators
description: Arithmetic, comparison, logical, unary, and string operators.
---

| Operator | Meaning |
| --- | --- |
| `+`, `-`, `*`, `/`, `%` | Arithmetic; `+` also concatenates strings |
| `==`, `!=`, `<`, `<=`, `>`, `>=` | Comparison |
| `&&`, `\|\|`, `!` | Logical AND, OR, and NOT |
| `-value` | Unary numeric negation |

```csharp
int remainder = 10 % 3;
bool inRange = remainder > 0 && remainder < 100;
string message = "Count: " + remainder;
```

`&&` and `||` short-circuit: the right-hand side is evaluated only when needed.
Compound assignment such as `+=` is not currently supported; write `i = i + 1`
instead.
