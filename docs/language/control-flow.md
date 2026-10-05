# Control Flow

The released compiler supports `if`, `while`, `break`, `continue`, and `return`. These snippets belong inside methods. It does not support `for`; use a `while` loop with an explicit increment.

## if / else

```hylang
if (x > 0) {
    System.Console.WriteLine("positive");
} else {
    System.Console.WriteLine("non-positive");
}
```

## while

```hylang
int i = 0;
while (i < 10) {
    i = i + 1;
}
```

## break / continue

`break` exits the innermost loop; `continue` moves to the next iteration:

```hylang
int i = 0;
while (i < 100) {
    if (i == 50) {
        break;
    }
    if (i == 25) {
        continue;
    }
    System.Console.WriteLine(i);
    i = i + 1;
}
```

## return

`return` exits the current method, optionally with a value:

```hylang
public int Max(int a, int b) {
    if (a > b) {
        return a;
    }
    return b;
}
```

Exceptions are not part of the current release. Return a status value or use an
explicit conditional path for recoverable errors.
