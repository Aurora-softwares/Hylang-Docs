---
title: Projects and references
description: Organize executable Hydrogen projects and source references.
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
separately linked artifacts. The released compiler does not build workspaces, test
projects, standalone library archives, packages, or dependency registries.
