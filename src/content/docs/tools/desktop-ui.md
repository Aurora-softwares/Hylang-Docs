---
title: Desktop applications with HYUI
description: Responsive XML views, desktop controls, and Hydrogen event handlers.
---

The Development checkout includes an optional desktop UI host, `hyui`, and the
Hydrogen-written `Hydrogen.UI` library. A `.hyui` file describes the frontend;
`Program.hy` selects the view and handles events. This is an experimental HYUI v1
API, separate from the published `alpha-0.0.2` compiler. It does not change the
development project's `0.1.0` release qualification milestone.

## Build and run

The build tools use Qt **Core 6.8 or newer** for XML, processes, and events;
Qt Test enables contract tests. Qt does not render the application's windows or
controls. Linux uses system GTK 4 and libadwaita (1.4+); macOS uses AppKit;
Windows uses Microsoft's WinUI 3 and requires the .NET 8+ SDK to build its host.
The compiler itself does not require a desktop SDK.

```bash
cmake -S . -B build -DHYDROGEN_BUILD_UI=ON -DCMAKE_BUILD_TYPE=Release
cmake --build build --target hy hyui hyui_tests -j 4
export PATH="$PWD/build:$PATH"
hy build samples/ui_studio/Studio.hyproj -o build/HydrogenStudio

# Double-click HydrogenStudio in your file manager, or run it directly:
./build/HydrogenStudio

# A single-file entry point automatically gets the bundled Hydrogen.UI library.
hy ui samples/ui_studio/Program.hy
```

For a project, reference
`libraries/Hydrogen.UI/Hydrogen.UI.hyproj` through `project_references`. The host
uses the sibling `hy` compiler, then `hy` on PATH. To select a self-hosted compiler,
set `HYUI_COMPILER` to its absolute path, or invoke
`hyui --compiler /path/to/hy --source /path/to/Program.hy`.
The native compiler requires `hyui` on PATH at build time. `cmake --install build`
installs the host tools and launcher templates. Published compiler archives do not
yet include these development tools.

## Building an application you can double-click

Add the entry view to a normal executable project:

```toml
format = 2
name = "MyApplication"
type = "exe"
ui = "Views/Main.hyui"
ui_assets = ["Assets"]
sources = ["Program.hy"]
project_references = ["../libraries/Hydrogen.UI/Hydrogen.UI.hyproj"]
```

`ui_assets` is optional. The entry view is always included. Assets must stay inside
the project directory; traversal paths and symlinks are rejected. The compiler
builds the Hydrogen backend and packages its native host and view automatically:

```bash
hy build MyApplication.hyproj -o MyApplication
hy build MyApplication.hyproj --target linux -o MyApplication
hy build MyApplication.hyproj --target windows -o MyApplication.exe
hy build MyApplication.hyproj --target macos -o MyApplication.app
```

Linux produces an ELF launcher and `MyApplication.runtime/`; Windows produces a
GUI `.exe` launcher and `MyApplication.exe.runtime/`; macOS produces a Finder
`.app` bundle. **Keep the runtime folder beside the executable** when copying or
distributing Linux/Windows applications. These are complete application folders,
not single-file static binaries. The executable locates its assets independently
of the terminal's working directory, and does not invoke `hy`, compile sources,
or require Hydrogen on the destination device. Ordinary projects without `ui`
retain their existing build behavior.

Builds stage the package before replacing the output. Invalid XML, missing assets,
compiler errors, or a missing target runtime preserve the previous application.
Rebuilds only replace runtime directories marked as Hydrogen packages.

The development backends currently emit **x86-64** applications. A cross-build
needs both the native compiler's target backend and an exported native runtime
for that platform. Run on the corresponding target system:

```bash
hyui --export-runtime /path/to/runtimes/linux-x64
# On Windows, with .NET and Windows App SDK development prerequisites:
hyui --export-runtime C:/runtimes/windows-x64
# On an Intel Mac, with macdeployqt available:
hyui --export-runtime /path/to/runtimes/macos-x64.app
```

