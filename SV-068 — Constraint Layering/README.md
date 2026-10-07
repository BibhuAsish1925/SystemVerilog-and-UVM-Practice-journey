# 068 — SV-068 — Constraint Layering

## Concept

Constraint layering means applying constraints at different levels.

A transaction class can define common constraints, while an individual `randomize()` call can add an **inline constraint** for a specific test scenario.

The inline constraint is combined with the active class constraints for that randomization call.

## Class Constraint

The class defines the default legal range:

```systemverilog id="6x5m8r"
constraint data_range {
    data inside {[10:100]};
}
```

Therefore, normal randomization produces:

```text id="8n2q4v"
10 <= data <= 100
```

## Inline Constraint

An inline constraint is specified with:

```systemverilog id="3p7k1c"
trans.randomize() with {
    data inside {[40:60]};
}
```

The class and inline constraints are both active.

Therefore:

```text id="0w6m9a"
Class:   10–100
Inline:  40–60
Result:  40–60
```

Another inline constraint can make the value exact:

```systemverilog id="5j8d2m"
trans.randomize() with {
    data == 75;
}
```

The result must therefore be:

```text id="v3r7qx"
data = 75
```

## Important Point

Inline constraints are **temporary**.

They apply only to the specific `randomize()` call:

```systemverilog id="a4c9kp"
trans.randomize() with { ... };
```

They do not permanently modify or replace the class constraint.

## Verification Relevance

Constraint layering allows a reusable transaction class to define common legal behavior while individual tests can apply additional scenario-specific restrictions.

This is especially useful when different verification tests need different stimulus without creating separate transaction classes.


## Example Output

```text id="9c5v2m"
Class constraint: data = 27
Class + inline constraint: data = 54
Class + exact inline constraint: data = 75
```

The exact randomized values can differ between simulations.
