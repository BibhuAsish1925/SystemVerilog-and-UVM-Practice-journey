# 065 — SV-065 — Constraint Inheritance

## Concept

Constraint inheritance allows a derived class to inherit constraint blocks from its base class and add additional constraints of its own.

When an object of the derived class is randomized, the inherited constraints and the derived-class constraints are both active.

This is useful in verification because a base transaction can define common legal values, while specialized transactions can further restrict those values.

## Important Syntax

### Base-class constraint

```systemverilog
constraint base_range {
    data inside {[10:50]};
}
```

### Derived class

```systemverilog
class write_transaction extends transaction;
```

The derived class automatically inherits the base-class constraint.

### Additional derived constraint

```systemverilog
constraint write_range {
    data inside {[30:40]};
}
```

For a `write_transaction` object, both constraints are applied:

```text
10 <= data <= 50
30 <= data <= 40
```

Therefore, the effective legal range is:

```text
30 <= data <= 40
```

## Verification Relevance

Constraint inheritance is useful for creating reusable transaction classes. Common constraints can be placed in a base class, while specialized transaction types can add more specific rules.


The exact randomized values may differ between simulations.
