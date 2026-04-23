# Roadmap

Hylang is developed in phases, moving from a bootstrap compiler through self-hosting to a full OS-level language for Aura OS.

## Vision

- A C#-like systems language with high-level ergonomics
- Capable of both managed application development and low-level OS work
- Self-hosted — the compiler will eventually be written in Hylang itself
- Backed by a real standard library, tooling ecosystem, and package/build workflow
- The primary language for Aura OS userland and, over time, larger parts of the OS stack

## Phase overview

| Phase | Name | Status |
|-------|------|--------|
| 0 | Bootstrap Foundation | Complete |
| 1 | Language Hardening | In progress |
| 2 | Core Language Expansion | Not started |
| 3 | Runtime and Memory Model | Not started |
| 4 | Tooling and Developer Workflow | Not started |
| 5 | Self-Hosting Preparation | Not started |
| 6 | Self-Hosted Compiler | Not started |
| 7 | Full Standard Library | Not started |
| 8 | Backend Evolution | Not started |
| 9 | Hylang for Aura OS Userland | Not started |
| 10 | Hylang for System Software | Not started |
| 11 | Full OS and Ecosystem Vision | Long-term |

## Phase 0 — Bootstrap Foundation (complete)

The compiler pipeline, `hyrun`, `hyc`, core OO syntax, basic control flow, and minimal standard library builtins are all in place. Small multi-file console tools can be written and run today.

## Phase 1 — Language Hardening (current)

Focus on making the existing language subset reliable enough for larger tools:

- Stronger parser error recovery
- Overload resolution and constructor selection hardening
- Broader regression coverage
- More string, array, and file APIs
- Additional sample programs written in Hylang

## Phase 2 — Core Language Expansion

Add the object-model features needed before self-hosting: inheritance, virtual/override, interfaces, enums, structs, generics, and improved namespace resolution.

## Phase 3 — Runtime and Memory Model

Replace the bootstrap allocation strategy with a real GC-backed runtime. Define `unsafe` blocks, pointer support, stack allocation, and manual allocation APIs.

## Phase 4 — Tooling and Developer Workflow

A first-class `hy` CLI (`hy new`, `hy build`, `hy run`, `hy test`, `hy fmt`, `hy package`), a formatter, a linter, language server support, and a stable project/package manifest format.

## Phase 5–6 — Self-Hosting

Prepare the compiler for incremental reimplementation in Hylang, then reach self-compilation and validate output against the bootstrap.

## Phase 7 — Full Standard Library

Grow from bootstrap builtins to a real platform library covering `System`, `System.IO`, `System.Text`, `System.Collections`, `System.Threading`, and more.

## Phase 8 — Backend Evolution

Add native x64 code generation and object-file emission alongside the C backend.

## Phases 9–11 — Aura OS Integration

Make Hylang the primary language for Aura OS userland, then extend it into system-adjacent code, and ultimately reach a point where the language, compiler, and ecosystem are mature enough for serious third-party development.

---

The full roadmap with detailed checklists is maintained in the [compiler repository](https://github.com/Aurora-Softwares/Hylang-Compiler/blob/main/ROADMAP.md).
