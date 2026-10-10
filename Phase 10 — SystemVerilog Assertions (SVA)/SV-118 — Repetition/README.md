# 118 — SV-118 — Repetition

## Introduction

SVA repetition operators describe how many times a sequence or condition must occur across clock cycles.

The main repetition operators covered here are:

- `[*3]` — consecutive repetition: the condition must hold for exactly 3 consecutive cycles.
- `[+]` — one or more repetition: the condition must hold for one or more consecutive cycles.
- `[->1]` — goto repetition: the condition must occur at least once, with the sequence completing when it occurs.

Repetition is useful for verifying protocol requirements such as:

- A `valid` signal remaining high for multiple cycles.
- A request remaining active for one or more cycles.
- A completion or acknowledgment eventually occurring.

## Important Syntax

### Consecutive Repetition

```systemverilog
valid[*3]
````

The sequence must match for three consecutive clocking events.

### One-or-More Repetition

```systemverilog
valid[+]
```

The sequence must match for one or more consecutive clocking events.

### Goto Repetition

```systemverilog
done[->1]
```

The condition must occur at least once. The sequence completes when the required occurrence happens.

## Verification Relevance

Repetition operators are useful for checking:

* Multi-cycle signal behavior
* Protocol timing requirements
* Request/response behavior
* Persistent `valid` or `enable` signals
* Eventual completion conditions

## Complete Runnable Code

```systemverilog
`timescale 1ns/1ps

module sv_118_repetition_tb;

    logic clk;
    logic valid;
    logic done;

    logic test_consecutive;
    logic test_one_or_more;
    logic test_goto;

    // [*3] : valid must be high for 3 consecutive cycles
    ap_consecutive:
        assert property (@(posedge clk)
                          test_consecutive |-> valid[*3])
        else $error("[%0t] [*3] failed: valid was not high for 3 cycles",
                    $time);

    // [+] : valid must be high for one or more cycles
    ap_one_or_more:
        assert property (@(posedge clk)
                          test_one_or_more |-> valid[+])
        else $error("[%0t] [+] failed: valid was not high",
                    $time);

    // [->1] : done must occur at least once
    ap_goto:
        assert property (@(posedge clk)
                          test_goto |-> done[->1])
        else $error("[%0t] [->1] failed: done did not occur",
                    $time);

    initial begin

        clk = 1'b0;
        valid = 1'b0;
        done = 1'b0;

        test_consecutive = 1'b0;
        test_one_or_more = 1'b0;
        test_goto = 1'b0;

        // Test [*3]
        @(negedge clk);
        valid = 1'b1;
        test_consecutive = 1'b1;

        @(negedge clk);
        test_consecutive = 1'b0;

        @(negedge clk);

        @(negedge clk);
        valid = 1'b0;

        // Test [+]
        @(negedge clk);
        valid = 1'b1;
        test_one_or_more = 1'b1;

        @(negedge clk);
        test_one_or_more = 1'b0;

        @(negedge clk);
        valid = 1'b0;

        // Test [->1]
        @(negedge clk);
        test_goto = 1'b1;
        done = 1'b0;

        @(negedge clk);
        test_goto = 1'b0;

        @(negedge clk);
        done = 1'b1;

        @(negedge clk);
        done = 1'b0;

        #5;
        $finish;

    end

    always #5 clk = ~clk;

endmodule
```

## Expected Result

The simulation should complete without assertion errors.

```text
# run 1000ns
$finish called at time : 115 ns
INFO: [USF-XSim-96] XSim completed.
INFO: [USF-XSim-97] XSim simulation ran for 1000ns
```

## Key Takeaway

* `[*3]` checks three consecutive matches.
* `[+]` checks one or more consecutive matches.
* `[->1]` checks that the condition occurs at least once.

These operators allow temporal repetition requirements to be expressed directly in SystemVerilog Assertions.
