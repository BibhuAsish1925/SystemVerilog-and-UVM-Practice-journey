
# 108 — SV-108 — Default Bins

## 1. Concept

A default bin collects values that are not matched by any explicitly defined coverage bin.

The basic syntax is:

```systemverilog
bins others = default;
````

For example:

```systemverilog
coverpoint opcode {

    bins add = {2'b00};
    bins sub = {2'b01};
    bins mul = {2'b10};

    bins others = default;

}
```

Here:

* `00` goes into `add`.
* `01` goes into `sub`.
* `10` goes into `mul`.
* Any remaining value goes into `others`.

## 2. Important Syntax

```systemverilog
bins others = default;
```

The `default` bin catches values that are not already covered by an explicit bin.

For a 2-bit signal:

```text
00 → add
01 → sub
10 → mul
11 → others
```

Default bins are useful for monitoring values outside the explicitly modeled scenarios.

> Note: A default bin is mainly a collection bucket and is not normally treated as a required coverage target.

## 3. Complete Runnable Code

```systemverilog
`timescale 1ns/1ps

module sv_108_default_bins_tb;

    logic [1:0] opcode;

    covergroup opcode_cg;

        coverpoint opcode {

            bins add = {2'b00};
            bins sub = {2'b01};
            bins mul = {2'b10};

            // Collect all other values
            bins others = default;

        }

    endgroup

    opcode_cg cg;

    initial begin

        cg = new();

        // Explicit bins
        opcode = 2'b00;
        cg.sample();

        opcode = 2'b01;
        cg.sample();

        opcode = 2'b10;
        cg.sample();

        // Goes into the default bin
        opcode = 2'b11;
        cg.sample();

        $display("[%0t] Coverage = %0.2f%%",
                 $time,
                 cg.get_coverage());

        $finish;

    end

endmodule
```

## 4. Expected Result

```text
[0] Coverage = 100.00%
$finish called at time : 0 ns
```

The sampled values are classified as:

| Value | Bin      |
| ----- | -------- |
| `00`  | `add`    |
| `01`  | `sub`    |
| `10`  | `mul`    |
| `11`  | `others` |

The `11` value is automatically collected by the default bin because it does not match any explicit bin.

## 5. Verification Relevance

Default bins are useful when the coverage model explicitly defines important values but still wants to observe everything else.

Typical uses include:

* Detecting unexpected values.
* Grouping unmodeled opcode values.
* Monitoring reserved or uncommon values.
* Avoiding a large number of individual bins.

The key distinction is:

`bins` → explicitly defined coverage category.

`default` bin → catches values not matched by explicit bins.

`ignore_bins` → excludes values from coverage.

`illegal_bins` → identifies values that should never occur.


