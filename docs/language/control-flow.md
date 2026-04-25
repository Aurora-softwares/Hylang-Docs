# Control Flow

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

## for

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
