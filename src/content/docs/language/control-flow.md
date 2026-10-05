---
title: Control flow
description: Branch, loop, continue, break, and return from Hydrogen methods.
---

The released compiler supports `if`, `while`, `break`, `continue`, and `return`.
It does not support `for`; use a `while` loop with an explicit increment.

```csharp
int i = 0;
while (i < 100) {
    if (i == 50) {
        break;
    }
    if (i == 25) {
        i = i + 1;
        continue;
    }
    System.Console.WriteLine(i);
    i = i + 1;
}
```

`return;` exits a `void` method. `return expression;` supplies a value from a
non-void method. Exceptions are not part of the current release; use a status
value or explicit condition for recoverable errors.
