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