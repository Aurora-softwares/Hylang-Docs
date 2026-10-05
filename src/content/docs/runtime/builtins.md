---
title: Builtin APIs
description: Console, file, conversion, and garbage-collection services in Linux-native output.
---

These services are implemented by the released compiler's Linux-native runtime.
Use the fully qualified names shown here.

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

`ToInt32` returns Hydrogen's 64-bit `int`. Malformed/out-of-range values and failed
I/O terminate the application with an error. `WriteLine()` accepts no argument for
an empty line. `Console.ReadLine` is not implemented.

## GC diagnostics

| Call | Result | Meaning |
| --- | --- | --- |
| `System.Runtime.GC.Collect()` | `void` | Force collection and release cached free pages |
| `System.Runtime.GC.GetAllocatedBytes()` | `int` | Active managed mapping bytes, excluding cached free pages |

## UEFI boundary

`--target uefi-x64` does not provide this Linux API table. It only emits
`System.Console.WriteLine` calls with ASCII literals from the static entry point.
It has no `Write`, files, conversion, GC, memory, or input support yet.
