# Phase 6 Self-Hosted Compiler

Phase 6 is the real self-hosting effort. The C++ compiler remains the trusted stage0 builder and oracle while the Hydrogen-written compiler grows toward a complete stage1 compiler.

## Current Foundation

The Phase 6 workspace lives at `samples/self_hosting` in the compiler repo. It now includes:

- `Hydrogen.Compiler.Binding` for the first Hydrogen-owned checker path.
- `Hydrogen.Compiler.IR` for the first compiler IR object model.
- `Hydrogen.Compiler.RuntimeModel` for the native runtime contract surface.
- `Hydrogen.Compiler.CodeGen.X64` for direct Linux x64 ELF byte writing.
- `Hydrogen.Compiler.Cli` with `tokens`, `parse`, `check`, `compile`, and a reserved `stage-compare` interface.

The native backend is intentionally tiny today. It recognizes a `System.Console.WriteLine("...")` proof program, lowers it to a small IR object, and writes a Linux x64 ELF executable directly from Hydrogen code. It does not emit C and does not call a C compiler, assembler, or linker.

## Commands

```bash
./build/hy run samples/self_hosting/Hydrogen.Compiler.Cli/Hydrogen.Compiler.Cli.hyproj -- check tests/phase6/native_hello.hy
./build/hy run samples/self_hosting/Hydrogen.Compiler.Cli/Hydrogen.Compiler.Cli.hyproj -- compile tests/phase6/native_hello.hy -o build/native_hello
chmod +x build/native_hello
./build/native_hello
```

The generated executable prints:

```text
Hydrogen native hello
```

## Still To Do

Phase 6 is complete only when Hydrogen can compile itself. The remaining work includes:

- broad binding and type checking
- a managed runtime clone for strings, arrays, classes, static fields, calls, and file IO
- native codegen for compiler-shaped programs
- stage0 building stage1
- stage1 building stage2
- stage1/stage2 diagnostics and runtime behavior matching on a shared corpus

The bootstrap compiler should remain in-tree as the historical seed and fallback after promotion.
