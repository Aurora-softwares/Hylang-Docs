# Building the Compiler

## Prerequisites

- A C++20-capable compiler (`g++`, `clang++`, or MSVC)
- CMake 3.15+ (recommended), or build manually

## With CMake

```bash
cmake -S . -B build
cmake --build build
ctest --test-dir build --output-on-failure
```

## Without CMake

```bash
mkdir -p build

# Build hyrun (interpreter/runner)
c++ -std=c++20 -Wall -Wextra -Wpedantic -Iinclude \
    src/hylang.cpp src/hyrun_main.cpp -o build/hyrun

# Build hyc (compiler)
c++ -std=c++20 -Wall -Wextra -Wpedantic -Iinclude \
    src/hylang.cpp src/hyc_main.cpp -o build/hyc
```

Both `build/hyrun` and `build/hyc` will be produced.
