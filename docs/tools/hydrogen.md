# Native Hydrogen compiler

The Hydrogen-written compiler emits Linux x86-64 ELF executables directly. After [building it](../getting-started/building.md), use `build/self_hosting/hydrogen-stage1`. Verified stage 2/3 binaries expose the same commands.

## Commands

```text
hydrogen-stage1 tokens <file.hy>
hydrogen-stage1 parse <file.hy>
hydrogen-stage1 check <file.hy|project.hyproj> [--emit-ir]
hydrogen-stage1 compile <file.hy> -o <output>
hydrogen-stage1 build <project.hyproj> -o <output>
hydrogen-stage1 stage-compare <project.hyproj> --stage1 <artifact> --stage2 <artifact>
```

`tokens` prints lexer tokens and locations. `parse` prints a syntax outline, not a bound or executable representation. `check` performs project-aware name/type checking; `--emit-ir` additionally prints typed method bodies and operations.

`compile` emits a single-file executable. `build` requires a format-2 `type = "exe"` manifest and follows `project_references` to library sources. It does not support SDK workspaces, packages, or standalone library artifacts.

`stage-compare` compares existing artifacts byte for byte and returns failure on length/content differences. It does not compile generations or test their behavior; the CMake bootstrap proof performs those additional checks.

## Example

```bash
./build/self_hosting/hydrogen-stage1 check tests/phase6/native_hello.hy --emit-ir
./build/self_hosting/hydrogen-stage1 compile tests/phase6/native_hello.hy -o build/hello
chmod +x build/hello
./build/hello
```

Output paths are explicit. The containing directory must exist, and emitted files need execute permission.

## Errors

Commands return `0` on success and `1` on invalid input or unsupported compilation. Diagnostics are printed by the CLI; do not assume all diagnostic output is on stderr. Lexer/parser diagnostics retain source positions; semantic diagnostics use `1:1` where node spans are unavailable.

Failed compilation does not create or overwrite the output. An existing executable may therefore be from an earlier build. Checking/IR inspection alone does not establish backend support. There is no fallback debug executable for unsupported programs.

Consult the [supported features](../getting-started/compiler-options.md) and [builtin APIs](../runtime/builtins.md). The native CLI does not implement the SDK's `run`, `test`, `fmt`, `new`, `package`, `lsp`, `--json`, or `--debug` options.
