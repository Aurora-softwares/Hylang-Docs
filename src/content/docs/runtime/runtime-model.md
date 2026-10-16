---
title: Runtime behavior
description: Managed values, the Linux-native runtime, and the UEFI target boundary.
---

Hydrogen programs use managed class objects, value-type structs, immutable byte
strings, and mutable arrays. Allocation and collection are automatic. Class and
array assignment copy references; struct assignment copies the value.

## Linux-native executables

The compiler embeds a Linux x86-64 runtime using raw Linux syscalls for console,
files, and memory mappings. It does not depend on libc, a C++ runtime, an assembler,
or a linker at application compilation time.

The heap uses a conservative, non-moving mark/sweep collector. Stack/register
values and heap payloads are scanned for allocation and interior pointers. Reachable
graphs and cycles are retained; unreachable mappings are reclaimed. Conservative
scanning can retain values that are no longer logically reachable.

Null access, out-of-range indices, malformed integers, failed I/O, and allocation
failure report errors and terminate with status `1`.

## UEFI output

The `uefi-x64` target has no embedded managed runtime. It emits PE32+ firmware
applications from a restricted static-entry sequence. Boot images can use UEFI
console, key-wait, and image-launch services. Kernel images can leave boot
services, establish early memory and paging, write to the GOP framebuffer, and
halt. See [UEFI Hello World and kernel handoff](/getting-started/uefi-hello/).

## Australis development formats

The current development compiler emits AUEX `.exec` images for Australis. The
kernel checks their instructions and memory accesses in its interpreter, and
provides bounded terminal, file, process, and channel calls. AUEX does not run
in hardware user mode. Separately, the OS can load small AUN1 machine-code
children in ring 3, with private user mappings and a stack guard. AUN1 currently
has PID and exit syscalls, and a fault ends only that child. Hydrogen does not
yet compile source into AUN1 or supply a managed native Australis runtime.
