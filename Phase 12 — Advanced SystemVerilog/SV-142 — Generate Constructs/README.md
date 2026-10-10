
# 142 — SV-142 — Generate Constructs

## Introduction

SystemVerilog generate constructs create hardware structures conditionally or repeatedly during elaboration.

The main constructs demonstrated here are:

- `generate`
- `genvar`
- Generate-if
- Generate-for

Generate constructs are useful for parameterized and scalable RTL designs.

## Important Concepts

### 1. generate

`generate` groups elaboration-time hardware generation statements.

### 2. genvar

`genvar` is used as the loop variable of a generate-for loop.

Example:

```systemverilog
genvar i;

generate
    for (i = 0; i < 4; i++) begin : gen_and
        assign and_result[i] = a[i] & b[i];
    end
endgenerate
````

This creates four separate hardware assignments.

### 3. Generate-if

Generate-if conditionally creates hardware based on a constant expression or parameter.

```systemverilog
generate
    if (USE_XOR) begin : gen_xor
        assign y = a ^ b;
    end
    else begin : gen_and_output
        assign y = and_result;
    end
endgenerate
```

The selected branch is determined during elaboration.

### 4. Generate-for

Generate-for is useful when the same hardware structure must be created multiple times.

```systemverilog
genvar i;

generate
    for (i = 0; i < 4; i++) begin : gen_and
        assign and_result[i] = a[i] & b[i];
    end
endgenerate
```

Here, four AND operations are generated.

## Verification Relevance

Generate constructs are important when creating:

* Parameterized RTL
* Repeated hardware structures
* Scalable datapaths
* Multiple identical channels
* Optional hardware features
* Configurable modules

## Complete Runnable Code

```systemverilog
`timescale 1ns/1ps

module sv_142_generate_unit #(
    parameter bit USE_XOR = 1'b0
)(
    input  logic [3:0] a,
    input  logic [3:0] b,
    output logic [3:0] y
);

    logic [3:0] and_result;

    // Generate-for: create four AND operations
    genvar i;

    generate
        for (i = 0; i < 4; i++) begin : gen_and
            assign and_result[i] = a[i] & b[i];
        end
    endgenerate

    // Generate-if: select hardware at elaboration time
    generate
        if (USE_XOR) begin : gen_xor
            assign y = a ^ b;
        end
        else begin : gen_and_output
            assign y = and_result;
        end
    endgenerate

endmodule


module sv_142_generate_constructs_tb;

    logic [3:0] a;
    logic [3:0] b;

    logic [3:0] y_and;
    logic [3:0] y_xor;

    sv_142_generate_unit #(
        .USE_XOR(1'b0)
    ) and_unit (
        .a(a),
        .b(b),
        .y(y_and)
    );

    sv_142_generate_unit #(
        .USE_XOR(1'b1)
    ) xor_unit (
        .a(a),
        .b(b),
        .y(y_xor)
    );

    initial begin

        a = 4'b1100;
        b = 4'b1010;

        #1;

        $display("Generate-for AND result = %b", y_and);
        $display("Generate-if  XOR result = %b", y_xor);

        a = 4'b1111;
        b = 4'b0011;

        #1;

        $display("Generate-for AND result = %b", y_and);
        $display("Generate-if  XOR result = %b", y_xor);

        $finish;

    end

endmodule
```

## Expected Output

```text
Generate-for AND result = 1000
Generate-if  XOR result = 0110
Generate-for AND result = 0011
Generate-if  XOR result = 1100
$finish called at time : 2 ns
```

## Vivado Usage

Add the `.sv` file to Simulation Sources and set:

```text
sv_142_generate_constructs_tb
```

as the simulation top.

Run Behavioral Simulation and observe the generated results and generated hierarchy.

## Key Takeaway

Generate constructs create or omit hardware during elaboration. `genvar` is used with generate-for to create repeated hardware, while generate-if selects hardware based on constant configuration such as a parameter.


