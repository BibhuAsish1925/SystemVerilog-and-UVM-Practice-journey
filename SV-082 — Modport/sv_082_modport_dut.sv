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
        input  ready
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