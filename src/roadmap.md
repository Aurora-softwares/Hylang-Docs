# Roadmap

Hylang is developed in phases, moving from a bootstrap compiler through self-hosting to a full OS-level language for Australis OS.

## Vision

- A C#-like systems language with high-level ergonomics
- Capable of both managed application development and low-level OS work
- Self-hosted — the compiler will eventually be written in Hylang itself
- Backed by a real standard library, tooling ecosystem, and package/build workflow
- The primary language for Australis OS userland and, over time, larger parts of the OS stack

## Phase overview

| Phase | Name                             | Status      |
|-------|----------------------------------|-------------|
| 0     | Bootstrap Foundation             | Complete    |
| 1     | Language Hardening               | Complete    |
| 2     | Core Language Expansion          | Complete    |
| 3     | Runtime and Memory Model         | In progress |
| 4     | Tooling and Developer Workflow   | In progress |
| 5     | Self-Hosting Preparation         | Not started |
| 6     | Self-Hosted Compiler             | Not started |
| 7     | Full Standard Library            | Not started |
| 8     | Backend Evolution                | Not started |
| 9     | Hylang for Australis OS Userland | Not started |
| 10    | Hylang for System Software       | Not started |
| 11    | Full OS and Ecosystem Vision     | Long-term   |

## Phase 0 — Bootstrap Foundation (complete)

The compiler pipeline, `hyrun`, `hyc`, core OO syntax, basic control flow, and minimal standard library builtins are all in place. Small multi-file console tools can be written and run today.

## Phase 1 — Language Hardening (complete)

Delivered a reliable language subset, comprehensive tests, and a medium-sized sample tool:

- Full arithmetic, comparison, logical, and unary operators
- Constructor and method overloading with ambiguity detection
- Basic enums with equality, static fields, and printing
- String character indexing
- Parser error recovery
- `token_dump` sample — 431 lines across 4 files
- Regression suite covering both interpreter and compiled output

## Phase 2 — Core Language Expansion (complete)

Phase 2 finished the core object model and type-system expansion:

- Single inheritance with `class Derived : Base`
- `base(...)` constructor chaining and `base.Member`
- `virtual` / `override`
- Interfaces and interface inheritance
- Structs with bootstrap by-value semantics
- Generic classes, interfaces, and methods
- `var` local inference
- Stronger name resolution and generic arity handling
- `mini_frontend_model` as the proof project

## Phase 3 — Runtime and Memory Model (current)

Phase 3 is currently focused on runtime foundations:

- Managed UTF-8 strings
- General managed `T[]`
- `new T[count]`
- Bootstrap `System.Collections.List<T>`
- Safe bootstrap `System.Runtime.Buffer`
- Bootstrap `System.Runtime.BinaryPrimitives` through 64-bit helpers
- In-tree non-moving mark-sweep GC for compiled output
- GC stress controls (`HYLANG_GC_STRESS`, `HYLANG_GC_THRESHOLD`)
- Runtime/unsafe spec notes

The current remaining work in this phase is around deeper low-level runtime primitives and the later executable unsafe/manual-memory surface.

## Phase 4 — Tooling and Developer Workflow (current)

Phase 4 now has a real delivered slice:

- first-class `hy` CLI
- v2 `.hyproj` manifests and workspaces
- `hy new`, `hy build`, `hy run`, `hy test`, `hy fmt`, `hy check`, `hy package`
- build caching and `.hymap.json` debug metadata
- bootstrap lint warnings via `hy check --json`
- light VS Code assets
- `hexlab` as the workflow showcase

The main remaining Phase 4 work is broader static analysis, stronger compiled runtime failure mapping, and the executable unsafe/manual-memory systems surface that still overlaps with the Phase 3 follow-on work.

## Phase 5–6 — Self-Hosting

Prepare the compiler for incremental reimplementation in Hylang, then reach self-compilation and validate output against the bootstrap.

## Phase 7 — Full Standard Library

Grow from bootstrap builtins to a real platform library covering `System`, `System.IO`, `System.Text`, `System.Collections`, `System.Threading`, and more.

## Phase 8 — Backend Evolution

Add native x64 code generation and object-file emission alongside the C backend.

## Phases 9–11 — Australis OS Integration

Make Hylang the primary language for Australis OS userland, then extend it into system-adjacent code, and ultimately reach a point where the language, compiler, and ecosystem are mature enough for serious third-party development.

---

See also:

- [Phase 2 Bootstrap Spec](implementation/phase2-bootstrap-spec.md)
- [Phase 4 Tooling Slice](implementation/phase4-tooling-slice.md)
