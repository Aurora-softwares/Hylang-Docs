---
title: Your first Hydrogen project
description: Download and run a tiny Hydrogen program, then make it your own.
---

Welcome! In this guide you will run your first Hydrogen program. You don't need to know everything about programming to start.

## 1. Install Hydrogen

Follow the [installation guide](/getting-started/installing/) for your platform. The published compiler's documented native executable workflow is for **Linux x86-64**.

Open a terminal and confirm the `hy` command is available:

```bash
hy --help
```

## 2. Download your first example

[Download hello.hy](/samples/hello.hy) and save the file in a new folder. You can open it with a text editor.

Here is what the program looks like:

```csharp
public class Program {
    public static int Main(string[] args) {
        System.Console.WriteLine("Hello, Hydrogen!");
        return 0;
    }
}
```

The `Main` method is where your program begins. `WriteLine` prints a message to your terminal. `return 0` tells your computer that everything finished successfully.

## 3. Compile and run it

Open a terminal in the same folder as `hello.hy`:

```bash
hy check hello.hy
hy compile hello.hy -o hello
chmod +x hello
./hello
```

You should see:

```text
Hello, Hydrogen!
```

## 4. Make it yours

Change the text between the quotation marks, then compile and run the program again. Try printing a different message!

When you're ready, [download another sample](/samples/) or learn about [variables and types](/language/types/). Have fun experimenting.
