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

Current development version: the compiler's in-progress **0.1.0** codebase.
The new [single-file Linux GTK4 proposal (draft PR #187)](https://github.com/Aurora-softwares/Hylang-Compiler/pull/187)
has **not yet merged into Development or been released**. The older
[experimental PR #182](https://github.com/Aurora-softwares/Hylang-Compiler/pull/182)
was closed without merging, so its Windows and macOS direct-packaging paths
are not part of the current Development branch.

- 🟡 **Proposed:** Replace the default Linux UI package with one native GTK4 ELF containing Hydrogen application code, HYUI views and assets; no `hyui-native`, `hyui-launcher`, Qt host or runtime sidecar. The old host-based build remains an opt-in path via `--ui-sdk`.
- 🟡 **Proposed:** Require self-hosted UI preflight for both full applications and `--ui-backend`; keep the comprehensive native schema check optional when an SDK is supplied.
- 🟢 **Previously demonstrated:** A Linux Stage 1 GTK4 single-ELF integration test passed in the earlier [prototype CI](https://github.com/Aurora-softwares/Hylang-Compiler/actions/runs/41632279604); the narrower PR #187 must be retested independently.
- 🟢 **Previously demonstrated, not merged:** The old prototype built a single Windows WinUI 3 EXE and a macOS AppKit `.app` without an extra launcher, as shown by [prototype CI](https://github.com/Aurora-softwares/Hylang-Compiler/actions/runs/41627353676). The Windows EXE was not exercised as an interactive standalone app.
- 🔴 Linux GTK4 still needs system GTK4 libraries; UI generation currently requires C++, GTK4 development headers and repository-local frontend source.
- 🔴 Native Hydrogen callbacks are still handled in a child process (Linux: anonymous `memfd`). One output file does not mean one process; a linkable native Hydrogen ABI is a separate milestone.
- 🔴 Release gates remain Stage 1–3 UI builds, full test-suite regression, complete Hydrogen HYUI schema validation, platform-native interaction and visual parity, and the in-process ABI.

Use the [Hydrogen — Development project](https://github.com/orgs/Aurora-softwares/projects/4) for live task status. Git tags describe historical releases, not the current development version.

The development compiler already emits the Australis bootloader, raw kernel,
and checked AUEX programs. The OS can load small AUN1 ring-3 machine-code
programs. Hydrogen's narrow AUN1 version 2 `native` project path emits one
static entry point, but general native Australis source compilation still
requires explicit target contracts, memory ownership, layout/ABI
support, and a suitable runtime profile. See the [Australis GUI roadmap](https://aurora-softwares.github.io/Australis-Docs/development/gui-roadmap/);
Linux executables do not establish support for these targets.

## Native Linux GTK4 UI builds (draft proposal)

The targeted [PR #187](https://github.com/Aurora-softwares/Hylang-Compiler/pull/187)
introduces default single-file Linux GTK4 UI builds, without carrying over
the old prototype's changes to default non-UI compiler targets. The GTK4
frontend is compiled from `tools/hyui/linux_gtk_app.cpp` and embeds
the compiled Hydrogen backend and resource archive in one ELF file.
No `.runtime` directory is distributed.

For the proposed source-checkout workflow:

```bash
sudo apt install build-essential binutils pkg-config libgtk-4-dev
./build/self_hosting/linux/hydrogen-stage1 build samples/ui_studio/Studio.hyproj -o build/Studio
./build/Studio
```

Keep the source checkout as the current working directory for UI generation.
The frontend uses the system GTK4 runtime. Hydrogen event callbacks currently
run from an embedded backend launched in an anonymous in-memory child process:
**single-file distribution is implemented in the proposal, but single-process
execution is not**. Existing native UI packaging on Development remains in
place until this proposal passes CI and is merged; the old `--ui-sdk` route
remains available after migration.

The proposed new Linux regression exercises clean compiler bootstrap without
Qt or `hyui-native`, frontend generation, relocation, events and rebuilds.
Stage 2/3 equivalence, independent installation of the GTK frontend template,
and full native UI schema parity remain future gates.

## Tooling and packages

Improve LSP navigation/completion/indexing, debugger integration, and diagnostic fidelity. Native source archive packing, project-local exact dependency loading, a SHA-256 lockfile, static-registry downloads, and exact restore/upgrade are implemented in Development. Linux install lifecycle and Windows release layout are also implemented; PowerShell lifecycle fixture tests run on GitHub-hosted Windows runners. Registry signing, version-range solving, published installer-ready release assets, and live Windows installation from those assets remain open.

## Development history

The original phases covered the bootstrap foundation, language hardening, object/type expansion, SDK runtime, local developer workflows, Hydrogen frontend libraries, and native self-hosting. Their implementation notes now describe the actual [SDK/compiler architecture](https://hylang.co.uk/implementation/phase5-self-hosting-prep/) and [native bootstrap process](https://hylang.co.uk/implementation/phase6-self-hosted-compiler/) rather than a progress checklist.

Future work should retain runnable examples, meaningful regressions, clear feature boundaries, and repeatable compiler generations.
