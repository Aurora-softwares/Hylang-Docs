---
title: Builtin APIs
description: Linux runtime services and the constrained UEFI built-ins.
---

These services are implemented by the released compiler's Linux-native runtime.
The development AUEX backend also implements `Console.Write`, `WriteLine`,
`System.IO.File.Exists`, `ReadAllText`, `WriteAllText`, and
`System.Convert.ToInt32`. AUEX additionally implements `Console.ReadLine`;
its console and file text values are limited to 255 bytes. Use the fully
qualified names shown here.

| Call | Result | Use |
| --- | --- | --- |
| `System.Console.Write(value)` | `void` | Print a string, integer, or boolean |
| `System.Console.WriteLine(value)` | `void` | Print a value followed by a newline |
| `System.IO.File.Exists(path)` | `bool` | Test a path |
| `System.IO.File.ReadAllText(path)` | `string` | Read a file as bytes in a string |
| `System.IO.File.ReadAllBytes(path)` | `byte[]` | Read a file into an array |
| `System.IO.File.WriteAllText(path, text)` | `void` | Create or replace a text file |
| `System.IO.File.WriteAllBytes(path, data)` | `void` | Create or replace a binary file |
| `System.Convert.ToInt32(text)` | `int` | Parse a signed decimal integer |

`ToInt32` returns Hydrogen's 32-bit `int`. Malformed/out-of-range values and failed
I/O terminate the application with an error. `WriteLine()` accepts no argument for
an empty line. `Console.ReadLine` is currently AUEX-only.

## GC diagnostics

| Call | Result | Meaning |
| --- | --- | --- |
| `System.Runtime.GC.Collect()` | `void` | Force collection and release cached free pages in native output; the development SDK's C output also supports it, while its interpreter treats it as a no-op |
| `System.Runtime.GC.GetAllocatedBytes()` | `int` | Active managed mapping bytes, excluding cached free pages |

`GetAllocatedBytes()` is available to native source programs only.

## UEFI boundary

`--target uefi-x64` does not provide this Linux API table. Its entry point
accepts `System.Console.WriteLine` with ASCII literals and selected built-ins:

| Call | Purpose |
| --- | --- |
| `System.Uefi.ClearScreen()` | Clear the firmware text console before output |
| `System.Uefi.Await()` | Wait for and consume a key after console output |
| `System.Uefi.StartImage("\\EFI\\KERNEL.EFI")` | Launch one EFI image from the boot volume |
| `System.Uefi.ExitBootServices()` | Capture the final memory map and leave firmware services |
| `System.Kernel.MemoryMap.Initialize()` | Initialize the captured map |
| `System.Kernel.Memory.Initialize()` | Reserve early physical pages |
| `System.Kernel.VirtualMemory.Initialize()` and `ApplyPolicy()` | Take ownership of four-level page tables |
| `System.Kernel.Memory.AllocatePage()` | Reserve and zero a 4 KiB page |
| `System.Kernel.Heap.Initialize()` and `Allocate(<literal>)` | Initialize the early heap and allocate 1 byte to 1 MiB |
| `System.Kernel.Framebuffer.Initialize()` and `WriteLine("literal")` | Capture GOP and write printable ASCII after boot services |
| `System.Kernel.Halt()` | Stop kernel initialization |

The kernel calls form a fixed sequence and are not general-purpose runtime
functions. See [UEFI Hello World and kernel handoff](/getting-started/uefi-hello/)
for a compilable example and ordering. UEFI output does not support file I/O,
the Linux GC, or arbitrary input handling.
