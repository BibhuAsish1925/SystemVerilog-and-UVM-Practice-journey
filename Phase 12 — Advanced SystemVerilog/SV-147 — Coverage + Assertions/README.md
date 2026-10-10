
# 147 — SV-147 — Coverage + Assertions

### Introduction

Coverage + Assertions combines two important verification techniques.

- Assertions check whether the design obeys a required rule.
- Functional coverage measures whether important scenarios have occurred.

For a simple valid/ready protocol:

```text
Assertion:
valid → ready
````

checks correctness.

Functional coverage can measure whether these scenarios were exercised:

```text
valid=0, ready=0
valid=0, ready=1
valid=1, ready=0
valid=1, ready=1
```

This provides both correctness checking and verification completeness measurement.

### Integrated Verification Model

This example uses:

* `covergroup`
* `coverpoint`
* `cross`
* Concurrent assertion
* `get_coverage()`

The `covergroup` records all valid/ready combinations while the assertion checks that `valid` is not high when `ready` is low.

### Complete Runnable Code

```systemverilog
`timescale 1ns/1ps

module sv_147_coverage_assertions_tb;

    logic clk;
    logic valid;
    logic ready;

    // Functional coverage
    covergroup protocol_cg @(posedge clk);

        cp_valid:
            coverpoint valid {
                bins valid_low  = {0};
                bins valid_high = {1};
            }

        cp_ready:
            coverpoint ready {
                bins ready_low  = {0};
                bins ready_high = {1};
            }

        cross_valid_ready:
            cross cp_valid, cp_ready;

    endgroup

    protocol_cg cg;

    // Assertion: a valid transfer must have ready high
    ap_valid_requires_ready:
        assert property (@(posedge clk)
                          valid |-> ready)
        else
            $error("[%0t] ASSERTION FAILED: valid=1 but ready=0",
                   $time);

    initial begin

        cg = new();

        clk   = 1'b0;
        valid = 1'b0;
        ready = 1'b0;

        // valid=0, ready=0
        @(negedge clk);

        // valid=1, ready=1 : PASS
        valid = 1'b1;
        ready = 1'b1;

        @(negedge clk);

        // valid=0, ready=1
        valid = 1'b0;
        ready = 1'b1;

        @(negedge clk);

        // valid=1, ready=0 : assertion FAIL
        valid = 1'b1;
        ready = 1'b0;

        @(negedge clk);

        // valid=0, ready=0
        valid = 1'b0;
        ready = 1'b0;

        @(negedge clk);

        $display("========================================");
        $display("Coverage + Assertion Verification");
        $display("========================================");

        $display("Functional Coverage = %0.2f%%",
                 cg.get_coverage());

        $finish;

    end

    always #5 clk = ~clk;

endmodule
```

### Expected Output

```text
[15] ASSERTION FAILED: valid=1 but ready=0
========================================
Coverage + Assertion Verification
========================================
Functional Coverage = 100.00%
$finish called at time : 40 ns
```

The exact assertion formatting may vary between simulator versions.

### Verification Relevance

Coverage answers:

> Did we exercise the important scenarios?

Assertions answer:

> Did the design obey the required rule?

Using both together gives stronger verification than using either technique alone.

### Important XSim Note

This example uses a `covergroup` for functional coverage.

It intentionally does not use `cover property` because XSim 2025.1 reports that SystemVerilog cover statements are not supported for simulation.

### Key Takeaway

The integrated verification flow is:

```text
Stimulus
   |
   +------> Functional Coverage
   |             |
   |             +--> What scenarios were exercised?
   |
   +------> Assertions
                 |
                 +--> Was the behavior correct?
```

Coverage measures verification completeness, while assertions check design correctness.


