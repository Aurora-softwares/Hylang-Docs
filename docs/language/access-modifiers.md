# Access Modifiers

The table below describes SDK access rules. Native Hydrogen checks private members and constructors, but has no inheritance model; use public/private members for native code. Static methods are supported natively; static fields are not.

Hylang uses four access modifiers. The SDK supports normal class-local access rules plus subclass access for `protected`.

| Modifier | Visibility |
|----------|------------|
| `public` | Visible everywhere |
| `private` | Restricted to the declaring class |
| `internal` | Visible within the current compilation |
| `protected` | Visible in the declaring class and its subclasses |

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

## Inheritance note

`private` members are not visible from derived classes. `protected` members are.

```hylang
namespace Banking {
    public class Account {
        protected int balance;

        public Account() {
            balance = 10;
        }
    }

    public class SavingsAccount : Account {
        public int CurrentBalance() {
            return balance;
        }
    }
}
```

## Static members

In the SDK, both fields and methods can be `static`; native code supports static methods only. Static members belong to the class rather than an instance:

```hylang
class MathHelper {
    public static int Square(int n) {
        return n * n;
    }
}

```

Inside another method, call it without creating an object:

```hylang
int result = MathHelper.Square(5);
```
