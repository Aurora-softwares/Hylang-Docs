# Write and run a program

Save this complete program as `hello.hy` in the compiler repository root:

```hylang
public class Program {
    public static int Main(string[] args) {
        string name = "World";
        if (args.Length > 0) { name = args[0]; }
        System.Console.WriteLine("Hello, " + name);
        return 0;
    }
}
```

## Interpret with the SDK

```bash
./build/hy run hello.hy -- Hydrogen
```

Output:

```text
Hello, Hydrogen
```

The SDK's `run` command interprets the program after parsing, binding, and type checking. It accepts a source file or executable project. `--` separates application arguments from the SDK command. The compatibility runner uses:

```bash
./build/hyrun hello.hy Hydrogen
```

## Run native output

```bash
./build/self_hosting/hydrogen-stage1 compile hello.hy -o build/hello
chmod +x build/hello
./build/hello Hydrogen
```

For repeat runs, execute `build/hello` directly. The native CLI does not have an interpreted `run` command.

## Entry point and arguments

`Main` must be a static class method returning `int` or `void`. It accepts no parameters or one `string[]` parameter. User arguments exclude the executable name. A returned integer becomes the process exit status; use `0` for success.

Array access is checked, so test `args.Length` before indexing. For programs also executed by the SDK interpreter, use explicit `if` guards: that interpreter evaluates both sides of `&&` and `||`.

See [compilation](compiling.md) for projects, output paths, and diagnostics.
