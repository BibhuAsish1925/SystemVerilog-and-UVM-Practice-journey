`timescale 1ns/1ps

module sv_094_race_conditions_tb;

    logic clk;
    logic d;
    logic q;

    // DUT
    always_ff @(posedge clk) begin
        q <= d;
    end

    // Driver
    initial begin
        clk = 1'b0;
        d   = 1'b0;

        #10;

        // Driver changes d at the same time
        // that the DUT samples d.
        @(posedge clk);
        d = 1'b1;

        #10;

        @(posedge clk);
        d = 1'b0;

        #10;

        $finish;
    end

    // Monitor
    always @(posedge clk) begin
        $display("[%0t] Monitor: d=%b q=%b",
                 $time, d, q);
    end

    always #5 clk = ~clk;

endmodule