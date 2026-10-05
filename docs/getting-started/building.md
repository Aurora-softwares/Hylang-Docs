# Build the tools

Run these commands from a checkout of [Hylang-Compiler](https://github.com/Aurora-Softwares/Hylang-Compiler).

## Requirements

The SDK needs CMake 3.20 or newer and a C++20 compiler. C-backed executable builds need a host C compiler; static libraries additionally need an archiver. The native compiler and its generated executables target Linux x86-64. The bootstrap proof uses CMake as a test driver and `prlimit` to bound memory.

## Build the SDK and native compiler

```bash
cmake -S . -B build
cmake --build build
cmake --build build --target hydrogen_stage1
```

The SDK produces `build/hy`, `build/hyrun`, and `build/hyc`. The native target uses the SDK's C backend to seed a Hydrogen CLI, then that CLI compiles its own project/reference closure with the Hydrogen x64 backend. It publishes `build/self_hosting/hydrogen-stage1` after token/parser checks and a compile/run smoke test.

The published native compiler does not invoke a C/C++ compiler, assembler, or linker when building supported programs.

## Manual SDK build

```bash
mkdir -p build
c++ -std=c++20 -Wall -Wextra -Wpedantic -Iinclude src/hylang.cpp src/hy_main.cpp -o build/hy
c++ -std=c++20 -Wall -Wextra -Wpedantic -Iinclude src/hylang.cpp src/hyrun_main.cpp -o build/hyrun
c++ -std=c++20 -Wall -Wextra -Wpedantic -Iinclude src/hylang.cpp src/hyc_main.cpp -o build/hyc
```

## Rebuild from a native seed

Keep a verified native compiler outside the output directory before rebuilding:

```bash
cp build/self_hosting/hydrogen-stage1 build/hydrogen-seed
./build/hydrogen-seed build samples/self_hosting/Hydrogen.Compiler.Cli/Hydrogen.Compiler.Cli.hyproj -o build/hydrogen-rebuilt
chmod +x build/hydrogen-rebuilt
```

This rebuild needs no C++ sources or host C toolchain. A source-only checkout needs either an existing seed binary or the initial SDK bootstrap route. The native compiler does not replace the SDK's additional language features and tools.

Compiler contributors can run `ctest --test-dir build --output-on-failure` and `cmake --build build --target hydrogen_bootstrap_proof`. See the [bootstrap architecture](../implementation/phase6-self-hosted-compiler.md) for the repeated self-compilation checks.
