---
title: Hydrogen compiler
description: Commands provided by Hydrogen alpha-0.0.2.
---

Hydrogen `alpha-0.0.2` emits Linux x86-64 ELF executables by default and can
emit constrained `uefi-x64` PE32+ EFI images.

```text
hy tokens <file.hy>
hy parse <file.hy>
hy check <file.hy|project.hyproj> [--emit-ir]
hy compile <file.hy> [--target uefi-x64] -o <output>
hy build <project.hyproj> -o <output-file|output-directory>
hy new app|lib|tool|test|workspace|os|efi|kernel <name>
hy stage-compare <project.hyproj> --stage1 <artifact> --stage2 <artifact>
```

`tokens` prints lexer tokens and source locations. `parse` prints a syntax outline.
`check` performs name and type checking; `--emit-ir` also prints typed operations.
`compile` handles one source file. `build` accepts format-2 `exe`, `efi`,
`kernel`, and `os` projects. Executable references contribute library sources;
OS projects place referenced EFI and kernel images under an output directory.
`new` creates a project scaffold. The scaffolded `tool`, `test`, and `workspace`
projects are not separate native build modes.

## Targets

Without `--target`, output is Linux x86-64 ELF with the native runtime.

`compile --target uefi-x64` emits a PE32+ EFI application. Its static entry
point can write ASCII literals, clear the firmware screen, wait for a key, and
launch one EFI image. A separate constrained kernel path can exit boot services,
initialize early memory, paging, heap, and framebuffer output, then halt. See
[UEFI Hello World and kernel handoff](/getting-started/uefi-hello/) for the
required call order. General-purpose firmware APIs and arbitrary method bodies
are not supported by this target.

## Errors

Commands return `0` on success and nonzero for invalid input or unsupported
compilation. A failed compilation does not create or overwrite the requested output.
An existing executable may therefore be from an earlier successful build.

## Features in the development checkout

The current compiler source checkout extends `hy new` and `hy build` with
Australis `exec` projects. It emits checked AUEX `.exec` applications and a raw
`AUKR` kernel image for the current Australis OS tree. These capabilities are
not part of the published `alpha-0.0.2` command and target summary above.
See [Projects and references](/tools/projects/) and
[Australis applications](/tools/australis-applications/) for examples.
The Development compiler's narrow `native` project emits AUN1 version 2 for a
single static `Main` with bounded literal terminal output. The OS loader runs
small AUN1 machine-code images in ring 3. General native terminal/file/IPC
bindings and a full application runtime remain future work.
