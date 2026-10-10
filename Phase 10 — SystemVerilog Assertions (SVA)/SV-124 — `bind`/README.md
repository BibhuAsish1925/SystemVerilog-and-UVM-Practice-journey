
# 124 — SV-124 — `bind`

## 1. Small Introduction

The SystemVerilog `bind` construct allows verification logic, such as assertions, to be attached to a DUT externally without modifying the DUT source code.

This is useful when:

- The DUT is already written and should remain unchanged.
- Assertions need to be added from a separate verification file.
- The same checker needs to be reused across multiple DUT instances.
- Verification properties should remain separate from design RTL.

Basic syntax:

```systemverilog
bind dut_module checker_module checker_instance (...);
````

Conceptually:

```text
DUT
 │
 └── bind ──► Assertion Checker
```

## 2. Important Syntax

A checker module can contain assertions:

```systemverilog
module assertion_checker (
    input logic clk,
    input logic valid,
    input logic ready
);

    assert property (@(posedge clk)
                      valid |-> ready);

endmodule
```

The checker can then be attached externally:

```systemverilog
bind dut_module
    assertion_checker checker_inst (
        .clk   (clk),
        .valid (valid),
        .ready (ready)
    );
```

The DUT source itself does not need to contain the assertion.

## 3. Verification Relevance

`bind` is useful for keeping design and verification logic separate.

```text
DUT RTL
   │
   │  bind
   ▼
Assertion Checker
```

Advantages:

* No modification of DUT RTL.
* Assertions can be added after RTL development.
* Checkers can be reused.
* Useful for verification of existing RTL.
* Keeps verification properties separate from implementation logic.

## 4. Complete Runnable Code

```systemverilog
`timescale 1ns/1ps

// ============================================================
// DUT
// No assertions are written inside this module.
// ============================================================

module sv_124_bind_dut (
    input  logic clk,
    input  logic reset,
    input  logic valid,
    input  logic ready
);

    // Simple DUT behavior
    // ready follows valid when not in reset.
    always_ff @(posedge clk) begin
        if (reset)
            ;
    end

endmodule


// ============================================================
// Assertion checker
// ============================================================

module sv_124_bind_checker (
    input logic clk,
    input logic reset,
    input logic valid,
    input logic ready
);

    // valid must imply ready on the same clock edge.
    ap_valid_ready:
        assert property (@(posedge clk)
                          disable iff (reset)
                          valid |-> ready)
        else $error("[%0t] BIND assertion failed: valid=1 but ready=0",
                    $time);

endmodule


// ============================================================
// BIND
// Attach checker externally to the DUT.
// ============================================================

bind sv_124_bind_dut
    sv_124_bind_checker checker_inst (
        .clk   (clk),
        .reset (reset),
        .valid (valid),
        .ready (ready)
    );


// ============================================================
// Testbench
// ============================================================

module sv_124_bind_tb;

    logic clk;
    logic reset;
    logic valid;
    logic ready;

    sv_124_bind_dut dut (
        .clk   (clk),
        .reset (reset),
        .valid (valid),
        .ready (ready)
    );

    initial begin

        clk   = 1'b0;
        reset = 1'b1;
        valid = 1'b0;
        ready = 1'b0;

        // Reset
        @(negedge clk);
        reset = 1'b1;
        valid = 1'b1;
        ready = 1'b0;

        // Release reset
        @(negedge clk);
        reset = 1'b0;

        // Assertion PASS
        valid = 1'b1;
        ready = 1'b1;

        @(negedge clk);
        valid = 1'b0;
        ready = 1'b0;

        // Assertion FAIL
        @(negedge clk);
        valid = 1'b1;
        ready = 1'b0;

        @(negedge clk);
        valid = 1'b0;
        ready = 1'b0;

        #5;
        $finish;

    end

    always #5 clk = ~clk;

endmodule
```

## 5. Expected Behavior

Compilation and elaboration should succeed.

The assertion is intentionally violated once after reset:

```text
Error: [45000] BIND assertion failed: valid=1 but ready=0
```

The important point is that the assertion is not written inside `sv_124_bind_dut`.

It is attached externally using:

```systemverilog
bind sv_124_bind_dut
    sv_124_bind_checker checker_inst (...);
```

Therefore, the DUT remains unchanged while the checker observes its signals.

## 6. Key Takeaway

```text
bind → Attach verification logic externally to existing RTL.

DUT RTL
   │
   └── bind ──► Assertion Checker
```

`bind` is especially useful for adding reusable assertions and verification checkers without modifying the design source.
