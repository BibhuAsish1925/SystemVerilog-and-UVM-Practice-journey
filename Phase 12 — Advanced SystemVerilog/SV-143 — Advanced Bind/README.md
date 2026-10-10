
# 143 — SV-143 — Advanced Bind

## Introduction

SystemVerilog `bind` allows verification code to be attached to an existing DUT without modifying the DUT source code.

This example demonstrates:

- Binding monitors
- Binding checkers
- Binding assertions

The DUT remains unchanged while additional verification logic is attached externally.

## 1. Binding a Monitor

A monitor can be created separately and attached to the DUT:

```systemverilog
bind sv_143_advanced_bind_dut
    sv_143_bound_monitor monitor_inst (
        .clk   (clk),
        .valid (valid),
        .ready (ready),
        .data  (data)
    );
````

The monitor can observe DUT signals and report transactions.

## 2. Binding a Checker

A checker is dedicated verification logic that can observe DUT behavior.

```systemverilog
bind sv_143_advanced_bind_dut
    sv_143_bound_checker checker_inst (
        .clk   (clk),
        .reset (reset),
        .valid (valid),
        .ready (ready)
    );
```

The checker is useful for protocol or functional checks without changing RTL.

## 3. Binding Assertions

SVA properties can also be placed in a separate assertion module and bound into the DUT.

```systemverilog
bind sv_143_advanced_bind_dut
    sv_143_bound_assertion assertion_inst (
        .clk   (clk),
        .reset (reset),
        .valid (valid),
        .ready (ready)
    );
```

The assertion used here checks:

```systemverilog
valid |-> ready
```

Therefore, whenever `valid` is asserted, `ready` must also be high at the same clocking point.

## Verification Relevance

Advanced `bind` is useful for:

* Adding assertions to existing RTL
* Monitoring internal or interface signals
* Creating reusable protocol checkers
* Keeping verification code separate from RTL
* Adding verification to third-party or frozen IP
* Reusing the same checker across multiple DUT instances

## Complete Runnable Code

```systemverilog
`timescale 1ns/1ps

module sv_143_advanced_bind_dut (
    input logic       clk,
    input logic       reset,
    input logic       valid,
    input logic       ready,
    input logic [7:0] data
);

    logic [7:0] stored_data;

    always_ff @(posedge clk) begin

        if (reset)
            stored_data <= 8'h00;
        else if (valid && ready)
            stored_data <= data;

    end

endmodule


// Bound monitor
module sv_143_bound_monitor (
    input logic       clk,
    input logic       valid,
    input logic       ready,
    input logic [7:0] data
);

    always @(posedge clk) begin

        if (valid && ready)
            $display("[%0t] Bound Monitor: transfer data=%h",
                     $time, data);

    end

endmodule


// Bound checker
module sv_143_bound_checker (
    input logic       clk,
    input logic       reset,
    input logic       valid,
    input logic       ready
);

    always @(posedge clk) begin

        if (!reset && valid && !ready)
            $display("[%0t] Bound Checker: waiting for ready",
                     $time);

    end

endmodule


// Bound assertion
module sv_143_bound_assertion (
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
            $error("[%0t] Bound Assertion FAILED: valid=1 but ready=0",
                   $time);

endmodule


// Bind monitor into DUT
bind sv_143_advanced_bind_dut
    sv_143_bound_monitor monitor_inst (
        .clk   (clk),
        .valid (valid),
        .ready (ready),
        .data  (data)
    );


// Bind checker into DUT
bind sv_143_advanced_bind_dut
    sv_143_bound_checker checker_inst (
        .clk   (clk),
        .reset (reset),
        .valid (valid),
        .ready (ready)
    );


// Bind assertion into DUT
bind sv_143_advanced_bind_dut
    sv_143_bound_assertion assertion_inst (
        .clk   (clk),
        .reset (reset),
        .valid (valid),
        .ready (ready)
    );


module sv_143_advanced_bind_tb;

    logic       clk;
    logic       reset;
    logic       valid;
    logic       ready;
    logic [7:0] data;

    sv_143_advanced_bind_dut dut (
        .clk   (clk),
        .reset (reset),
        .valid (valid),
        .ready (ready),
        .data  (data)
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

        // Valid transfer
        @(negedge clk);
        valid = 1'b1;
        ready = 1'b1;
        data  = 8'hA5;

        @(negedge clk);
        valid = 1'b0;
        ready = 1'b0;

        // Intentional assertion failure
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
[25] Bound Monitor: transfer data=a5
[35] Bound Checker: waiting for ready
ERROR: [35] Bound Assertion FAILED: valid=1 but ready=0
$finish called at time : 45 ns
```

## Vivado Usage

Add the `.sv` file to Simulation Sources and set:

```text
sv_143_advanced_bind_tb
```

as the simulation top.

Run Behavioral Simulation.

The bound components should appear conceptually below the DUT:

```text
dut
 ├── monitor_inst
 ├── checker_inst
 └── assertion_inst
```

## Key Takeaway

`bind` allows verification logic to be attached to an existing DUT without modifying its RTL.

It can be used to attach:

* Monitors
* Checkers
* Assertions

This provides a clean separation between **design implementation** and **verification logic**.


