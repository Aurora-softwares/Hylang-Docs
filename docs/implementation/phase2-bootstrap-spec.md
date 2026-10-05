# SDK semantic model

This page describes the C++ SDK's binding contracts. For writing programs, start with the [language guide](../language/structure.md) and [compiler support table](../getting-started/compiler-options.md). The historical page URL is retained for existing links.

## Pipeline

`src/hylang.cpp` in Hylang-Compiler implements lexer, parser, syntax nodes, symbols, binder, bound IR, interpreter, C emitter, and runtime helpers. `hy`, `hyrun`, and `hyc` share this semantic pipeline.

Declarations are registered before bodies are bound. Type lookup considers namespace/import context and generic arity. Ambiguous references and invalid calls produce diagnostics. Imports are namespace-only; aliases are not implemented.

## Object and value types

The SDK supports one base class, inherited member lookup, explicit/implicit base-constructor chaining, virtual overrides, interfaces with transitive interface inheritance, and structs with value-copy semantics. Struct-to-interface conversion boxes a copy, so mutations through the boxed interface do not change the original struct value.

Private access is class-local; protected access includes subclasses. Interfaces contain instance method signatures, not fields or default implementations. Constructors are not inherited.

## Generics and overloads

Generic classes, interfaces, and methods are invariant. Closed instances are specialized/cached by type arguments. Method inference uses arguments, not the expected return type. Exact matches are preferred to inheritance/interface conversions or boxing; equally good overloads are ambiguous.

Constraints, variance, default type arguments, generic structs, and boxing to `object` are not implemented. Some C-emitted generic signatures erase parameters to `void*`; numeric instantiations can fail host compilation even when interpretation succeeds. See the [generic usage guide](../language/generics.md).

## Statements and execution

The SDK includes `for`, string `throw`/`try`/`catch`, and checked unsafe/manual-memory operations alongside ordinary blocks, branches, and loops. Catch variables must be strings. The [native backend](phase6-self-hosted-compiler.md) implements a smaller executable subset.

The interpreter and C emitter consume bound IR. Their execution details can differ; the interpreter evaluates logical operands eagerly. See [runtime behavior](../runtime/runtime-model.md).

The compiler repository's `samples/mini_frontend_model` demonstrates inheritance, generic visitor interfaces, structs, and interface boxing with the SDK.
