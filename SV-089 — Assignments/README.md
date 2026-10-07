# 089 — SV-089 — Assignments

## Introduction

SystemVerilog provides two fundamental procedural assignment types:

- **Blocking `=`** — updates the left-hand side immediately within the current procedural flow.
- **Nonblocking `<=`** — schedules the update for the end of the current simulation time step.

A common RTL guideline is:

```text
Combinational logic → blocking =
Sequential/clocked logic → nonblocking <=
````

Understanding the difference is important because assignment type affects simulation ordering, race conditions, and sequential logic behavior.

## Blocking Assignment

Blocking assignment uses:

```systemverilog
=
```

Example:

```systemverilog
blocking_x = a;
blocking_y = blocking_x;
```

The second statement immediately sees the updated value of `blocking_x`.

Therefore, if `a = 1`:

```text
blocking_x = 1
blocking_y = 1
```

Blocking assignments are commonly used in combinational procedural logic.

## Nonblocking Assignment

Nonblocking assignment uses:

```systemverilog
<=
```

Example:

```systemverilog
nonblocking_x <= a;
nonblocking_y <= nonblocking_x;
```

The updates are scheduled rather than applied immediately.

Therefore, `nonblocking_y` receives the previous value of `nonblocking_x`.

This behavior makes nonblocking assignments appropriate for modeling clocked sequential logic such as flip-flops.

## Key Difference

```text
Blocking:
Statement 1 updates immediately
Statement 2 sees the new value

Nonblocking:
Statement 1 schedules an update
Statement 2 sees the previous value
```

## Complete Runnable Code

```systemverilog
module sv_089_assignments_tb;

    logic a;
    logic b;

    logic blocking_x;
    logic blocking_y;

    logic nonblocking_x;
    logic nonblocking_y;

    initial begin

        a = 1'b1;
        b = 1'b0;

        // Blocking assignments execute immediately
        blocking_x = a;
        blocking_y = blocking_x;

        $display("[%0t] Blocking    : x=%b y=%b",
                 $time,
                 blocking_x,
                 blocking_y);

        // Nonblocking assignments update later
        nonblocking_x <= a;
        nonblocking_y <= nonblocking_x;

        // NBA updates have not occurred yet
        $display("[%0t] Before NBA  : x=%b y=%b",
                 $time,
                 nonblocking_x,
                 nonblocking_y);

        #1;

        // NBA updates have now occurred
        $display("[%0t] After NBA   : x=%b y=%b",
                 $time,
                 nonblocking_x,
                 nonblocking_y);

        $finish;

    end

endmodule
```

## Expected Behavior

The output should be similar to:

```text
[0] Blocking    : x=1 y=1
[0] Before NBA  : x=x y=x
[1000] After NBA   : x=1 y=x
```

The exact timestamp representation depends on the simulator time resolution.

The important result is that blocking assignments update immediately, while nonblocking assignments schedule their updates.

## RTL Guideline

Use blocking assignments for combinational procedural logic:

```systemverilog
always_comb begin
    y = a & b;
end
```

Use nonblocking assignments for clocked sequential logic:

```systemverilog
always_ff @(posedge clk) begin
    q <= d;
end
```

This distinction becomes especially important when multiple registers are updated on the same clock edge.

## Verification Relevance

Understanding blocking and nonblocking assignments is essential for:

* RTL simulation
* Race-condition analysis
* Flip-flop modeling
* Combinational logic modeling
* Testbench timing
* SystemVerilog simulation semantics

