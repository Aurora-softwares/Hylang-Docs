# Access modifiers

The released compiler supports `public` and `private` members. Use `public` for
types and members that code in another class must use, and `private` for details
that belong only to the declaring class.

| Modifier | Visibility |
| --- | --- |
| `public` | Visible everywhere in the compilation |
| `private` | Restricted to the declaring class |

## Example

```hylang
public class Account {
    private int balance;
    public bool isActive;

    public Account(int initial) {
        this.balance = initial;
        this.isActive = true;
    }

    public int GetBalance() {
        return this.balance;
    }

    private void Audit() {
        // Internal implementation detail.
    }
}
```

`protected` is not useful in the current release because inheritance is not yet
supported. Static methods are supported; static fields are not.
