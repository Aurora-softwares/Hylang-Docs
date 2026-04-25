# Running a Script

`hyrun` interprets `.hy` source files and `.hyproj` project files directly — no compilation step needed.

## Run a single file

```bash
build/hyrun tests/hello_world.hy
```

## Run a project

```bash
build/hyrun tests/projects/app/App.hyproj
```

You can also run the shipped proof projects directly:

```bash
build/hyrun samples/mini_frontend_model/MiniFrontendModel.hyproj
build/hyrun samples/managed_collections/ManagedCollections.hyproj
```

## Pass arguments

Command-line arguments after the file path are forwarded to `Main`:

```bash
build/hyrun myscript.hy arg1 arg2
```

Inside Hylang, read them through `string[] args` on your `Main` method.

`hyrun` follows the same parser, binder, and type-checker pipeline as `hyc build`, so the interpreted path is meant to stay aligned with compiled behavior.
