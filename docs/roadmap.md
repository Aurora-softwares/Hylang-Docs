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
| 3     | Runtime and Memory Model         | Complete    |
| 4     | Tooling and Developer Workflow   | Complete    |
| 5     | Self-Hosting Preparation         | Complete    |
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

## Phase 3 — Runtime and Memory Model (complete at bootstrap scope)

Phase 3 delivered the bootstrap runtime foundation and executable low-level surface:

- Managed UTF-8 strings
- General managed `T[]`
- `new T[count]`
- Bootstrap `System.Collections.List<T>`
- Safe bootstrap `System.Runtime.Buffer`
- Bootstrap `System.Runtime.Memory`
- Bootstrap `System.Runtime.BinaryPrimitives` through 64-bit helpers
- In-tree non-moving mark-sweep GC for compiled output
- Executable `unsafe`, pointers, `stackalloc`, and `sizeof`
- GC stress controls (`HYLANG_GC_STRESS`, `HYLANG_GC_THRESHOLD`)
- Runtime/unsafe spec notes

The main remaining cleanup around this area is bootstrap polish rather than missing core surface: tighter interpreter/compiled low-level unification, broader unmanaged-struct pointer materialization, and a more native unmanaged backing story for `Buffer.DangerousData()`.

## Phase 4 — Tooling and Developer Workflow (complete at local-first bootstrap scope)

Phase 4 now has a real delivered slice:

- first-class `hy` CLI
- v2 `.hyproj` manifests and workspaces
- `hy new`, `hy build`, `hy run`, `hy test`, `hy fmt`, `hy check`, `hy package`
- build caching and `.hymap.json` debug metadata
- bootstrap lint warnings via `hy check --json`
- local filesystem package registry publish/search/install
- lightweight `hy lsp` diagnostics, document symbols, hover, and formatting
- VS Code assets
- `hexlab` as the systems/runtime showcase
- `sdk_demo` as the package/tooling proof workspace

Deferred beyond Phase 4 are hosted registry services, authentication/signing, semver range solving, and full semantic IDE features such as completion, go-to-definition, references, rename, semantic tokens, and workspace indexing.

## Phase 5 — Self-Hosting Preparation (complete at prototype scope)

Phase 5 delivered the first reusable Hydrogen compiler libraries:

- `Hydrogen.Compiler.Core` for text and diagnostics
- `Hydrogen.Compiler.Syntax` for tokens, syntax kinds, lexer, parser, and syntax trees
- `Hydrogen.Compiler.Cli` with `tokens <file>` and `parse <file>`
- `Hydrogen.Compiler.Tests`
- golden token and parse fixtures
- bootstrap compiler architecture notes and a clear Phase 6 boundary

This prototype is syntax-only. It does not bind, type-check, lower IR, emit code, or replace the C++ bootstrap compiler.

## Phase 6 — Self-Hosted Compiler

Phase 6 has started the real self-hosted compiler effort. The current foundation adds Hydrogen-owned binding, typed IR, runtime-contract, and Linux x64 codegen projects under `samples/self_hosting`, plus a direct ELF proof path that emits a tiny `System.Console.WriteLine("...")` executable without C emission, an assembler, or a linker.

Remaining Phase 6 work includes broad semantic binding, the managed runtime clone, native backend expansion for compiler-shaped programs, stage1/stage2 builds, and boringly repeatable stage comparison before promotion.

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
- [Phase 5 Self-Hosting Preparation](implementation/phase5-self-hosting-prep.md)
