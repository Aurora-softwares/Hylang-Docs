# Builtin APIs

These services are implemented by the released compiler's Linux-native runtime;
they do not need an external standard-library package. Use the fully qualified
names shown here.

## Console, files, and conversion

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

Paths and text arguments are `string`; binary data is `byte[]`. Despite its
name, `ToInt32` returns Hydrogen's 64-bit `int`. Malformed/out-of-range input
and failed I/O terminate the application with an error. These text APIs do not
perform Unicode decoding.

`WriteLine()` also accepts no argument for an empty line. `Console.ReadLine` is
not implemented in the released compiler.

Complete example:

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

The program creates/replaces `message.txt` in its working directory and prints
`hello`, then `42`, on separate lines.

## Native GC diagnostics

| Call | Result | Meaning |
| --- | --- | --- |
| `System.Runtime.GC.Collect()` | `void` | Force collection and release cached free pages |
| `System.Runtime.GC.GetAllocatedBytes()` | `int` | Active managed mapping bytes, excluding cached free pages |

Automatic collection is normally sufficient. Conservative retention means this
accounting is not an exact measure of logically live objects. See
[runtime behavior](runtime-model.md).

## UEFI target boundary

`--target uefi-x64` does **not** provide the Linux API table above. Its current
proof profile only emits `System.Console.WriteLine` calls with ASCII string
literals from the static entry point. It writes through the firmware text
console and has no `Write`, `ReadLine`, file, conversion, collection, GC,
memory, or buffer support yet. A reusable `Hydrogen.Uefi` library is the next
planned layer.
