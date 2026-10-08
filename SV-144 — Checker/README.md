
# 144 — SV-144 — Checker

## Introduction

A SystemVerilog `checker` is a dedicated verification construct used to group assertions and checking logic separately from the DUT.

A checker can have ports that receive DUT or testbench signals.

However, Vivado XSim 2025.1 does not currently support the SystemVerilog `checker` construct for simulation.

Therefore, this practical example uses an XSim-compatible module-based checker while preserving the same verification architecture.

## Standard SystemVerilog Checker

The standard SystemVerilog syntax is:

```systemverilog
checker protocol_checker (
    input logic clk,
    input logic valid,
    input logic ready
);

    // Assertions and checking logic

endchecker
````

The `checker` construct is specifically intended for verification.

## XSim-Compatible Checker

Because Vivado XSim 2025.1 does not support `checker`, a module can be used:

```systemverilog
module sv_144_protocol_checker (
    input logic clk,
    input logic reset,
    input logic valid,
    input logic ready
);

    // Assertions and checking logic

endmodule
```

This keeps the checker logic separate from the DUT while allowing the design to simulate in XSim.

## Checker Ports

The checker receives DUT signals through its ports:

```systemverilog
sv_144_protocol_checker protocol_checker (
    .clk   (clk),
    .reset (reset),
    .valid (valid),
    .ready (ready)
);
```

This makes the checking component reusable.

## Assertions

The checker contains an SVA assertion:

```systemverilog
ap_valid_ready:
    assert property (
        @(posedge clk)
        disable iff (reset)
        valid |-> ready
    )
    else
        $error("CHECKER ASSERTION FAILED");
```

The property means that whenever `valid` is asserted, `ready` must also be high at the same clocking point.

## Verification Relevance

Checker-style components are useful for:

* Protocol verification
* Interface checking
* Reusable assertions
* Separating verification logic from RTL
* Checking multiple DUT instances
* Creating reusable verification components

## Complete Runnable Code

```systemverilog
`timescale 1ns/1ps

module sv_144_checker_dut (
    input logic       clk,
    input logic       reset,
    input logic       valid,
    input logic       ready,
    input logic [7:0] data
);

    always_ff @(posedge clk) begin

        if (!reset && valid && ready)
            $display("[%0t] DUT: transfer accepted, data=%h",
                     $time, data);

    end

endmodule


// XSim-compatible checker module
module sv_144_protocol_checker (
    input logic clk,
    input logic reset,
    input logic valid,
    input logic ready
);

    ap_valid_ready:
        assert property (
            @(posedge clk)
            disable iff (reset)
            valid |-> ready
        )
        else
            $error("[%0t] CHECKER ASSERTION FAILED: valid=1 but ready=0",
                   $time);

endmodule


module sv_144_checker_tb;

    logic       clk;
    logic       reset;
    logic       valid;
    logic       ready;
    logic [7:0] data;

    sv_144_checker_dut dut (
        .clk   (clk),
        .reset (reset),
        .valid (valid),
        .ready (ready),
        .data  (data)
    );

    sv_144_protocol_checker protocol_checker (
        .clk   (clk),
        .reset (reset),
        .valid (valid),
        .ready (ready)
    );

    initial begin

        clk   = 1'b0;
        reset = 1'b1;
        valid = 1'b0;
        ready = 1'b0;
        data  = 8'h00;

        repeat (2)
            @(negedge clk);

        reset = 1'b0;

        // Valid transfer: assertion passes
        @(negedge clk);
        valid = 1'b1;
        ready = 1'b1;
        data  = 8'hA5;

        @(negedge clk);
        valid = 1'b0;
        ready = 1'b0;

        // Intentional protocol violation
        @(negedge clk);
        valid = 1'b1;
        ready = 1'b0;
        data  = 8'h3C;

        @(negedge clk);
        valid = 1'b0;
        ready = 1'b1;

        #5;
        $finish;

    end

    always #5 clk = ~clk;

endmodule
```

## Expected Output

```text
[25] DUT: transfer accepted, data=a5
ERROR: [35] CHECKER ASSERTION FAILED: valid=1 but ready=0
$finish called at time : 45 ns
```

## Vivado Usage

Add the `.sv` file to Simulation Sources and set:

```text
sv_144_checker_tb
```

as the simulation top.

Run Behavioral Simulation.

The expected verification architecture is:

```text
              +----------------------+
              |        DUT           |
              |                      |
valid ------->|                      |
ready ------->|                      |
data -------->|                      |
              +----------------------+
                         |
                         | observed signals
                         v
              +----------------------+
              |  Protocol Checker    |
              |                      |
              |  SVA Assertion       |
              +----------------------+
```

## Tool Compatibility Note

Vivado XSim 2025.1 reports:

```text
The SystemVerilog feature "Checker" is not supported yet for simulation.
```

Therefore, the literal `checker ... endchecker` syntax is not used in the runnable XSim version.

The module-based implementation demonstrates the same checker architecture and allows the assertion to be compiled and simulated.

## Key Takeaway

A SystemVerilog `checker` is intended to provide a dedicated structure for verification logic.

It can contain:

* Checker ports
* Assertions
* Verification properties

When the simulator does not support the `checker` construct, a separate module containing the same checking logic can provide a practical simulation-compatible alternative.


