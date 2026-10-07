# Phase 7 — Interfaces & Testbench Connectivity

# 087 — SV-087 — Clocking Block + Driver

## Introduction

A **clocking block + driver** provides a race-free way for a testbench driver to drive DUT signals.

Instead of directly using:

```systemverilog
@(posedge vif.clk);
````

the driver waits for:

```systemverilog
@(vif.cb);
```

The clocking block defines the timing relationship between the driver and the DUT.

In this example:

* `data` and `valid` are clocking-block outputs because the driver drives them.
* `ready` is a clocking-block input because the driver samples it.
* `#1step` provides timing skew to help avoid race conditions.

## Key Concepts

### Clocking Block

A clocking block is declared using:

```systemverilog
clocking cb @(posedge clk);
    ...
endclocking
```

It creates a controlled timing interface between the testbench and the DUT.

### Clocking Block Directions

For this driver:

```systemverilog
input  #1step ready;

output #1step data;
output #1step valid;
```

The directions describe the signals from the **testbench/clocking-block perspective**.

Therefore:

```text
ready       DUT → Driver
data        Driver → DUT
valid       Driver → DUT
```

### Important Correction

The same signal must not be declared twice in the same clocking block.

Incorrect:

```systemverilog
input  #1step data;
output #1step data;
```

Correct:

```systemverilog
output #1step data;
```

because this driver drives `data`.

### Output Skew

```systemverilog
output #1step data;
```

The `#1step` output skew controls when the clocking-block output is driven relative to the clocking event.

This helps prevent the testbench from racing with DUT logic operating on the same clock edge.

### Virtual Interface

The driver is a class, so it receives a virtual interface:

```systemverilog
virtual simple_if vif;
```

The testbench passes the physical interface to the driver:

```systemverilog
drv = new(bus);
```

The driver can then access the interface through `vif`.

### Driver Operation

The driver waits for the clocking block:

```systemverilog
@(vif.cb);
```

and drives the signals through it:

```systemverilog
vif.cb.data  <= data_value;
vif.cb.valid <= 1'b1;
```

After another clocking event, `valid` is deasserted:

```systemverilog
@(vif.cb);
vif.cb.valid <= 1'b0;
```

## Complete Runnable Code

```systemverilog
interface simple_if;

    logic       clk;
    logic       reset;
    logic [7:0] data;
    logic       valid;
    logic       ready;

    // Clocking block used by the driver
    clocking cb @(posedge clk);

        // Signals sampled by the driver
        input  #1step ready;

        // Signals driven by the driver
        output #1step data;
        output #1step valid;

    endclocking

endinterface


module sv_087_clocking_block_driver_dut (
    simple_if bus
);

    always_ff @(posedge bus.clk) begin

        if (bus.reset)
            bus.ready <= 1'b0;
        else
            bus.ready <= bus.valid;

    end

endmodule


class driver;

    virtual simple_if vif;

    function new(virtual simple_if vif);
        this.vif = vif;
    endfunction

    task drive(input logic [7:0] data_value);

        // Wait for the clocking block event
        @(vif.cb);

        // Drive signals through the clocking block
        vif.cb.data  <= data_value;
        vif.cb.valid <= 1'b1;

        // Wait for the next clocking event
        @(vif.cb);

        // Deassert valid
        vif.cb.valid <= 1'b0;

        $display("[%0t] Driver sent data = %h",
                 $time,
                 data_value);

    endtask

endclass


module sv_087_clocking_block_driver_tb;

    simple_if bus();

    sv_087_clocking_block_driver_dut dut (
        .bus(bus)
    );

    driver drv;

    initial begin

        // Initialize interface
        bus.clk   = 1'b0;
        bus.reset = 1'b1;
        bus.data  = 8'h00;
        bus.valid = 1'b0;

        // Pass the physical interface to the driver
        drv = new(bus);

        #10;

        bus.reset = 1'b0;

        // Driver sends one transaction
        drv.drive(8'hA5);

        #10;

        $finish;

    end

    always #5 bus.clk = ~bus.clk;

endmodule
```

## Verification Relevance

Clocking blocks are important in verification because they provide controlled timing between the testbench and DUT.

The driver pattern introduced here is later used in:

* Non-UVM testbench drivers
* Protocol drivers
* Transaction-based verification
* UVM drivers
* Race-free DUT stimulus generation

```
```
