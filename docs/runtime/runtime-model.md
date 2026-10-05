# Runtime behavior

Hydrogen programs use managed class objects, immutable byte strings, and mutable arrays. Allocation and collection are automatic for these values. Class/array assignment copies references.

## Direct native executables

The native compiler embeds a Linux x86-64 runtime and uses raw Linux syscalls for console, files, and memory mappings. It does not depend on libc, a C++ runtime, an assembler, or a linker at application compilation time.

The heap uses a conservative, non-moving mark/sweep collector. Stack/register values and heap payloads are scanned for allocation/interior pointers. Reachable graphs and cycles are retained; unreachable mappings are reclaimed. Conservative scanning can retain values that are no longer logically reachable.

Collection occurs under allocation pressure. Small live heaps use a larger growth budget than large compiler heaps. A bounded pool can retain up to 16 MiB of freed single-page mappings for reuse; recycled pages are cleared. `System.Runtime.GC.Collect()` releases this pool as well as collecting. `GetAllocatedBytes()` reports active managed mapping bytes, excluding the pool.

String indexing uses immutable cached one-byte strings. Strings and arrays expose byte/element length, respectively. Native file reads require seekable files. Null access, out-of-range indices, invalid allocation sizes, malformed integers, failed I/O, and allocation failure report errors on stderr and terminate with status `1`.

Native programs do not expose the C backend's GC environment controls or `.hymap.json` debug metadata. Their Hydrogen-to-Hydrogen calling convention is internal, not a C ABI.

This section applies to the default Linux x86-64 target. The `uefi-x64` output has no embedded managed runtime: it is a small PE32+ firmware application that directly calls the UEFI text-console service for its restricted Hello World profile.

The released compiler has no interpreter or C-backed execution mode. Use explicit
conditional guards for bounds and null-sensitive code, and consult [the
released compiler guide](../getting-started/compiler-options.md) for the
currently supported language surface.
