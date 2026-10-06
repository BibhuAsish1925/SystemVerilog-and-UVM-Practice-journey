# 048 — SV-048 — Basic Randomization

SystemVerilog provides **constrained randomization** to automatically generate test values for verification.

A class property declared with the `rand` keyword becomes a **random variable**.

### `rand`

```systemverilog
rand int data;
```

This tells SystemVerilog that `data` can be randomized.

### `randomize()`

The `randomize()` method generates a random value for the `rand` properties of the object.

```systemverilog
if (trans.randomize())
    $display("Randomization successful");
else
    $display("Randomization failed");
```

`randomize()` returns:

* `1` when randomization succeeds.
* `0` when randomization fails.

At this basic stage there are no constraints, so the `rand` variable can take values from its legal data-type range.

### Why it matters in verification

Randomization allows a verification environment to automatically generate different transaction values instead of manually writing every test value. This becomes especially useful when combined with constraints to generate meaningful legal test scenarios.


**Key concepts:** `rand`, random variable, `randomize()`, randomization success/failure, randomized verification data.
