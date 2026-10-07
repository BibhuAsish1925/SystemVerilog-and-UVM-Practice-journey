`timescale 1ns/1ps

interface simple_if;

    logic clk;
    logic d;
    logic q;

    // Clocking block for the driver
    clocking driver_cb @(posedge clk);
        output #1step d;
    endclocking

    // Clocking block for the monitor
    clocking monitor_cb @(posedge clk);
        input #1step d;
        input #1step q;
    endclocking

endinterface


module sv_095_race_avoidance_dut (
    simple_if bus
);

    always_ff @(posedge bus.clk) begin
        bus.q <= bus.d;
    end

endmodule


class driver;

    virtual simple_if vif;

    function new(virtual simple_if vif);
        this.vif = vif;
    endfunction

    task drive(input logic value);

        // Synchronize driver with the clock
        @(vif.driver_cb);

        // Drive through the driver clocking block
        vif.driver_cb.d <= value;

        $display("[%0t] Driver  : d=%b",
                 $time, value);

    endtask

endclass


class monitor;

    virtual simple_if vif;

    function new(virtual simple_if vif);
        this.vif = vif;
    endfunction

    task run();

        forever begin

            // Synchronize monitor with the clock
            @(vif.monitor_cb);

            // Sample through the monitor clocking block
            $display("[%0t] Monitor : d=%b q=%b",
                     $time,
                     vif.monitor_cb.d,
                     vif.monitor_cb.q);

        end

    endtask

endclass


module sv_095_race_avoidance_tb;

    simple_if bus();

    sv_095_race_avoidance_dut dut (
        .bus(bus)
    );

    driver  drv;
    monitor mon;

    initial begin

        bus.clk = 1'b0;
        bus.d   = 1'b0;
        bus.q   = 1'b0;

        drv = new(bus);
        mon = new(bus);

        fork
            mon.run();
        join_none

        #7;
        drv.drive(1'b1);

        #10;
        drv.drive(1'b0);

        #10;

        $finish;

    end

    always #5 bus.clk = ~bus.clk;

endmodule