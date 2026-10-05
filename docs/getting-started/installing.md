# Install the released compiler

Hydrogen is distributed as a self-hosted compiler binary. For normal language
and Australis development, download that release binary; you do not need the
older C++ SDK or a C++ compiler.

## Linux x86-64

Download the current Linux x86-64 asset from the
[Hydrogen compiler releases](https://github.com/Aurora-Softwares/Hylang-Compiler/releases),
extract it, and keep the executable in a stable location. The current binary is
named `hydrogen-stage1`.

```bash
chmod +x /path/to/hydrogen-stage1
export HYDROGEN=/path/to/hydrogen-stage1
```

The next section compiles a first program, which confirms that the release
compiler can run on the host.

You can make the compiler available in each shell by adding its directory to
`PATH`, or keep using the explicit `$HYDROGEN` path in scripts and Makefiles.

## First program

Create `hello.hy`:

```hylang
public class Program {
    public static int Main(string[] args) {
        System.Console.WriteLine("Hello, Hydrogen!");
        return 0;
    }
}
```

Compile and run it:

```bash
"$HYDROGEN" compile hello.hy -o hello
chmod +x hello
./hello
```

See [Write and run a program](running.md) for an explanation of the entry point
and [Compile an executable](compiling.md) for projects, diagnostics, and UEFI
output.

## Building the compiler from source

You only need this when contributing to the compiler or creating a new trusted
seed. A source-only bootstrap needs a previously verified Hydrogen compiler;
the historical C++ seed route is maintainer infrastructure, not part of using a
release. See [self-hosting architecture](../implementation/phase6-self-hosted-compiler.md).
