# 084 — SV-084 — Virtual Interface

## Introduction

A virtual interface is a class handle that allows a SystemVerilog class to access an actual interface instance.

Classes cannot directly instantiate a physical interface. Instead, a class stores a virtual interface handle:

```systemverilog
virtual simple_if vif;
````

The actual interface instance is then passed to the class:

```systemverilog
drv = new(bus);
```

The class can access interface signals through the virtual interface:

```systemverilog
vif.data
vif.valid
vif.ready
```

## Why Virtual Interfaces Are Important

SystemVerilog verification components such as drivers, monitors, and other testbench classes need a way to communicate with DUT signals.

A virtual interface provides that connection:

```text
Physical Interface
       |
       v
Virtual Interface Handle
       |
       v
Verification Class
       |
       v
DUT
```

The class does not contain a copy of the interface. The virtual interface handle points to the existing interface instance.

## Verification Relevance

Virtual interfaces are fundamental to class-based SystemVerilog verification.

They allow:

* Drivers to drive DUT signals
* Monitors to observe DUT signals
* Classes to access interface tasks/functions
* Testbench classes to remain separate from the DUT
* Reusable verification components

Virtual interfaces are also an important foundation for UVM because UVM drivers and monitors commonly access DUT interfaces through virtual interface handles.

## Complete Runnable Code

```systemverilog
interface simple_if;

    logic       clk;
    logic       reset;
    logic [7:0] data;
    logic       valid;
    logic       ready;

endinterface


module sv_084_virtual_interface_dut (
    simple_if bus
);

    always_ff @(posedge bus.clk) begin

        if (bus.reset)
            bus.ready <= 1'b0;
        else
            bus.ready <= bus.valid;

    end

endmodule


class driver;

    virtual simple_if vif;

    function new(virtual simple_if vif);
        this.vif = vif;
    endfunction

    task drive(input logic [7:0] data_value);

        @(posedge vif.clk);

        vif.data  <= data_value;
        vif.valid <= 1'b1;

        @(posedge vif.clk);

        wait (vif.ready);

        vif.valid <= 1'b0;

    endtask

endclass


module sv_084_virtual_interface_tb;

    simple_if bus();

    sv_084_virtual_interface_dut dut (
        .bus(bus)
    );

    driver drv;

    initial begin

        bus.clk   = 1'b0;
        bus.reset = 1'b1;
        bus.data  = 8'h00;
        bus.valid = 1'b0;

        drv = new(bus);

        #10;

        bus.reset = 1'b0;

        drv.drive(8'hA5);

        $display("[%0t] Driver completed | data = %h",
                 $time,
                 bus.data);

        #10;

        $finish;

    end

    always #5 bus.clk = ~bus.clk;

endmodule
```

## Key Takeaway

A physical interface is instantiated in the testbench:

```systemverilog
simple_if bus();
```

A class stores a virtual handle to that interface:

```systemverilog
virtual simple_if vif;
```

The actual interface is passed to the class:

```systemverilog
drv = new(bus);
```

The class can then communicate with the DUT through:

```systemverilog
vif.data
vif.valid
vif.ready
```

Virtual interfaces therefore provide the bridge between **class-based verification components and interface-based DUT connectivity**.

