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

The current development compiler is the in-progress **0.1.0** line.
[Compiler PR #187](https://github.com/Aurora-softwares/Hylang-Compiler/pull/187)
**merged into Development** on 3 November 2026. It produces a single Linux
GTK4 ELF with embedded HYUI and application logic, with no native UI
helper executable, though its frontend is still written in C++ and runs
the Hydrogen backend in a separate anonymous child process.

[Compiler draft PR #188](https://github.com/Aurora-softwares/Hylang-Compiler/pull/188)
starts replacing this with native Linux ABI imports and an ELF dynamic linker
both written in Hydrogen. It adds a Hydrogen-written GTK4 Window class
and a headless test that builds a window from outside the compiler repository.
This **experimental foundation is not yet merged or released**.

- 🟢 Self-hosted Stage 1–3 compiler bootstrap has been verified on Linux,
  Windows and macOS by the developer, with byte-identical Stage 2/3 outputs.
- 🟢 Linux UI documents compile to one distributable ELF on Development;
  runtime GTK4 libraries are still needed.
- 🟡 Draft PR #188 adds direct GTK4 C ABI calls, image imports and a
  Hydrogen-only sample window. CI and native runtime behavior are pending.
- 🔴 The default XML-based UI renderer still compiles a C++ GTK frontend;
  removing its sources requires implementation and parity of the full HYUI
  document/schema, native layout, controls and events in Hydrogen.
- 🔴 Linux in-process event callbacks, ownership/lifetimes, resource
  embedding, and Stage 1–3 proof of a fully Hydrogen UI remain release gates.
- 🔴 Windows/macOS native API interoperability and renderer migration,
  comprehensive cross-platform visual parity, and the final retirement
  of the optional C++ Stage 0 bootstrap remain separate milestones.

Stage 0 is the historical C++ seed, **not** the self-hosted production
compiler. Removing it without a verified replacement would break clean
bootstrapping and its trust/reproducibility chain. Retain it in
`bootstrap/` until the replacement seed is established.

Use the [Hydrogen — Development project](https://github.com/orgs/Aurora-softwares/projects/4)
for current task status.

The development compiler already emits the Australis bootloader, raw kernel,
and checked AUEX programs. The OS can load small AUN1 ring-3 machine-code
programs. Hydrogen's narrow AUN1 version 2 `native` project path emits one
static entry point, but general native Australis source compilation still
requires explicit target contracts, memory ownership, layout/ABI
support, and a suitable runtime profile. See the [Australis GUI roadmap](https://aurora-softwares.github.io/Australis-Docs/development/gui-roadmap/);
Linux executables do not establish support for these targets.

## Native Linux GTK4 UI builds

On Development, the merged single-file GTK4 path uses a C++ frontend
and Hydrogen backend in one distributed file. This is a transitional
packager, not the final native Hydrogen UI runtime.

The proposed replacement in [draft PR #188](https://github.com/Aurora-softwares/Hylang-Compiler/pull/188)
compiles a GTK4 window written exclusively in `.hy` with the Hydrogen
compiler's new direct Linux dynamic ELF loader integration. The sample is:

```bash
./build/self_hosting/linux/hydrogen-stage1 build samples/native_gtk/NativeGtk.hyproj -o build/NativeGtk
./build/NativeGtk
```

This new API is a narrow, type-checked GTK ABI slice; it still needs
event callbacks and complete HYUI compatibility before the existing
native frontend can be deleted. It is not part of the Release branch
and must not be described as a finished 100% Hydrogen GUI framework.

## Tooling and packages

Improve LSP navigation/completion/indexing, debugger integration, and diagnostic fidelity. Native source archive packing, project-local exact dependency loading, a SHA-256 lockfile, static-registry downloads, and exact restore/upgrade are implemented in Development. Linux install lifecycle and Windows release layout are also implemented; PowerShell lifecycle fixture tests run on GitHub-hosted Windows runners. Registry signing, version-range solving, published installer-ready release assets, and live Windows installation from those assets remain open.

## Development history

The original phases covered the bootstrap foundation, language hardening, object/type expansion, SDK runtime, local developer workflows, Hydrogen frontend libraries, and native self-hosting. Their implementation notes now describe the actual [SDK/compiler architecture](https://hylang.co.uk/implementation/phase5-self-hosting-prep/) and [native bootstrap process](https://hylang.co.uk/implementation/phase6-self-hosted-compiler/) rather than a progress checklist.

Future work should retain runnable examples, meaningful regressions, clear feature boundaries, and repeatable compiler generations.
