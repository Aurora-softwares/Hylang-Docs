# Runtime Model

Phase 3 standardizes the current managed runtime surface for Hylang.

## Strings

- `string` is immutable
- runtime storage is UTF-8 byte-oriented
- `string.Length` returns byte length
- `text[index]` is byte-based and returns a one-byte `string`

## Arrays

- arrays are managed reference types
- allocate with `new T[count]`
- arrays support `.Length`, indexed reads, and indexed assignment

## Compiled runtime

Compiled output currently uses:

- an in-tree non-moving mark-sweep collector
- managed string objects
- managed array objects
- class-specific trace helpers
- precise emitted root frames for live reference-like values

Current collector properties:

- single-threaded
- stop-the-world
- non-moving
- no finalizers
- no compaction
- no weak references

## Stress controls

The compiled runtime supports internal stress/debug controls:

```bash
HYLANG_GC_STRESS=1 ./build/myapp
HYLANG_GC_THRESHOLD=128 ./build/myapp
```

- `HYLANG_GC_STRESS=1` forces collection at runtime safe points
- `HYLANG_GC_THRESHOLD=<bytes>` changes the collection threshold

## Interpreter note

`hyrun` matches the same visible string/array/List semantics, but the interpreter still uses a bootstrap reference-managed implementation internally. The language/runtime contract is aligned first, and deeper internal unification can continue later without changing source behavior.
