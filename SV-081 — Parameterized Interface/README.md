# 081 — SV-081 — Parameterized Interface

## Introduction

A parameterized interface allows the same SystemVerilog interface definition to be reused with different configurations.

The interface parameter is declared using:

```systemverilog
interface simple_if #(
    parameter int WIDTH = 8
);
````

The parameter can control the width of interface signals:

```systemverilog
logic [WIDTH-1:0] data;
```

Different interface instances can then use different widths:

```systemverilog
simple_if #(8) bus_8();
simple_if #(16) bus_16();
```

Therefore:

* `bus_8.data` is 8 bits wide.
* `bus_16.data` is 16 bits wide.

The same interface structure can consequently be reused without creating separate interfaces for every bus width.

## Important Syntax

Parameterized interface:

```systemverilog
interface simple_if #(
    parameter int WIDTH = 8
);
```

Parameterized interface instance:

```systemverilog
simple_if #(8) bus_8();
simple_if #(16) bus_16();
```

The DUT can use the interface as a port:

```systemverilog
module dut #(
    parameter int WIDTH = 8
)(
    simple_if bus
);
```

The interface instances determine the actual interface configuration.

## Verification Relevance

Parameterized interfaces are useful in reusable verification environments because the same interface can support different data widths and configurations.

They improve:

* Reusability
* Scalability
* Testbench connectivity
* Configuration
* Parameterized verification environments

## Complete Runnable Code

```systemverilog
interface simple_if #(
    parameter int WIDTH = 8
);

    logic             clk;
    logic             reset;
    logic [WIDTH-1:0] data;
    logic             valid;
    logic             ready;

endinterface


module sv_081_parameterized_interface_dut #(
    parameter int WIDTH = 8
)(
    simple_if bus
);

    always_ff @(posedge bus.clk) begin

        if (bus.reset)
            bus.ready <= 1'b0;
        else
            bus.ready <= bus.valid;

    end

endmodule


module sv_081_parameterized_interface_tb;

    simple_if #(8) bus_8();
    simple_if #(16) bus_16();

    sv_081_parameterized_interface_dut #(.WIDTH(8)) dut_8 (
        .bus(bus_8)
    );

    sv_081_parameterized_interface_dut #(.WIDTH(16)) dut_16 (
        .bus(bus_16)
    );

    initial begin

        bus_8.clk   = 1'b0;
        bus_8.reset = 1'b1;
        bus_8.data  = 8'h00;
        bus_8.valid = 1'b0;

        bus_16.clk   = 1'b0;
        bus_16.reset = 1'b1;
        bus_16.data  = 16'h0000;
        bus_16.valid = 1'b0;

        #10;

        bus_8.reset = 1'b0;
        bus_8.data  = 8'hA5;
        bus_8.valid = 1'b1;

        bus_16.reset = 1'b0;
        bus_16.data  = 16'h1234;
        bus_16.valid = 1'b1;

        #10;

        bus_8.valid  = 1'b0;
        bus_16.valid = 1'b0;

        #10;

        $finish;

    end

    always #5 begin
        bus_8.clk  = ~bus_8.clk;
        bus_16.clk = ~bus_16.clk;
    end

    always @(posedge bus_8.clk) begin
        $display("[%0t] 8-bit  | data=%h | valid=%b | ready=%b",
                 $time,
                 bus_8.data,
                 bus_8.valid,
                 bus_8.ready);
    end

    always @(posedge bus_16.clk) begin
        $display("[%0t] 16-bit | data=%h | valid=%b | ready=%b",
                 $time,
                 bus_16.data,
                 bus_16.valid,
                 bus_16.ready);
    end

endmodule
```

## Key Takeaway

A parameterized interface allows one interface definition to support multiple configurations:

```systemverilog
simple_if #(8)  bus_8();
simple_if #(16) bus_16();
```

This is especially useful when building reusable SystemVerilog verification environments where the same communication structure may need to support different bus widths.

```

And yes — **this 6-section structure is the format I should continue using for every topic from SV-081 onward.**
```
