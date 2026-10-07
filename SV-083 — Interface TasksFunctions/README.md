# 083 — SV-083 — Interface Tasks/Functions

## Introduction

SystemVerilog interfaces can contain tasks and functions in addition to signals.

This allows common bus operations to be defined directly inside the interface.

For example:

```systemverilog
task automatic write(input logic [7:0] write_data);
````

The testbench can then perform a bus operation using:

```systemverilog
bus.write(8'hA5);
```

instead of manually controlling every bus signal.

Tasks are useful for bus operations that involve timing because they can contain delays and event controls such as:

```systemverilog
@(posedge clk);
```

Functions are useful for operations that do not consume simulation time.

## Bus Operations Inside an Interface

The interface contains both the bus signals and the operations that use those signals:

```text
Interface
├── clk
├── reset
├── data
├── valid
├── ready
├── write()
└── get_data()
```

This provides a convenient abstraction for the testbench.

The testbench only needs to call:

```systemverilog
bus.write(8'hA5);
```

while the interface task handles the required signal activity and timing.

## Verification Relevance

Interface tasks and functions are useful for creating reusable bus operations in verification environments.

They can:

* Hide low-level signal manipulation
* Reduce repeated testbench code
* Encapsulate bus timing
* Make stimulus easier to read
* Provide reusable bus transactions

This concept becomes particularly useful when developing more structured SystemVerilog testbenches before moving into UVM.

## Complete Runnable Code

```systemverilog
interface simple_if;

    logic       clk;
    logic       reset;
    logic [7:0] data;
    logic       valid;
    logic       ready;

    // Bus write operation
    task automatic write(input logic [7:0] write_data);

        @(posedge clk);

        data  <= write_data;
        valid <= 1'b1;

        @(posedge clk);

        wait (ready);

        valid <= 1'b0;

    endtask

    // Function to check the current bus data
    function automatic logic [7:0] get_data();

        return data;

    endfunction

endinterface


module sv_083_interface_tasks_functions_dut (
    simple_if bus
);

    always_ff @(posedge bus.clk) begin

        if (bus.reset)
            bus.ready <= 1'b0;
        else
            bus.ready <= bus.valid;

    end

endmodule


module sv_083_interface_tasks_functions_tb;

    simple_if bus();

    sv_083_interface_tasks_functions_dut dut (
        .bus(bus)
    );

    initial begin

        bus.clk   = 1'b0;
        bus.reset = 1'b1;
        bus.data  = 8'h00;
        bus.valid = 1'b0;

        #10;

        bus.reset = 1'b0;

        bus.write(8'hA5);

        $display("[%0t] Write completed | data = %h",
                 $time,
                 bus.get_data());

        #10;

        $finish;

    end

    always #5 bus.clk = ~bus.clk;

endmodule
```

## Key Takeaway

An interface can contain not only signals but also reusable tasks and functions.

A task can encapsulate a complete bus operation:

```systemverilog
bus.write(8'hA5);
```

while a function can provide a simple interface utility:

```systemverilog
bus.get_data();
```

This makes the testbench cleaner by moving bus-specific operations and timing into the interface itself.

