---
title: Write and run a program
description: Compile and execute a first Hydrogen application.
---

Save this program as `hello.hy`:

```csharp
public class Program {
    public static int Main(string[] args) {
        string name = "World";
        if (args.Length > 0) { name = args[0]; }
        System.Console.WriteLine("Hello, " + name);
        return 0;
    }
}
```

```bash
hy compile hello.hy -o hello
chmod +x hello
./hello Hydrogen
```

For repeat runs, execute `./hello` directly. The release compiler produces native
executables; it does not have an interpreted `run` command.

## Entry point and arguments

`Main` must be a static class method returning `int` or `void`. It accepts no
parameters or one `string[]` parameter. Arguments exclude the executable name;
an integer result becomes the process exit status.

Array access is checked, so test `args.Length` before indexing. UEFI output is
different: an EFI application is booted by firmware, not run from Linux.
