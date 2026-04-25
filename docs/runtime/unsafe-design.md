# Unsafe Design

Unsafe and manual-memory features are executable in the current bootstrap at a deliberately narrow systems-programming boundary.

## Executable Surface

The current bootstrap supports:

- `unsafe { ... }`
- pointer types `T*`
- address-of `&expr`
- dereference `*ptr`
- pointer indexing `ptr[index]`
- pointer arithmetic `ptr + n` and `ptr - n`
- pointer difference returning `nint`
- `stackalloc T[count]`
- `System.Runtime.Memory` manual allocation APIs
- `sizeof(T)`
- explicit numeric and pointer casts

## Safety Boundary

Managed Hylang remains the default experience:

- normal object allocation uses the managed runtime
- strings and arrays remain managed
- `System.Runtime.Buffer` is the safe byte-storage abstraction
- unsafe features should only be needed for low-level runtime, OS, or interop scenarios

Unsafe code stays:

- explicit
- locally auditable
- opt-in at the block or API boundary

## Rules

- pointer creation, dereference, indexing, arithmetic, and `DangerousData()` require `unsafe`
- unsafe operations do not silently leak into surrounding safe code
- `stackalloc` memory is scoped to the current stack lifetime
- manual allocation APIs are explicit and never implied by normal object creation
- low-level memory APIs live in `System.Runtime.Memory`
- address-of is rejected for managed objects, strings, managed arrays, and managed object fields
- non-zero integer-to-pointer casts are intentionally rejected in the bootstrap runtime

## Current Status

These forms execute in both `hyrun` and compiled output through checked runtime helpers. Invalid frees, double frees, use-after-free, and out-of-range pointer access report runtime failures.

## Bootstrap Boundaries

The current compiler/runtime still keeps these boundaries:

- ABI/layout controls for low-level interop
- managed-object pinning
- `void*`
- floating-point numerics
- broader unmanaged-struct pointer materialization beyond the current primitive, enum, and `bool` element paths

## Goal

Hylang remains managed-by-default. Unsafe features exist for low-level runtime, OS, and interop work, and they stay explicit and locally auditable.
