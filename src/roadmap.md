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
| 4     | Tooling and Developer Workflow   | Not started |
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
- In-tree non-moving mark-sweep GC for compiled output
- GC stress controls (`HYLANG_GC_STRESS`, `HYLANG_GC_THRESHOLD`)
- Runtime/unsafe spec notes

The current remaining work in this phase is around deeper low-level runtime primitives and the later executable unsafe/manual-memory surface.

## Phase 4 — Tooling and Developer Workflow

A first-class `hy` CLI (`hy new`, `hy build`, `hy run`, `hy test`, `hy fmt`, `hy package`), a formatter, a linter, language server support, and a stable project/package manifest format.

## Phase 5–6 — Self-Hosting

Prepare the compiler for incremental reimplementation in Hylang, then reach self-compilation and validate output against the bootstrap.

## Phase 7 — Full Standard Library

Grow from bootstrap builtins to a real platform library covering `System`, `System.IO`, `System.Text`, `System.Collections`, `System.Threading`, and more.

## Phase 8 — Backend Evolution

Add native x64 code generation and object-file emission alongside the C backend.

## Phases 9–11 — Australis OS Integration

Make Hylang the primary language for Australis OS userland, then extend it into system-adjacent code, and ultimately reach a point where the language, compiler, and ecosystem are mature enough for serious third-party development.

---

The full roadmap with detailed checklists is maintained in the [compiler repository](https://github.com/Aurora-Softwares/Hylang-Compiler/blob/main/ROADMAP.md).
