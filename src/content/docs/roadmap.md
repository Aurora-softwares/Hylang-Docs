---
title: Hydrogen roadmap
description: Australis-first language, firmware, kernel, and native-application direction.
---

Hydrogen's primary purpose is to build Australis OS and native Australis
applications. Linux is the host of the published compiler. The Development
compiler also emits Windows x64 programs and Windows release candidates; live
Windows installation from published assets remains a release gate. macOS is a
future target.

## Current development status

The [Hydrogen development project](https://github.com/orgs/Aurora-softwares/projects/4)
is the source of truth for target versions and task status. As of 26 October
2026, `0.1.0` is a pre-release qualification gate with 8 Ready, 4 In Progress,
and 1 Done item. The `0.2.0` language milestone has 11 Done, 1 In Progress,
1 Ready, and 10 Backlog items. The next `0.1.0` gates include verified release
artifacts, real Windows-host validation, and compiler release tests. The
[documentation migration](https://github.com/Aurora-softwares/Hylang-Compiler/issues/174)
is in progress; it does not by itself qualify a compiler release.

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
- A narrow AUN1 native project emits a single static entry point; a general
  Australis native runtime and syscall ABI remain planned.
- Australis loads bounded AUN1 machine-code children in ring 3 and contains
  their faults. This native loader is separate from Hydrogen's AUEX backend.

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
2. Extend native terminal, file, process, and channel syscalls beyond the
   current bounded PID, exit, and terminal-write path.
3. Add native scheduling/preemption and broader capability/resource policy.
4. Expand filesystem recovery and physical-media validation.

## Native application platform

Hydrogen compiles AUEX for Australis, with a bounded process interface and
software-checked execution. The OS's AUN1 path proves native ring-3 isolation
for small programs. Hydrogen's narrow AUN1 project path is a first compiler
step; its full syscall ABI and native application libraries remain future work. See
[Australis applications](/tools/australis-applications/) for the AUEX workflow.

Australis will eventually need its own coherent native visual system, in the broad
sense that Material and Liquid Glass give other platforms a visual language. That
work comes after input, rendering, windowing, and application-runtime foundations.

Have a use case or missing capability? [Request it on GitHub](https://github.com/Aurora-Softwares/Hylang-Compiler/issues/new/choose).
