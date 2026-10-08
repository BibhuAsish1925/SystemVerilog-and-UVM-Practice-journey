
# 115 — SV-115 — Sequences

## Introduction

An SVA sequence describes a temporal pattern that occurs across one or more clock cycles.

For example:

```systemverilog
sequence valid_then_ready;
    valid ##1 ready;
endsequence
````

This means:

* `valid` must be true at the current assertion clock.
* `ready` must be true one clock cycle later.

Sequences are fundamental building blocks for SystemVerilog Assertions because they allow multi-cycle behavior to be described clearly.

## Important Syntax

```systemverilog
sequence valid_then_ready;
    valid ##1 ready;
endsequence
```

Here:

* `valid` is checked at the current clocking event.
* `##1` introduces a one-clock-cycle delay.
* `ready` is checked at the next clocking event.

A sequence can then be used inside an assertion:

```systemverilog
assert property (@(posedge clk)
                  trigger |-> valid_then_ready);
```

Using a trigger is useful in a testbench because it allows the sequence to be evaluated only during the intended test.

## Verification Relevance

Sequences are useful for describing:

* Request followed by acknowledge
* Valid followed by ready
* Multi-cycle protocol behavior
* Control signal timing
* Handshake relationships
* Temporal patterns in verification

## Complete Runnable Code

```systemverilog
`timescale 1ns/1ps

module sv_115_sequences_tb;

    logic clk;
    logic valid;
    logic ready;

    logic test_pass;
    logic test_fail;

    // Sequence:
    // valid must be followed by ready
    // on the next clock cycle.
    sequence valid_then_ready;
        valid ##1 ready;
    endsequence

    // Trigger the sequence intentionally.
    ap_valid_then_ready:
        assert property (@(posedge clk)
                          (test_pass || test_fail) |->
                          valid_then_ready)
        else $error("[%0t] Sequence failed: valid was not followed by ready",
                    $time);

    initial begin

        clk       = 1'b0;
        valid     = 1'b0;
        ready     = 1'b0;

        test_pass = 1'b0;
        test_fail = 1'b0;

        // Passing sequence
        @(negedge clk);

        valid     = 1'b1;
        ready     = 1'b0;
        test_pass = 1'b1;

        @(negedge clk);

        test_pass = 1'b0;
        valid     = 1'b0;
        ready     = 1'b1;

        @(negedge clk);

        ready = 1'b0;

        // Failing sequence
        @(negedge clk);

        valid     = 1'b1;
        ready     = 1'b0;
        test_fail = 1'b1;

        @(negedge clk);

        test_fail = 1'b0;
        valid     = 1'b0;
        ready     = 1'b0;

        @(negedge clk);

        #5;
        $finish;

    end

    always #5 clk = ~clk;

endmodule
```

## Expected Result

The first sequence passes and the second sequence intentionally fails.

```text
# run 1000ns
Error: [45000] Sequence failed: valid was not followed by ready
$finish called at time : 55 ns
```

The exact XSim diagnostic formatting may vary.

## Key Takeaway

A sequence describes a temporal pattern.

For:

```systemverilog
valid ##1 ready
```

`valid` must occur at one assertion clock and `ready` must occur at the next assertion clock.

Using a trigger around the sequence makes the testbench deterministic and prevents unwanted assertion failures on unrelated clock cycles.

