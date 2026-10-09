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
- Australis packages that output into a bootable ISO that displays Hydrogen text
  in QEMU/OVMF.
- The UEFI target clears the console, waits for a key, and chain-loads an EFI image.
- The early kernel path exits boot services, initializes physical memory and
  paging, and writes to a framebuffer after firmware services end.
- OS manifests build separate bootloader and kernel EFI images into an output tree.

## Next: general UEFI and kernel facilities

The current firmware target supports a fixed sequence of built-in operations,
not a general runtime. A broader UEFI and kernel programming model still needs:

- General console and keyboard APIs beyond literal output and one key wait.
- General boot-service and memory-map wrappers.
- Explicit UEFI data layouts, function pointers, strings, and ABI support.
- Tests that compile and boot each feature.

Those capabilities would enable a firmware-hosted command shell written in
Hydrogen.

## Further Australis kernel work

1. Turn the current fixed early-memory and framebuffer sequence into reusable
   kernel APIs.
2. Add interrupt, input, and storage facilities suitable for kernel code.
3. Define the kernel/runtime boundary.
4. Grow userland and system calls.

## Native application platform

Hydrogen is intended to be the main language for native Australis applications,
not only for the kernel. Application libraries, process/system interfaces, and the
application model follow after the lower-level OS boundary is reliable.

Australis will eventually need its own coherent native visual system, in the broad
sense that Material and Liquid Glass give other platforms a visual language. That
work comes after input, rendering, windowing, and application-runtime foundations.

Have a use case or missing capability? [Request it on GitHub](https://github.com/Aurora-Softwares/Hylang-Compiler/issues/new/choose).
