# 099 — SV-099 — Explicit Bins

## Introduction

**Explicit bins** allow the verification engineer to define exactly how values are grouped in a functional coverage model.

Unlike implicit bins, explicit bins provide direct control over:

- Bin names
- Individual values
- Value groups
- Functional meaning

This example groups an 8-bit `opcode` into three functional categories:

```text
arithmetic → 01, 02, 03
logical    → 10, 11
control    → 20, 21
````

## Key Concepts

### 1. Explicit Bin Declaration

Explicit bins are declared inside a coverpoint:

```systemverilog
coverpoint opcode {

    bins arithmetic = {8'h01, 8'h02, 8'h03};
    bins logical    = {8'h10, 8'h11};
    bins control    = {8'h20, 8'h21};

}
```

The verification engineer decides which values belong to each bin.

### 2. User-Defined Bin Names

Each bin has a meaningful name:

```systemverilog
bins arithmetic = {8'h01, 8'h02, 8'h03};
```

The name `arithmetic` describes the functional behavior represented by those values.

### 3. Multiple Values in One Bin

A single bin can contain multiple values:

```systemverilog
bins arithmetic = {8'h01, 8'h02, 8'h03};
```

Any sampled value from `01`, `02`, or `03` hits the same `arithmetic` bin.

For example:

```systemverilog
opcode = 8'h02;
cg.sample();
```

hits:

```text
arithmetic
```

### 4. Bin Coverage

A bin becomes covered when at least one sampled value matches that bin.

For example:

```text
01 → arithmetic → covered
10 → logical    → covered
20 → control    → covered
```

The other values in those bins do not need to be sampled for the bin itself to be hit.

## Explicit Bins vs Implicit Bins

### Implicit Bin

```systemverilog
coverpoint opcode;
```

The simulator automatically creates the coverage model.

### Explicit Bins

```systemverilog
coverpoint opcode {

    bins arithmetic = {8'h01, 8'h02, 8'h03};
    bins logical    = {8'h10, 8'h11};
    bins control    = {8'h20, 8'h21};

}
```

The verification engineer explicitly defines the functional categories.

## Complete Code

```systemverilog
`timescale 1ns/1ps

module sv_099_explicit_bins_tb;

    logic [7:0] opcode;

    // Functional coverage model
    covergroup opcode_cg;

        // User-defined functional bins
        coverpoint opcode {

            bins arithmetic = {8'h01, 8'h02, 8'h03};
            bins logical    = {8'h10, 8'h11};
            bins control    = {8'h20, 8'h21};

        }

    endgroup

    opcode_cg cg;

    initial begin

        // Create the coverage object
        cg = new();

        // Hit arithmetic bin
        opcode = 8'h01;
        cg.sample();

        // Hit logical bin
        opcode = 8'h10;
        cg.sample();

        // Hit control bin
        opcode = 8'h20;
        cg.sample();

        $display("[%0t] Explicit-bin coverage = %0.2f%%",
                 $time,
                 cg.get_coverage());

        $finish;

    end

endmodule
```

## Expected Output

```text
[0] Explicit-bin coverage = 100.00%
$finish called at time : 0 ns
```

The sampled values hit all three user-defined bins:

```text
01 → arithmetic
10 → logical
20 → control
```

Therefore, all three bins are covered.

## Coverage Flow

```text
opcode value
     ↓
coverpoint opcode
     ↓
User-defined bin
     ↓
Bin becomes covered
     ↓
get_coverage()
```

## Verification Relevance

Explicit bins are important when the verification plan has specific functional categories.

They are commonly used for:

* Opcode categories
* Protocol command types
* FSM states
* Configuration modes
* Transaction types
* Boundary conditions

For example, instead of treating every opcode value independently, a verification engineer can group related operations:

```systemverilog
bins arithmetic = {8'h01, 8'h02, 8'h03};
```

This makes the coverage model reflect **functional intent** rather than simply tracking raw signal values.

## Main Concept

**Explicit bins = user-defined functional coverage categories.**

The main lesson of SV-099 is:

**The verification engineer controls what values belong to each coverage bin and gives each bin a meaningful functional name.**

