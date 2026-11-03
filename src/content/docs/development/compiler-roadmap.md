---
title: "Hydrogen development roadmap"
---

> Development reference from [Hylang-Compiler](https://github.com/Aurora-softwares/Hylang-Compiler/tree/Development). Commands and source paths on this page are relative to that repository checkout. For current task status, use the [development project](https://github.com/orgs/Aurora-softwares/projects/4).

This document describes future work. For available language features and commands, use the [README](https://hylang.co.uk/contributing/compiler-source/), [language reference](https://hylang.co.uk/), and [native compiler guide](https://hylang.co.uk/contributing/native-compiler/).

## Foundation

The C++ SDK includes an interpreter, C backend, extended object/type system, unsafe/manual memory, projects/workspaces, local packages, formatting/checking, and lightweight editor services.

The Hydrogen-written compiler emits Linux x86-64 ELF directly, binds executable project references, supports the class/string/array/runtime subset needed by its own sources, and passes repeated native self-compilation with behavioral checks and identical stage 2/3 compiler/application artifacts. These facts apply to the native subset, not the entire SDK language and workflow surface.

## Native language and SDK parity

- Implement inheritance, virtual/interface dispatch, struct value semantics, and generics in executable native IR/code generation.
- Add overloads, static fields, `for`, wider numerics, exceptions, and remaining runtime APIs.
- Retain clean failure for unsupported programs and add cross-backend semantic regressions.
- Preserve node spans through AST/binding/IR for precise diagnostics.
- Improve collector allocation density, compiler memory use, and generated-code performance.
  The measured self-hosted native runtime priorities are in [optimisations.md](https://hylang.co.uk/performance/optimisation-evidence/).
- Port or replace SDK scaffolding, run/test/fmt/check tooling, workspace/package resolution, and LSP services.
- Migrate build/tests to retained verified native seeds before deciding whether to retire C++ bootstrap sources.

## Standard library

Expand compiler/runtime builtins into reusable Hydrogen-written libraries: collections, text/encoding/builders, streams/filesystems, paths, process/environment APIs, numerics, serialization, and test support. The [stdlib design plan](https://github.com/Aurora-Softwares/Hylang-Stdlib) describes proposed layers, not currently installable packages.

## Backend and platform work

Direct Linux x64 code generation is implemented. Additional work includes object files, linker/external ABI integration, debug information, cross-compilation, and additional platform runtime/startup implementations. Keep the C backend useful as a portability route while parity develops.

### Native desktop UI — development branch

Current development version: the compiler's in-progress 0.1.0 codebase, with Linux single-file GTK4 packaging on the `feature/embedded-native-ui-stage-compilers` branch ([draft PR #182](https://github.com/Aurora-softwares/Hylang-Compiler/pull/182)). This is **not** a released feature.

- 🟢 Compiler stages contain HYUI validation and build the application logic without a separately installed `hyui-native`.
- 🟢 Linux GTK4 application generation can package the compiled Hydrogen backend, declarative UI and assets into **one ELF executable**; it requires C++, GTK4 development headers, `tar` and `objcopy` at build time.
- 🟢 The Linux Stage 1 single-ELF GTK4 integration test passed on [Hylang-Compiler PR #182, CI run 41623739036](https://github.com/Aurora-softwares/Hylang-Compiler/actions/runs/41623739036). Stage 2/3 standalone GTK4 builds remain a separate verification gate.
- 🔴 In-process UI callbacks are not implemented: the embedded Hydrogen backend currently runs from an anonymous Linux `memfd` in a child process. No backend ELF is written alongside the app.
- 🟢 Windows WinUI 3 native Stage 1 builds now publish a single-EXE self-contained app via .NET `PublishSingleFile`, with the Hydrogen backend and UI resources embedded. [CI run 41627353676](https://github.com/Aurora-softwares/Hylang-Compiler/actions/runs/41627353676) verified the EXE build, no runtime sidecars, and relocation. Interactive launch of this single-file EXE remains unverified.
- 🟢 macOS AppKit bundles directly use the AppKit renderer as `CFBundleExecutable`, with no launcher. The [x64 macOS CI run 41627353676](https://github.com/Aurora-softwares/Hylang-Compiler/actions/runs/41627353676) exported the SDK, built the `.app` and launched it to capture a screenshot. This remains a normal multi-file `.app` bundle carrying Qt Core runtime libraries.
- 🔴 True in-process native Hydrogen calls remain necessary to eliminate the platform-specific child backend processes.
- 🔴 Remaining release gates include native UI regressions across all three compiler stages, visual parity, and a native linkable Hydrogen ABI to eliminate the child process.

A **single executable file** is distinct from **single-process execution**. GTK4 remains a system shared-library dependency on Linux.

The development compiler already emits the Australis bootloader, raw kernel,
and checked AUEX programs. The OS can load small AUN1 ring-3 machine-code
programs. Hydrogen's narrow AUN1 version 2 `native` project path emits one
static entry point, but general native Australis source compilation still
requires explicit target contracts, memory ownership, layout/ABI
support, and a suitable runtime profile. See the [Australis GUI roadmap](https://aurora-softwares.github.io/Australis-Docs/development/gui-roadmap/);
Linux executables do not establish support for these targets.

## Native Linux GTK4 UI builds (experimental branch)

The experimental [embedded UI compiler PR #182](https://github.com/Aurora-softwares/Hylang-Compiler/pull/182)
extends the three self-hosted compiler stages with native UI validation. On Linux,
the feature branch now generates an application-specific GTK4 executable by
compiling its GTK4 frontend source against the system GTK4 development SDK.
This route does not require the old `hyui-native`/Qt host or a separate
`hyui-launcher` executable. The previous Qt renderer remains available with
an explicitly provided `--ui-sdk` during migration.

The initial generator requires `c++`, `pkg-config` and the GTK4 development
headers. The current implementation is intended for source checkouts and
locates `tools/hyui/linux_gtk_app.cpp` relative to the repository root.

A typical source-checkout build is:

```bash
sudo apt install build-essential pkg-config libgtk-4-dev
./build/self_hosting/linux/hydrogen-stage1 build samples/ui_studio/Studio.hyproj -o build/Studio
./build/Studio
```

The Linux application currently consists of a GTK4 frontend executable and
a private `.runtime/app/__hyui_backend` containing compiled Hydrogen event
logic and resources. Event transport still launches the backend process. The
**single-process executable** is a future integration stage, not delivered by
this GTK4 milestone. Windows WinUI3 and macOS AppKit direct generation are
separate future tasks.

The branch includes headless Ubuntu GTK4 build and event tests. Its status
must not be presented as release-qualified until those checks and native
interaction tests pass. The latest task status remains in the
[Hydrogen development project](https://github.com/orgs/Aurora-softwares/projects/4).

## Tooling and packages

Improve LSP navigation/completion/indexing, debugger integration, and diagnostic fidelity. Native source archive packing, project-local exact dependency loading, a SHA-256 lockfile, static-registry downloads, and exact restore/upgrade are implemented in Development. Linux install lifecycle and Windows release layout are also implemented; PowerShell lifecycle fixture tests run on GitHub-hosted Windows runners. Registry signing, version-range solving, published installer-ready release assets, and live Windows installation from those assets remain open.

## Development history

The original phases covered the bootstrap foundation, language hardening, object/type expansion, SDK runtime, local developer workflows, Hydrogen frontend libraries, and native self-hosting. Their implementation notes now describe the actual [SDK/compiler architecture](https://hylang.co.uk/implementation/phase5-self-hosting-prep/) and [native bootstrap process](https://hylang.co.uk/implementation/phase6-self-hosted-compiler/) rather than a progress checklist.

Future work should retain runnable examples, meaningful regressions, clear feature boundaries, and repeatable compiler generations.
