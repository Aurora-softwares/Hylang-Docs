# Native Hydrogen compiler

The released, Hydrogen-written compiler emits Linux x86-64 ELF executables directly by default. It also has a constrained `uefi-x64` target which emits a PE32+ EFI application for the current console Hello World proof. Install the release first, then use its `hydrogen-stage1` executable. See [Install the released compiler](../getting-started/installing.md).

## Commands

```text
hydrogen-stage1 tokens <file.hy>
hydrogen-stage1 parse <file.hy>
hydrogen-stage1 check <file.hy|project.hyproj> [--emit-ir]
hydrogen-stage1 compile <file.hy> [--target uefi-x64] -o <output>
hydrogen-stage1 build <project.hyproj> -o <output>
hydrogen-stage1 stage-compare <project.hyproj> --stage1 <artifact> --stage2 <artifact>
```

`tokens` prints lexer tokens and locations. `parse` prints a syntax outline, not a bound or executable representation. `check` performs project-aware name/type checking; `--emit-ir` additionally prints typed method bodies and operations.

`compile` emits a single-file executable. `build` requires a format-2 `type = "exe"` manifest and follows `project_references` to library sources. It does not support SDK workspaces, packages, or standalone library artifacts.

## Targets

Without `--target`, `compile` and `build` produce Linux x86-64 ELF files. These use the native runtime and support the subset described in [The released Hydrogen compiler](../getting-started/compiler-options.md).

`compile --target uefi-x64` produces an x86-64 PE32+ EFI application. It is currently limited to the firmware console proof: a static `Main` can call `System.Console.WriteLine` with ASCII string literals. The target has no general runtime, object allocation, file API, command-line arguments, keyboard input, graphics support, or `Hydrogen.Uefi` library yet. Use the [UEFI Hello World guide](../getting-started/uefi-hello.md) to package and boot it.

`stage-compare` compares existing artifacts byte for byte and returns failure on length/content differences. It does not compile generations or test their behavior; the CMake bootstrap proof performs those additional checks.

## Example

```bash
"$HYDROGEN" check hello.hy --emit-ir
"$HYDROGEN" compile hello.hy -o hello
chmod +x hello
./hello
```

Output paths are explicit. The containing directory must exist. Linux ELF output needs execute permission; EFI output is loaded by firmware and is normally named `EFI/BOOT/BOOTX64.EFI` when placed on removable-media-style boot media.

## Errors

Commands return `0` on success and `1` on invalid input or unsupported compilation. Diagnostics are printed by the CLI; do not assume all diagnostic output is on stderr. Lexer/parser diagnostics retain source positions; semantic diagnostics use `1:1` where node spans are unavailable.

Failed compilation does not create or overwrite the output. An existing executable may therefore be from an earlier build. Checking/IR inspection alone does not establish backend support. There is no fallback debug executable for unsupported programs.

Consult [the released compiler guide](../getting-started/compiler-options.md) and [builtin APIs](../runtime/builtins.md). The current CLI has no interpreted `run`, test runner, formatter, project scaffolder, package manager, language server, JSON diagnostics, or debug-metadata mode.
