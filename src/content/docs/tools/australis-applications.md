---
title: Australis applications
description: Build a checked AUEX .exec program from a Hylang project.
---

The current **development compiler checkout** can build Hylang `exec` projects
for Australis OS. This workflow is newer than the published Hydrogen
`alpha-0.0.2` release. Australis loads the resulting `.exec` file through its
checked AUEX v1 interpreter; it is not a Linux ELF or native ring-3 process.

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
`public static int Main(string[] args)`. The current backend does not populate
`args`, so do not depend on command-line arguments yet. For example:

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

The source subset supports scoped integer and Boolean locals, assignment,
arithmetic, comparisons, short-circuit Boolean operators, `if`/`else`, `while`,
`for`, `break`, `continue`, scalar console output, and computed exit codes.
Australis builtins provide literal terminal output, bounded terminal input,
read-only file open/read/close, and cooperative yield. Read capacities must be
literals; file paths and string output must be ASCII literals. General strings,
arrays, method calls, writable files, and process creation are not yet in this
backend.

## Add it to an Australis image

The OS repository's `applications/Applications.hyproj` aggregates bundled
`exec` projects. Add your project's relative path to its `project_references`,
then build and run the image from `Australis-OS`:

```bash
make iso
make run-serial
```

At the shell, run the output name from the root filesystem:

```text
australis> run /example.exec
australis> ps
```

For a separate aggregate manifest, set
`APPLICATIONS_PROJECT=/path/to/MyApplications.hyproj` on `make iso`. To include
an already built `.exec`, set
`APPLICATION_ARTIFACTS="/path/to/example.exec"`. The OS repository's
`applications/README.md` documents the full AUEX call set and packaging rules.
