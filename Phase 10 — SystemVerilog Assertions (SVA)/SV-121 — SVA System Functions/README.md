# 121 — SV-121 — SVA System Functions

### Small Introduction

SVA provides several system functions for checking previous or current
signal behavior during assertion evaluation.

This topic covers:

- `$past(expr)` — returns the sampled value from a previous clock cycle.
- `$rose(expr)` — detects a `0 → 1` transition.
- `$fell(expr)` — detects a `1 → 0` transition.
- `$stable(expr)` — checks whether a signal remained unchanged.
- `$changed(expr)` — checks whether a signal changed.

These functions are useful for checking protocol handshakes,
control-signal transitions, and cycle-to-cycle behavior.

### Verification Relevance

SVA system functions are useful for verifying:

- Previous-cycle values
- Rising and falling transitions
- Stable signals
- Data changes
- Cycle-to-cycle protocol behavior
- Sequential relationships

### Function Summary

| Function | Meaning |
|---|---|
| `$past(expr)` | Sampled value from a previous cycle |
| `$rose(expr)` | Detects `0 → 1` transition |
| `$fell(expr)` | Detects `1 → 0` transition |
| `$stable(expr)` | Detects no change |
| `$changed(expr)` | Detects a change |

### Complete Runnable Code

```systemverilog
`timescale 1ns/1ps

module sv_121_sva_system_functions_tb;

    logic       clk;
    logic       signal_a;
    logic [7:0] data;

    logic test_past;
    logic test_rose;
    logic test_fell;
    logic test_stable;
    logic test_changed;

    // $past
    // Current data must equal previous data + 1.
    ap_past:
        assert property (@(posedge clk)
                          test_past |->
                          (data == $past(data) + 8'd1))
        else $error("[%0t] $past failed: data did not increment",
                    $time);

    // $rose
    ap_rose:
        assert property (@(posedge clk)
                          test_rose |-> $rose(signal_a))
        else $error("[%0t] $rose failed: signal_a did not rise",
                    $time);

    // $fell
    ap_fell:
        assert property (@(posedge clk)
                          test_fell |-> $fell(signal_a))
        else $error("[%0t] $fell failed: signal_a did not fall",
                    $time);

    // $stable
    ap_stable:
        assert property (@(posedge clk)
                          test_stable |-> $stable(data))
        else $error("[%0t] $stable failed: data changed",
                    $time);

    // $changed
    ap_changed:
        assert property (@(posedge clk)
                          test_changed |-> $changed(data))
        else $error("[%0t] $changed failed: data did not change",
                    $time);

    initial begin

        clk = 1'b0;
        signal_a = 1'b0;
        data = 8'd0;

        test_past    = 1'b0;
        test_rose    = 1'b0;
        test_fell    = 1'b0;
        test_stable  = 1'b0;
        test_changed = 1'b0;

        // $past PASS
        @(negedge clk);
        data = 8'd10;

        @(negedge clk);
        data = 8'd11;
        test_past = 1'b1;

        @(negedge clk);
        test_past = 1'b0;

        // $rose PASS
        @(negedge clk);
        signal_a = 1'b0;

        @(negedge clk);
        signal_a = 1'b1;
        test_rose = 1'b1;

        @(negedge clk);
        test_rose = 1'b0;

        // $fell PASS
        @(negedge clk);
        signal_a = 1'b1;

        @(negedge clk);
        signal_a = 1'b0;
        test_fell = 1'b1;

        @(negedge clk);
        test_fell = 1'b0;

        // $stable PASS
        @(negedge clk);
        data = 8'd20;

        @(negedge clk);
        data = 8'd20;
        test_stable = 1'b1;

        @(negedge clk);
        test_stable = 1'b0;

        // $changed PASS
        @(negedge clk);
        data = 8'd30;

        @(negedge clk);
        data = 8'd31;
        test_changed = 1'b1;

        @(negedge clk);
        test_changed = 1'b0;

        #5;
        $finish;

    end

    always #5 clk = ~clk;

endmodule
````

### Expected Output

All five demonstrations are intended to pass.

```text
# run 1000ns

$finish called at time : 105 ns
INFO: [USF-XSim-96] XSim completed.
INFO: [USF-XSim-97] XSim simulation ran for 1000ns
```

No assertion error messages should appear.

### Key Concepts

#### `$past`

Returns the sampled value from a previous clock cycle.

```systemverilog
data == $past(data) + 8'd1
```

This checks that the current value is one greater than the previous
sampled value.

#### `$rose`

Detects a rising transition:

```text
0 → 1
```

Example:

```systemverilog
$rose(signal_a)
```

#### `$fell`

Detects a falling transition:

```text
1 → 0
```

Example:

```systemverilog
$fell(signal_a)
```

#### `$stable`

Checks that the sampled value has not changed from the previous cycle.

```systemverilog
$stable(data)
```

#### `$changed`

Checks that the sampled value is different from the previous cycle.

```systemverilog
$changed(data)
```

### Vivado Usage

Use a SystemVerilog simulation source:

```text
sv_121_sva_system_functions_tb.sv
```

Simulation top:

```text
sv_121_sva_system_functions_tb
```

Run:

```text
run 1000ns
```

The testbench uses negedge-aligned stimulus so the assertion sampling
at the following posedge is deterministic.

