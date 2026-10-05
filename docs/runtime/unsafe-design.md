# Unsafe and manual memory

This page describes C++ SDK features. The direct native Hydrogen compiler does not implement pointers, manual-memory APIs, `stackalloc`, or `Buffer`.

## Operations

Inside `unsafe { ... }`, the SDK supports `T*`, address-of `&expr`, dereference `*ptr`, pointer indexing, pointer addition/subtraction, pointer difference, explicit pointer casts, `sizeof(T)`, and `stackalloc T[count]`.

Pointer access is backed by checked runtime helpers rather than unrestricted machine addresses. Primitive, enum, and boolean element loads/stores are implemented. The runtime detects invalid free, double free, use-after-free, and out-of-range access.

## Complete example

```hylang
using System.Runtime;

public class Program {
    public static int Main() {
        unsafe {
            byte* data = Memory.Alloc(4);
            Memory.Set(data, 0, 4);
            data[0] = 65;
            System.Console.WriteLine(data[0]);
            Memory.Free(data);
        }
        return 0;
    }
}
```

Run with `hy run` or compile with `hy build`. It prints `65`. Free manual allocations explicitly and do not access their pointers afterward.

## Memory services

- `Memory.Alloc(bytes)` returns a byte pointer.
- `Memory.Free(pointer)` releases its allocation.
- `Memory.Copy(destination, source, bytes)` copies bytes.
- `Memory.Set(destination, value, bytes)` fills bytes.
- `Memory.Compare(left, right, bytes)` compares memory.

`System.Runtime.Buffer` is the safe byte-storage wrapper, with bounds-checked operations and explicit `Free`. Its `DangerousData()` bridge requires an unsafe block. See the [builtin reference](builtins.md).

## Restrictions

Pointer creation/access and the dangerous buffer bridge require `unsafe`. Address-of managed objects, strings, arrays, and managed object fields is rejected. Nonzero integer-to-pointer casts are rejected. Arbitrary layout/ABI controls, pinning, `void*`, and broader unmanaged-struct pointer materialization are not provided.

`stackalloc` syntax uses checked allocation helpers in the SDK. It is not a promise of a raw native stack buffer or enforced lexical lifetime: the C backend lowers it to manual allocation. Do not use it as an ABI/interoperability mechanism or rely on automatic scope-based reclamation. For explicit ownership, prefer `Memory.Alloc`/`Free`.

Managed allocation with `new` remains separate from these manual-memory services.
