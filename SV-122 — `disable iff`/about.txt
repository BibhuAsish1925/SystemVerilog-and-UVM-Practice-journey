# 122 — SV-122 — `disable iff`

### Small Introduction

`disable iff` is used to temporarily disable a concurrent assertion
when a specified condition is true.

It is most commonly used with reset.

Example:

```systemverilog
assert property (@(posedge clk)
                 disable iff (reset)
                 valid |-> ready);
````

When `reset` is high, the assertion is disabled.

When `reset` becomes low, the assertion becomes active again.

### Verification Relevance

`disable iff` is useful for:

* Reset conditions
* Initialization periods
* Power-down conditions
* Temporary assertion disable conditions
* Preventing protocol checks while the DUT is in reset

### Syntax

```systemverilog
assert property (
    @(posedge clk)
    disable iff (reset)
    property_expression
);
```

### Complete Runnable Code

```systemverilog
`timescale 1ns/1ps

module sv_122_disable_iff_tb;

    logic clk;
    logic reset;
    logic valid;
    logic ready;

    logic test_reset;
    logic test_active;

    // Assertion is disabled whenever reset is high.
    // When reset is low:
    // valid must be followed by ready on the same cycle.

    ap_valid_ready:
        assert property (@(posedge clk)
                          disable iff (reset)
                          (test_reset || test_active) |->
                          (valid && ready))
        else $error("[%0t] Assertion failed: valid requires ready",
                    $time);

    initial begin

        clk = 1'b0;
        reset = 1'b1;
        valid = 1'b0;
        ready = 1'b0;

        test_reset  = 1'b0;
        test_active = 1'b0;

        // Assertion disabled during reset

        @(negedge clk);

        reset = 1'b1;
        valid = 1'b1;
        ready = 1'b0;
        test_reset = 1'b1;

        @(negedge clk);

        test_reset = 1'b0;
        valid = 1'b0;

        // Reset released
        // Assertion becomes active.

        @(negedge clk);

        reset = 1'b0;
        valid = 1'b1;
        ready = 1'b1;
        test_active = 1'b1;

        // Assertion passes because valid && ready.
        @(negedge clk);

        test_active = 1'b0;
        valid = 1'b0;
        ready = 1'b0;

        // Assertion active and intentionally failing

        @(negedge clk);

        valid = 1'b1;
        ready = 1'b0;
        test_active = 1'b1;

        @(negedge clk);

        test_active = 1'b0;
        valid = 1'b0;

        // Assert reset again.
        // Assertion is disabled again.

        @(negedge clk);

        reset = 1'b1;
        valid = 1'b1;
        ready = 1'b0;
        test_reset = 1'b1;

        @(negedge clk);

        test_reset = 1'b0;
        valid = 1'b0;
        ready = 1'b0;

        #5;
        $finish;

    end

    always #5 clk = ~clk;

endmodule
```

### Expected Output

The assertion is disabled during reset, so the reset-time violation
does not generate an assertion error.

After reset is released, the first active assertion passes.

One intentional assertion failure occurs while reset is low.

```text
# run 1000ns

Time: 55 ns ...
Error: [55000] Assertion failed: valid requires ready

$finish called at time : 75 ns
INFO: [USF-XSim-96] XSim completed.
INFO: [USF-XSim-97] XSim simulation ran for 1000ns
```

The exact XSim diagnostic formatting may vary.

### Key Concept

```text
reset = 1
    ↓
disable iff (reset)
    ↓
Assertion disabled

reset = 0
    ↓
Assertion active
```

For example:

```systemverilog
assert property (@(posedge clk)
                 disable iff (reset)
                 valid |-> ready);
```

means the `valid |-> ready` property is not checked while `reset`
is active.

### Vivado Usage

Use:

```text
sv_122_disable_iff_tb.sv
```

Simulation top:

```text
sv_122_disable_iff_tb
```

Run:

```text
run 1000ns
```

Keep the source as a SystemVerilog `.sv` file.

