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

### Native desktop UI — Development branch, 4 November 2026

**Current development version:** `0.1.0` (not released). This is an experimental
feature and does not qualify the compiler for an `0.1.0` release.

- 🟢 HYUI v1 native controls, events, layouts and visual regressions are covered by
  platform-specific GTK4, WinUI 3 and AppKit implementations and tests. The merged
  [native control parity PR #193](https://github.com/Aurora-softwares/Hylang-Compiler/pull/193)
  passed all applicable jobs in
  [Hydrogen CI run 41819210581](https://github.com/Aurora-softwares/Hylang-Compiler/actions/runs/41819210581).
- 🟢 Linux Stage 1–3 can build a relocatable single-file GTK4 application from
  Hydrogen without Qt or the old `hyui-native` build dependency. CI exercises native
  controls, callback dispatch, window lifecycle and output ownership.
- 🟢 Windows WinUI 3 and macOS AppKit native hosts and target-specific SDK
  packaging pass dedicated CI tests, including real native GUI interactions.
- 🟡 The Hydrogen-only XML preflight validates basic structure today. Expanded
  control, attribute, identifier and handler validation plus schema inventory
  checks are proposed in
  [compiler PR #195](https://github.com/Aurora-softwares/Hylang-Compiler/pull/195);
  its platform CI must pass before treating that work as complete.
- 🟢 Two additional native HYUI controls are merged to Development:
  `ToggleButton` (P1) and `ValidationMessage` (P2) have GTK4, WinUI 3,
  AppKit and single-file Linux GTK4 implementations with native interaction
  tests in [merged PR #196](https://github.com/Aurora-softwares/Hylang-Compiler/pull/196).
  [CI run 41843955763](https://github.com/Aurora-softwares/Hylang-Compiler/actions/runs/41843955763)
  passed the native UI suites, platform SDK exports and bootstrap regression tests.
- 🟡 `SplitView` (P1) and `StatusBar` (P1) are implemented in
  [PR #197](https://github.com/Aurora-softwares/Hylang-Compiler/pull/197)
  with native splitters, Hydrogen state updates and cross-platform regression tests.
  Full CI and a Development merge remain required before they are complete.
- 🔴 Next target controls include `TreeView`, `DocumentTabs` and
  `CodeEditor` (IDE essentials). Their native selection, close/reorder,
  accessibility and editor contracts still require implementation.
- 🔴 Windows and macOS native SDK packaging remains separate from the Linux
  single-file GTK4 output model. A fully single-process native Hydrogen UI
  callback path is not yet demonstrated on all three operating systems.
- 🔴 Remaining release gates: verified multi-stage native UI builds on all three
  platforms, cross-platform compiler/frontend schema parity, accessibility and
  release-distribution checks, and real-world lifecycle tests beyond the Studio sample.

A **single executable file** is distinct from **single-process execution**.
Linux applications still use the destination's GTK4 shared libraries.

The development compiler already emits the Australis bootloader, raw kernel,
and checked AUEX programs. The OS can load small AUN1 ring-3 machine-code
programs. Hydrogen's narrow AUN1 version 2 `native` project path emits one
static entry point, but general native Australis source compilation still
requires explicit target contracts, memory ownership, layout/ABI
support, and a suitable runtime profile. See the [Australis GUI roadmap](https://aurora-softwares.github.io/Australis-Docs/development/gui-roadmap/);
Linux executables do not establish support for these targets.

## Native Linux GTK4 UI builds (Development)

The merged direct UI compiler work generates application-specific GTK4
executables without requiring the former Qt renderer or `hyui-native`
during normal Linux builds. Build prerequisites include a C++ compiler,
`pkg-config` and GTK4 development headers.

```bash
sudo apt install build-essential pkg-config libgtk-4-dev
./build/self_hosting/linux/hydrogen-stage1 build samples/ui_studio/Studio.hyproj -o build/Studio
./build/Studio
```

The produced Linux executable embeds the frontend, UI document, assets and
compiled Hydrogen backend. The backend is still launched as a separate
process for event handling; the one-file output does not imply in-process
callbacks. macOS AppKit `.app` bundles and Windows WinUI 3 runtime packaging
follow their native SDK paths. See the
[HYUI guide](/tools/desktop-ui/) and the
[Hydrogen development project](https://github.com/orgs/Aurora-softwares/projects/4)
for up-to-date work and release gates.

## Tooling and packages

Improve LSP navigation/completion/indexing, debugger integration, and diagnostic fidelity. Native source archive packing, project-local exact dependency loading, a SHA-256 lockfile, static-registry downloads, and exact restore/upgrade are implemented in Development. Linux install lifecycle and Windows release layout are also implemented; PowerShell lifecycle fixture tests run on GitHub-hosted Windows runners. Registry signing, version-range solving, published installer-ready release assets, and live Windows installation from those assets remain open.

## Development history

The original phases covered the bootstrap foundation, language hardening, object/type expansion, SDK runtime, local developer workflows, Hydrogen frontend libraries, and native self-hosting. Their implementation notes now describe the actual [SDK/compiler architecture](https://hylang.co.uk/implementation/phase5-self-hosting-prep/) and [native bootstrap process](https://hylang.co.uk/implementation/phase6-self-hosted-compiler/) rather than a progress checklist.

Future work should retain runnable examples, meaningful regressions, clear feature boundaries, and repeatable compiler generations.
