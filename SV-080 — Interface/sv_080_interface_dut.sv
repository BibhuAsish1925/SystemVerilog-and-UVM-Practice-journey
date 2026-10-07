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