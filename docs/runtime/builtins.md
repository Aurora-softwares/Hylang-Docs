# Builtin APIs

These services are implemented by the compilers/runtimes; they do not require an external standard-library package. Use fully qualified API names for native-compatible code.

## Console, files, and conversion

Both routes provide these static calls:

| Call | Result | Use |
| --- | --- | --- |
| `System.Console.Write(value)` | `void` | Print a string, integer, or boolean |
| `System.Console.WriteLine(value)` | `void` | Print a value followed by a newline |
| `System.IO.File.Exists(path)` | `bool` | Test whether a path exists |
| `System.IO.File.ReadAllText(path)` | `string` | Read a file as bytes in a string |
| `System.IO.File.ReadAllBytes(path)` | `byte[]` | Read a file into an array |
| `System.IO.File.WriteAllText(path, text)` | `void` | Create/replace a file with string bytes |
| `System.IO.File.WriteAllBytes(path, data)` | `void` | Create/replace a file with array bytes |
| `System.Convert.ToInt32(text)` | `int` | Parse a signed decimal integer |

Paths/text arguments are `string`; binary data is `byte[]`. Despite its name, `ToInt32` returns Hydrogen's 64-bit `int`. The native implementation rejects malformed/out-of-range input. Native file reads require seekable files, and failed I/O terminates with an error. These text APIs do not perform Unicode decoding.

Native `WriteLine()` also accepts no argument for an empty line; for code shared with the SDK, use `WriteLine("")`. `Console.ReadLine` is not an executable builtin in either route; the native checker recognizes the name but emission rejects it.

Complete example, compatible with both routes:

```hylang
public class Program {
    public static int Main() {
        System.IO.File.WriteAllText("message.txt", "hello\n");
        if (System.IO.File.Exists("message.txt")) {
            string text = System.IO.File.ReadAllText("message.txt");
            System.Console.Write(text);
        }
        System.Console.WriteLine(System.Convert.ToInt32("42"));
        return 0;
    }
}
```

Running this program creates/replaces `message.txt` in the process's working directory and prints `hello`, then `42`, on separate lines.

## Native GC diagnostics

These calls are available in direct native executables, not SDK source binding:

| Call | Result | Meaning |
| --- | --- | --- |
| `System.Runtime.GC.Collect()` | `void` | Force collection and release cached free pages |
| `System.Runtime.GC.GetAllocatedBytes()` | `int` | Active managed mapping bytes, excluding cached free pages |

Automatic collection is normally sufficient. Conservative retention means accounting is not an exact measure of logically live objects. See [runtime behavior](runtime-model.md).

## SDK collections and byte buffers

`System.Collections.List<T>` supplies `new List<T>()`, `Add(value)`, `Get(index)`, `Set(index, value)`, and `Count()`. It requires SDK generics; see [arrays and collections](../language/arrays-and-collections.md).

`System.Runtime.Buffer` supplies static `Allocate(count)` and `FromArray(bytes)`, then instance `Length()`, `Get(index)`, `Set(index, value)`, `Slice(start, count)`, `Fill(value)`, `ToArray()`, `DangerousData()`, and `Free()`. Slices share storage. `ToArray()` copies bytes. Freeing the backing allocation invalidates its views; subsequent use fails. `DangerousData()` requires `unsafe` and exposes the checked pointer bridge.

`System.Runtime.BinaryPrimitives` supplies `ReadUInt16LE/BE`, `ReadInt16LE/BE`, `ReadUInt32LE/BE`, `ReadInt32LE/BE`, `ReadUInt64LE/BE`, and `ReadInt64LE/BE`, with matching `Write...` helpers. Reads take `(byte[] data, int offset)`; writes add the value argument. Refer to `tests/binary_primitives_64.hy` in the compiler repository for usage.

## SDK manual memory and tests

`System.Runtime.Memory` supplies `Alloc(bytes)`, `Free(pointer)`, `Copy(destination, source, bytes)`, `Set(destination, value, bytes)`, and `Compare(left, right, bytes)`. Pointer operations require `unsafe`; use the [unsafe guide](unsafe-design.md).

`System.Testing.Assert` supplies `True(condition, message)`, `False(condition, message)`, `Equal(expected, actual, message)`, `NotEqual(expected, actual, message)`, and `Fail(message)`. Equality assertions have integer, boolean, and string overloads. Assertion failures produce a failing test execution.

These SDK APIs are not supported by the direct native compiler. The proposed libraries in Hylang-Stdlib are a separate design plan, not installable implementations of these builtins.
