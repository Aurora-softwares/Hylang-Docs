---
title: Australis applications
description: Build a checked AUEX .exec program from a Hylang project.
---

The current **development compiler checkout** can build Hylang `exec` projects
for Australis OS. This workflow is newer than the published Hydrogen
`alpha-0.0.2` release. Australis loads the resulting `.exec` file through its
checked AUEX v1 interpreter; it is not a Linux ELF or native ring-3 process.
Australis also has a separate, bounded AUN1 ring-3 loader, but Hydrogen does
not yet compile Hylang source into AUN1.

## Create and build a project

```bash
hy new exec Example
```

The format-2 manifest contains `type = "exec"`, source paths, and a plain
`.exec` output filename:

```toml
format = 2
name = "Example"
version = "0.1.0"
type = "exec"
output = "example.exec"
sources = ["Program.hy"]
project_references = []
```

An AUEX v1 entry point is `public static void Main(string[] args)` or
`public static int Main(string[] args)`. Shell arguments populate `args`.
For example:

```csharp
public class Program {
    public static int Main(string[] args) {
        int total = 0;
        for (int i = 1; i <= 5; i = i + 1) {
            total = total + i;
        }
        System.Console.WriteLine(total);
        return total;
    }
}
```

```bash
hy build Example/Example.hyproj -o example.exec
```

The source subset supports scoped scalar and string locals, assignment,
arithmetic, comparisons, short-circuit Boolean operators, `if`/`else`, `while`,
`for`, `break`, `continue`, scalar console output, and computed exit codes.
Portable source can use `System.Console.ReadLine()`,
`System.IO.File.Exists(path)`, `System.IO.File.ReadAllText(path)`,
`System.IO.File.WriteAllText(path, text)`, and
`System.Convert.ToInt32(text)`.
Returned strings remain valid across later reads; console lines and text files
are currently limited to 255 bytes. The `System.Australis.*` builtins provide
additional metadata, directory, writable-file, cooperative-yield, and low-level
operations. The current development backend also supports application method
calls, bounded strings and byte arrays, and concurrent AUEX child processes.
Native thread preemption and a general managed native Australis runtime remain
future work.

```csharp
public class Program {
    public static void Main(string[] args) {
        System.Console.Write("Name: ");
        string name = System.Console.ReadLine();
        string message = System.IO.File.ReadAllText("/hello.txt");
        System.IO.File.WriteAllText("/data/last-name.txt", name);
        System.Console.WriteLine(name);
        System.Console.Write(message);
    }
}
```

## Add it to an Australis image

The OS repository's `applications/Applications.hyproj` aggregates bundled
`exec` projects. Add your project's relative path to its `project_references`,
then build and run the image from `Australis-OS`:

```bash
make iso
make run-serial
```

At the shell, run the output name from the read-only system bin directory:

```text
australis> run /System/Bin/example.exec
australis> ps
```

For a separate aggregate manifest, set
`APPLICATIONS_PROJECT=/path/to/MyApplications.hyproj` on `make iso`. To include
an already built `.exec`, set
`APPLICATION_ARTIFACTS="/path/to/example.exec"`. The OS repository's
The [Australis application platform guide](https://aurora-softwares.github.io/Australis-Docs/applications/platform/) documents the full AUEX call set and packaging rules.
