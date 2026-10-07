interface simple_if;

    logic       clk;
    logic       reset;
    logic [7:0] data;
    logic       valid;
    logic       ready;

    // Clocking block used by the driver
    clocking cb @(posedge clk);

        // Signals sampled by the driver
        input  #1step ready;

        // Signals driven by the driver
        output #1step data;
        output #1step valid;

    endclocking

endinterface


module sv_087_clocking_block_driver_dut (
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

        // Wait for the clocking block event
        @(vif.cb);

        // Drive signals through the clocking block
        vif.cb.data  <= data_value;
        vif.cb.valid <= 1'b1;

        // Wait for the next clocking event
        @(vif.cb);

        // Deassert valid
        vif.cb.valid <= 1'b0;

        $display("[%0t] Driver sent data = %h",
                 $time,
                 data_value);

    endtask

endclass


module sv_087_clocking_block_driver_tb;

    simple_if bus();

    sv_087_clocking_block_driver_dut dut (
        .bus(bus)
    );

    driver drv;

    initial begin

        // Initialize interface
        bus.clk   = 1'b0;
        bus.reset = 1'b1;
        bus.data  = 8'h00;
        bus.valid = 1'b0;

        // Pass the physical interface to the driver
        drv = new(bus);

        #10;

        bus.reset = 1'b0;

        // Driver sends one transaction
        drv.drive(8'hA5);

        #10;

        $finish;

    end

    always #5 bus.clk = ~bus.clk;

endmodule