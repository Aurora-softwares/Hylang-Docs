---
title: Access modifiers
description: Control visibility with public and private members.
---

The released compiler supports `public` and `private` members.

| Modifier | Visibility |
| --- | --- |
| `public` | Visible everywhere in the compilation |
| `private` | Restricted to the declaring class |

```csharp
public class Account {
    private int balance;
    public bool isActive;

    public Account(int initial) {
        this.balance = initial;
        this.isActive = true;
    }

    public int GetBalance() { return this.balance; }
}
```

`protected` is not useful in the current release because inheritance is not yet
supported. Static methods are supported; static fields are not.
