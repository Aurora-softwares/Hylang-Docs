---
title: Self-hosted compiler architecture
description: Native generations, UEFI proof output, and bootstrap boundaries.
---

> This is contributor documentation. Release users install `hy` and
> do not need the historical C++ bootstrap to use Hydrogen.

The Hydrogen-written compiler emits standalone Linux x86-64 ELF executables by
default. It binds the complete source/reference closure of its CLI project and can
compile itself. It can additionally produce constrained PE32+ UEFI bootloader
and early-kernel images.

## UEFI target

The `uefi-x64` path is implemented in Hydrogen. It writes a minimal PE32+ EFI
image, provides an x86-64 EFI entry stub, encodes console text as UTF-16, and
calls firmware protocols through the UEFI system table. `mtools` and `xorriso`
can package the executable into boot media; they do not compile it.

This is intentionally not a general ABI/runtime layer. It lowers a fixed set of
static-entry operations: literal console output, screen clearing, key wait, image
launch, and early-kernel handoff. The kernel path captures the final memory map,
exits boot services, installs owned page tables, and can use a basic heap and GOP
framebuffer console. Arbitrary method bodies, general firmware wrappers, and
foreign-function calls remain future work.

## Rebuild from a seed

Keep a verified compiler outside a new output directory, then rebuild the compiler
project with it:

```bash
"$HYDROGEN" build samples/self_hosting/Hydrogen.Compiler.Cli/Hydrogen.Compiler.Cli.hyproj \
  -o hydrogen-rebuilt
chmod +x hydrogen-rebuilt
```

A clean source-only checkout still needs a trusted initial seed. Repeated bootstrap
proofs build successive generations and verify their behavior and representative
artifacts.
