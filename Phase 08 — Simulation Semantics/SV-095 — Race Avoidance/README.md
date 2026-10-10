
# 095 — SV-095 — Race Avoidance

## Introduction

A race condition can occur when the DUT, driver, and monitor access signals at the same simulation time without defined synchronization.

A **clocking block** provides a controlled timing interface between the testbench and DUT.

This example uses separate clocking blocks for the driver and monitor:

- `driver_cb` drives `d`.
- `monitor_cb` samples `d` and `q`.
- The DUT captures `d` on the rising clock edge using a nonblocking assignment.

This avoids uncontrolled direct `@(posedge clk)` access.

## Key Concepts

### 1. Driver Clocking Block

```systemverilog
clocking driver_cb @(posedge clk);
    output #1step d;
endclocking
````

The driver uses this clocking block to synchronize its stimulus with the clock.

### 2. Monitor Clocking Block

```systemverilog
clocking monitor_cb @(posedge clk);
    input #1step d;
    input #1step q;
endclocking
```

The monitor uses this clocking block to sample DUT signals with defined timing.

### 3. Virtual Interface

The driver and monitor receive the physical interface through a virtual interface:

```systemverilog
virtual simple_if vif;
```

This allows class-based testbench components to access the interface.

### 4. Race Avoidance

Instead of directly using:

```systemverilog
@(posedge clk);
```

the driver and monitor synchronize through their clocking blocks:

```systemverilog
@(vif.driver_cb);
```

and:

```systemverilog
@(vif.monitor_cb);
```

This provides controlled synchronization between testbench components and the DUT.

## Complete Code

```systemverilog
`timescale 1ns/1ps

interface simple_if;

    logic clk;
    logic d;
    logic q;

    // Clocking block used by the driver
    clocking driver_cb @(posedge clk);
        output #1step d;
    endclocking

    // Clocking block used by the monitor
    clocking monitor_cb @(posedge clk);
        input #1step d;
        input #1step q;
    endclocking

endinterface


module sv_095_race_avoidance_dut (
    simple_if bus
);

    always_ff @(posedge bus.clk) begin
        bus.q <= bus.d;
    end

endmodule


class driver;

    virtual simple_if vif;

    function new(virtual simple_if vif);
        this.vif = vif;
    endfunction

    task drive(input logic value);

        // Synchronize with the clock through the driver clocking block
        @(vif.driver_cb);

        // Drive input through the clocking block
        vif.driver_cb.d <= value;

        $display("[%0t] Driver  : d=%b",
                 $time, value);

    endtask

endclass


class monitor;

    virtual simple_if vif;

    function new(virtual simple_if vif);
        this.vif = vif;
    endfunction

    task run();

        forever begin

            // Synchronize with the clock through the monitor clocking block
            @(vif.monitor_cb);

            // Sample DUT interface signals
            $display("[%0t] Monitor : d=%b q=%b",
                     $time,
                     vif.monitor_cb.d,
                     vif.monitor_cb.q);

        end

    endtask

endclass


module sv_095_race_avoidance_tb;

    simple_if bus();

    sv_095_race_avoidance_dut dut (
        .bus(bus)
    );

    driver  drv;
    monitor mon;

    initial begin

        bus.clk = 1'b0;
        bus.d   = 1'b0;
        bus.q   = 1'b0;

        drv = new(bus);
        mon = new(bus);

        fork
            mon.run();
        join_none

        #7;
        drv.drive(1'b1);

        #10;
        drv.drive(1'b0);

        #10;

        $finish;

    end

    always #5 bus.clk = ~bus.clk;

endmodule
```

## Expected Output

```text
[5000] Monitor : d=0 q=0
[15000] Driver  : d=1
[15000] Monitor : d=0 q=0
[25000] Driver  : d=0
[25000] Monitor : d=1 q=0
$finish called at time : 35 ns
```

## Verification Relevance

Clocking blocks are important in SystemVerilog verification because they provide a standardized way to control when testbench components drive and sample DUT signals.

They are commonly used with:

* Drivers
* Monitors
* Virtual interfaces
* Transaction-based testbenches
* UVM interfaces

### SV-094 vs SV-095

**SV-094 — Race Condition**

```text
DUT + Driver + Monitor
        |
   Same clock edge
        |
   Possible race
```

**SV-095 — Race Avoidance**

```text
Driver → driver_cb
             |
           Clock
             |
            DUT
             |
        monitor_cb
             |
          Monitor
```

The main lesson is that **clocking blocks provide controlled timing and synchronization between the testbench and DUT, reducing race conditions in simulation.**

