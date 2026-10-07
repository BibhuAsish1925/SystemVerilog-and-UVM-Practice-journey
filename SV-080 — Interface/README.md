# 080 — SV-080 — Interface

A SystemVerilog **interface** groups related signals into a single communication structure.

Interfaces are especially useful in verification because a DUT may have many signals that are logically part of the same protocol or connection.

Instead of passing each signal separately:

```systemverilog
module dut (
    input  logic clk,
    input  logic reset,
    input  logic [7:0] data,
    input  logic valid,
    output logic ready
);
```

an interface can group them together.

### Interface Declaration

An interface is declared using:

```systemverilog
interface simple_if;

    logic       clk;
    logic       reset;
    logic [7:0] data;
    logic       valid;
    logic       ready;

endinterface
```

The signals declared inside the interface can be accessed through an interface instance.

### Interface Instance

An interface instance is created using:

```systemverilog
simple_if bus();
```

The interface can then be connected to a DUT:

```systemverilog
sv_080_interface_dut dut (
    .bus(bus)
);
```

The DUT accesses the signals through the interface:

```systemverilog
bus.clk
bus.reset
bus.data
bus.valid
bus.ready
```

### Complete Runnable Example

```systemverilog
interface simple_if;

    logic       clk;
    logic       reset;
    logic [7:0] data;
    logic       valid;
    logic       ready;

endinterface


module sv_080_interface_dut (
    simple_if bus
);

    always_ff @(posedge bus.clk) begin

        if (bus.reset) begin
            bus.ready <= 1'b0;
        end
        else begin
            bus.ready <= bus.valid;
        end

    end

endmodule


module sv_080_interface_tb;

    simple_if bus();

    sv_080_interface_dut dut (
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

### Expected Behavior

The interface provides a common connection between the testbench and DUT:

```text
Testbench
    |
    | bus
    v
+-------------------+
|   simple_if       |
|                   |
| clk               |
| reset             |
| data[7:0]         |
| valid             |
| ready             |
+-------------------+
    |
    v
   DUT
```

The DUT observes `valid` and updates `ready` on the clock edge.

### Verification Relevance

Interfaces are fundamental to SystemVerilog verification environments because they provide a clean way to bundle protocol signals.

They also form the foundation for later concepts such as:

* Interface modports
* Clocking blocks
* Virtual interfaces
* Drivers
* Monitors
* UVM testbench connectivity

Instead of passing individual signals throughout a verification environment, related protocol signals can be organized into one interface.
