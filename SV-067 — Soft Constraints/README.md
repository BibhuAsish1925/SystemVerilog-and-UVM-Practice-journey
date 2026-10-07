# 067 — SV-067 — Soft Constraints

## Concept

A **soft constraint** defines a default preference for randomization.

The keyword `soft` allows another constraint to override that preference when the two constraints conflict.

### Default constraint

```systemverilog id="m5n8xq"
constraint data_range {
    soft data inside {[10:20]};
}
```

Normally, `data` is randomized between 10 and 20.

### Override

An inline constraint can request a different range:

```systemverilog id="g3r2kw"
trans.randomize() with {
    data inside {[50:60]};
}
```

Because the class constraint is soft, the solver can override it.

Therefore:

```text id="q8h5vm"
Normal randomization → 10–20
Inline override      → 50–60
```

## Soft vs Hard Constraints

A normal constraint is a **hard constraint**:

```systemverilog id="7k4m1p"
constraint data_range {
    data inside {[10:20]};
}
```

If another active constraint requires:

```systemverilog id="0s6v9a"
data inside {[50:60]};
```

the constraints conflict and randomization can fail.

A soft constraint:

```systemverilog id="d1x8cz"
constraint data_range {
    soft data inside {[10:20]};
}
```

can be discarded when necessary to satisfy a stronger conflicting constraint.

## Verification Relevance

Soft constraints are useful for defining **default transaction behavior** while allowing individual tests or inline constraints to override those defaults.

This makes transaction classes reusable without requiring the base class to know every test-specific requirement.

## Example Output

```text id="7p3k9w"
Default: data = 16
Override: data = 54
```

The exact values are random.

The important behavior is:

```text
Default  → 10–20
Override → 50–60
```
