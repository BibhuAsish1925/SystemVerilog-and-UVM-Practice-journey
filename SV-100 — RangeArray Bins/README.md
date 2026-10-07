# 100 — SV-100 — Range/Array Bins

## Introduction

SystemVerilog allows coverage bins to represent multiple values or ranges.

Three useful forms are:

- `{}` — specifies a set of individual values.
- `[]` — specifies a value range.
- `bins[]` — creates an array of bins over a range.

These constructs make functional coverage models more compact and easier to organize.

## Key Concepts

### 1. Set of Individual Values — `{}`

Curly braces can specify individual values:

```systemverilog
bins selected_values = {8'd10, 8'd20, 8'd30};
````

This creates one bin containing the values:

```text
10
20
30
```

If any of these values is sampled, the `selected_values` bin is hit.

### 2. Value Range — `[]`

A range can be specified using:

```systemverilog
bins range_values = {[8'd40:8'd60]};
```

This represents all values from `40` through `60`, inclusive.

```text
40, 41, 42, ... 59, 60
```

Any sampled value in this range hits the `range_values` bin.

### 3. Array of Bins — `bins[]`

An array of bins can be declared using:

```systemverilog
bins value_bins[4] = {[8'd100:8'd199]};
```

This creates four separate bins covering the specified range.

The simulator distributes the range across the requested number of bins.

This is useful when a large range needs to be divided into multiple coverage categories without manually declaring every bin.

## Syntax Comparison

### Individual Values

```systemverilog
bins values = {8'd10, 8'd20, 8'd30};
```

Meaning:

```text
10, 20, 30
```

### Continuous Range

```systemverilog
bins range = {[8'd40:8'd60]};
```

Meaning:

```text
40 through 60
```

### Array of Bins

```systemverilog
bins range_bins[4] = {[8'd100:8'd199]};
```

Meaning:

```text
100 through 199
↓
4 automatically distributed bins
```

## Complete Code

```systemverilog
`timescale 1ns/1ps

module sv_100_range_array_bins_tb;

    logic [7:0] data;

    covergroup data_cg;

        coverpoint data {

            // {} : selected individual values
            bins selected_values = {8'd10, 8'd20, 8'd30};

            // [] : continuous value range
            bins range_values = {[8'd40:8'd60]};

            // bins[] : automatic array of bins
            bins value_bins[4] = {[8'd100:8'd199]};

        }

    endgroup

    data_cg cg;

    initial begin

        cg = new();

        // Hit the selected_values bin
        data = 8'd10;
        cg.sample();

        // Hit the range_values bin
        data = 8'd50;
        cg.sample();

        // Hit one of the value_bins
        data = 8'd125;
        cg.sample();

        // Hit another value_bins bin
        data = 8'd175;
        cg.sample();

        $display("[%0t] Coverage = %0.2f%%",
                 $time,
                 cg.get_coverage());

        $finish;

    end

endmodule
```

## Expected Output

The coverage model contains:

```text
selected_values → 10, 20, 30
range_values    → 40–60
value_bins[4]   → 100–199 divided into 4 bins
```

The sampled values are:

```text
10   → selected_values
50   → range_values
125  → one value_bins bin
175  → another value_bins bin
```

Only some of the four automatically generated array bins are exercised, so the overall coverage is less than 100%.

The exact percentage can depend on how the simulator distributes the range among the requested bins.

## Verification Relevance

Range and array bins are useful when a verification plan contains:

* Specific individual values
* Continuous value ranges
* Large value spaces
* Multiple functional categories
* Data-width dependent coverage

For example, instead of manually creating many bins:

```systemverilog
bins bin0 = {[0:24]};
bins bin1 = {[25:49]};
bins bin2 = {[50:74]};
bins bin3 = {[75:99]};
```

an array of bins can provide a more compact representation:

```systemverilog
bins bins_array[4] = {[0:99]};
```

## Main Concept

```text
{}      → selected individual values
[]      → continuous range
bins[]  → array of multiple bins
```

The main lesson of SV-100 is:

**Use value sets, ranges, and bin arrays to build compact and meaningful functional coverage models.**

