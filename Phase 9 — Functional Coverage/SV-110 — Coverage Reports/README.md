# 110 — SV-110 — Coverage Reports

## 1. Concept

Coverage collection and reporting are used to measure how much of the functional coverage model has been exercised during simulation.

A covergroup can collect coverage through `sample()` and report the result using coverage methods.

Two useful methods are:

```systemverilog
cg.get_coverage()
cg.get_inst_coverage()
````

`get_coverage()` returns the coverage percentage for the covergroup type.

`get_inst_coverage()` returns the coverage percentage for a particular covergroup instance.

## 2. Coverage Collection

Coverage is collected when the covergroup is sampled:

```systemverilog
opcode = 2'b00;
cg.sample();
```

The sampled value is compared against the bins defined in the coverpoint.

Multiple samples can gradually increase coverage until the required bins are covered.

## 3. Coverage Reporting

A simple report can be printed using `$display`:

```systemverilog
$display("Coverage = %0.2f%%", cg.get_coverage());
```

An instance-specific result can be reported with:

```systemverilog
$display("Instance = %0.2f%%", cg.get_inst_coverage());
```

## 4. Complete Runnable Code

```systemverilog
`timescale 1ns/1ps

module sv_110_coverage_reports_tb;

    logic [1:0] opcode;

    covergroup opcode_cg;

        coverpoint opcode {
            bins add = {2'b00};
            bins sub = {2'b01};
            bins mul = {2'b10};
            bins div = {2'b11};
        }

    endgroup

    opcode_cg cg;

    initial begin

        cg = new();

        // Collect functional coverage
        opcode = 2'b00;
        cg.sample();

        opcode = 2'b01;
        cg.sample();

        opcode = 2'b10;
        cg.sample();

        opcode = 2'b11;
        cg.sample();

        // Coverage report
        $display("================================");
        $display("      FUNCTIONAL COVERAGE");
        $display("================================");
        $display("Covergroup : opcode_cg");
        $display("Coverage   : %0.2f%%", cg.get_coverage());
        $display("Instance   : %0.2f%%", cg.get_inst_coverage());
        $display("================================");

        $finish;

    end

endmodule
```

## 5. Expected Result

```text
================================
      FUNCTIONAL COVERAGE
================================
Covergroup : opcode_cg
Coverage   : 100.00%
Instance   : 100.00%
================================
$finish called at time : 0 ns
```

All four bins are sampled:

| Opcode | Bin   | Result  |
| ------ | ----- | ------- |
| `00`   | `add` | Covered |
| `01`   | `sub` | Covered |
| `10`   | `mul` | Covered |
| `11`   | `div` | Covered |

Therefore the reported coverage is 100%.

## 6. Verification Relevance

Coverage reporting is important for determining whether a verification environment has exercised the intended functional scenarios.

A typical coverage flow is:

```text
Stimulus
   ↓
Covergroup sampling
   ↓
Coverage collection
   ↓
Coverage calculation
   ↓
Coverage report
```

In larger verification environments, coverage results are used to identify untested functionality and decide what additional stimulus is required.

The key methods introduced in this topic are:

```systemverilog
get_coverage()
get_inst_coverage()
```
