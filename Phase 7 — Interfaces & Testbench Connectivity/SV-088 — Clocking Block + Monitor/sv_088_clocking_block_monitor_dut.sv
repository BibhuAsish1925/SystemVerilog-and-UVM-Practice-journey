interface simple_if;

    logic       clk;
    logic       reset;
    logic [7:0] data;
    logic       valid;
    logic       ready;

    // Clocking block used by the monitor
    clocking cb @(posedge clk);

        // Signals sampled by the monitor
        input #1step data;
        input #1step valid;
        input #1step ready;

    endclocking

endinterface


module sv_088_clocking_block_monitor_dut (
    simple_if bus
);

    always_ff @(posedge bus.clk) begin

        if (bus.reset)
            bus.ready <= 1'b0;
        else
            bus.ready <= bus.valid;

    end

endmodule


class monitor;

    virtual simple_if vif;

    function new(virtual simple_if vif);
        this.vif = vif;
    endfunction

    task run();

        forever begin

            // Wait for the clocking block event
            @(vif.cb);

            // Sample through the clocking block
            $display("[%0t] Monitor: data=%h | valid=%b | ready=%b",
                     $time,
                     vif.cb.data,
                     vif.cb.valid,
                     vif.cb.ready);

        end

    endtask

endclass


module sv_088_clocking_block_monitor_tb;

    simple_if bus();

    sv_088_clocking_block_monitor_dut dut (
        .bus(bus)
    );

    monitor mon;

    initial begin

        // Initialize interface
        bus.clk   = 1'b0;
        bus.reset = 1'b1;
        bus.data  = 8'h00;
        bus.valid = 1'b0;

        // Pass interface to the monitor
        mon = new(bus);

        // Start monitor
        fork
            mon.run();
        join_none

        #10;

        bus.reset = 1'b0;

        bus.data  = 8'hA5;
        bus.valid = 1'b1;

        #10;

        bus.data  = 8'h3C;
        bus.valid = 1'b1;

        #10;

        bus.valid = 1'b0;

        #10;

        $finish;

    end

    always #5 bus.clk = ~bus.clk;

endmodule