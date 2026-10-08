# 120 — SV-120 — Temporal Operators

### Small Introduction

Temporal operators are used in SVA to describe relationships between
signals across multiple clock cycles.

This topic covers:

- `throughout` — an expression must remain true for the entire duration
  of a sequence.
- `within` — one sequence must occur completely inside another sequence.
- `until` — the left-hand expression must remain true until the
  right-hand expression becomes true.

These operators are useful for verifying multi-cycle protocol behavior,
transaction windows, busy periods, and completion conditions.

### Verification Relevance

Temporal operators can be used to verify:

- Signals that must remain asserted during an operation
- Events occurring inside a valid transaction window
- Busy-to-done behavior
- Multi-cycle protocol requirements
- Timing relationships between protocol events

### Complete Runnable Code

```systemverilog
`timescale 1ns/1ps

module sv_120_temporal_operators_tb;

    logic clk;

    logic busy;
    logic request;
    logic acknowledge;

    logic start;
    logic event_a;
    logic event_b;
    logic done;

    logic test_throughout;
    logic test_within;
    logic test_until;

    // throughout
    // busy must remain high throughout request -> acknowledge
    sequence request_ack;
        request ##1 acknowledge;
    endsequence

    ap_throughout:
        assert property (@(posedge clk)
                          test_throughout |->
                          (busy throughout request_ack))
        else $error("[%0t] throughout failed: busy was not high",
                    $time);

    // within
    // event_a -> event_b must occur completely
    // inside the start -> done operation window
    sequence event_sequence;
        event_a ##1 event_b;
    endsequence

    sequence operation_window;
        start ##1 done;
    endsequence

    ap_within:
        assert property (@(posedge clk)
                          test_within |->
                          (event_sequence within operation_window))
        else $error("[%0t] within failed: event sequence was outside window",
                    $time);

    // until
    // busy must remain high until done becomes high
    ap_until:
        assert property (@(posedge clk)
                          test_until |->
                          (busy until done))
        else $error("[%0t] until failed: busy ended before done",
                    $time);

    initial begin

        clk = 1'b0;

        busy        = 1'b0;
        request     = 1'b0;
        acknowledge = 1'b0;

        start   = 1'b0;
        event_a = 1'b0;
        event_b = 1'b0;
        done    = 1'b0;

        test_throughout = 1'b0;
        test_within     = 1'b0;
        test_until      = 1'b0;

        // throughout PASS
        @(negedge clk);

        busy = 1'b1;
        request = 1'b1;
        test_throughout = 1'b1;

        @(negedge clk);

        test_throughout = 1'b0;
        request = 1'b0;
        acknowledge = 1'b1;

        @(negedge clk);

        acknowledge = 1'b0;
        busy = 1'b0;

        // within PASS
        @(negedge clk);

        start = 1'b1;
        event_a = 1'b1;
        test_within = 1'b1;

        @(negedge clk);

        test_within = 1'b0;
        start = 1'b0;
        event_a = 1'b0;
        event_b = 1'b1;
        done = 1'b1;

        @(negedge clk);

        event_b = 1'b0;
        done = 1'b0;

        // until PASS
        @(negedge clk);

        busy = 1'b1;
        done = 1'b0;
        test_until = 1'b1;

        @(negedge clk);

        test_until = 1'b0;
        busy = 1'b1;
        done = 1'b0;

        @(negedge clk);

        busy = 1'b1;
        done = 1'b1;

        @(negedge clk);

        busy = 1'b0;
        done = 1'b0;

        #5;
        $finish;

    end

    always #5 clk = ~clk;

endmodule
````

### Expected Output

All three temporal-operator demonstrations are intended to pass.

```text
# run 1000ns

$finish called at time : 75 ns
INFO: [USF-XSim-96] XSim completed.
INFO: [USF-XSim-97] XSim simulation ran for 1000ns
```

No assertion error messages should appear.

### Key Concepts

#### throughout

```text
expression throughout sequence
```

The expression must remain true throughout the complete sequence.

Example:

```systemverilog
busy throughout (request ##1 acknowledge)
```

This checks that `busy` remains high while the request-to-acknowledge
sequence occurs.

#### within

```text
sequence_A within sequence_B
```

The complete match of `sequence_A` must occur within the match of
`sequence_B`.

Example:

```systemverilog
event_sequence within operation_window
```

This checks that the event sequence occurs inside the defined
operation window.

#### until

```text
expression until condition
```

The left expression remains true until the right condition becomes true.

Example:

```systemverilog
busy until done
```

This checks that `busy` remains high until `done` becomes high.

### Vivado Usage

Use a SystemVerilog simulation source:

```text
sv_120_temporal_operators_tb.sv
```

Simulation top:

```text
sv_120_temporal_operators_tb
```

Run:

```text
run 1000ns
```

The testbench uses separate trigger signals so each temporal operator
is demonstrated independently and deterministically.

