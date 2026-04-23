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

## Build a static library

```bash
build/hyc build tests/projects/mathlib/Math.hyproj --target lib -o build/libmathlib.a
```

## Notes

- The C backend emits a single C translation unit that is compiled and linked by the host C compiler.
- Allocations made during a run are released at process shutdown; a proper GC integration is planned for a later phase.
