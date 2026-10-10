
# 123 — SV-123 — Assertion Intent

## 1. Small Introduction

SystemVerilog Assertions provide three main assertion intents:

- **`assert property`** — checks that a property is true. A failure indicates a design/verification violation.
- **`assume property`** — specifies a condition that the environment is expected to satisfy. Mainly used to constrain formal verification.
- **`cover property`** — checks whether a property or sequence actually occurs, useful for measuring scenario reachability.

In short:

```text
assert  → "The design must satisfy this."
assume  → "The environment is expected to satisfy this."
cover   → "Did this scenario ever happen?"
````

## 2. Important Syntax

### Assert

```systemverilog
assert property (property_expression)
    else $error("Assertion failed");
```

Used to verify that design behavior satisfies a requirement.

### Assume

```systemverilog
assume property (property_expression);
```

Used to describe legal or expected environment behavior, especially in formal verification.

### Cover

```systemverilog
cover property (property_expression);
```

Used to determine whether a particular scenario can occur.

## 3. Verification Relevance

These three constructs have different purposes:

| Construct         | Purpose                        |
| ----------------- | ------------------------------ |
| `assert property` | Check design behavior          |
| `assume property` | Constrain environment behavior |
| `cover property`  | Check scenario reachability    |

A useful verification mindset is:

```text
ASSERT → Is the design correct?
ASSUME → What can the environment legally do?
COVER  → Can this interesting scenario happen?
```

## 4. Complete Runnable Code

```systemverilog
`timescale 1ns/1ps

module sv_123_assertion_intent_tb;

    logic clk;
    logic reset;
    logic valid;
    logic ready;

    // ------------------------------------------------------------
    // ASSERT
    // valid must imply ready on the same clock edge.
    // ------------------------------------------------------------
    ap_valid_ready:
        assert property (@(posedge clk)
                          disable iff (reset)
                          valid |-> ready)
        else $error("[%0t] ASSERT failed: valid=1 but ready=0",
                    $time);

    // ------------------------------------------------------------
    // ASSUME
    // In a formal environment, assume that valid is not asserted
    // while reset is active.
    // ------------------------------------------------------------
    ap_reset_environment:
        assume property (@(posedge clk)
                          reset |-> !valid);

    // ------------------------------------------------------------
    // COVER
    // Check whether a valid transaction followed by ready occurs.
    // ------------------------------------------------------------
    cp_valid_ready:
        cover property (@(posedge clk)
                         disable iff (reset)
                         valid ##1 ready);

    initial begin

        clk   = 1'b0;
        reset = 1'b1;
        valid = 1'b0;
        ready = 1'b0;

        // Reset
        @(negedge clk);
        reset = 1'b1;
        valid = 1'b0;
        ready = 1'b0;

        // Valid transaction: ASSERT passes
        @(negedge clk);
        reset = 1'b0;
        valid = 1'b1;
        ready = 1'b1;

        @(negedge clk);
        valid = 1'b0;
        ready = 1'b0;

        // Cover scenario:
        // valid at one clock, ready at the next clock.
        @(negedge clk);
        valid = 1'b1;
        ready = 1'b0;

        @(negedge clk);
        valid = 1'b0;
        ready = 1'b1;

        @(negedge clk);
        valid = 1'b0;
        ready = 1'b0;

        // Intentional ASSERT failure
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

The first valid/ready transaction satisfies the assertion.

The `cover property` scenario occurs when `valid` is followed by `ready` on the next clock.

The final transaction intentionally violates the assertion, so the simulator reports an assertion error.

The `assume property` does not normally produce a simulation pass/fail message. Its primary role is to constrain environment behavior during formal verification.

## 6. Key Takeaway

```text
assert property → Verify required design behavior
assume property  → Constrain expected environment behavior
cover property   → Check whether a scenario can occur
```


