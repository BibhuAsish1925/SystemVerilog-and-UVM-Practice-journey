
# 085 — SV-085 — Virtual Interface Configuration

## Introduction

Virtual interface configuration is the process of passing an actual interface instance from the testbench to a class-based verification component such as a driver.

The basic flow is:

```text
Testbench creates interface
          ↓
Testbench creates driver
          ↓
Testbench passes interface to driver
          ↓
Driver stores virtual interface
          ↓
Driver accesses DUT signals
````

The driver does not create its own physical interface. Instead, it receives a virtual interface handle:

```systemverilog
virtual simple_if vif;
```

The interface is passed through the driver's constructor:

```systemverilog
drv = new(bus);
```

## Passing the Interface from TB to Driver

The testbench creates the actual interface:

```systemverilog
simple_if bus();
```

The driver declares a virtual interface:

```systemverilog
virtual simple_if vif;
```

The constructor receives the interface:

```systemverilog
function new(virtual simple_if vif);
    this.vif = vif;
endfunction
```

The testbench then passes the actual interface instance:

```systemverilog
drv = new(bus);
```

The driver can now access the interface signals through `vif`.

## Verification Relevance

Passing a virtual interface from the testbench to a driver provides a clean separation between:

* Physical DUT connectivity
* Testbench configuration
* Class-based stimulus generation
* Signal-level driving

This pattern is commonly used when building structured SystemVerilog verification environments and forms an important foundation for UVM virtual-interface configuration.

## Complete Runnable Code

```systemverilog
interface simple_if;

    logic       clk;
    logic       reset;
    logic [7:0] data;
    logic       valid;
    logic       ready;

endinterface


module sv_085_virtual_interface_configuration_dut (
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

    // Receive the interface from the testbench
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

        $display("[%0t] Driver: data = %h",
                 $time,
                 vif.data);

    endtask

endclass


module sv_085_virtual_interface_configuration_tb;

    // Testbench creates the physical interface
    simple_if bus();

    sv_085_virtual_interface_configuration_dut dut (
        .bus(bus)
    );

    driver drv;

    initial begin

        // Initialize interface
        bus.clk   = 1'b0;
        bus.reset = 1'b1;
        bus.data  = 8'h00;
        bus.valid = 1'b0;

        // Pass interface from TB to driver
        drv = new(bus);

        #10;

        bus.reset = 1'b0;

        // Driver now uses the passed interface
        drv.drive(8'hA5);

        #10;

        $finish;

    end

    always #5 bus.clk = ~bus.clk;

endmodule
```

## Key Takeaway

The testbench owns the actual interface:

```systemverilog
simple_if bus();
```

The driver owns only a virtual interface handle:

```systemverilog
virtual simple_if vif;
```

The testbench connects them by passing the interface during driver construction:

```systemverilog
drv = new(bus);
```

The driver can then access the DUT-connected interface through:

```systemverilog
vif.clk
vif.data
vif.valid
vif.ready
```

This creates the important verification connection:

```text
TB Interface Instance
        ↓
Virtual Interface
        ↓
Driver
        ↓
DUT
```

