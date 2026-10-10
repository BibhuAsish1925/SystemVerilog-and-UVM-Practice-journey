# 101 — SV-101 — Cross Coverage

## 1. Concept

Cross coverage measures combinations of values between two or more coverpoints.

An individual coverpoint checks whether specific values were exercised. A cross checks whether combinations of those values were exercised.

For example:

- `opcode` represents the operation.
- `mode` represents the operating mode.
- `cross cp_opcode, cp_mode` checks every opcode/mode combination.

This is important in verification because a design may work correctly for individual values but fail for a specific combination of conditions.

### 2. Important Syntax

```systemverilog
covergroup operation_cg;

    cp_opcode : coverpoint opcode {
        bins add = {2'b00};
        bins sub = {2'b01};
    }

    cp_mode : coverpoint mode {
        bins normal = {1'b0};
        bins fast   = {1'b1};
    }

    opcode_mode_cross : cross cp_opcode, cp_mode;

endgroup
````

The cross creates combinations between the bins of the participating coverpoints.

For this example:

* `cp_opcode` has 2 bins.
* `cp_mode` has 2 bins.
* Cross coverage has `2 × 2 = 4` combinations.

All four combinations must be sampled to achieve 100% cross coverage.

## 3. Complete Runnable Code

```systemverilog
`timescale 1ns/1ps

module sv_101_cross_coverage_tb;

    logic [1:0] opcode;
    logic       mode;

    covergroup operation_cg;

        // Individual coverpoints
        cp_opcode : coverpoint opcode {
            bins add = {2'b00};
            bins sub = {2'b01};
        }

        cp_mode : coverpoint mode {
            bins normal = {1'b0};
            bins fast   = {1'b1};
        }

        // Cross coverage between opcode and mode
        opcode_mode_cross : cross cp_opcode, cp_mode;

    endgroup

    operation_cg cg;

    initial begin

        cg = new();

        // Test all opcode/mode combinations
        opcode = 2'b00;
        mode   = 1'b0;
        cg.sample();

        opcode = 2'b00;
        mode   = 1'b1;
        cg.sample();

        opcode = 2'b01;
        mode   = 1'b0;
        cg.sample();

        opcode = 2'b01;
        mode   = 1'b1;
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

The four combinations are:

| Opcode | Mode   | Covered |
| ------ | ------ | ------- |
| ADD    | Normal | Yes     |
| ADD    | Fast   | Yes     |
| SUB    | Normal | Yes     |
| SUB    | Fast   | Yes     |

Therefore:

`Cross Coverage = 4 / 4 × 100 = 100%`

## 5. Verification Relevance

Cross coverage is useful for identifying untested combinations between different functional conditions.

It is commonly used when verification needs to answer questions such as:

* Was every command tested in every mode?
* Was every packet type tested with every priority?
* Was every opcode tested with every privilege level?
* Were reset states exercised with different operating modes?

Cross coverage helps expose gaps that individual coverpoints can miss.

