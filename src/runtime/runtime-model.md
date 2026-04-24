# Runtime Model

This page records the current managed runtime contract implemented by the bootstrap compiler.

## Scope

The current runtime surface includes:

- managed `string`
- general managed `T[]`
- bootstrap `System.Collections.List<T>`
- bootstrap `System.Runtime.Buffer`
- bootstrap `System.Runtime.Memory`
- bootstrap `System.Runtime.BinaryPrimitives`
- compiled-runtime garbage collection
- executable bootstrap `unsafe`
- runtime stress controls

Executable unsafe/manual-memory behavior now exists in both `hyrun` and compiled mode, with a few bootstrap caveats noted below.

## Strings

- `string` is immutable
- runtime storage is UTF-8 byte-oriented
- `string.Length` returns byte length
- `text[index]` is byte-based and returns a one-byte `string`
- concatenation, equality, console output, and file IO keep the same source syntax as earlier phases

## Arrays

- `T[]` is a first-class managed reference type
- allocate with `new T[count]`
- `count` must be an integral size expression accepted by the current bootstrap
- `void[]` is invalid
- elements are zero/default-initialized
- arrays support `.Length`, indexed reads, and indexed assignment
- out-of-range access is a runtime failure

## Bootstrap Collections

The current bootstrap ships a minimal `System.Collections.List<T>` backed by managed arrays.

Supported API:

- `public List()`
- `public void Add(T value)`
- `public T Get(int index)`
- `public void Set(int index, T value)`
- `public int Count()`

Capacity starts at `4` and doubles when full.

## Safe Buffer Primitive

The current follow-on runtime work also ships a safe bootstrap `System.Runtime.Buffer`.

Supported API:

- `Buffer.Allocate`
- `Buffer.FromArray`
- `Length`
- `Get`
- `Set`
- `Slice`
- `Fill`
- `ToArray`
- `DangerousData`
- `Free`

Current semantics:

- slices share underlying storage
- `Free()` invalidates the owning storage and all related views
- later access after `Free()` is a runtime failure
- `DangerousData()` requires `unsafe` and returns a `byte*`
- the current bootstrap path bridges through checked raw memory rather than a fully native unmanaged backing store

## Unsafe and Manual Memory

The bootstrap runtime now supports:

- `unsafe { ... }`
- pointer types `T*`
- address-of `&expr`
- dereference `*ptr`
- pointer indexing and arithmetic
- `stackalloc T[count]`
- `sizeof(T)`
- `System.Runtime.Memory.Alloc/Free/Copy/Set/Compare`

Current bootstrap boundaries:

- the low-level surface is checked in both execution modes
- non-zero integer-to-pointer casts remain intentionally rejected
- pointer loads/stores are currently strongest for primitive, enum, and `bool` element types
- the interpreter and compiled runtime now match the same visible behavior, while deeper internal unification remains follow-on work

## Binary Primitives

The bootstrap runtime includes `System.Runtime.BinaryPrimitives` helpers for:

- 16-bit reads/writes
- 32-bit reads/writes
- 64-bit reads/writes
- little-endian and big-endian forms

These helpers are currently used by showcase code such as `hexlab`.

## Compiled Runtime

Compiled output currently uses:

- an in-tree non-moving mark-sweep collector
- managed string objects
- managed array objects
- class-specific trace helpers
- precise emitted root frames for live reference-like values
- checked raw-manual-memory helpers for the bootstrap unsafe/manual-memory surface

Current collector properties:

- single-threaded
- stop-the-world
- non-moving
- no finalizers
- no compaction
- no weak references

Compiled runtime failures now report Hylang file/line/column context for the currently executing statement instead of only raw generated-runtime messages.

## Stress Controls

The compiled runtime supports internal stress/debug controls:

```bash
HYLANG_GC_STRESS=1 ./build/myapp
HYLANG_GC_THRESHOLD=128 ./build/myapp
```

- `HYLANG_GC_STRESS=1` forces collection at runtime safe points
- `HYLANG_GC_THRESHOLD=<bytes>` changes the collection threshold

## Interpreter Note

`hyrun` matches the same visible string/array/List/Buffer semantics, but the interpreter still uses a bootstrap reference-managed implementation internally. The language/runtime contract is aligned first, and deeper internal unification can continue later without changing source behavior.
