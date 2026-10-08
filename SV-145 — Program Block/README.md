
# 145 — SV-145 — Program Block

## Introduction

A SystemVerilog `program` block provides a dedicated structure for testbench code.

One of its main purposes is to separate testbench activity from DUT activity through SystemVerilog's simulation scheduling regions.

The `program` construct is primarily a SystemVerilog testbench concept.

## Program Block

A program is declared using:

```systemverilog
program test_program (
    input  logic clk,
    output logic enable
);

    initial begin
        // Testbench stimulus
    end

endprogram
````

The program can contain procedural testbench code and communicate with the DUT through ports.

## Testbench Scheduling

SystemVerilog provides different scheduling regions for design and verification activity.

The simplified concept is:

```text
Simulation time slot
        |
        +-- DUT/module activity
        |
        +-- program/testbench reactive activity
```

The program block was designed to help prevent races between DUT execution and testbench stimulus.

## Verification Relevance

Program blocks are useful for understanding:

* Testbench scheduling
* DUT/testbench race conditions
* Reactive testbench behavior
* SystemVerilog simulation regions

Modern verification environments commonly use interfaces, clocking blocks, classes, and UVM instead of program blocks.

## Complete Runnable Code

```systemverilog
`timescale 1ns/1ps

module sv_145_program_dut (
    input  logic       clk,
    input  logic       reset,
    input  logic       enable,
    input  logic [7:0] data,
    output logic [7:0] result
);

    always_ff @(posedge clk) begin

        if (reset)
            result <= 8'h00;
        else if (enable)
            result <= data + 8'd1;

    end

endmodule


program sv_145_test_program (
    input  logic       clk,
    input  logic       reset,
    output logic       enable,
    output logic [7:0] data,
    input  logic [7:0] result
);

    initial begin

        enable = 1'b0;
        data   = 8'h00;

        @(negedge clk);

        enable = 1'b1;
        data   = 8'h10;

        @(negedge clk);

        enable = 1'b0;

        @(posedge clk);

        #1;

        $display("[%0t] Program: data=%h result=%h",
                 $time, data, result);

        @(negedge clk);

        enable = 1'b1;
        data   = 8'h20;

        @(negedge clk);

        enable = 1'b0;

        @(posedge clk);

        #1;

        $display("[%0t] Program: data=%h result=%h",
                 $time, data, result);

        $finish;

    end

endprogram


module sv_145_program_tb;

    logic       clk;
    logic       reset;
    logic       enable;
    logic [7:0] data;
    logic [7:0] result;

    sv_145_program_dut dut (
        .clk    (clk),
        .reset  (reset),
        .enable (enable),
        .data   (data),
        .result (result)
    );

    sv_145_test_program test_program (
        .clk    (clk),
        .reset  (reset),
        .enable (enable),
        .data   (data),
        .result (result)
    );

    initial begin

        clk   = 1'b0;
        reset = 1'b1;

        #12;

        reset = 1'b0;

    end

    always #5 clk = ~clk;

endmodule
```

## Expected Output

```text
[26] Program: data=10 result=11
[46] Program: data=20 result=21
$finish called at time : 46 ns
```

The program generates two stimulus transactions:

```text
data = 10 → result = 11
data = 20 → result = 21
```

## Vivado Usage

Add the `.sv` file to Simulation Sources and set:

```text
sv_145_program_tb
```

as the simulation top.

Run Behavioral Simulation.

## Key Takeaway

A `program` block is a SystemVerilog construct intended for testbench code.

Its major concept is **testbench scheduling**: program code executes in the reactive portion of the simulation scheduling model, helping separate testbench activity from DUT activity.

For modern verification environments, interfaces, clocking blocks, classes, and UVM are generally more important, but understanding `program` is useful for understanding SystemVerilog scheduling and legacy testbench architectures.


