# 098 — SV-098 — Implicit Bins

## Introduction

**Implicit bins** are automatically created by SystemVerilog when a coverpoint does not explicitly define its bins.

For a small integral value space, the simulator automatically creates coverage bins for the possible values of the coverpoint.

This example uses a 2-bit `opcode`, which has four possible values:

```text
00
01
10
11
````

No explicit bins are declared, so the simulator automatically creates the value coverage model.

## Key Concepts

### 1. Coverpoint Without Explicit Bins

The coverpoint can be declared without a bin list:

```systemverilog
coverpoint opcode;
```

The simulator automatically creates coverage bins for the values of the coverpoint.

### 2. Implicit Value Coverage

For a 2-bit signal:

```systemverilog
logic [1:0] opcode;
```

the possible values are:

```text
00
01
10
11
```

Each value can be tracked automatically by the coverpoint.

### 3. Sampling

The coverage model is sampled using:

```systemverilog
cg.sample();
```

For example:

```systemverilog
opcode = 2'b01;
cg.sample();
```

This records the current value of `opcode` in the coverage model.

### 4. Coverage Percentage

The current coverage percentage is obtained using:

```systemverilog
cg.get_coverage()
```

After all four possible values are sampled, the coverage reaches:

```text
100.00%
```

## Explicit vs Implicit Bins

### Explicit Bins

The verification engineer defines the bins:

```systemverilog
coverpoint opcode {
    bins add = {8'h01};
    bins sub = {8'h02};
    bins mul = {8'h03};
}
```

This provides direct control over the coverage model.

### Implicit Bins

The simulator creates the bins automatically:

```systemverilog
coverpoint opcode;
```

This is convenient when every individual value is meaningful and the value space is small.

## Complete Code

```systemverilog
`timescale 1ns/1ps

module sv_098_implicit_bins_tb;

    logic [1:0] opcode;

    // Functional coverage model
    covergroup opcode_cg;

        // No explicit bins are declared.
        // The simulator creates implicit value bins.
        coverpoint opcode;

    endgroup

    opcode_cg cg;

    initial begin

        // Create the coverage object
        cg = new();

        // Sample all possible 2-bit values
        opcode = 2'b00;
        cg.sample();

        opcode = 2'b01;
        cg.sample();

        opcode = 2'b10;
        cg.sample();

        opcode = 2'b11;
        cg.sample();

        $display("[%0t] Implicit-bin coverage = %0.2f%%",
                 $time,
                 cg.get_coverage());

        $finish;

    end

endmodule
```

## Expected Output

```text
[0] Implicit-bin coverage = 100.00%
$finish called at time : 0 ns
```

All possible values were sampled:

```text
00 → covered
01 → covered
10 → covered
11 → covered
```

## Coverage Flow

```text
2-bit opcode
     ↓
coverpoint opcode
     ↓
Automatic / implicit bins
     ↓
cg.sample()
     ↓
Coverage collection
     ↓
get_coverage()
```

## Verification Relevance

Implicit bins are useful when:

* The value space is small.
* Every individual value is important.
* Manual bin declarations would be unnecessary.
* A quick coverage model is required.

For larger value spaces, explicit bins or automatic range-based binning are generally more useful because tracking every individual value may create an unnecessarily large coverage model.

## Main Concept

**Implicit bins = automatically generated coverage bins when no explicit bins are declared.**

```systemverilog
coverpoint signal;
```

The main lesson of SV-098 is:

**Explicit bins give control; implicit bins provide automatic value coverage.**

