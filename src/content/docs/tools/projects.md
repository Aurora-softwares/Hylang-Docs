---
title: Projects and references
description: Organize executable, EFI, kernel, OS, and Australis application projects.
---

A `.hyproj` manifest lists sources compiled together. Paths are relative to the
manifest, including referenced projects.

```text
Demo/
  App/App.hyproj
  App/Program.hy
  Math/Math.hyproj
  Math/Math.hy
```

`App/App.hyproj`:

```toml
format = 2
name = "App"
type = "exe"
sources = ["Program.hy"]
project_references = ["../Math/Math.hyproj"]
```

`Math/Math.hyproj`:

```toml
format = 2
name = "Math"
type = "lib"
sources = ["Math.hy"]
```

Build the executable project:

```bash
hy build Demo/App/App.hyproj -o Demo/app
chmod +x Demo/app
./Demo/app
```

Referenced libraries contribute sources to the final executable; they are not
separately linked artifacts.

## EFI and OS projects

Use `type = "efi"` for a boot image and `type = "kernel"` for a kernel image.
An OS manifest references those projects, and each child declares a relative
`output` path:

```toml
# OS.hyproj
format = 2
name = "Demo.OS"
type = "os"
project_references = ["Boot/Boot.hyproj", "Kernel/Kernel.hyproj"]
```

```toml
# Boot/Boot.hyproj
format = 2
name = "Demo.Boot"
type = "efi"
output = "EFI/BOOT/BOOTX64.EFI"
sources = ["program.hy"]
project_references = []
```

The kernel manifest uses `type = "kernel"` and its own output path, such as
`EFI/KERNEL.EFI`. Build both images into a directory with:

```bash
hy check OS.hyproj
hy build OS.hyproj -o image-root
```

`output` paths must stay below `image-root` and be unique. OS projects contain
references and no direct sources. Both images still use the restricted UEFI
target, described in [UEFI Hello World and kernel handoff](/getting-started/uefi-hello/).
The compiler does not package the result as a bootable ISO.

The CLI can scaffold manifests with `hy new os Demo`, `hy new efi Boot`, and
`hy new kernel Kernel`. Edit the generated manifests to add the OS references.
It does not build workspace or test projects as native outputs, standalone
library archives, packages, or dependency registries.

## Current Australis development projects

The compiler checkout used by the current Australis OS development build adds
`type = "exec"` for AUEX `.exec` applications and emits the OS kernel as a raw
`AUKR` image at `EFI/AUSTRALIS/KERNEL.BIN`. These features are newer than the documented `alpha-0.0.2`
release described above. Use a compiler checkout with this support when building
the current OS tree.

An `exec` manifest uses format 2 and a plain `.exec` output filename:

```toml
format = 2
name = "Example"
type = "exec"
output = "example.exec"
sources = ["Program.hy"]
project_references = []
```

Create one with `hy new exec Example`, or build an existing project with
`hy build Example/Example.hyproj -o example.exec`. An aggregate `os` project
can reference `exec` projects alongside the bootloader and kernel. See
[Australis applications](/tools/australis-applications/) for the supported
entry point and source features.

The current OS also accepts bounded AUN1 native images under `/System/Bin`,
but the Hydrogen `exec` backend emits AUEX, not AUN1. AUN1 is presently built
by the OS's small machine-code test-image tool.
