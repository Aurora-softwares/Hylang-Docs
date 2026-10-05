---
title: Hydrogen compiler
description: Commands provided by the released self-hosted compiler.
---

The released compiler emits Linux x86-64 ELF executables by default and can emit
the constrained `uefi-x64` PE32+ EFI proof target.

```text
hy tokens <file.hy>
hy parse <file.hy>
hy check <file.hy|project.hyproj> [--emit-ir]
hy compile <file.hy> [--target uefi-x64] -o <output>
hy build <project.hyproj> -o <output>
hy stage-compare <project.hyproj> --stage1 <artifact> --stage2 <artifact>
```

`tokens` prints lexer tokens and source locations. `parse` prints a syntax outline.
`check` performs name and type checking; `--emit-ir` also prints typed operations.
`compile` handles one source file. `build` accepts a format-2 `type = "exe"`
project and follows `project_references` to library sources.

## Targets

Without `--target`, output is Linux x86-64 ELF with the native runtime.

`compile --target uefi-x64` emits a PE32+ EFI application. It currently supports
only the static-entry console proof: ASCII literals passed to
`System.Console.WriteLine`. There is no general runtime, object allocation, file
API, arguments, keyboard input, graphics support, or `Hydrogen.Uefi` library yet.

## Errors

Commands return `0` on success and `1` for invalid input or unsupported
compilation. A failed compilation does not create or overwrite the requested output.
An existing executable may therefore be from an earlier successful build.
