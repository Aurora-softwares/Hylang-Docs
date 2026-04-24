# Unsafe Design

Unsafe and manual-memory features are planned, but they are not executable in the current bootstrap.

## Planned Surface

The later unsafe phase is expected to introduce:

- `unsafe { ... }`
- pointer types `T*`
- address-of `&expr`
- dereference `*ptr`
- pointer indexing `ptr[index]`
- `stackalloc T[count]`
- `System.Runtime.Memory` manual allocation APIs

## Safety Boundary

Managed Hylang remains the default experience:

- normal object allocation uses the managed runtime
- strings and arrays remain managed
- `System.Runtime.Buffer` is the current safe byte-storage abstraction
- future unsafe features should only be needed for low-level runtime, OS, or interop scenarios

Unsafe code is intended to stay:

- explicit
- locally auditable
- opt-in at the block or API boundary

## Planned Rules

When unsafe support lands, the intended rules are:

- pointer creation and dereference require `unsafe`
- unsafe operations do not silently leak into surrounding safe code
- `stackalloc` memory is scoped to the current stack lifetime
- manual allocation APIs are explicit and never implied by normal object creation
- low-level memory APIs live in `System.Runtime.Memory`

## Current Status

These forms are design-only today:

- the parser does not execute them
- the binder does not type-check them
- the interpreter does not run them
- the compiled backend does not emit them

The current bootstrap does expose `Buffer.DangerousData()`, but it intentionally fails at runtime until the executable unsafe surface exists.

## Not Yet Implemented

The current compiler does not implement:

- pointer parsing or binding
- pointer arithmetic
- stack allocation codegen
- manual heap allocation/free APIs
- raw unmanaged allocation tables shared across both modes
- ABI/layout controls for low-level interop

## Goal

Hylang remains managed-by-default. Unsafe features are intended for later low-level runtime, OS, and interop work, and they should stay explicit and locally auditable when they land.
