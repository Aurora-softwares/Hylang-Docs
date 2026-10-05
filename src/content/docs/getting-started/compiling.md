---
title: Compile an executable
description: Use checks, diagnostics, projects, and target selection.
---

## Linux-native compilation

```bash
hy check hello.hy
hy compile hello.hy -o hello
chmod +x hello
./hello Hydrogen
```

For an executable project:

```bash
hy build app/App.hyproj -o app/bin/app
```

Project references supply source to one combined executable. The current CLI does
not produce standalone library archives or workspace manifests.

## Diagnostics and IR

```bash
hy check hello.hy --emit-ir
```

`check --emit-ir` prints bound executable IR for inspection; it does not create a
runnable debug executable. Failed `compile` and `build` commands return non-zero
and preserve an existing output artifact.

## UEFI output

```bash
hy compile uefi_hello.hy --target uefi-x64 -o BOOTX64.EFI
file BOOTX64.EFI
```

`BOOTX64.EFI` is firmware code, not a Linux executable. Put it on a FAT EFI
system partition or use the Australis ISO workflow, then boot it with UEFI
firmware or QEMU/OVMF.
