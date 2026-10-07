# 086 — SV-086 — Clocking Block

## Introduction

A clocking block defines the timing relationship between a testbench and a DUT around a clock.

It helps synchronize testbench sampling and driving with the DUT and reduces race conditions.

A clocking block is declared using:

```systemverilog
clocking cb @(posedge clk);
````

Signals can then have input and output skew:

```systemverilog
input  #1step ready;
output #1step valid;
```

## Input and Output Skew

**Input skew** defines when the testbench samples an input signal relative to the clocking event.

```systemverilog
input #1step ready;
```

**Output skew** defines when the testbench drives an output signal relative to the clocking event.

```systemverilog
output #1step valid;
```

The clocking block therefore provides controlled timing for communication between the testbench and DUT.

## Verification Relevance

Clocking blocks are important in verification because DUT and testbench processes may otherwise access the same signals at the same simulation time.

They help:

* Avoid race conditions
* Synchronize testbench activity
* Define input sampling timing
* Define output driving timing
* Make clock-based testbench code easier to understand

Clocking blocks are commonly used in structured SystemVerilog testbenches and are also relevant when learning UVM verification architecture.

## Complete Runnable Code

```systemverilog
interface simple_if;

    logic       clk;
    logic       reset;
    logic [7:0] data;
    logic       valid;
    logic       ready;

    clocking cb @(posedge clk);

        input  #1step ready;
        input  #1step data;

        output #1step valid;

    endclocking

endinterface


module sv_086_clocking_block_dut (
    simple_if bus
);

    always_ff @(posedge bus.clk) begin

        if (bus.reset)
            bus.ready <= 1'b0;
        else
            bus.ready <= bus.valid;

    end

endmodule


module sv_086_clocking_block_tb;

    simple_if bus();

    sv_086_clocking_block_dut dut (
        .bus(bus)
    );

    initial begin

        bus.clk   = 1'b0;
        bus.reset = 1'b1;
        bus.data  = 8'h00;
        bus.valid = 1'b0;

        #10;

        bus.reset = 1'b0;

        // Drive through the clocking block
        @(bus.cb);

        bus.cb.valid <= 1'b1;
        bus.data     <= 8'hA5;

        // Sample through the clocking block
        @(bus.cb);

        $display("[%0t] Clocking block | data=%h | ready=%b",
                 $time,
                 bus.cb.data,
                 bus.cb.ready);

        bus.cb.valid <= 1'b0;

        @(bus.cb);

        $display("[%0t] Clocking block | data=%h | ready=%b",
                 $time,
                 bus.cb.data,
                 bus.cb.ready);

        #10;

        $finish;

    end

    always #5 bus.clk = ~bus.clk;

endmodule
```

## Key Takeaway

A clocking block groups clock-synchronized testbench signals and defines their timing relationship with the clock.

```systemverilog
clocking cb @(posedge clk);
    input  #1step ready;
    input  #1step data;
    output #1step valid;
endclocking
```

The testbench can synchronize with the clocking block:

```systemverilog
@(bus.cb);
```

and access its signals through:

```systemverilog
bus.cb.data
bus.cb.valid
bus.cb.ready
```

Input skew controls sampling timing, while output skew controls driving timing.

The main purpose of a clocking block is to provide predictable synchronization between the testbench and DUT and reduce race-condition problems.

