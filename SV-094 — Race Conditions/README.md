
# 094 — SV-094 — Race Conditions

## Introduction

A **race condition** occurs when multiple simulation processes access or modify the same signal in the same simulation time slot, and the result depends on their scheduling order.

Common verification races occur between:

- DUT and driver
- DUT and monitor
- Driver and monitor

A race should be avoided rather than relying on a particular simulator execution order.

---

## Running Code

**Code type:** SystemVerilog race-condition demonstration / testbench

```systemverilog
`timescale 1ns/1ps

module sv_094_race_conditions_tb;

    logic clk;
    logic d;
    logic q;

    // DUT
    always_ff @(posedge clk) begin
        q <= d;
    end

    // Driver
    initial begin
        clk = 1'b0;
        d   = 1'b0;

        #10;

        // Driver changes d at the same time
        // that the DUT samples d.
        @(posedge clk);
        d = 1'b1;

        #10;

        @(posedge clk);
        d = 1'b0;

        #10;

        $finish;
    end

    // Monitor
    always @(posedge clk) begin
        $display("[%0t] Monitor: d=%b q=%b",
                 $time, d, q);
    end

    always #5 clk = ~clk;

endmodule
````

---

## How the Race Occurs

The DUT samples `d` at:

```systemverilog
@(posedge clk)
```

The driver also changes `d` at:

```systemverilog
@(posedge clk)
```

The monitor is triggered by the same edge:

```systemverilog
always @(posedge clk)
```

Therefore, all three processes are activated by the same clock event.

Conceptually:

```text
             posedge clk
                  │
        ┌─────────┼─────────┐
        ↓         ↓         ↓
       DUT      Driver    Monitor
        │         │         │
     samples    changes    reads
        d          d         d/q
```

The testbench must not depend on which process executes first.

---

## Expected Output

Because the example intentionally contains a race, the exact ordering should not be considered guaranteed.

A possible output is:

```text
[5000] Monitor: d=0 q=x
[15000] Monitor: d=1 q=0
[25000] Monitor: d=0 q=1
```

The important problem is that the driver changes `d` on the same event where the DUT samples it.

---

## Safer Driver Timing

One simple way to avoid the race is to drive the input on the opposite clock edge:

```systemverilog
@(negedge clk);
d = 1'b1;
```

Now the sequence becomes:

```text
negedge
   ↓
Driver changes d
   ↓
d remains stable
   ↓
posedge
   ↓
DUT samples d
```

This provides a clear separation between driving and sampling.

---

## Clocking Blocks

For more advanced verification environments, SystemVerilog **clocking blocks** provide controlled timing for drivers and monitors.

For example:

```systemverilog
clocking cb @(posedge clk);
    input  q;
    output d;
endclocking
```

The driver and monitor can then use the clocking block instead of directly accessing signals at the same clock edge.

This is especially useful in structured testbenches and UVM environments.

---

## DUT / Driver / Monitor Race

### DUT

The DUT samples inputs:

```systemverilog
always_ff @(posedge clk)
    q <= d;
```

### Driver

The driver should provide inputs with enough timing margin before the DUT samples them.

### Monitor

The monitor should sample outputs after the DUT has updated them.

This separation prevents the monitor from observing an intermediate or stale value.

---

## Vivado Usage

1. Add `sv_094_race_conditions_tb.sv` under **Simulation Sources**.
2. Set `sv_094_race_conditions_tb` as the simulation top.
3. Run **Run Simulation → Run Behavioral Simulation**.
4. Observe the clock, `d`, and `q`.
5. Change the driver from `@(posedge clk)` to `@(negedge clk)`.
6. Run the simulation again.

---

## Key Takeaway

A race condition occurs when multiple processes interact at the same simulation event without a well-defined synchronization mechanism.

Common solutions include:

* Drive inputs before the DUT sampling edge.
* Sample outputs after the DUT update.
* Use nonblocking assignments appropriately.
* Use SystemVerilog clocking blocks.
* Use proper event-region synchronization.

In verification environments, avoiding race conditions is essential for producing deterministic and reliable simulations.

