# Compile an executable

Commands use `$HYDROGEN`, set when you [install the released compiler](installing.md). First create the `hello.hy` program from the [running guide](running.md).

## Direct native compilation

```bash
"$HYDROGEN" check hello.hy
"$HYDROGEN" compile hello.hy -o hello
chmod +x hello
./hello Hydrogen
```

The compiler writes Linux x86-64 ELF directly. It needs no external compiler, assembler, or linker. Set execute permission on its output before running.

For an executable project:

```bash
"$HYDROGEN" build app/App.hyproj -o app/bin/app
chmod +x app/bin/app
./app/bin/app
```

Project references supply sources to one combined compilation; the current CLI does not produce standalone library archives or build workspace manifests. See [projects](../tools/projects.md).

## Diagnostics and IR

```bash
"$HYDROGEN" check hello.hy --emit-ir
```

`check --emit-ir` prints bound executable IR for inspection. It does not create a runnable debug ELF. Semantic diagnostics use `1:1` when AST node spans are unavailable; lexer/parser diagnostics retain source positions.

Native `compile` and `build` fail with nonzero status on invalid or unsupported code. Failure does not create or overwrite the requested output. An older artifact can still exist, so only execute after a successful compilation. A successful `check` can still be followed by a backend rejection; consult [the released compiler guide](compiler-options.md).

## UEFI Hello World output

The self-hosted compiler can emit a PE32+ EFI application for x86-64 firmware:

```bash
"$HYDROGEN" compile uefi_hello.hy --target uefi-x64 -o BOOTX64.EFI
file BOOTX64.EFI
```

`BOOTX64.EFI` is not a Linux executable: do not `chmod` or run it on the host. Put it on a FAT EFI system partition or use the companion Australis OS `make iso` workflow, then boot it in UEFI firmware or QEMU/OVMF.

This target is a proof of firmware execution, not the general native backend with a different container. Its supported program shape is a static `Main` using `System.Console.WriteLine` with ASCII string literals. It does not yet provide a general console API, arguments, files, memory services, input, graphics, or a managed runtime. Follow the complete [UEFI Hello World guide](uefi-hello.md) before extending it.
