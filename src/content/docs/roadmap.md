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

## Next: usable UEFI programs

The current firmware target is a console-output proof, not a runtime. The next
milestone is a minimal `Hydrogen.Uefi` library and the compiler support it needs:

- Console `Write`, `WriteLine`, and `Clear`.
- Keyboard input.
- Basic boot-service and memory-map wrappers.
- Explicit UEFI data layouts, function pointers, strings, and ABI support.
- Tests that compile and boot each feature.

This enables a firmware-hosted command shell written completely in Hydrogen.

## Then: Australis kernel work

1. Obtain the firmware memory map and call `ExitBootServices`.
2. Provide allocation and framebuffer output without firmware services.
3. Add interrupts plus keyboard and storage drivers.
4. Define the kernel/runtime boundary.
5. Grow userland and system calls.

## Native application platform

Hydrogen is intended to be the main language for native Australis applications,
not only for the kernel. Application libraries, process/system interfaces, and the
application model follow after the lower-level OS boundary is reliable.

Australis will eventually need its own coherent native visual system, in the broad
sense that Material and Liquid Glass give other platforms a visual language. That
work comes after input, rendering, windowing, and application-runtime foundations.

Have a use case or missing capability? [Request it on GitHub](https://github.com/Aurora-Softwares/Hylang-Compiler/issues/new/choose).
