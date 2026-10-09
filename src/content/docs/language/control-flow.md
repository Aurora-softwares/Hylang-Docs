---
title: Control flow
description: Branch, loop, continue, break, and return from Hydrogen methods.
---

The released compiler supports `if`, `while`, `for`, `break`, `continue`, and
`return`.

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

Use `for` when initialization, condition, and update belong together:

```csharp
for (int index = 0; index < 10; index = index + 1) {
    System.Console.WriteLine(index);
}
```

`return;` exits a `void` method. `return expression;` supplies a value from a
non-void method. Exceptions are not part of the current release; use a status
value or explicit condition for recoverable errors.
