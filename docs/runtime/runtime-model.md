# Runtime behavior

Hydrogen programs use managed class objects, immutable byte strings, and mutable arrays. Allocation and collection are automatic for these values. Class/array assignment copies references; SDK structs use value copies.

## Direct native executables

The native compiler embeds a Linux x86-64 runtime and uses raw Linux syscalls for console, files, and memory mappings. It does not depend on libc, a C++ runtime, an assembler, or a linker at application compilation time.

The heap uses a conservative, non-moving mark/sweep collector. Stack/register values and heap payloads are scanned for allocation/interior pointers. Reachable graphs and cycles are retained; unreachable mappings are reclaimed. Conservative scanning can retain values that are no longer logically reachable.

Collection occurs under allocation pressure. Small live heaps use a larger growth budget than large compiler heaps. A bounded pool can retain up to 16 MiB of freed single-page mappings for reuse; recycled pages are cleared. `System.Runtime.GC.Collect()` releases this pool as well as collecting. `GetAllocatedBytes()` reports active managed mapping bytes, excluding the pool.

String indexing uses immutable cached one-byte strings. Strings and arrays expose byte/element length, respectively. Native file reads require seekable files. Null access, out-of-range indices, invalid allocation sizes, malformed integers, failed I/O, and allocation failure report errors on stderr and terminate with status `1`.

Native programs do not expose the C backend's GC environment controls or `.hymap.json` debug metadata. Their Hydrogen-to-Hydrogen calling convention is internal, not a C ABI.

## SDK C-backed executables

The SDK emits C and an in-tree non-moving mark/sweep runtime. Generated root frames identify managed parameters/locals; tracing visits managed fields and array elements. Allocation accounting includes string and array backing storage. The default collection budget grows with retained heap size.

The following controls apply only to C-backed executables:

```bash
HYLANG_GC_STRESS=1 ./build/app
HYLANG_GC_THRESHOLD=128 ./build/app
```

`HYLANG_GC_STRESS` requests collection at runtime safe points. `HYLANG_GC_THRESHOLD` sets a fixed collection budget for testing/debugging. SDK `hy build --debug` emits `.hymap.json`; C-backed runtime failures report the executing Hydrogen statement's source location.

The SDK's unsafe/manual memory uses checked runtime helpers. Invalid free, double free, use-after-free, and pointer bounds violations fail at runtime. This model does not supply arbitrary machine-address interop; see [unsafe operations](unsafe-design.md).

## SDK interpreter

`hy run` and `hyrun` evaluate the SDK's bound IR using reference-managed C++ runtime values. They do not execute the generated ELF runtime. Sharing syntax and binding does not make all execution details identical: in particular the interpreter eagerly evaluates both operands of `&&`/`||`, whereas C-backed and direct native output short-circuit.

Use explicit conditional guards in code that runs in all modes. The [compiler support table](../getting-started/compiler-options.md) and [builtin reference](builtins.md) describe additional differences.
