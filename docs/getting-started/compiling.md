# Building an Executable

`hyc build` compiles Hylang source to a native binary through the C backend.

## Compile a single file

```bash
build/hyc build tests/hello_world.hy -o build/hello_world
./build/hello_world
```

## Compile a project

```bash
build/hyc build tests/projects/app/App.hyproj -o build/demo_app
./build/demo_app
```

## Compile the runtime proof project

```bash
build/hyc build samples/managed_collections/ManagedCollections.hyproj -o build/managed_collections
./build/managed_collections
```

## Build a static library

```bash
build/hyc build tests/projects/mathlib/Math.hyproj --target lib -o build/libmathlib.a
```

## Notes

- The C backend emits a single C translation unit that is compiled and linked by the host C compiler.
- Compiled output now uses an in-tree non-moving mark-sweep GC with managed strings and arrays.
- `HYLANG_GC_STRESS=1` forces collection at runtime safe points, and `HYLANG_GC_THRESHOLD=<bytes>` lowers or raises the compiled-runtime collection threshold.
