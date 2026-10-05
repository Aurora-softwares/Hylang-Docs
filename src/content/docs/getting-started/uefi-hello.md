---
title: Make a bootable UEFI Hello World
description: Compile Hydrogen to a PE32+ EFI application and boot it with Australis.
---

This produces the current Hydrogen firmware proof of concept: a bootable x86-64
UEFI ISO that displays a line of text. It proves the self-hosted compiler can
create an EFI executable; it does not yet prove a complete UEFI library or kernel.

## Compile the EFI application

Create `uefi_hello.hy`:

```csharp
public class Program {
    public static void Main(string[] args) {
        System.Console.WriteLine("Hello world from UEFI x64!");
    }
}
```

```bash
hy compile uefi_hello.hy --target uefi-x64 -o BOOTX64.EFI
file BOOTX64.EFI
```

The output should identify as a PE32+ EFI application. Put it at
`EFI/BOOT/BOOTX64.EFI` on removable-style UEFI media.

## Build and boot the Australis ISO

Install `mtools`, `xorriso`, QEMU, and OVMF, then use the companion repository:

```bash
git clone https://github.com/Aurora-Softwares/Australis-OS.git
cd Australis-OS
make iso HYDROGEN="$(command -v hy)"
make run HYDROGEN="$(command -v hy)"
```

The expected text is `Hello world from Hylang!`.

## Current boundary

`uefi-x64` supports the static-entry console demonstration only: ASCII literals
passed to `System.Console.WriteLine`. There is no `Hydrogen.Uefi` library yet;
console input, clearing, memory/boot-service wrappers, and graphics are the next
steps. A self-contained kernel later needs the memory map, `ExitBootServices`,
allocation, framebuffer, interrupts, keyboard, storage, and runtime layers.
