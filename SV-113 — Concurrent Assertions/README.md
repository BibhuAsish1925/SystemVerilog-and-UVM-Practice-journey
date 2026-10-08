# 113 — SV-113 — Concurrent Assertions

### Concept

A concurrent assertion checks signal behavior over time, normally synchronized with a clock.

The basic syntax is:

```systemverilog
assert property (property_expression);
````

For example:

```systemverilog
assert property (@(posedge clk) valid |-> ready);
```

This checks that whenever `valid` is true at a rising edge of `clk`, `ready` is also true at that sampled clock edge.

### Immediate vs Concurrent Assertions

| Assertion            | Evaluation                                                   |
| -------------------- | ------------------------------------------------------------ |
| Immediate assertion  | Evaluated when the procedural statement executes             |
| Concurrent assertion | Evaluated according to a clocking event over simulation time |

Concurrent assertions are therefore useful for describing temporal behavior.

### Important Syntax

```systemverilog
assert property (@(posedge clk) valid |-> ready)
    else $error("Assertion failed");
```

* `assert property` — declares a concurrent assertion.
* `@(posedge clk)` — specifies the sampling clock.
* `valid` — antecedent or condition being checked.
* `|->` — implication operator.
* `ready` — consequent that must be true when the antecedent is true.
* `else` — failure action.

### Complete Runnable Code

```systemverilog
`timescale 1ns/1ps

module sv_113_concurrent_assertions_tb;

    logic clk;
    logic valid;
    logic ready;

    // Concurrent assertion:
    // Whenever valid is 1 at a rising edge,
    // ready must also be 1 at that edge.
    ap_valid_ready:
        assert property (@(posedge clk) valid |-> ready)
        else $error("[%0t] Assertion failed: valid=1 but ready=0",
                    $time);

    initial begin

        clk   = 1'b0;
        valid = 1'b0;
        ready = 1'b0;

        #10;

        // Assertion passes
        valid = 1'b1;
        ready = 1'b1;

        #10;

        // Assertion fails
        valid = 1'b1;
        ready = 1'b0;

        #10;

        // No failure because valid is 0
        valid = 1'b0;
        ready = 1'b0;

        #10;

        $finish;

    end

    always #5 clk = ~clk;

endmodule
```

### Expected Output

The assertion fails during the clock cycle where `valid=1` and `ready=0`.

Conceptually:

```text
[15000] Assertion failed: valid=1 but ready=0
$finish called at time : 40 ns
```

The exact XSim assertion diagnostic may include additional simulator information.

### Verification Relevance

Concurrent assertions are useful for checking behavior that depends on clock cycles, including:

* Handshake protocols
* FSM transitions
* Valid/ready relationships
* Multi-cycle behavior
* Protocol timing
* Design control logic

They are an important foundation for more advanced SVA concepts such as sequences, properties, implication operators, delays, and temporal assertions.
