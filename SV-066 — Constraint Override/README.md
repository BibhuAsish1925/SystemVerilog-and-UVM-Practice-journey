# 066 — SV-066 — Constraint Override

## Concept

Constraint override describes how a derived class can change the constraint behavior inherited from a base class.

A derived constraint normally does **not** automatically replace a base constraint. If both constraints are enabled, they are combined.

For example:

```text
Base constraint:     data = 10–50
Derived constraint:  data = 30–40
Effective range:    data = 30–40
```

This is called **constraint extension**.

To replace the inherited constraint for a derived object, the inherited constraint can be disabled using `constraint_mode(0)`.

## Important Syntax

### Constraint extension

```systemverilog
constraint write_range {
    data inside {[30:40]};
}
```

The inherited base constraint remains active, so both constraints participate in randomization.

### Disable inherited constraint

```systemverilog
base_range.constraint_mode(0);
```

This disables the inherited constraint for that object.

### Constraint replacement

After disabling the base constraint, the derived constraint becomes the effective restriction.

```text
Base constraint:     disabled
Derived constraint:  active
```

## Verification Relevance

Constraint extension is useful when specialized transactions need stricter rules than the base transaction.

Constraint replacement is useful when a derived transaction needs a completely different legal range from the base transaction.

## Example Output

```text
Base transaction: data = 27
Write transaction: data = 73
```

The exact values vary because they are randomized.
