# Unsafe Design

Unsafe and manual-memory features are planned, but they are not executable in the current Phase 3 bootstrap.

## Planned surface

The later unsafe phase is expected to introduce:

- `unsafe { ... }`
- pointer types `T*`
- address-of `&expr`
- dereference `*ptr`
- pointer indexing `ptr[index]`
- `stackalloc T[count]`
- `System.Runtime.Memory` manual allocation APIs

## Current status

These forms are design-only today:

- the parser does not execute them
- the binder does not type-check them
- the interpreter does not run them
- the compiled backend does not emit them

## Goal

Hylang remains managed-by-default. Unsafe features are intended for later low-level runtime, OS, and interop work, and they should stay explicit and locally auditable when they land.
