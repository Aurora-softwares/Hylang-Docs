---
title: Download sample projects
description: Three small, ready-to-edit Hydrogen programs with beginner-friendly run instructions.
---

These are tiny programs you can use as a starting point. Download any .hy file and save it to a folder of your choice. Each example is designed around the published Linux compiler's documented language features.

## 1. Hello, world!

**What you'll learn:** the main entry point and printing text.

[Download hello.hy](/samples/hello.hy)

In a terminal, go to the folder containing the file and run:

    hy compile hello.hy -o hello
    chmod +x hello
    ./hello

Expected output:

    Hello, Hydrogen!

## 2. Count to five

**What you'll learn:** variables, a while loop, and simple maths.

[Download count-to-five.hy](/samples/count-to-five.hy)

    hy compile count-to-five.hy -o count-to-five
    chmod +x count-to-five
    ./count-to-five

The program prints the numbers one to five. Try changing the limit to ten.

## 3. Personal greeting

**What you'll learn:** reading command-line arguments and changing a message.

[Download greet-you.hy](/samples/greet-you.hy)

    hy compile greet-you.hy -o greet-you
    chmod +x greet-you
    ./greet-you Ada

The program prints **Hello, Ada!** Run it without a name to see the default greeting.

## What's next?

Follow the [first-program guide](/getting-started/running/), read about [control flow](/language/control-flow/), or learn how to group files using a [Hydrogen project](/tools/projects/).

For more involved or experimental examples, browse [the compiler's development samples](https://github.com/Aurora-softwares/Hylang-Compiler/tree/Development/samples). These may require a development compiler rather than the published release.
