# Make a bootable UEFI Hello World

This guide produces the current Hydrogen firmware proof of concept: a bootable x86-64 UEFI ISO that displays a line of text. It demonstrates that the self-hosted compiler can create an EFI executable. It does **not** yet demonstrate a complete UEFI standard library or an independent operating-system kernel.

## What you need

Work on a Linux x86-64 host. Install the released Hydrogen compiler first, then
clone `Australis-OS`. ISO packaging needs `mtools` and `xorriso`. QEMU with OVMF
is optional but recommended for local boot testing.

Compiling supported Hydrogen programs—including the EFI example—does not use C++,
a host C compiler, an assembler, or a linker. Keep a known-good release binary
if you want to rebuild the compiler from Hydrogen alone.

## Install the self-hosted compiler

Download the release described in [Install the released compiler](installing.md),
then set its location:

```bash
export HYDROGEN=/path/to/hydrogen-stage1
```

It is compiled from the compiler's Hydrogen project closure and is the compiler
used by the OS packaging flow.

## Compile an EFI application directly

Create `uefi_hello.hy` with the exact supported example:

```hylang
public class Program {
    public static void Main(string[] args) {
        System.Console.WriteLine("Hello world from UEFI x64!");
    }
}
```

Compile it as an EFI application:

```bash
"$HYDROGEN" compile uefi_hello.hy --target uefi-x64 -o BOOTX64.EFI
file BOOTX64.EFI
```

The `file` command should identify a PE32+ EFI application. It is firmware code, so it cannot be executed as a Linux program. On removable-style UEFI media, copy it to `EFI/BOOT/BOOTX64.EFI` on a FAT EFI system partition.

## Build and boot the ISO

The companion `Australis-OS` repository packages its Hydrogen source with the self-hosted compiler:

```bash
cd Australis-OS
make iso HYDROGEN="$HYDROGEN"
make run HYDROGEN="$HYDROGEN"
```

`make iso` invokes the supplied release compiler with `--target uefi-x64`, then uses `mtools` and `xorriso` to put the generated `BOOTX64.EFI` into a bootable ISO. `make run` starts that ISO in QEMU using OVMF. The expected screen text is:

```text
Hello world from Hylang!
```

## Current boundary

Keep this distinction in mind while learning the language:

- The default self-hosted target is Linux x86-64 and includes the documented native runtime.
- `uefi-x64` currently supports the small static-entry console demonstration only: ASCII string literals passed to `System.Console.WriteLine`.
- There is no `Hydrogen.Uefi` library yet. `Console.Write`, clear-screen support, keyboard input, memory/boot-service wrappers, and graphics are planned next.
- This application still runs under UEFI firmware. A self-contained OS kernel will later need to obtain the memory map, call `ExitBootServices`, and supply its own memory, display, interrupt, keyboard, storage, and runtime layers.

That narrow scope is intentional: it gives the project a tested compiler-to-firmware milestone while leaving the next engineering steps explicit.
