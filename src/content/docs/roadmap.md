---
title: Hydrogen roadmap
description: Australis-first language, firmware, kernel, and native-application direction.
---

Hydrogen's primary purpose is to build Australis OS and native Australis
applications. Linux is the current host and application target because it makes the
compiler practical to develop and validate today. Windows and macOS hosts are
valuable future ports, but they do not set the core work order.

## Completed foundation

- Hydrogen compiles its own compiler project closure.
- The default output is direct Linux x86-64 ELF.
- The self-hosted compiler emits a PE32+ `uefi-x64` application.
- Australis packages a UEFI bootloader and raw Hylang kernel into a hybrid ISO.
- The UEFI target clears the console, waits for a key, and chain-loads an EFI image.
- The early kernel path exits boot services, initializes physical memory and
  paging, and writes to a framebuffer after firmware services end.
- OS manifests build separate bootloader and kernel images into an output tree.
- The current compiler checkout builds checked AUEX `.exec` applications from
  Hylang projects for the Australis shell.

## Next: general UEFI and kernel facilities

The current firmware target supports a fixed sequence of built-in operations,
not a general runtime. A broader UEFI and kernel programming model still needs:

- General console and keyboard APIs beyond literal output and one key wait.
- General boot-service and memory-map wrappers.
- Explicit UEFI data layouts, function pointers, strings, and ABI support.
- Tests that compile and boot each feature.

The current Australis shell runs after the UEFI handoff in its freestanding
kernel. The broader UEFI APIs above would enable other firmware-hosted programs.

## Further Australis kernel work

1. Turn bootstrap memory, interrupts, input, and storage code into reusable
   kernel APIs with broader hardware coverage.
2. Extend the checked user-program ABI and external userland services.
3. Add native process privilege separation and scheduling.
4. Expand filesystem writes and recovery in the live kernel.

## Native application platform

Hydrogen now compiles a constrained AUEX application format for Australis.
Application libraries, a richer process interface, and native execution remain
future work. See [Australis applications](/tools/australis-applications/) for the
current development workflow.

Australis will eventually need its own coherent native visual system, in the broad
sense that Material and Liquid Glass give other platforms a visual language. That
work comes after input, rendering, windowing, and application-runtime foundations.

Have a use case or missing capability? [Request it on GitHub](https://github.com/Aurora-Softwares/Hylang-Compiler/issues/new/choose).
