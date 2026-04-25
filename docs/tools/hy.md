# hy

`hy` is the primary Hylang workflow CLI.

It wraps the current bootstrap compiler/runtime with one entry point for scaffolding, building, running, testing, formatting, checking, and packaging.

## Usage

```text
hy <command> [arguments...]
```

## Commands

- `hy new app|lib|tool|test|workspace <name>`
- `hy build <target> [--target exe|lib] [-o output] [--debug]`
- `hy run <target> [-- args...]`
- `hy test [target]`
- `hy fmt <path...> [--check]`
- `hy check <target> [--json]`
- `hy package pack <target> [-o output]`
- `hy package add <target> <path>`
- `hy package init-registry <path>`
- `hy package publish <project.hyproj> --registry <path>`
- `hy package search <query> --registry <path>`
- `hy package install <target.hyproj> <package-id> [--version <version>] --registry <path>`
- `hy lsp`

## Examples

```bash
# Scaffold a new app
build/hy new app HelloApp

# Build and run a script
build/hy build tests/hello_world.hy -o build/hello_world
./build/hello_world

# Run a project directly
build/hy run samples/hexlab/HexLab.Cli/HexLab.Cli.hyproj -- inspect samples/hexlab/demo.bin

# Check a project and emit machine-readable diagnostics
build/hy check samples/hexlab/HexLab.Cli/HexLab.Cli.hyproj --json

# Format a workspace
build/hy fmt samples/hexlab --check

# Publish and consume a local package
build/hy package init-registry build/local-registry
build/hy package publish samples/sdk_demo/SdkDemo.Core/SdkDemo.Core.hyproj --registry build/local-registry
build/hy package search SdkDemo --registry build/local-registry
```

## Notes

- `hy` is the documented/default CLI for the completed Phase 4 local tooling slice
- `hyrun` and `hyc build` still exist as compatibility shims
- `hy build --debug` emits a `.hymap.json` file next to the generated artifact
- compiled runtime failures now report Hylang file/line/column context, and debug builds keep the matching `.hymap.json` artifact metadata
- `hy check --json` emits diagnostics with severity, file, line, column, and message fields
- workspace/package support is local-first, including filesystem-backed registries
- `hy lsp` provides lightweight diagnostics, document symbols, hover, and formatting over stdio
