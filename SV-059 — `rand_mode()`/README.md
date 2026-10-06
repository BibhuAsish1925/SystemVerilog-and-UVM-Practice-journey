# 059 — SV-059 — `rand_mode()`

## Concept

`rand_mode()` controls whether an individual `rand` variable participates in randomization.

Syntax:

```systemverilog
variable.rand_mode(0);  // Disable
variable.rand_mode(1);  // Enable
```

When randomization is disabled for a variable, calling `randomize()` does not generate a new value for that variable. Its existing value is retained.

For example:

```systemverilog
trans.data.rand_mode(0);
```

disables randomization of `data`.

It can later be enabled again:

```systemverilog
trans.data.rand_mode(1);
```

### Important points

* `rand_mode(1)` enables randomization.
* `rand_mode(0)` disables randomization.
* The setting applies to the specific random variable.
* A disabled variable keeps its current value during subsequent `randomize()` calls.
* Other enabled random variables continue to randomize normally.
* `rand_mode()` is useful when a test needs precise control over which transaction fields are randomized.


## Verification Relevance

`rand_mode()` is useful when a verification environment needs to randomize most transaction fields while keeping a particular field fixed.

For example, a test can generate a random transaction first and then disable one field:

```systemverilog
trans.data.rand_mode(0);
```

The next `randomize()` call can change other enabled fields while preserving the existing `data` value.

This provides selective control over constrained-random stimulus generation.

## Vivado

Use this as a **Simulation Source** with no DUT. Run **Behavioral Simulation** and observe the transaction values in the simulator console.
