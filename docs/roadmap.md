# Future work

This page describes planned work, not available language syntax or APIs. For current capabilities, use the [compiler support table](getting-started/compiler-options.md) and [language guide](language/structure.md).

The native Hydrogen compiler already builds its own complete CLI project through repeated, behaviorally tested generations. Future compiler work focuses on broader language parity with the SDK, improved source spans/diagnostics, memory/performance work, and migrating the SDK workflow tools to Hydrogen.

Further platform work includes object-file emission, external ABI/linker integration, richer debug information, and additional target runtimes. Linux x86-64 ELF is the direct native target today; UEFI and Australis OS integration remain design work.

The standard-library plan covers reusable collections, text/encoding, streams/filesystems, process/environment services, testing, and platform abstractions. Hylang-Stdlib currently contains a design plan rather than installable library projects; existing `System.*` builtins are implemented in the compiler runtimes.

See the [compiler roadmap](https://github.com/Aurora-Softwares/Hylang-Compiler/blob/main/ROADMAP.md), [OS design plan](https://github.com/Aurora-Softwares/Hylang-Compiler/blob/main/OS_ROADMAP.md), and [standard-library plan](https://github.com/Aurora-Softwares/Hylang-Stdlib/blob/main/hydrogen-standard-library-roadmap.md).
