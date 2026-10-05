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

Build from the compiler root with `Demo` beneath it:

```bash
./build/self_hosting/hydrogen-stage1 build Demo/App/App.hyproj -o build/demo
chmod +x build/demo
./build/demo
```

This prints `42`. The native compiler registers types across the complete source/reference closure before checking bodies. Imports remain local to each source file; qualifying a type with its namespace avoids ambiguous simple names. Referenced libraries contribute sources to the final executable rather than separately linked artifacts.

## SDK workspaces

The SDK supports format-2 workspaces:

```toml
format = 2
name = "Demo"
type = "workspace"
members = ["App/App.hyproj", "Math/Math.hyproj", "Tests/Tests.hyproj"]
```

Use `type = "test"` for an executable test project. SDK commands:

```bash
./build/hy build Demo/Demo.hyproj
./build/hy test Demo/Demo.hyproj
./build/hy check Demo/Demo.hyproj --json
./build/hy fmt Demo --check
```

`hy test` runs test projects; workspaces without explicit test projects fall back to member projects. A nonzero test exit signals failure. SDK build caching lives under `.hylang/cache/`.

Additional SDK manifest fields include `version`, `[package]` metadata (`id`, `description`, `authors`, `license`), and `[dependencies]` local path entries. For example:

```toml
[dependencies]
Shared = { path = "../Shared/Shared.hyproj" }
```

SDK package commands can publish/search/install from an explicitly supplied filesystem registry; there is no hosted registry or semver range solver. See [SDK commands](hy.md) and the `samples/sdk_demo` example in the compiler repository.

The SDK also reads older manifests using `references`; write format-2 `project_references` for native-compatible projects. Native `build` accepts executable projects, not workspaces or standalone library builds, and does not implement SDK package resolution.
