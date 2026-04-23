# Access Modifiers

Hylang uses four access modifiers. Their bootstrap semantics are intentionally conservative until inheritance is fully implemented.

| Modifier | Visibility |
|----------|------------|
| `public` | Visible everywhere |
| `private` | Restricted to the declaring class |
| `internal` | Visible within the current compilation |
| `protected` | Same-class only (until inheritance is added) |

## Example

```hylang
class Account {
    private int balance;          // only this class
    internal string owner;        // visible in the same compilation
    public bool isActive;         // visible everywhere

    public Account(string name, int initial) {
        this.owner = name;
        this.balance = initial;
        this.isActive = true;
    }

    public int GetBalance() {
        return this.balance;
    }

    private void Audit() {
        // internal helper
    }
}
```

## Static members

Both fields and methods can be `static`. Static members belong to the class rather than an instance:

```hylang
class MathHelper {
    public static int Square(int n) {
        return n * n;
    }
}

// Called without creating an object:
int result = MathHelper.Square(5);
```
