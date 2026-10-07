# 091 — SV-091 — Event Control

## Introduction

SystemVerilog provides event-control mechanisms that allow a process to wait for a specific simulation event or condition.

The main mechanisms covered here are:

- **`@`** — waits for an event or signal transition.
- **`wait`** — waits until a Boolean condition becomes true.
- **Event expressions** — combine multiple events to control when a process resumes.

These mechanisms are fundamental in testbenches because they allow stimulus and checking to synchronize with DUT activity.

## `@` Event Control

The `@` operator can wait for a signal event:

```systemverilog
@(posedge clk);
````

The process pauses until `clk` changes from `0` to `1`.

Other common event controls include:

```systemverilog
@(negedge clk);
@(posedge valid);
@(signal);
```

## `wait`

The `wait` statement waits until a Boolean expression becomes true:

```systemverilog
wait (enable == 1'b1);
```

Unlike `@`, `wait` is condition-based rather than specifically tied to an edge.

When `enable` becomes `1`, the process continues.

## Event Expressions

Multiple events can be combined:

```systemverilog
@(posedge clk or posedge done);
```

The process resumes when either:

* `clk` has a rising edge, or
* `done` has a rising edge.

This is useful when a testbench needs to react to multiple possible events.

## Complete Runnable Code

```systemverilog
module sv_091_event_control_tb;

    logic clk;
    logic enable;
    logic done;

    initial begin

        clk    = 1'b0;
        enable = 1'b0;
        done   = 1'b0;

        // @ waits for a signal event
        @(posedge clk);

        $display("[%0t] @: Detected clock rising edge",
                 $time);

        // wait waits until the condition becomes true
        wait (enable == 1'b1);

        $display("[%0t] wait: Enable became 1",
                 $time);

        // Event expression: wait for either condition
        @(posedge clk or posedge done);

        $display("[%0t] Event expression: clock or done detected",
                 $time);

        $finish;

    end


    // Generate clock
    always #5 clk = ~clk;


    initial begin

        #12;
        enable = 1'b1;

        #8;
        done = 1'b1;

    end

endmodule
```

## Expected Behavior

The process first waits for:

```systemverilog
@(posedge clk);
```

Then it waits for:

```systemverilog
wait (enable == 1'b1);
```

Finally, it waits for either:

```systemverilog
@(posedge clk or posedge done);
```

The expected output is similar to:

```text
[5000] @: Detected clock rising edge
[15000] wait: Enable became 1
[25000] Event expression: clock or done detected
```

The exact timestamp representation depends on the simulator's time resolution.

## Key Difference

```text
@       → Wait for an event
wait    → Wait for a condition
or      → Allow multiple events to trigger continuation
```

For example:

```systemverilog
@(posedge clk);
```

waits for a specific edge.

```systemverilog
wait (ready);
```

waits until `ready` becomes true.

```systemverilog
@(posedge clk or posedge done);
```

waits for either event.

## Verification Relevance

Event control is heavily used in verification for:

* Clock synchronization
* Waiting for DUT responses
* Testbench sequencing
* Handshake monitoring
* Protocol checking
* Transaction timing
* Driver and monitor synchronization
