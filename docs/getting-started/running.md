# Write and run a program

Save this complete program as `hello.hy`:

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

## Compile and run native output

```bash
"$HYDROGEN" compile hello.hy -o hello
chmod +x hello
./hello Hydrogen
```

For repeat runs, execute `./hello` directly. The release compiler does not have an interpreted `run` command.

UEFI output is different: an EFI application is booted by firmware, not run from Linux. See [Make a bootable UEFI Hello World](uefi-hello.md) for that workflow and its current restricted source shape.

## Entry point and arguments

`Main` must be a static class method returning `int` or `void`. It accepts no parameters or one `string[]` parameter. User arguments exclude the executable name. A returned integer becomes the process exit status; use `0` for success.

Array access is checked, so test `args.Length` before indexing. The released compiler produces a native executable; there is no interpreted `run` command in the release.

See [compilation](compiling.md) for projects, output paths, and diagnostics.
