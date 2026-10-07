# 103 — SV-103 — `ignore_bins`

## 1. Concept

`ignore_bins` is used to exclude specific values or scenarios from functional coverage.

Sometimes a signal can have values that are valid at the language or hardware level but are not relevant to the verification objective.

For example, if an opcode value is reserved:

```systemverilog
ignore_bins reserved = {2'b11};
````

The reserved value is excluded from the coverage calculation.

This prevents intentionally unsupported or irrelevant scenarios from reducing meaningful coverage.

## 2. Important Syntax

```systemverilog
coverpoint opcode {

    bins add = {2'b00};
    bins sub = {2'b01};
    bins mul = {2'b10};

    ignore_bins reserved = {2'b11};

}
```

### Difference from normal bins

A normal bin contributes to the coverage goal:

```systemverilog
bins add = {2'b00};
```

An ignored bin does not:

```systemverilog
ignore_bins reserved = {2'b11};
```

If `2'b11` is sampled, it does not become a missing coverage item.

## 3. Complete Runnable Code

```systemverilog
`timescale 1ns/1ps

module sv_103_ignore_bins_tb;

    logic [1:0] opcode;

    covergroup opcode_cg;

        coverpoint opcode {

            bins add = {2'b00};
            bins sub = {2'b01};
            bins mul = {2'b10};

            // Reserved opcode is intentionally excluded
            ignore_bins reserved = {2'b11};

        }

    endgroup

    opcode_cg cg;

    initial begin

        cg = new();

        opcode = 2'b00;
        cg.sample();

        opcode = 2'b01;
        cg.sample();

        opcode = 2'b10;
        cg.sample();

        // 2'b11 is ignored and does not affect coverage
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

The three required bins are all covered:

| Opcode | Bin        | Result  |
| ------ | ---------- | ------- |
| `00`   | `add`      | Covered |
| `01`   | `sub`      | Covered |
| `10`   | `mul`      | Covered |
| `11`   | `reserved` | Ignored |

Therefore the meaningful coverage is:

`3 / 3 = 100%`

## 5. Verification Relevance

`ignore_bins` is useful for excluding scenarios such as:

* Reserved protocol values.
* Unsupported command combinations.
* Intentionally unreachable states.
* Values outside the verification scope.
* Scenarios that are legal but irrelevant to the current coverage goal.

The important principle is that `ignore_bins` should represent a **deliberate verification decision**, not a way to artificially increase the coverage percentage.
