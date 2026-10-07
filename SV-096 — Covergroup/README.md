# 096 — SV-096 — Covergroup

## Introduction

A **covergroup** is a SystemVerilog construct used to measure functional coverage.

Functional coverage answers questions such as:

- Did the required values occur?
- Did important ranges get exercised?
- Which verification scenarios are still missing?

A covergroup commonly contains:

- **Coverpoints** — define what is being measured.
- **Bins** — divide values into coverage categories.
- **Sampling** — records values into the coverage model.

This example uses explicit sampling with `cg.sample()`.

## Key Concepts

### 1. Covergroup Creation

A covergroup is declared using:

```systemverilog
covergroup data_cg;

    coverpoint data;

endgroup
````

It defines the functional coverage model.

### 2. Coverpoint

A coverpoint specifies the signal or expression that should be covered:

```systemverilog
coverpoint data
```

Here, the `data` signal is the item being measured.

### 3. Coverage Bins

Bins divide the possible values into meaningful categories:

```systemverilog
bins low  = {[0:63]};
bins mid  = {[64:191]};
bins high = {[192:255]};
```

For an 8-bit signal:

```text
0–63     → low
64–191   → mid
192–255  → high
```

### 4. Covergroup Object

The covergroup declaration defines the coverage model, while an object is created using:

```systemverilog
data_cg cg;

initial begin
    cg = new();
end
```

### 5. Sampling

The current value of `data` is sampled explicitly with:

```systemverilog
cg.sample();
```

For example:

```systemverilog
data = 8'd20;
cg.sample();
```

The value `20` hits the `low` bin.

### 6. Coverage Percentage

The current coverage percentage can be obtained using:

```systemverilog
cg.get_coverage()
```

If all defined bins have been hit, the coverage is:

```text
100.00%
```

## Complete Code

```systemverilog
`timescale 1ns/1ps

module sv_096_covergroup_tb;

    logic [7:0] data;

    // Functional coverage model
    covergroup data_cg;

        coverpoint data {
            bins low  = {[0:63]};
            bins mid  = {[64:191]};
            bins high = {[192:255]};
        }

    endgroup

    data_cg cg;

    initial begin

        // Create the covergroup object
        cg = new();

        // Sample 1: low range
        data = 8'd20;
        cg.sample();

        // Sample 2: middle range
        data = 8'd100;
        cg.sample();

        // Sample 3: high range
        data = 8'd220;
        cg.sample();

        // Display coverage result
        $display("[%0t] Data coverage = %0.2f%%",
                 $time,
                 cg.get_coverage());

        $finish;

    end

endmodule
```

## Expected Output

```text
[0] Data coverage = 100.00%
$finish called at time : 0 ns
```

The three sampled values exercise all three bins:

```text
20   → low
100  → mid
220  → high
```

Therefore, all defined bins are covered.

## Coverage Flow

```text
Create covergroup
       ↓
Create covergroup object
       ↓
Assign value to data
       ↓
cg.sample()
       ↓
Coverpoint evaluates data
       ↓
Matching bin is hit
       ↓
get_coverage()
```

## Verification Relevance

Functional coverage helps measure whether the verification environment has exercised the intended functional scenarios.

Covergroups become especially useful when combined with:

* Random stimulus
* Constrained randomization
* Coverage-driven verification
* Cross coverage
* UVM sequences and monitors

### Important Syntax

```systemverilog
covergroup cg_name;
    coverpoint signal;
endgroup
```

Create the object:

```systemverilog
cg_name cg;
cg = new();
```

Sample explicitly:

```systemverilog
cg.sample();
```

Read coverage:

```systemverilog
cg.get_coverage();
```

The main concept of SV-096 is:

**Define → Create → Sample → Measure**