Set `HYUI_RUNTIME_ROOT` to that runtimes directory on the build machine. The native
compiler can then select the matching exported runtime. A missing or mismatched
runtime fails clearly; a Qt Fluent/macOS lookalike is never substituted. The C++
SDK's backend remains a host-native C route; use the self-hosted compiler for
cross-target code generation. Windows runtime export restores/builds the genuine
Microsoft WinUI host using its pinned Windows App SDK dependency.

## Small application

`Program.hy`:

```csharp
using Hydrogen.UI;

class Program {
    public static int Main(string[] args) {
        if (!Application.IsEvent(args)) {
            Application.Open("Main.hyui");
            return 0;
        }
        if (Application.Handler(args) == "Greet") {
            Application.SetText("greeting", "Hello, " + Application.Value(args, "name"));
        }
        return 0;
    }
}
```

`Main.hyui` (beside `Program.hy`):

```xml
<Window version="1" title="My Hydrogen app" width="900" height="650">
  <Panel title="Welcome">
    <RowPanel breakpoint="600">
      <Input id="name" placeholder="Your name" accessibleName="Your name" />
      <Button id="greet" text="Say hello" onClick="Greet" />
    </RowPanel>
    <Label id="greeting" text="Make yourself at home." />
  </Panel>
</Window>
```

Run `hy ui Program.hy`. The host compiles the backend to a temporary executable,
runs `Main`, resolves `Application.Open` relative to the source directory, and
creates the window. `--backend /path/to/executable` also supports a precompiled
app: its view is relative to the executable directory, or can be supplied with
`--document`. Ship the compiled backend and its `.hyui` files together.

## Elements

Common visual-control attributes: `id`, `visible`, `enabled`, `fill`, `preferredWidth`, and
`accessibleName`. IDs are unique identifiers (letters, digits, underscores;
starting with a letter or underscore). Text remains plain text, including backend
responses. Standard XML escaping applies, for example `&amp;` and `&#10;`.

| Element | Attributes and behavior |
| --- | --- |
| `Window` | Required `version="1"`; `title`, logical-pixel `width`/`height`, `padding`, `theme="system\|light\|dark"`, `material="auto\|glass\|solid"`, `onLoad` |
| `ColumnPanel` | Vertical stack; `gap` |
| `RowPanel` | Horizontal layout that stacks below its local `breakpoint` (default 700); `gap`. Set breakpoint 0 to keep a compact row horizontal. |
| `GridPanel` | Up to `columns` (default 3), reducing automatically according to `minItemWidth` (default 240); `gap` |
| `Panel` | Card with optional `title`, `padding`, `gap`; contents stack vertically |
| `SplitView` | Two visual child panes, native draggable divider; `height`, pixel-valued `value` (default 260), `onChange` |
| `Label` | `text`, `role="title\|heading\|body\|caption"`, `tone="normal\|muted\|accent"`; wraps to available width |
| `Input` | `text`, `placeholder`, `onChange`, `onSubmit` |
| `TextArea` | `text`, `placeholder`, preferred `height`, `onChange`; wraps text |
| `Button` | `text`, `primary`, `onClick` |
| `ToggleButton` | `text`, `checked`, `onChange`; native stateful press-button, reflected in Hydrogen event snapshots |
| `CheckBox`, `Switch` | `text`, `checked`, `onChange` |
| `ValidationMessage` | `text`, `severity="error\|warning\|info\|success"`; native text feedback with severity styling |
| `StatusBar` | Native status text, `text`, editable with Hydrogen `SetText` |
| `Select` | Pipe-separated `items`, zero-based selected index `value`, `onChange` |
| `NumberInput`, `Slider` | Integer `value`, `minimum`, `maximum`, `onChange` |
| `ProgressBar` | `value`, `minimum`, `maximum` (defaults 0–100), `indeterminate` |
| `Spinner` | `running`; animated activity indicator |
| `Separator`, `Spacer` | Divider or vertical space (`height`) |
| `Timer` | `interval` in milliseconds (minimum 100), `running`, required `onTick` |
| `State` | Nonvisual `value` available to Hydrogen handlers |

Numeric attributes use nonnegative integers up to 32767. Width, height, columns,
and minimum item width must be positive. Boolean attributes use `true`/`false`.
Unknown elements/attributes, duplicate IDs, unsupported versions, malformed XML,
DTD/entities, excessive nesting, and oversized documents fail before a window is
shown. There is no embedded JavaScript, QML, HTML, or shell-script element.


