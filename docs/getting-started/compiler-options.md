# Choose a compiler

Two compiler implementations are available in Hylang-Compiler. Commands below assume its repository root as the working directory.

| Capability | Native Hydrogen compiler | C++ SDK (`hy`, `hyrun`, `hyc`) |
| --- | --- | --- |
| Compilation | Direct Linux x86-64 ELF | Host C compiler and runtime |
| Interpreted execution | No | `hy run`, `hyrun` |
| Classes, constructors, instance fields | Yes | Yes |
| Field initializers | Yes | No; initialize in constructors |
| Static/instance methods and recursion | Yes | Yes |
| `int`, `byte`, `bool`, strings, arrays, enums, `var` | Yes | Yes |
| `if`, `while`, `break`, `continue`, `return` | Yes | Yes |
| `for` | No; use `while` | Yes |
| Inheritance, virtual dispatch, interfaces | No | Yes |
| Struct value semantics, generics, overloads | No | Yes; C-emitted numeric generics have representation limitations |
| Static fields | No | Yes |
| Wider integer types | Checking can recognize them; reachable native signatures are restricted | Yes |
| String `throw`/`try`/`catch` | No native emission | Yes |
| Unsafe, pointers, manual memory, `Buffer`, `BinaryPrimitives`, `List<T>` | No | Yes |
| Console output, file text/bytes, integer parsing | Yes | Yes |
| Explicit GC collection/accounting APIs | Yes | No source-level API |
| Console input (`ReadLine`) | Recognized by checker; no emission | No |
| Executable project source references | Yes | Yes |
| Workspaces, standalone static libraries, local package registry | No | Yes |
| Scaffolding, test runner, formatter, JSON diagnostics, LSP | No | Yes |
| Rebuild the native compiler from a retained binary | Yes | Can create the initial seed |

Native `check` validates names and types and can print executable IR. A successful check does not guarantee backend support: `compile`/`build` can reject constructs or intrinsics that the checker recognizes. Native compilation rejects unsupported code with a nonzero exit status and preserves any existing output file.

## Which command to use

Use `build/self_hosting/hydrogen-stage1 compile` for a native single source and `build` for an executable project. The stage suffix identifies how the binary was bootstrapped, not a different language edition; later verified generations expose the same CLI.

Use `build/hy run` to interpret, `build/hy build` for C-backed compilation, and `build/hy` for SDK workflow commands. The compatibility tools `hyrun` and `hyc build` use the same SDK implementation.

Keep fully qualified builtin names, such as `System.Console.WriteLine`, in code shared with the native compiler. Namespace imports work for user-defined types; shortened SDK builtin names are not a portable native API spelling.

The interpreter evaluates both operands of `&&` and `||`. Native executables and the C backend short-circuit. Use nested `if` statements for guards that also run in the interpreter.
