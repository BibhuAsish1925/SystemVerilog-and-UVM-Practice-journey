# 097 — SV-097 — Coverpoint

## Introduction

A **coverpoint** defines what signal or expression a covergroup should measure.

A covergroup provides the overall functional coverage model, while a coverpoint focuses on a specific signal or value.

In this example, an 8-bit `opcode` is measured using four value bins.

## Key Concepts

### 1. Coverpoint

A coverpoint is declared inside a covergroup:

```systemverilog
covergroup opcode_cg;

    coverpoint opcode;

endgroup
````

It tells the simulator to collect coverage information for `opcode`.

### 2. Value Coverage

A coverpoint can define bins for specific values:

```systemverilog
coverpoint opcode {
    bins add = {8'h01};
    bins sub = {8'h02};
    bins mul = {8'h03};
    bins div = {8'h04};
}
```

Each bin represents a functional value that the verification environment should exercise.

The mapping is:

```text
8'h01 → add
8'h02 → sub
8'h03 → mul
8'h04 → div
```

### 3. Sampling

The current value of the coverpoint is recorded when the covergroup is sampled:

```systemverilog
opcode = 8'h01;
cg.sample();
```

The `add` bin is then hit.

### 4. Coverage Percentage

Coverage can be queried using:

```systemverilog
cg.get_coverage()
```

If all four bins are hit, the coverpoint reaches:

```text
100.00%
```

## Complete Code

```systemverilog
`timescale 1ns/1ps

module sv_097_coverpoint_tb;

    logic [7:0] opcode;

    // Functional coverage model
    covergroup opcode_cg;

        // Coverpoint measures the opcode value
        coverpoint opcode {
            bins add = {8'h01};
            bins sub = {8'h02};
            bins mul = {8'h03};
            bins div = {8'h04};
        }

    endgroup

    opcode_cg cg;

    initial begin

        // Create the coverage object
        cg = new();

        // Sample different opcode values
        opcode = 8'h01;
        cg.sample();

        opcode = 8'h02;
        cg.sample();

        opcode = 8'h03;
        cg.sample();

        opcode = 8'h04;
        cg.sample();

        $display("[%0t] Coverpoint coverage = %0.2f%%",
                 $time,
                 cg.get_coverage());

        $finish;

    end

endmodule
```

## Expected Output

```text
[0] Coverpoint coverage = 100.00%
$finish called at time : 0 ns
```

The four sampled values hit all four bins:

```text
01 → add
02 → sub
03 → mul
04 → div
```

## Coverage Flow

```text
Signal / Expression
        ↓
    Coverpoint
        ↓
      Bins
        ↓
    Sample value
        ↓
      Bin hit
        ↓
Coverage percentage
```

## Verification Relevance

Coverpoints are fundamental to functional coverage because they identify specific values, states, or conditions that should be exercised during verification.

They are commonly used for:

* Opcode coverage
* State coverage
* Protocol field coverage
* Configuration coverage
* Boundary-value coverage
* Control-signal coverage

For example, an instruction decoder may define bins for each supported opcode:

```systemverilog
coverpoint opcode {
    bins add = {8'h01};
    bins sub = {8'h02};
    bins mul = {8'h03};
    bins div = {8'h04};
}
```

The main concept of SV-097 is:

**Coverpoint = What should be measured**

**Bins = Which values are considered meaningful**

