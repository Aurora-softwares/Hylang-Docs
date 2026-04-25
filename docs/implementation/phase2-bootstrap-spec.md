# Phase 2 Bootstrap Spec

This page records the Phase 2 language rules implemented by the bootstrap compiler. It is intentionally practical: it describes the supported surface, the active semantics, and the deliberate exclusions that still belong to later phases.

## Scope

Phase 2 completed the core-language expansion from the early bootstrap language into a compiler-flavored application language. The implemented areas are:

- `base(...)`, `base.Member`, `virtual`, and `override`
- namespace-scope `interface`
- namespace-scope `struct`
- invariant generics on classes, interfaces, and methods
- `var` local inference
- harder name resolution and generic arity checking

## Type Declarations

### Classes

- classes are declared at namespace scope
- a class may declare type parameters: `class Box<T>`
- a class may inherit from one base class and implement zero or more interfaces
- if no base class is specified, the class is a root class

Example:

```hylang
namespace Demo {
    public class Derived<T> : Base, IFoo<T>, IBar {
    }
}
```

### Interfaces

- interfaces are declared at namespace scope
- interface members are public instance method signatures only
- interfaces may inherit from multiple interfaces
- interfaces do not support fields, constructors, static members, default implementations, events, operators, or properties in Phase 2

Example:

```hylang
public interface INodeVisitor<T> : IVisitor<T> {
    T VisitNode(SyntaxNode node);
}
```

### Structs

- structs are declared at namespace scope
- structs may declare fields, constructors, instance methods, and static methods
- structs may implement interfaces
- structs do not participate in class inheritance
- generic structs are out of scope for Phase 2

Example:

```hylang
public struct TextSpan : ISpanView {
    private int _start;
    private int _length;
}
```

## Base Access and Override Rules

### Constructor Initializers

- `: base(args)` is supported on constructors
- `: this(args)` is not part of Phase 2
- if no explicit base initializer is provided, normal implicit parameterless base-constructor chaining still applies

### `base.Member`

- `base.Member` is valid only inside instance methods and instance constructors
- `base.Member` may target fields and methods from the base class chain
- `base.Member` binds statically to the base implementation and bypasses virtual dispatch
- `base` is not valid in static contexts

### `virtual` and `override`

- only non-static instance methods may be `virtual`
- a derived replacement must be marked `override`
- the overridden base method must already be virtual
- signature matching for override is exact, including static/instance shape and parameter list
- invalid overrides are compile-time errors

## Interface Model

- interfaces can be used as field, local, parameter, and return types
- interface dispatch works in both interpreter and compiled modes
- a class or struct implementing an interface must satisfy all inherited interface methods
- interface inheritance is transitive

## Struct Semantics

- structs are value types in the current bootstrap model
- struct locals and fields are zero-initialized by default
- struct assignment copies the value
- passing a struct as a parameter copies the value
- returning a struct returns a copy of the value
- `new S(...)` constructs a struct value
- `new S()` uses a matching declared constructor if present; otherwise it produces a zero-initialized struct value
- calling an instance method on a mutable struct lvalue operates on the original storage
- calling an instance method on a temporary operates on a temporary copy

### Boxing to Interfaces

- converting a struct to an interface boxes a copy into a managed wrapper object
- interface calls on the boxed value observe and mutate the boxed copy, not the original struct variable
- boxing to `object` is not part of Phase 2

## Generics

### Supported Forms

- generic classes: `class Box<T>`
- generic interfaces: `interface IVisitor<T>`
- generic methods: `T Identity<T>(T value)`

### Semantics

- generics are invariant
- closed generic types and methods are specialized by the compiler and cached per unique type-argument set
- method type inference uses call arguments only
- return-type-based inference is not supported
- constraints, variance, and default type arguments are not part of Phase 2

### Overload Selection

Overload ranking prefers:

1. exact match
2. generic exact match after successful inference/specialization
3. inheritance or interface conversion
4. boxing

Equal-best candidates are ambiguous and produce diagnostics.

## `var`

- `var` is valid for local variables only
- a `var` local requires an initializer
- the inferred type is the exact static type after implicit conversion
- `var` cannot be used when binding fails or when the initializer has no usable value type

Example:

```hylang
var node = new BinaryExpressionSyntax(left, plusToken, right, span);
```

## Name Resolution

- type lookup uses name plus generic arity
- simple-name type lookup prefers:
  1. the current namespace
  2. imported namespaces
  3. the global namespace
- ambiguous matches produce diagnostics
- qualified names win over imported-name lookup
- `using` remains namespace-only in Phase 2; alias imports are not supported

## Deliberate Exclusions

Phase 2 does not include:

- `abstract`, `sealed`, or `new`-hiding
- exceptions or async
- properties, events, or operator overloading
- generic constraints or variance
- generic structs
- boxing to `object`
- top-level statements or free functions
- low-level unsafe/pointer features

## Implementation Note

The semantic model tracks concrete specialized generic types and methods. The C backend still uses a bootstrap-oriented strategy for some generic/interface dispatch paths, so compiled helper signatures may erase some low-level representation details even though language binding and behavior are driven by the specialized semantic model.

## Proof Target

The sample project `samples/mini_frontend_model` is the Phase 2 proof target. It exercises:

- enum-backed syntax kinds
- `TextSpan` as a struct
- `SyntaxNode` inheritance
- `base(...)`, `base.Member`, `virtual`, and `override`
- a generic visitor interface
- a generic `Box<T>` type
- struct-to-interface boxing
