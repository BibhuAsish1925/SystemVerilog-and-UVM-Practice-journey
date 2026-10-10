
# 105 — SV-105 — `iff`

## 1. Concept

`iff` provides conditional coverage.

It allows a coverpoint to be sampled only when a specified condition is true.

For example:

```systemverilog
cp_data : coverpoint data iff (valid)
````

Here, `data` contributes to coverage only when `valid` is `1`.

When `valid` is `0`, the coverpoint does not record the sample.

## 2. Important Syntax

```systemverilog
coverpoint data iff (valid) {
    bins value_0 = {2'b00};
    bins value_1 = {2'b01};
    bins value_2 = {2'b10};
    bins value_3 = {2'b11};
}
```

The condition can be any appropriate Boolean expression.

For example:

```systemverilog
coverpoint data iff (valid && ready)
```

would sample `data` only when both `valid` and `ready` are true.

## 3. `iff` vs `ignore_bins`

`iff` controls **when a coverpoint is sampled**.

`ignore_bins` controls **which values or combinations are excluded** from the coverage model.

Example:

```systemverilog
coverpoint data iff (valid)
```

means:

> Sample only when `valid` is true.

Whereas:

```systemverilog
ignore_bins reserved = {2'b11};
```

means:

> Do not count `2'b11` as a coverage requirement.

## 4. Complete Runnable Code

```systemverilog
`timescale 1ns/1ps

module sv_105_iff_tb;

    logic [1:0] data;
    logic       valid;

    covergroup data_cg;

        // Data is covered only when valid is 1
        cp_data : coverpoint data iff (valid) {
            bins value_0 = {2'b00};
            bins value_1 = {2'b01};
            bins value_2 = {2'b10};
            bins value_3 = {2'b11};
        }

    endgroup

    data_cg cg;

    initial begin

        cg = new();

        // valid = 0: these samples are ignored
        valid = 1'b0;
        data  = 2'b00;
        cg.sample();

        valid = 1'b0;
        data  = 2'b01;
        cg.sample();

        // valid = 1: these samples are counted
        valid = 1'b1;
        data  = 2'b00;
        cg.sample();

        valid = 1'b1;
        data  = 2'b01;
        cg.sample();

        valid = 1'b1;
        data  = 2'b10;
        cg.sample();

        valid = 1'b1;
        data  = 2'b11;
        cg.sample();

        $display("[%0t] Conditional coverage = %0.2f%%",
                 $time,
                 cg.get_coverage());

        $finish;

    end

endmodule
```

## 5. Expected Result

```text
[0] Conditional coverage = 100.00%
$finish called at time : 0 ns
```

The samples with `valid = 0` do not contribute to coverage.

The samples with `valid = 1` cover all four bins:

| `valid` | `data` | Counted |
| ------- | ------ | ------- |
| 0       | `00`   | No      |
| 0       | `01`   | No      |
| 1       | `00`   | Yes     |
| 1       | `01`   | Yes     |
| 1       | `10`   | Yes     |
| 1       | `11`   | Yes     |

Therefore:

`Conditional Coverage = 4 / 4 × 100 = 100%`

## 6. Verification Relevance

`iff` is especially useful when a signal is meaningful only under a particular protocol or transaction condition.

Common examples include:

* Cover data only when `valid` is asserted.
* Cover transactions only when `ready` is asserted.
* Cover packet fields only when a transaction is active.
* Cover a state only when reset is inactive.
* Cover a protocol operation only when an enable signal is asserted.

The key idea is:

`iff` → **sample coverage only when the condition is true.**


