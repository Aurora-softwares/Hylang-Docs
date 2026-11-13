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

### Apple Silicon application builds — 0.9.0 track

The [Hydrogen Development project](https://github.com/orgs/Aurora-softwares/projects/4) assigns [Apple Silicon issue #146](https://github.com/Aurora-softwares/Hylang-Compiler/issues/146) to the 0.9.0 cross-platform qualification track. This target is in progress and has no published arm64 release.

- 🟢 The C++ bootstrap compiler accepts `hy build <file.hy|exe-project.hyproj> --target macos-arm64 -o <output>` on macOS with Xcode Command Line Tools. It uses Hydrogen's C backend and Apple's arm64 clang. The [Apple Silicon CI job](https://github.com/Aurora-softwares/Hylang-Compiler/actions/runs/42608237362/job/129129800150) compiled and ran arm64 console/runtime applications.
- 🟢 The release packager has a `macos-arm64` candidate format and rejects non-arm64 compiler binaries. Apple Silicon CI verified the archive and compiled an application using its installed compiler. The maintenance script distinguishes native arm64 installs from existing Intel installs under Rosetta.
- 🔴 The Hydrogen-written direct backend still emits x86-64 machine code. Its next target is an AArch64 emitter, arm64 runtime and Mach-O writer, then self-hosting stage 2/3 checks on Apple Silicon.
- 🟢 HYUI AppKit export and package creation select `macos-arm64` on Apple Silicon and use the portable C backend for Hydrogen event logic. The [Apple Silicon native UI job](https://github.com/Aurora-softwares/Hylang-Compiler/actions/runs/42608237362/job/129129800150) verified native controls, an arm64 Studio bundle, and packaged application launch.
- 🔴 A checksum-verified published arm64 compiler archive, live website install, update, and uninstall remain release gates. The installer now selects the arm64 asset on Apple Silicon.

### Native desktop UI — Development branch, 13 November 2026

**Current development version:** `0.2.0` language track; native UI work is
assigned to the `0.5.0` project target. These are development targets, not releases.

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
- 🟢 Hydrogen Stage 1–3 preflight validates HYUI structure, controls,
  attributes, identifiers, handler syntax and important value constraints;
  schema inventory checks are covered in [merged compiler PR #195](https://github.com/Aurora-softwares/Hylang-Compiler/pull/195).
  Deeper renderer-specific validation and native SDK checks remain part of
  the platform integration suite.
- 🟢 [Merged compiler PR #194](https://github.com/Aurora-softwares/Hylang-Compiler/pull/194)
  adds a named contract for each of the 43 current HYUI elements, verifies
  their native GTK4, WinUI 3 and AppKit control types, and checks multi-choice
  dialogs. [Cross-platform CI](https://github.com/Aurora-softwares/Hylang-Compiler/actions/runs/42782912556)
  passed all applicable jobs before the Development merge.
- 🟢 Two additional native HYUI controls are merged to Development:
  `ToggleButton` (P1) and `ValidationMessage` (P2) have GTK4, WinUI 3,
  AppKit and single-file Linux GTK4 implementations with native interaction
  tests in [merged PR #196](https://github.com/Aurora-softwares/Hylang-Compiler/pull/196).
  [CI run 41843955763](https://github.com/Aurora-softwares/Hylang-Compiler/actions/runs/41843955763)
  passed the native UI suites, platform SDK exports and bootstrap regression tests.
- 🟢 `SplitView` (P1) and `StatusBar` (P1) were merged in
  [PR #197](https://github.com/Aurora-softwares/Hylang-Compiler/pull/197).
  Native splitters, Hydrogen state updates, and GTK4, AppKit, and WinUI interaction
  jobs passed in [CI run 41876342201](https://github.com/Aurora-softwares/Hylang-Compiler/actions/runs/41876342201).
- 🟡 Dynamic `ListBox.items` replacement is implemented in the shared `.hyui`
  document and Hydrogen bridge, all three native host renderers, and the
  single-file GTK4 runtime generated by Stage 1.
  Selection updates and item replacement are atomic, and shrinking the list
  clamps an existing selection. Shared contracts, a native GTK4 host interaction
  run, and a generated single-file GTK4 application with accepted and rejected
  Hydrogen updates passed locally. AppKit and WinUI validation remains open.
- 🟡 `TreeView` now has a validated preorder hierarchy, zero-based selection
  callbacks, and atomic `Application.SetItems`/`SetValue` updates in the shared
  contract and native GTK4, AppKit, and WinUI renderers. The GTK4 host interaction
  suite and a generated Stage 1 single-file GTK4 application passed locally.
  AppKit and WinUI native jobs, multi-stage generation, pinned visual CI, and
  broader model APIs remain release gates. The local GTK screenshot comparison
  differs from the reviewed baseline even in a workspace view without the tree.
- 🔴 Next target controls include `TreeTable`, `DocumentTabs` and `CodeEditor`
  (IDE essentials). Close/reorder, accessibility, editor contracts, observable
  lists, and dynamic child updates still require implementation.
- 🔴 Windows and macOS native SDK packaging remains separate from the Linux
  single-file GTK4 output model. A fully single-process native Hydrogen UI
  callback path is not yet demonstrated on all three operating systems.
- 🔴 Remaining release gates: verified multi-stage native UI builds on all three
  platforms for the current changes, cross-platform compiler/frontend schema
  parity, accessibility and release-distribution checks, and real-world lifecycle
  tests beyond the Studio sample.

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
