---
title: UEFI Hello World and kernel handoff
description: Compile a PE32+ EFI application and explore the alpha-0.0.2 kernel sequence.
---

Hydrogen `alpha-0.0.2` can produce a UEFI boot application and a constrained
early-kernel image. Both are PE32+ EFI applications for x86-64 firmware. The
target compiles a fixed set of literal entry-point operations; it is not a
general-purpose UEFI runtime.

## Compile the EFI application

Create `uefi_hello.hy`:

```csharp
public class Program {
    public static void Main(string[] args) {
        System.Console.WriteLine("Hello from Hydrogen UEFI!");
    }
}
```

```bash
hy compile uefi_hello.hy --target uefi-x64 -o BOOTX64.EFI
file BOOTX64.EFI
```

`file` should identify a PE32+ EFI application. Place it at
`EFI/BOOT/BOOTX64.EFI` on a FAT EFI system partition. It runs under firmware,
not as a Linux executable.

## Firmware console and image launch

The bootloader entry point can clear the console before output, wait for a key
after output, and start one EFI image from the same boot volume:

```csharp
public class Program {
    public static void Main(string[] args) {
        System.Uefi.ClearScreen();
        System.Console.WriteLine("Press a key to boot.");
        System.Uefi.Await();
        System.Uefi.StartImage("\\EFI\\KERNEL.EFI");
    }
}
```

The image path is an ASCII literal. This profile does not support arbitrary
statements or method bodies.

## Early kernel sequence

A separately compiled kernel EFI image can leave boot services and use early
physical-memory, virtual-memory, heap, and framebuffer operations. These calls
must appear in the supported order:

```csharp
public class Program {
    public static void Main(string[] args) {
        System.Console.WriteLine("Starting kernel.");
        System.Uefi.ExitBootServices();
        System.Kernel.MemoryMap.Initialize();
        System.Kernel.Memory.Initialize();
        System.Kernel.VirtualMemory.Initialize();
        System.Kernel.VirtualMemory.ApplyPolicy();
        System.Kernel.Heap.Initialize();
        System.Kernel.Framebuffer.Initialize();
        System.Kernel.Framebuffer.WriteLine("Kernel framebuffer active.");
        System.Kernel.Halt();
    }
}
```

`ExitBootServices()` captures the final UEFI memory map and retries with a fresh
map key when needed. The kernel then reserves conventional memory, installs its
own four-level page tables, and can display printable ASCII through a supported
32-bit RGB or BGR GOP framebuffer. The early heap is a zero-filled, 16-byte
aligned bump allocator; it does not free allocations. Optional
`System.Kernel.Memory.AllocatePage()` calls go after `ApplyPolicy()` and before
`Heap.Initialize()`. Optional `System.Kernel.Heap.Allocate(<literal>)` calls go
after `Heap.Initialize()` and accept literal sizes from 1 byte through 1 MiB.

This path does not provide general object allocation, files, an ordinary
keyboard API, or arbitrary calls after the handoff. A bootloader that calls
`StartImage()` cannot also call `ExitBootServices()`.

## Build an OS project

An `os` manifest can reference separate `efi` and `kernel` projects. Each child
declares an `output` path under the build directory. See
[Projects and references](/tools/projects/) for the manifest format and `hy build`
command. Packaging those images onto boot media is a separate step.
