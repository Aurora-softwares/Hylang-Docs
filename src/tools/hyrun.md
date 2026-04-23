# hyrun

`hyrun` is the Hylang interpreter. It executes `.hy` source files and `.hyproj` project files directly without a compilation step.

## Usage

```
hyrun <file.hy | project.hyproj> [args...]
```

## Examples

```bash
# Run a single script
build/hyrun hello.hy

# Run a multi-file project
build/hyrun MyApp.hyproj

# Pass arguments to Main
build/hyrun greet.hy World
```

## Notes

- Arguments after the file path are accessible in `string[] args` inside `Main`.
- `hyrun` and `hyc` share the same semantic pipeline, so behavior should be consistent between interpreted and compiled output.
