---
title: Self-hosting preparation
description: How the Hydrogen compiler reaches executable IR and native output.
---

> This is contributor documentation. To use Hydrogen, start with the released
> compiler in the Getting Started section.

The compiler parses Hydrogen source, binds names and types, lowers reachable
methods into executable IR, and emits native x86-64 output. The current Linux
backend includes its runtime in each executable; the UEFI path uses a deliberately
small PE32+ image builder for the firmware console proof.

The compiler's own CLI project is within the supported language subset, enabling a
verified Hydrogen binary to rebuild that project closure without a C++ toolchain.

Features outside the released subset must not be assumed to work merely because
older design material describes them. Extend the parser, checker, IR, backend, and
tests together when adding language features.
