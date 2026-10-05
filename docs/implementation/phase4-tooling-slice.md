# SDK project and tooling model

The C++ SDK provides development workflows around its parser, binder, interpreter, and C backend. This page retains its historical URL; user-facing commands are documented under [SDK CLI](../tools/hy.md) and [projects](../tools/projects.md).

## Projects and build cache

Format-2 manifests describe executable, library, test, and workspace projects. Workspaces list members; project references and path dependencies bring library sources into a build. Older manifests remain readable for compatibility.

`hy build` accepts a source, project, or workspace and caches builds under `.hylang/cache/`. Cache inputs include manifests, source hashes, compiler version, target kind, and debug flags. `--debug` additionally emits simple `.hymap.json` artifact/source metadata.

`hy test` runs explicit test projects, falling back to workspace members when no test projects are declared. `hy run` interprets rather than executing a previously built artifact.

## Diagnostics and formatting

`hy check --json` reports severity, file, line, column, and message fields. Besides binding errors, the SDK warns about unused imports/locals/parameters/private members, unreachable statements, shadowed locals, redundant unsafe blocks, statically detectable buffer use-after-free, duplicate dependencies, and invalid metadata.

`hy fmt` formats sources and canonicalizes format-2 manifests; `--check` reports differences without changing files.

## Local packages

The SDK can pack projects and publish/search/install packages using an explicitly supplied filesystem registry. It does not provide a hosted registry, authentication/signing, remote downloads, or semver range solving. `samples/sdk_demo` provides a complete local workflow.

## Editor services

`hy lsp` communicates over stdio and supports diagnostics, document symbols, hover, and formatting. The compiler repository's `tools/vscode/hylang` supplies highlighting, snippets, tasks, a fallback JSON-diagnostic wrapper, and an entrypoint that starts the server. It does not yet implement an LSP client or register VS Code formatting/language providers; use the check/format tasks. Completion, go-to-definition, references, rename, semantic tokens, and full workspace indexing are not implemented.

These tooling services are SDK features, not commands of the direct native Hydrogen CLI.
