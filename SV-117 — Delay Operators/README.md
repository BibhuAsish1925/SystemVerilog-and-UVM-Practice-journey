# 117 — SV-117 — Delay Operators

### Introduction

SVA delay operators specify how many clock cycles later a consequent must occur.

The main operators covered here are:

- `##1` — the consequent must occur one clock cycle later.
- `##2` — the consequent must occur two clock cycles later.

For example:

```systemverilog
request ##1 acknowledge
````

means that after `request` occurs, `acknowledge` must occur on the next
clock cycle.

Separate trigger signals are used so that the `##1` and `##2`
demonstrations do not interfere with each other.

### Verification Relevance

Delay operators are useful for checking:

* Request/response timing
* Pipeline delays
* Protocol timing requirements
* Sequential control behavior
* Clock-cycle relationships

### Complete Runnable Code

```systemverilog
`timescale 1ns/1ps

module sv_117_delay_operators_tb;

    logic clk;
    logic request;
    logic acknowledge;

    logic test_one_cycle;
    logic test_two_cycle;

    // ##1: acknowledge must occur one cycle after request
    ap_one_cycle:
        assert property (@(posedge clk)
                          test_one_cycle |->
                          (request ##1 acknowledge))
        else $error("[%0t] ##1 failed: acknowledge missing after 1 cycle",
                    $time);

    // ##2: acknowledge must occur two cycles after request
    ap_two_cycle:
        assert property (@(posedge clk)
                          test_two_cycle |->
                          (request ##2 acknowledge))
        else $error("[%0t] ##2 failed: acknowledge missing after 2 cycles",
                    $time);

    initial begin

        clk = 1'b0;
        request = 1'b0;
        acknowledge = 1'b0;

        test_one_cycle = 1'b0;
        test_two_cycle = 1'b0;

        // ##1 PASS
        @(negedge clk);
        request = 1'b1;
        test_one_cycle = 1'b1;

        @(negedge clk);
        request = 1'b0;
        test_one_cycle = 1'b0;
        acknowledge = 1'b1;

        @(negedge clk);
        acknowledge = 1'b0;

        // ##2 PASS
        @(negedge clk);
        request = 1'b1;
        test_two_cycle = 1'b1;

        @(negedge clk);
        request = 1'b0;
        test_two_cycle = 1'b0;

        @(negedge clk);
        acknowledge = 1'b1;

        @(negedge clk);
        acknowledge = 1'b0;

        #5;
        $finish;

    end

    always #5 clk = ~clk;

endmodule
```

### Expected Output

Both delay assertions pass, so no assertion errors are expected.

```text
# run 1000ns
$finish called at time : 75 ns
INFO: [USF-XSim-96] XSim completed.
INFO: [USF-XSim-97] XSim simulation ran for 1000ns
```

### Key Difference

```text
##1 → consequent occurs 1 clock cycle later

##2 → consequent occurs 2 clock cycles later
```

### Vivado Verification

Simulation top:

```text
sv_117_delay_operators_tb
```

Vivado Simulator 2025.1 / XSim:

```text
Compilation   → PASS
Elaboration  → PASS
##1 assertion → PASS
##2 assertion → PASS
Simulation    → PASS
```

