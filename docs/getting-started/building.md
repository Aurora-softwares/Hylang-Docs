# Build with Hydrogen

For normal development, start with the released self-hosted compiler. See
[Install the released compiler](installing.md). No C++ compiler, host C
compiler, assembler, or linker is used when Hydrogen compiles its supported
programs.

## Compile a source file

```bash
export HYDROGEN=/path/to/hydrogen-stage1
"$HYDROGEN" check hello.hy
"$HYDROGEN" compile hello.hy -o hello
chmod +x hello
./hello
```

The default output is a standalone Linux x86-64 ELF executable. `check` is a
fast way to find syntax and type errors; `compile` is still the final authority
because it rejects language features the current backend does not emit.

## Build a project

For an executable `.hyproj` project:

```bash
"$HYDROGEN" build app/App.hyproj -o app/bin/app
chmod +x app/bin/app
./app/bin/app
```

Executable project references contribute their source files to one native
compilation. The current release does not produce library archives, build
workspaces, resolve packages, or run tests for you.

## Compile UEFI proof output

Use the target only for the current restricted firmware console profile:

```bash
"$HYDROGEN" compile hello.hy --target uefi-x64 -o BOOTX64.EFI
```

This produces firmware code, not a Linux program. Package it into an EFI system
partition or use the Australis ISO workflow described in
[Make a bootable UEFI Hello World](uefi-hello.md).

## Compiler contributors: rebuild from a seed

The compiler compiles its own Hydrogen project closure. Preserve a verified
release binary, then use it as the seed:

```bash
export HYDROGEN=/path/to/hydrogen-stage1
"$HYDROGEN" build samples/self_hosting/Hydrogen.Compiler.Cli/Hydrogen.Compiler.Cli.hyproj \
  -o hydrogen-rebuilt
chmod +x hydrogen-rebuilt
```

This rebuild is Hydrogen-only. A clean source-only compiler checkout still
needs a trusted seed; the historical C++ bootstrap is for maintainers creating
or recovering that first seed, not for release users. See the
[self-hosting architecture](../implementation/phase6-self-hosted-compiler.md)
for the reproducibility checks.
