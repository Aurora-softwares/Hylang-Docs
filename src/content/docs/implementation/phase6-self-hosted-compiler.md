---
title: Self-hosted compiler architecture
description: Native generations, UEFI proof output, and bootstrap boundaries.
---

> This is contributor documentation. Release users install `hydrogen-stage1` and
> do not need the historical C++ bootstrap to use Hydrogen.

The Hydrogen-written compiler emits standalone Linux x86-64 ELF executables by
default. It binds the complete source/reference closure of its CLI project and can
compile itself. It can additionally produce a constrained PE32+ UEFI console
application.

## UEFI proof target

The `uefi-x64` path is implemented in Hydrogen. It writes a minimal PE32+ EFI
image, provides an x86-64 EFI entry stub, encodes console text as UTF-16, and
calls the firmware text-output function through the UEFI system table. `mtools`
and `xorriso` package that executable into boot media; they do not compile it.

This is intentionally not a general ABI/runtime layer. It currently lowers the
console proof profile—ASCII literals passed to `System.Console.WriteLine` from the
static entry point. Managed heap support, firmware wrappers, keyboard support,
graphics, and general foreign-function calls are future work.

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
