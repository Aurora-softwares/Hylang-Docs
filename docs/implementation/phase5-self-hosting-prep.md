# Phase 5 Self-Hosting Preparation

Phase 5 prepared Hydrogen to write its own compiler incrementally. It did not replace the C++ bootstrap compiler.

## Delivered Prototype

The Phase 5 proof workspace lives in the compiler repo at `samples/self_hosting`:

- `Hydrogen.Compiler.Core` provides source text, text spans, locations, and diagnostics.
- `Hydrogen.Compiler.Syntax` provides syntax kinds, syntax tokens, syntax nodes, syntax trees, a lexer, and a parser.
- `Hydrogen.Compiler.Cli` exposes `tokens <file>` and `parse <file>`.
- `Hydrogen.Compiler.Tests` validates the prototype from Hydrogen code.

The parser prototype is syntax-only. It handles usings, namespaces, classes, structs, interfaces, enums, members, parameters, blocks, statements, and core expressions, but it does not bind, type-check, lower IR, emit code, or self-compile.

## Bootstrap Compiler Contract

The trusted C++ compiler still owns the real pipeline:

- lexing
- parsing
- semantic model construction
- binding and type checking
- bound IR
- interpreter execution
- C backend emission
- runtime support

The Hydrogen frontend mirrored the lexer/parser side first because it was the safest path into self-hosting. Phase 6 now uses these libraries as the foundation for binding, typed IR, native backend integration, and eventually self-compilation.

## Proof Commands

```bash
./build/hy build samples/self_hosting/Hydrogen.Compiler.hyproj
./build/hy test samples/self_hosting/Hydrogen.Compiler.hyproj
./build/hy run samples/self_hosting/Hydrogen.Compiler.Cli/Hydrogen.Compiler.Cli.hyproj -- tokens tests/hello_world.hy
./build/hy run samples/self_hosting/Hydrogen.Compiler.Cli/Hydrogen.Compiler.Cli.hyproj -- parse tests/hello_world.hy
```

Phase 5 is complete at prototype scope when the workspace builds, tests, format-checks, check-runs, and matches golden token/parse fixtures.
