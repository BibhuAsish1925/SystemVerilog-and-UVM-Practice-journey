# SV-026 — Tasks

A **task** is a reusable block of SystemVerilog code that can perform multiple operations and can contain timing controls.

Unlike functions, tasks can consume simulation time using controls such as `#`, `@`, and `wait`.

## 1. Task Declaration

Basic syntax:

```systemverilog
task task_name(input type argument);
    // task body
endtask
```

Example:

```systemverilog
task automatic print_message(input string message);
    #10;
    $display("[%0t] %s", $time, message);
endtask
```

The `automatic` keyword gives each task invocation its own storage, which is useful when multiple task calls may execute independently.

## 2. Timing Controls

Tasks can contain timing controls such as:

```systemverilog
#10;
```

This advances simulation time by 10 time units.

Other common timing controls include:

```systemverilog
@(posedge clk);
wait (done);
```

These allow tasks to model activities that depend on simulation events.

## Verification Relevance

Tasks are commonly used in verification for:

* Driving stimulus
* Waiting for clock edges
* Applying transactions
* Reset sequences
* Protocol operations
* Reusable testbench procedures

For example, a testbench task can drive a complete transaction and wait for the DUT to respond.


