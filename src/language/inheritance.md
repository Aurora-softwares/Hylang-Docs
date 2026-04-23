# Inheritance

Hylang currently supports basic single inheritance. This is the first Phase 2 object-model milestone and is designed to make medium-sized programs and compiler-style models easier to express.

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

Only one base class is allowed.

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

Constructors are not inherited. In the current milestone, object creation implicitly runs the parameterless constructor chain from base to derived.

That means a derived class must have an accessible parameterless base constructor available, either declared explicitly or provided implicitly by the base class.

## Current limitations

- Single inheritance only
- No explicit `base(...)` constructor chaining syntax yet
- No `base.Member`
- No `virtual` / `override`
- No interfaces yet
