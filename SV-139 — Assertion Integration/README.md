
# 139 — SV-139 — Assertion Integration

## 1. Concept

Assertion Integration connects **SystemVerilog Assertions (SVA)** directly to DUT behavior.

The DUT generates `ready` based on `valid` and `enable`.

The verification property checks:

```text
When valid is high, ready must also be high.
````

### Verification Flow

```text
Stimulus
   ↓
DUT
   ↓
ready
   ↓
SVA Assertion
   ↓
PASS / FAILURE
```

## 2. Important Concepts

### DUT

The DUT contains the behavior being verified:

```systemverilog
ready <= valid && enable;
```

Therefore, when `valid=1` and `enable=0`, the DUT produces:

```text
ready = 0
```

### SVA Property

The assertion is:

```systemverilog
assert property (@(posedge clk)
                  disable iff (reset)
                  valid |-> ready)
```

This means:

* Check the property on every positive clock edge.
* Disable the assertion during reset.
* If `valid` is high, `ready` must be high on the same clocking event.

### Assertion Failure

If:

```text
valid = 1
ready = 0
```

the assertion fails and `$error` reports the violation.

## 3. Verification Relevance

Assertion integration is useful for checking:

* Protocol rules
* Handshake behavior
* Reset behavior
* Timing relationships
* Control signal relationships
* Illegal DUT states

Assertions provide automatic checking while simulation is running.

## 4. Complete Runnable Code

```systemverilog
`timescale 1ns/1ps

module sv_139_dut (
    input  logic clk,
    input  logic reset,
    input  logic valid,
    input  logic enable,
    output logic ready
);

    always_ff @(posedge clk) begin

        if (reset)
            ready <= 1'b0;
        else
            ready <= valid && enable;

    end

endmodule


module sv_139_assertion_integration_tb;

    logic clk;
    logic reset;
    logic valid;
    logic enable;
    logic ready;

    sv_139_dut dut (
        .clk    (clk),
        .reset  (reset),
        .valid  (valid),
        .enable (enable),
        .ready  (ready)
    );


    // When valid is high, ready must be high.
    ap_valid_ready:
        assert property (@(posedge clk)
                          disable iff (reset)
                          valid |-> ready)
        else $error("[%0t] ASSERTION FAILED: valid=1 but ready=0",
                    $time);


    initial begin

        clk    = 1'b0;
        reset  = 1'b1;
        valid  = 1'b0;
        enable = 1'b0;

        // Reset
        @(negedge clk);

        reset = 1'b1;

        @(negedge clk);

        // Valid transaction with enable
        reset  = 1'b0;
        enable = 1'b1;
        valid  = 1'b1;

        @(negedge clk);

        valid = 1'b0;

        // Intentional assertion failure
        // valid=1 while enable=0 causes ready=0.
        @(negedge clk);

        enable = 1'b0;
        valid  = 1'b1;

        @(negedge clk);

        valid = 1'b0;

        @(negedge clk);

        $finish;

    end


    always #5 clk = ~clk;

endmodule
```

## 5. Expected Result

The first valid transaction passes.

The second transaction intentionally violates the assertion:

```text
valid = 1
ready = 0
```

The simulator should report:

```text
ASSERTION FAILED: valid=1 but ready=0
```

The test then continues until `$finish`.

## 6. Vivado Usage

Save the file as:

```text
sv_139_assertion_integration.sv
```

Set:

```text
sv_139_assertion_integration_tb
```

as the simulation top and run:

```text
launch_simulation
run 1000ns
```

Check the Tcl console for the SVA failure message.

