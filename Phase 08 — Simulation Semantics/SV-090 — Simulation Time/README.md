
# 090 — SV-090 — Simulation Time

## Introduction

SystemVerilog simulation uses **simulation time** to control when events occur.

Two important concepts are:

- **`#delay`** — pauses a procedural process for a specified simulation time.
- **`time`** — stores a simulation-time value such as the current time or a timestamp.

For example:

```systemverilog
#10;
````

means the current process waits for 10 simulation time units before continuing.

A `time` variable can capture the current simulation time:

```systemverilog
time start_time;
start_time = $time;
```

This is useful for measuring delays, transaction duration, and verification timing.

## `#delay`

A delay control uses the `#` symbol:

```systemverilog
#10;
```

The process pauses for 10 simulation time units before executing the next statement.

Another example:

```systemverilog
#5;
```

adds another 5 simulation time units.

The delay affects **simulation time**, not real-world execution time.

## `time`

The `time` data type is used to store simulation-time values:

```systemverilog
time start_time;
time end_time;
```

The system function:

```systemverilog
$time
```

returns the current simulation time.

For example:

```systemverilog
start_time = $time;
```

stores the current simulation timestamp.

## Measuring Elapsed Time

Two timestamps can be subtracted:

```systemverilog
elapsed_time = end_time - start_time;
```

This can be used to measure how long a simulated operation takes.

## Complete Runnable Code

```systemverilog
module sv_090_simulation_time_tb;

    time start_time;
    time end_time;
    time elapsed_time;

    initial begin

        start_time = $time;

        $display("[%0t] Simulation started",
                 $time);

        #10;

        end_time = $time;
        elapsed_time = end_time - start_time;

        $display("[%0t] After #10 delay",
                 $time);

        $display("Start time   = %0t",
                 start_time);

        $display("End time     = %0t",
                 end_time);

        $display("Elapsed time = %0t",
                 elapsed_time);

        #5;

        $display("[%0t] After additional #5 delay",
                 $time);

        $finish;

    end

endmodule
```

## Expected Behavior

Conceptually, the simulation progresses as:

```text
Time = 0
   │
   ├── #10
   ▼
Time = 10
   │
   └── #5
       ▼
     Time = 15
```

The expected logical result is:

```text
Start time   = 0
End time     = 10
Elapsed time = 10
Final time   = 15
```

Vivado XSim may display timestamps in ps depending on the simulator's time resolution. Therefore, a `#10` delay can appear as `10000`.

## Important SystemVerilog Concepts

### Delay Control

```systemverilog
#10;
```

Advances the current procedural process by 10 simulation time units.

### Current Simulation Time

```systemverilog
$time
```

Returns the current simulation time.

### Time Variable

```systemverilog
time timestamp;
```

Stores a simulation-time value.

### Elapsed Time

```systemverilog
elapsed_time = end_time - start_time;
```

Calculates the simulated duration between two timestamps.

## Verification Relevance

Simulation time is important for:

* Testbench timing
* Clock generation
* Protocol timing
* Transaction latency measurement
* Timeout mechanisms
* Event scheduling
* Simulation-based performance checks
