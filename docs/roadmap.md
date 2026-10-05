# Hydrogen roadmap · [Request a feature](https://github.com/Aurora-Softwares/Hylang-Compiler/issues/new/choose)

Hydrogen's primary purpose is to build Australis OS and native applications for
Australis. Linux is the current host and native application target because it
makes the compiler practical to develop and test today. Windows and macOS hosts
are valuable future ports, but they do not set the order of the core work.

This page is direction, not a promise that every item is already available. For
the current supported language, use [the released compiler guide](getting-started/compiler-options.md).

## Completed foundation

- The compiler is self-hosted: Hydrogen compiles its own compiler project
  closure.
- The default output is direct Linux x86-64 ELF.
- The self-hosted compiler emits a PE32+ `uefi-x64` application.
- Australis packages that output into a bootable ISO that displays a Hydrogen
  Hello World in QEMU/OVMF.

## Next: usable UEFI programs

The present firmware target is intentionally a console-output proof, not a
runtime. The next milestone is a minimal `Hydrogen.Uefi` library and the
compiler support it needs:

- Console `Write`, `WriteLine`, and `Clear`.
- Keyboard input.
- Basic boot-service and memory wrappers.
- Explicit UEFI data layouts, function pointers, strings, and ABI support.
- Tests that compile and boot each feature.

This enables a firmware-hosted command shell written completely in Hydrogen.

## Then: Australis kernel work

Once the shell and firmware library are stable, Australis can stop depending on
UEFI services in the right order:

1. Obtain the firmware memory map and call `ExitBootServices`.
2. Provide allocation and framebuffer output without firmware services.
3. Add interrupts plus keyboard and storage drivers.
4. Define the kernel/runtime boundary.
5. Grow userland and system calls.

At that point the project changes from an EFI application to an operating
system kernel with its own services.

## Native application platform

Hydrogen is intended to be the main language for native Australis applications,
not only for the kernel. Application libraries, process/system interfaces, and
the application model follow after the lower-level OS boundary is reliable.

Australis will eventually need its own coherent native visual system, in the
same broad sense that Material and Liquid Glass give other platforms a visual
language. That work comes after input, rendering, windowing, and application
runtime foundations exist; the project should not invent a UI style before it
can support the systems that make it usable.

## Host platforms

Linux x86-64 is the current released host. Windows and macOS compiler releases
are planned once their host executables, packaging, and validation are ready.
They are ports of the Hydrogen toolchain, not a change in Australis-first
priority.

Have a use case or missing capability? [Request it on GitHub](https://github.com/Aurora-Softwares/Hylang-Compiler/issues/new/choose).
