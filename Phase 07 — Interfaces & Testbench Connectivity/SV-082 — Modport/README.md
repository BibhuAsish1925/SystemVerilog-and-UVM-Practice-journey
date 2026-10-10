# 082 — SV-082 — Modport

## Introduction

A `modport` defines how a module or testbench can access signals inside an interface.

It provides:

- DUT/TB signal directions
- Access control
- Clear interface connectivity
- Protection against incorrect signal driving

A modport is declared inside an interface:

```systemverilog
modport dut_mp (
    input clk,
    input reset,
    input data,
    input valid,
    output ready
);
````

The DUT can therefore read the input signals and drive `ready`.

A separate testbench modport can define the opposite access direction:

```systemverilog
modport tb_mp (
    output clk,
    output reset,
    output data,
    output valid,
    input ready
);
```

The interface itself contains the actual signals, while the modport defines the access view of those signals.

## Verification Relevance

Modports are useful in verification environments because they clearly define which side of an interface is allowed to drive or read each signal.

For example:

```text
DUT:
    Reads  → clk, reset, data, valid
    Drives → ready

Testbench:
    Drives → clk, reset, data, valid
    Reads  → ready
```

This becomes especially useful as interfaces become larger and verification environments contain multiple components.

## Complete Runnable Code

```systemverilog
interface simple_if;

    logic       clk;
    logic       reset;
    logic [7:0] data;
    logic       valid;
    logic       ready;

    // DUT access permissions
    modport dut_mp (
        input  clk,
        input  reset,
        input  data,
        input  valid,
        output ready
    );

    // Testbench access permissions
    modport tb_mp (
        output clk,
        output reset,
        output data,
        output valid,
        input ready
    );

endinterface


module sv_082_modport_dut (
    simple_if.dut_mp bus
);

    always_ff @(posedge bus.clk) begin

        if (bus.reset)
            bus.ready <= 1'b0;
        else
            bus.ready <= bus.valid;

    end

endmodule


module sv_082_modport_tb;

    simple_if bus();

    sv_082_modport_dut dut (
        .bus(bus)
    );

    initial begin

        bus.clk   = 1'b0;
        bus.reset = 1'b1;
        bus.data  = 8'h00;
        bus.valid = 1'b0;

        #10;

        bus.reset = 1'b0;
        bus.data  = 8'hA5;
        bus.valid = 1'b1;

        #10;

        bus.valid = 1'b0;

        #10;

        $finish;

    end

    always #5 bus.clk = ~bus.clk;

    always @(posedge bus.clk) begin
        $display("[%0t] reset=%b valid=%b data=%h ready=%b",
                 $time,
                 bus.reset,
                 bus.valid,
                 bus.data,
                 bus.ready);
    end

endmodule
```

## Key Takeaway

An interface groups related signals, while a modport defines the access direction for a particular component.

```systemverilog
simple_if.dut_mp bus
```

means the DUT uses the `dut_mp` access view of the interface.

```systemverilog
simple_if.tb_mp bus
```

would mean a component uses the `tb_mp` access view.

Modports therefore provide a clean way to control and document DUT/testbench access to interface signals.

