# Projects and references

A `.hyproj` manifest lists sources compiled together. Paths are relative to the manifest's directory, including paths to referenced projects.

## An executable and a library

Directory layout:

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

`Math/Math.hy`:

```hylang
namespace DemoMath {
    public class Numbers {
        public static int Twice(int value) { return value * 2; }
    }
}
```

`App/Program.hy`:

```hylang
using DemoMath;
public class Program {
    public static int Main() {
        System.Console.WriteLine(Numbers.Twice(21));
        return 0;
    }
}
```

Build with the release compiler:

```bash
"$HYDROGEN" build Demo/App/App.hyproj -o Demo/app
chmod +x Demo/app
./Demo/app
```

This prints `42`. The native compiler registers types across the complete source/reference closure before checking bodies. Imports remain local to each source file; qualifying a type with its namespace avoids ambiguous simple names. Referenced libraries contribute sources to the final executable rather than separately linked artifacts.

## Current project boundary

The released compiler accepts format-2 executable projects and `project_references`
only. It does not build workspaces, test projects, standalone library archives,
packages, or dependency registries. Referenced `type = "lib"` projects are a
source-organization feature: their source is compiled into the final executable.

Write `project_references`, rather than older `references` fields, in new projects.
