
# 107 — SV-107 — Wildcard Bins

## 1. Concept

Wildcard bins allow a coverage bin to match multiple values using don't-care bits.

The `wildcard` keyword is used when declaring the bin:

```systemverilog
wildcard bins group_0 = {4'b1??0};
````

The `?` positions are treated as don't-care positions.

For example:

```text
1??0
```

matches:

```text
1000
1010
1100
1110
```

This is useful when only specific bit positions are important for functional coverage.

## 2. Important Syntax

```systemverilog
wildcard bins group_0 = {4'b1??0};
wildcard bins group_1 = {4'b0??1};
```

The fixed bits must match the corresponding signal bits.

The `?` positions can take either `0` or `1`.

For example:

```text
1??0
```

means:

* First bit must be `1`.
* Middle two bits can be either `0` or `1`.
* Last bit must be `0`.

## 3. Complete Runnable Code

```systemverilog
`timescale 1ns/1ps

module sv_107_wildcard_bins_tb;

    logic [3:0] opcode;

    covergroup opcode_cg;

        coverpoint opcode {

            // Bit positions marked with ? are don't-care
            wildcard bins group_0 = {4'b1??0};
            wildcard bins group_1 = {4'b0??1};

        }

    endgroup

    opcode_cg cg;

    initial begin

        cg = new();

        // Matches group_0: 1??0
        opcode = 4'b1000;
        cg.sample();

        opcode = 4'b1110;
        cg.sample();

        // Matches group_1: 0??1
        opcode = 4'b0001;
        cg.sample();

        opcode = 4'b0111;
        cg.sample();

        $display("[%0t] Wildcard coverage = %0.2f%%",
                 $time,
                 cg.get_coverage());

        $finish;

    end

endmodule
```

## 4. Expected Result

```text
[0] Wildcard coverage = 100.00%
$finish called at time : 0 ns
```

The sampled values cover both wildcard bins:

| Value  | Matching bin |
| ------ | ------------ |
| `1000` | `1??0`       |
| `1110` | `1??0`       |
| `0001` | `0??1`       |
| `0111` | `0??1`       |

Therefore both bins are covered.

## 5. Verification Relevance

Wildcard bins are useful when some signal bits are not relevant to the coverage requirement.

Common applications include:

* Opcode pattern coverage.
* Protocol field patterns.
* Control-bit combinations.
* Address or command classes.
* Coverage where some bits are don't-care.

The key syntax is:

```systemverilog
wildcard bins bin_name = {pattern};
```

Wildcard bins allow the coverage model to focus on the important bit positions instead of creating separate bins for every possible value.

