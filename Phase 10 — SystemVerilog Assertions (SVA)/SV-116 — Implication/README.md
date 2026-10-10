# 116 — SV-116 — Implication

### Introduction

SVA implication operators describe a relationship between a triggering condition
and a required condition.

- `|->` — overlapped implication; the consequent is checked on the same clock cycle.
- `|=>` — non-overlapped implication; the consequent is checked on the next clock cycle.

Stimulus is changed on the negative clock edge so that assertions can sample
stable values on the positive clock edge.

### Key Syntax

```systemverilog
@(posedge clk) antecedent |-> consequent
@(posedge clk) antecedent |=> consequent
````

### Verification Relevance

Implication operators are commonly used to express protocol requirements such as:

* If `valid` is asserted, `ready` must also be asserted.
* If a request occurs, an acknowledgement must occur on the next cycle.
* If a control condition occurs, a specific response must follow.

### Complete Runnable Code

```systemverilog
`timescale 1ns/1ps

module sv_116_implication_tb;

    logic clk;
    logic valid;
    logic ready;

    logic test_overlapped;
    logic test_non_overlapped;

    // |-> : valid and ready must be true on the same clock edge
    ap_overlapped:
        assert property (@(posedge clk)
                          test_overlapped |-> (valid && ready))
        else $error("[%0t] |-> failed: valid and ready were not both high",
                    $time);

    // |=> : ready must be true on the next clock edge
    ap_non_overlapped:
        assert property (@(posedge clk)
                          test_non_overlapped |=> ready)
        else $error("[%0t] |=> failed: ready was not high next cycle",
                    $time);

    initial begin

        clk = 1'b0;
        valid = 1'b0;
        ready = 1'b0;

        test_overlapped     = 1'b0;
        test_non_overlapped = 1'b0;

        // |-> PASS
        @(negedge clk);
        valid = 1'b1;
        ready = 1'b1;
        test_overlapped = 1'b1;

        @(negedge clk);
        test_overlapped = 1'b0;
        valid = 1'b0;
        ready = 1'b0;

        // |=> PASS
        @(negedge clk);
        valid = 1'b1;
        ready = 1'b0;
        test_non_overlapped = 1'b1;

        @(negedge clk);
        test_non_overlapped = 1'b0;
        valid = 1'b0;
        ready = 1'b1;

        @(negedge clk);
        ready = 1'b0;

        // |-> FAIL
        @(negedge clk);
        valid = 1'b1;
        ready = 1'b0;
        test_overlapped = 1'b1;

        @(negedge clk);
        test_overlapped = 1'b0;
        valid = 1'b0;

        // |=> FAIL
        @(negedge clk);
        valid = 1'b1;
        ready = 1'b0;
        test_non_overlapped = 1'b1;

        @(negedge clk);
        test_non_overlapped = 1'b0;
        valid = 1'b0;
        ready = 1'b0;

        @(negedge clk);

        #5;
        $finish;

    end

    always #5 clk = ~clk;

endmodule
```

### Expected Behavior

The first `|->` and `|=>` tests pass.

The second `|->` and `|=>` tests intentionally fail, producing two
assertion error messages while allowing the simulation to continue.

### Important Difference

```text
|->  Same-cycle implication
|=>  Next-cycle implication
```


