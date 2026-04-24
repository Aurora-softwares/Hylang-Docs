# Inheritance and Dispatch

Hylang supports single inheritance, explicit base-constructor chaining, `base.Member`, and non-static virtual dispatch.

## Declaring a derived class

Use `:` after the class name:

```hylang
namespace Demo {
    public class Entity {
        protected int seed;

        public Entity() {
            seed = 4;
        }

        public int Total() {
            return seed + 2;
        }
    }

    public class Widget : Entity {
        public Widget() {
            seed = seed + 1;
        }
    }
}
```

Only one base class is allowed, but a class may also implement interfaces.

## Inherited members

Derived classes can use accessible instance members and static members from their base class.

```hylang
namespace Demo {
    public class Entity {
        public static int Created;
        protected int seed;

        public Entity() {
            seed = 4;
            Created = Created + 1;
        }

        protected int Bump(int value) {
            return value + seed;
        }
    }

    public class Widget : Entity {
        public int Total() {
            return Bump(6);
        }
    }
}
```

## Assignability

A derived value can be used anywhere its base type is expected:

```hylang
Entity first = new Widget();

public static Entity Echo(Entity value) {
    return value;
}
```

This also applies during overload resolution. Exact matches are preferred, and derived-to-base matches are considered after that.

## Constructor behavior

Constructors are not inherited. Hylang supports both implicit parameterless chaining and explicit `: base(...)` chaining.

```hylang
public class Base {
    protected int value;

    public Base(int seed) {
        value = seed;
    }
}

public class Derived : Base {
    public Derived(int seed) : base(seed) {
    }
}
```

## `base.Member`

`base.Member` is valid inside instance methods and constructors and binds to the base implementation directly:

```hylang
public class Derived : Base {
    public override int Read() {
        return base.Read() + 1;
    }
}
```

## `virtual` and `override`

Non-static instance methods may be marked `virtual`, and derived replacements must use `override`:

```hylang
public class Base {
    public virtual int Read() {
        return 10;
    }
}

public class Derived : Base {
    public override int Read() {
        return base.Read() + 5;
    }
}
```

Calls through a base-typed reference use virtual dispatch.

## Current limitations

- Single inheritance only
- No `abstract`, `sealed`, or member-hiding keyword yet
- No multiple base classes
- Interface members are method signatures only
