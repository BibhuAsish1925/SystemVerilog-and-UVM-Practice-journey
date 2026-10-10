# 088 — SV-088 — Clocking Block + Monitor

## Introduction

A **clocking block + monitor** provides a race-free way for a testbench monitor to sample DUT signals.

Instead of directly sampling signals using:

```systemverilog
@(posedge vif.clk);
````

the monitor waits for:

```systemverilog
@(vif.cb);
```

The clocking block defines the timing relationship between the DUT and the testbench monitor.

For a monitor, the observed signals are declared as `input` because they are sampled from the DUT side.

## Key Concepts

### Clocking Block

A clocking block is declared using:

```systemverilog
clocking cb @(posedge clk);
    ...
endclocking
```

It provides controlled timing for testbench signal sampling.

### Input Signals

The monitor only observes the DUT signals:

```systemverilog
input #1step data;
input #1step valid;
input #1step ready;
```

The direction is from the DUT toward the testbench.

Therefore:

```text
data     DUT → Monitor
valid    DUT → Monitor
ready    DUT → Monitor
```

### Input Skew

The `#1step` input skew controls when the clocking block samples a signal relative to the clocking event:

```systemverilog
input #1step data;
```

This helps the monitor obtain stable sampled values and reduces race conditions between DUT activity and testbench sampling.

### Virtual Interface

The monitor is a class, so it receives a virtual interface:

```systemverilog
virtual simple_if vif;
```

The testbench passes the physical interface:

```systemverilog
mon = new(bus);
```

The monitor can then access the interface through `vif`.

### Monitor Sampling

The monitor waits for the clocking block event:

```systemverilog
@(vif.cb);
```

It then samples the clocking block signals:

```systemverilog
vif.cb.data
vif.cb.valid
vif.cb.ready
```

This provides a race-free sampling mechanism for verification.

## Complete Runnable Code

```systemverilog
interface simple_if;

    logic       clk;
    logic       reset;
    logic [7:0] data;
    logic       valid;
    logic       ready;

    // Clocking block used by the monitor
    clocking cb @(posedge clk);

        // Signals sampled by the monitor
        input #1step data;
        input #1step valid;
        input #1step ready;

    endclocking

endinterface


module sv_088_clocking_block_monitor_dut (
    simple_if bus
);

    always_ff @(posedge bus.clk) begin

        if (bus.reset)
            bus.ready <= 1'b0;
        else
            bus.ready <= bus.valid;

    end

endmodule


class monitor;

    virtual simple_if vif;

    function new(virtual simple_if vif);
        this.vif = vif;
    endfunction

    task run();

        forever begin

            // Wait for the clocking block event
            @(vif.cb);

            // Sample through the clocking block
            $display("[%0t] Monitor: data=%h | valid=%b | ready=%b",
                     $time,
                     vif.cb.data,
                     vif.cb.valid,
                     vif.cb.ready);

        end

    endtask

endclass


module sv_088_clocking_block_monitor_tb;

    simple_if bus();

    sv_088_clocking_block_monitor_dut dut (
        .bus(bus)
    );

    monitor mon;

    initial begin

        // Initialize interface
        bus.clk   = 1'b0;
        bus.reset = 1'b1;
        bus.data  = 8'h00;
        bus.valid = 1'b0;

        // Pass interface to the monitor
        mon = new(bus);

        // Start monitor
        fork
            mon.run();
        join_none

        #10;

        bus.reset = 1'b0;

        bus.data  = 8'hA5;
        bus.valid = 1'b1;

        #10;

        bus.data  = 8'h3C;
        bus.valid = 1'b1;

        #10;

        bus.valid = 1'b0;

        #10;

        $finish;

    end

    always #5 bus.clk = ~bus.clk;

endmodule
```

## Verification Relevance

A clocking-block monitor is an important building block for verification because it allows the testbench to observe DUT behavior without directly racing with DUT clocked logic.

This pattern is later used in:

* Non-UVM monitors
* Protocol monitors
* Transaction monitors
* Scoreboards
* UVM monitors
