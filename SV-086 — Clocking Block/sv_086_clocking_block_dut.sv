interface simple_if;

    logic       clk;
    logic       reset;
    logic [7:0] data;
    logic       valid;
    logic       ready;

    clocking cb @(posedge clk);

        input  #1step ready;
        input  #1step data;

        output #1step valid;

    endclocking

endinterface


module sv_086_clocking_block_dut (
    simple_if bus
);

    always_ff @(posedge bus.clk) begin

        if (bus.reset)
            bus.ready <= 1'b0;
        else
            bus.ready <= bus.valid;

    end

endmodule


module sv_086_clocking_block_tb;

    simple_if bus();

    sv_086_clocking_block_dut dut (
        .bus(bus)
    );

    initial begin

        bus.clk   = 1'b0;
        bus.reset = 1'b1;
        bus.data  = 8'h00;
        bus.valid = 1'b0;

        #10;

        bus.reset = 1'b0;

        // Drive through the clocking block
        @(bus.cb);

        bus.cb.valid <= 1'b1;
        bus.data     <= 8'hA5;

        // Sample through the clocking block
        @(bus.cb);

        $display("[%0t] Clocking block | data=%h | ready=%b",
                 $time,
                 bus.cb.data,
                 bus.cb.ready);

        bus.cb.valid <= 1'b0;

        @(bus.cb);

        $display("[%0t] Clocking block | data=%h | ready=%b",
                 $time,
                 bus.cb.data,
                 bus.cb.ready);

        #10;

        $finish;

    end

    always #5 bus.clk = ~bus.clk;

endmodule