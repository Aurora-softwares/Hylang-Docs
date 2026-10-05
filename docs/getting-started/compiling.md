# Compile an executable

Commands assume the compiler repository root. First [build the tools](building.md) and create the `hello.hy` program from the [running guide](running.md).

## Direct native compilation

```bash
./build/self_hosting/hydrogen-stage1 check hello.hy
./build/self_hosting/hydrogen-stage1 compile hello.hy -o build/hello
chmod +x build/hello
./build/hello Hydrogen
```

The compiler writes Linux x86-64 ELF directly. It needs no external compiler, assembler, or linker. Set execute permission on its output before running.

For an executable project:

```bash
./build/self_hosting/hydrogen-stage1 build tests/phase6/static_calls/App.hyproj -o build/app
chmod +x build/app
./build/app
```

This test application deliberately returns `42`. Project references supply sources to one combined compilation; the native CLI does not produce standalone library archives or build workspace manifests. See [projects](../tools/projects.md).

## SDK compilation through C

```bash
./build/hy build hello.hy -o build/hello-sdk
./build/hello-sdk Hydrogen
./build/hy build tests/projects/mathlib/Math.hyproj --target lib -o build/libmath.a
```

`hy build` uses the host C toolchain and supports the broader SDK language. `hyc build` is its compatibility compilation entry point. SDK `--debug` writes `.hymap.json` metadata alongside an artifact; C-backed runtime failures include source locations. These options are not native CLI flags.

## Diagnostics and IR

```bash
./build/self_hosting/hydrogen-stage1 check hello.hy --emit-ir
./build/hy check hello.hy --json
```

Native `check --emit-ir` prints bound executable IR for inspection. It does not create a runnable debug ELF. Semantic native diagnostics use `1:1` when AST node spans are unavailable; lexer/parser diagnostics retain source positions.

Native `compile` and `build` fail with nonzero status on invalid or unsupported code. Failure does not create or overwrite the requested output. An older artifact can still exist, so only execute after a successful compilation. A successful `check` can still be followed by a backend rejection; consult the [support table](compiler-options.md).
