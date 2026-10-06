# 060 — SV-060 — `constraint_mode()`

## Concept

`constraint_mode()` controls whether a specific constraint block is active during randomization.

Syntax:

```systemverilog
constraint_name.constraint_mode(0);  // Disable
constraint_name.constraint_mode(1);  // Enable
```

For example:

```systemverilog
trans.data_range.constraint_mode(0);
```

temporarily disables the `data_range` constraint.

It can be enabled again using:

```systemverilog
trans.data_range.constraint_mode(1);
```

### Important points

* `constraint_mode(1)` enables a constraint.
* `constraint_mode(0)` disables a constraint.
* It controls a **constraint block**, not a random variable.
* Other active constraints continue to participate in randomization.
* A disabled constraint is ignored during subsequent `randomize()` calls.
* `rand_mode()` controls random variables, while `constraint_mode()` controls constraints.


## Verification Relevance

`constraint_mode()` is useful when a verification environment needs to **change the constraints applied to randomized stimulus** without modifying the class itself.

For example, a test can use the same transaction class but disable a particular constraint for a specific scenario:

```systemverilog
trans.data_range.constraint_mode(0);
```

Later, the original constraint can be restored:

```systemverilog
trans.data_range.constraint_mode(1);
```

This allows different tests to reuse the same transaction class with different randomization behavior.

## Vivado

Use this as a **Simulation Source** with no DUT. Run **Behavioral Simulation** and observe the randomized values in the simulator console.