### New development controls: stateful buttons and validation feedback

The `Development` compiler's [HYUI control addition PR #196](https://github.com/Aurora-softwares/Hylang-Compiler/pull/196) introduces native `ToggleButton` and `ValidationMessage` elements for GTK4, WinUI 3 and AppKit. Both are implemented in `Development` and passed native GTK4, WinUI 3, AppKit and bootstrap checks in [CI run 41843955763](https://github.com/Aurora-softwares/Hylang-Compiler/actions/runs/41843955763). They remain **unreleased experimental features** until a compiler release includes them.

```xml
<ToggleButton id="advanced" text="Enable advanced tools" checked="false" onChange="ToggleAdvanced" />
<ValidationMessage id="advancedMessage" severity="info" text="Advanced tools disabled" />
```

A Hydrogen handler can read `Application.Value(args, "advanced")` as `"true"` or `"false"`, and update either control using `Application.SetChecked` or `Application.SetText`. Severity is fixed in the XML document for v1; the message's visibility and text can change at runtime.

### Resizable IDE panes and status feedback (Development)

The [SplitView and StatusBar implementation PR #197](https://github.com/Aurora-softwares/Hylang-Compiler/pull/197) adds two experimental HYUI elements. `SplitView` accepts **exactly two visual children** and uses a real GTK4 `GtkPaned`, AppKit `NSSplitView`, or WinUI `Grid` with draggable `Thumb`. The divider position is a **pixel count**, available as `Application.Value(args, "workspaceSplit")` in its `onChange` handler. Hydrogen can also set the position with `Application.SetValue`. `StatusBar` text can be changed with `Application.SetText`.

```xml
<SplitView id="workspaceSplit" value="280" height="320" onChange="PaneResized">
  <Panel title="Explorer"><Label text="Project files" /></Panel>
  <Panel title="Editor"><Label text="Choose a file" /></Panel>
</SplitView>
<StatusBar id="workspaceStatus" text="Ready" />
```

The proposed controls remain **unreleased** and need complete CI before claiming production cross-platform parity. Initial SplitView supports the horizontal (left/right) arrangement; vertical splits, nested IDE docking, persistent splitter positions, and closeable editor tabs remain future work.

## Hydrogen handlers and updates

`Application.IsEvent(args)`, `Handler(args)`, and `Sender(args)` identify the
callback. `Application.Value(args, id)` returns the control's text, selected
index, numeric value, checked state, or nonvisual state value. It returns an empty
string for an unknown ID. For numeric values use `System.Convert.ToInt32`.

Use `SetText`, `SetValue`, `SetChecked`, `SetEnabled`, `SetVisible`, and
`SetRunning`; `Set(id, property, stringValue)` also supports `indeterminate` and
string-valued `State.value`. A response is validated and applied as one batch;
invalid responses preserve the previous UI state. Only registered control
properties and XML-declared handlers can be used.

Each callback runs the **same compiled Hydrogen backend in a fresh process**.
Static fields are not persistent application state. Use control values, `State`,
or explicit backend file storage. The host dispatches asynchronously and serially,
captures the latest values when each queued event starts, and coalesces duplicate
pending events. Do long work as short steps driven by a timer so the UI stays
responsive. Handlers have a 10-second timeout, a 1 MiB stdout limit, a 64 KiB
stderr limit, and a 24000-character value snapshot limit. Errors appear in the
window. Backend arguments use an argument vector, so input text is not shell code.
The Windows host implements the same wire protocol; its rendering and diagnostic
options still need a real Windows validation pass.

The version 1 wire protocol uses tab-separated `HYUI OPEN path` and
`HYUI SET id property value` records. Tabs, newlines, carriage returns, and literal
percent signs are escaped as `%09`, `%0A`, `%0D`, `%25`. Other console output is
ignored by the host. Normal application errors should return a nonzero exit code.

## Responsive behavior and platform appearance

Layouts use available width, rows collapse, grids reduce columns, and the root
view scrolls vertically. Native frameworks handle fonts and display scaling;
the host and compositor constrain windows to the monitor. Test narrow windows,
large system fonts, and multiple monitor configurations. `preferredWidth` remains
a layout hint rather than a fixed minimum; native backends may allocate space
differently.

| Platform | Actual controls and window chrome |
| --- | --- |
| GNOME Linux | System GTK 4/libadwaita: `GtkEntry`, `GtkButton`, `GtkDropDown`, `GtkSwitch`, etc. `AdwWindow` and `AdwHeaderBar` provide the real native window controls and follow the system's button layout. |
| macOS | Real `NSWindow`, `NSButton`, `NSTextField`, `NSSwitch`, `NSProgressIndicator`, etc. AppKit supplies the traffic-light buttons. Public `NSGlassEffectView` is used on macOS 26+, with `NSVisualEffectView` fallback and Reduce Transparency support. |
| Windows | Real `Microsoft.UI.Xaml` WinUI 3 controls. The standard Windows caption bar is retained, including its system menu, close, minimise and maximise controls. |

The old Qt Quick/Fusion and Qt-rendered Fluent preview is superseded. Packaged
apps do not ship Qt Quick styles. GNOME apps load GTK/libadwaita from the OS rather
than bundling a frozen copy, so system toolkit/theme updates reach their controls.
GNOME's [native header bar](https://gnome.pages.gitlab.gnome.org/libadwaita/doc/main/class.HeaderBar.html)
owns window-button rendering and layout. Linux desktops differ; a KDE-specific
Qt Widgets/Breeze backend is not implemented yet.

AppKit controls follow the system frameworks. WinUI 3 is Microsoft's actual
toolkit, but [Windows App SDK versions are independent of Windows](https://learn.microsoft.com/en-us/windows/apps/get-started/versioning-overview):
an OS update alone cannot guarantee every new WinUI appearance. The Windows host
uses the shared Windows App Runtime, which must be installed on the destination;
the .NET runtime itself is bundled. Microsoft documents this
[unpackaged WinUI deployment model](https://learn.microsoft.com/en-us/windows/apps/package-and-deploy/unpackage-winui-app).

Real Windows and macOS build/rendering, Liquid Glass composition, accessibility,
signing/notarisation, and portable distribution remain platform release gates.
This desktop host is separate from Australis's freestanding runtime.

## Demo and validation

`samples/ui_studio` is a functioning project-plan editor: inputs update a summary,
a cancellable timer drives progress, and Save writes the plan and notes to the
requested file. The demo's progress creates a plan; it does not invoke a compiler
build or implement desktop notifications.

```bash
ctest --test-dir build -R '^hyui_' --output-on-failure
hyui --document samples/ui_studio/Studio.hyui --validate
hyui --source samples/ui_studio/Studio.hyproj --size 1120x900 --screenshot build/studio.png
hyui --source samples/ui_studio/Program.hy --size 360x740 --screenshot build/studio-narrow.png
```

The screenshot command captures the actual native application. The host's
`--event Handler:sender` and `--state-output path.json` options support deterministic
integration checks on Linux. GTK tests require a display; run them under
`xvfb-run` in headless CI. Native GUI tests explicitly skip when no display is
available; Qt Core contract tests still run. Linux screenshot capture can use
`GSK_RENDERER=cairo` for deterministic software rendering without changing the
toolkit's native controls.

Local verification on 30 October 2026 passed Qt Core contract tests, SDK and
self-hosted native demo/package integration, relocation to paths containing spaces
and quotes, source-free startup with Hydrogen removed from PATH, real GTK window
captures, callbacks, cancellation, completion, file saving and failure preservation.
The documentation build also passes, and updated native stage 2/3 compiler
binaries have matching SHA-256 hashes. The earlier 29 October standard
`hydrogen_stage1` target exceeded its 90-second SDK seed-build timeout on this
host; development validation uses a retained native seed. These are targeted UI
checks, not qualification of the full compiler release suite.

Linux packages depend on the destination's GTK 4/libadwaita and base C/C++ runtime.
Build on the oldest Linux distribution baseline you intend to support; bundling
nonvisual Qt Core support does not make a Linux binary compatible with older
system ABIs. macOS and Windows builds/rendering remain unverified on this Linux
development host.
