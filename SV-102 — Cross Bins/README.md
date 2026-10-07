# 102 — SV-102 — Cross Bins

## 1. Concept

Cross bins allow specific combinations of coverpoint bins to be selected and named.

A normal cross creates combinations between all participating coverpoint bins. Cross bins are useful when only certain combinations are important for verification.

For example:

- `cp_opcode.add` represents the ADD operation.
- `cp_mode.fast` represents FAST mode.
- `add_fast` represents the specific ADD + FAST combination.

## 2. Important Syntax

```systemverilog
cross_opcode_mode : cross cp_opcode, cp_mode {
    bins add_fast = binsof(cp_opcode.add)
                  && binsof(cp_mode.fast);
}
````

### `binsof()`

`binsof()` selects a particular bin from a coverpoint.

```systemverilog
binsof(cp_opcode.add)
```

selects the `add` bin from `cp_opcode`.

```systemverilog
binsof(cp_mode.fast)
```

selects the `fast` bin from `cp_mode`.

The `&&` operator combines the selected bins into one specific cross combination.

## 3. Complete Runnable Code

```systemverilog
`timescale 1ns/1ps

module sv_102_cross_bins_tb;

    logic [1:0] opcode;
    logic       mode;

    covergroup operation_cg;

        cp_opcode : coverpoint opcode {
            bins add = {2'b00};
            bins sub = {2'b01};
        }

        cp_mode : coverpoint mode {
            bins normal = {1'b0};
            bins fast   = {1'b1};
        }

        // Cover only the specific ADD + FAST combination
        cross_opcode_mode : cross cp_opcode, cp_mode {
            bins add_fast = binsof(cp_opcode.add)
                          && binsof(cp_mode.fast);
        }

    endgroup

    operation_cg cg;

    initial begin

        cg = new();

        // ADD + NORMAL
        opcode = 2'b00;
        mode   = 1'b0;
        cg.sample();

        // ADD + FAST
        opcode = 2'b00;
        mode   = 1'b1;
        cg.sample();

        // SUB + NORMAL
        opcode = 2'b01;
        mode   = 1'b0;
        cg.sample();

        $display("[%0t] Cross coverage = %0.2f%%",
                 $time,
                 cg.get_coverage());

        $finish;

    end

endmodule
```

## 4. Expected Result

```text
[0] Cross coverage = 100.00%
$finish called at time : 0 ns
```

The explicitly defined `add_fast` cross bin is hit when:

```text
opcode = ADD
mode   = FAST
```

Therefore, the specific cross-bin coverage reaches 100%.

## 5. Verification Relevance

Cross bins are useful when certain combinations have specific functional importance.

Typical examples include:

* A particular opcode in a particular operating mode.
* A packet type with a specific priority.
* A command combined with a specific privilege level.
* A protocol operation under a particular configuration.

The important syntax introduced in this topic is:

```systemverilog
binsof(...)
```

which allows specific coverpoint bins to be selected when defining cross-bin combinations.

