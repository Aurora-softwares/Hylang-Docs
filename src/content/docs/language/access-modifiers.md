---
title: Access modifiers
description: Control visibility with public and private members.
---

The released compiler supports `public`, `private`, and `protected` members.

| Modifier | Visibility |
| --- | --- |
| `public` | Visible everywhere in the compilation |
| `private` | Restricted to the declaring class |
| `protected` | Available to the declaring class and derived classes |

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

Classes may inherit from a base class. Static methods and fields belong to the
class rather than an instance.
