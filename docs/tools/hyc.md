# hyc

`hyc` is the C++ SDK compatibility compiler. It compiles `.hy` files and `.hyproj` projects to native binaries via a C backend.

## Usage

```
hyc build <file.hy | project.hyproj> [options]
```

## Options

| Option | Description |
|--------|-------------|
| `-o <path>` | Output path for the binary or library |
| `--target lib` | Build a static library (`.a`) instead of an executable |

## Examples

```bash
# Compile a single file to an executable
build/hyc build hello.hy -o build/hello
./build/hello

# Compile a project
build/hyc build MyApp.hyproj -o build/myapp
./build/myapp

# Build a static library
build/hyc build Math.hyproj --target lib -o build/libmath.a
```

## How it works

1. The source is parsed, bound, and type-checked by the shared compiler pipeline.
2. The bound IR is lowered to a single C translation unit.
3. The host C compiler (`cc`) is invoked to produce the final binary.

The SDK uses the C backend. The separate [Hydrogen native compiler](hydrogen.md) emits Linux x64 ELF directly and has a narrower language/API surface.

## Runtime notes

- Compiled output uses the SDK managed runtime.
- Managed strings and general `T[]` arrays are supported.
- Runtime stress/debug controls:

```bash
HYLANG_GC_STRESS=1 ./build/myapp
HYLANG_GC_THRESHOLD=128 ./build/myapp
```
