# Control Flow

Both routes support `if`, `while`, `break`, `continue`, and `return`. These snippets belong inside methods. The native parser does not support `for`; use a `while` loop with an explicit increment.

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

## for (SDK only)

```hylang
for (int i = 0; i < 10; i = i + 1) {
    System.Console.WriteLine("i = " + i);
}
```

## break / continue

`break` exits the innermost loop; `continue` moves to the next iteration:

```hylang
for (int i = 0; i < 100; i = i + 1) {
    if (i == 50) {
        break;
    }
    if (i == 25) {
        continue;
    }
    System.Console.WriteLine(i);
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

## String exceptions (SDK only)

The SDK supports string `throw` and `try`/`catch`; typed catch variables must be `string`. Native code generation rejects exceptions. There is no exception-class hierarchy or `finally` construct.

```hylang
try {
    throw "invalid input";
} catch (string message) {
    System.Console.WriteLine(message);
}
```
