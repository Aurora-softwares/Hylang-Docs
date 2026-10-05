# hyrun

`hyrun` is the C++ SDK compatibility interpreter. The equivalent SDK workflow is `hy run <target> -- args...`. It executes `.hy` source files and `.hyproj` project files directly without a compilation step.

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
- `hyrun` and `hyc` share parsing/binding. The interpreter evaluates both sides of `&&`/`||`; generated C and direct native output short-circuit. Use explicit guards when sharing code.
- `hyrun` can run both single-file scripts and multi-file `.hyproj` sample projects.

The [native compiler](hydrogen.md) has no interpreted run command; compile a supported program and execute its ELF output.
