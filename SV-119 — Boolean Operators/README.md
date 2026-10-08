
# 119 — SV-119 — Boolean Operators

## Introduction

SystemVerilog Assertions provide temporal Boolean operators for combining sequences.

- `and` — both sequences must match.
- `or` — at least one sequence must match.
- `intersect` — both sequences must match and end at the same clocking event.

A one-cycle trigger is used for each assertion so that the properties are checked only during their intended test.

## Important Syntax

### AND

```systemverilog
seq_a and seq_b
````

Both sequences must match.

### OR

```systemverilog
seq_a or seq_b
```

At least one sequence must match.

### INTERSECT

```systemverilog
seq_a intersect seq_b
```

Both sequences must match and their end points must occur at the same clocking event.

## Verification Relevance

Boolean sequence operators are useful for checking:

* Multiple conditions occurring together
* Alternative protocol conditions
* Synchronization between temporal sequences
* Relationships between multiple signal sequences

## Complete Runnable Code

```systemverilog
`timescale 1ns/1ps

module sv_119_boolean_operators_tb;

    logic clk;
    logic a;
    logic b;
    logic c;

    logic test_and;
    logic test_or;
    logic test_intersect;

    // One-cycle sequences
    sequence seq_a;
        a;
    endsequence

    sequence seq_b;
        b;
    endsequence

    // AND: both sequences must match
    ap_and:
        assert property (@(posedge clk)
                          test_and |-> (seq_a and seq_b))
        else $error("[%0t] AND failed",
                    $time);

    // OR: at least one sequence must match
    ap_or:
        assert property (@(posedge clk)
                          test_or |-> (seq_a or seq_b))
        else $error("[%0t] OR failed",
                    $time);

    // Two-cycle sequences for INTERSECT
    sequence seq_a_then_b;
        a ##1 b;
    endsequence

    sequence seq_c_then_b;
        c ##1 b;
    endsequence

    // INTERSECT: both sequences must end together
    ap_intersect:
        assert property (@(posedge clk)
                          test_intersect |->
                          (seq_a_then_b intersect seq_c_then_b))
        else $error("[%0t] INTERSECT failed",
                    $time);

    initial begin

        clk = 1'b0;
        a   = 1'b0;
        b   = 1'b0;
        c   = 1'b0;

        test_and       = 1'b0;
        test_or        = 1'b0;
        test_intersect = 1'b0;

        // Test AND
        @(negedge clk);
        a = 1'b1;
        b = 1'b1;
        test_and = 1'b1;

        @(negedge clk);
        test_and = 1'b0;
        a = 1'b0;
        b = 1'b0;

        // Test OR
        @(negedge clk);
        a = 1'b1;
        b = 1'b0;
        test_or = 1'b1;

        @(negedge clk);
        test_or = 1'b0;
        a = 1'b0;

        // Test INTERSECT
        @(negedge clk);
        a = 1'b1;
        c = 1'b1;
        b = 1'b0;
        test_intersect = 1'b1;

        @(negedge clk);
        test_intersect = 1'b0;
        b = 1'b1;

        @(negedge clk);
        a = 1'b0;
        b = 1'b0;
        c = 1'b0;

        #5;
        $finish;

    end

    always #5 clk = ~clk;

endmodule
```

## Expected Result

The simulation should complete without assertion errors.

```text
# run 1000ns
$finish called at time : 75 ns
```

## Key Takeaway

`and` requires both sequences to match, `or` requires at least one sequence to match, and `intersect` requires both sequences to match with the same ending clocking event.
