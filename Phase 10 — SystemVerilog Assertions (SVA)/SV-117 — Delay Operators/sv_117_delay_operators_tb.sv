`timescale 1ns/1ps

module sv_117_delay_operators_tb;

    logic clk;
    logic request;
    logic acknowledge;

    logic test_one_cycle;
    logic test_two_cycle;

    // ##1: acknowledge must occur one cycle after request
    ap_one_cycle:
        assert property (@(posedge clk)
                          test_one_cycle |->
                          (request ##1 acknowledge))
        else $error("[%0t] ##1 failed: acknowledge missing after 1 cycle",
                    $time);

    // ##2: acknowledge must occur two cycles after request
    ap_two_cycle:
        assert property (@(posedge clk)
                          test_two_cycle |->
                          (request ##2 acknowledge))
        else $error("[%0t] ##2 failed: acknowledge missing after 2 cycles",
                    $time);

    initial begin

        clk = 1'b0;
        request = 1'b0;
        acknowledge = 1'b0;

        test_one_cycle = 1'b0;
        test_two_cycle = 1'b0;

        // ---------------------------------------------
        // ##1 PASS
        // ---------------------------------------------

        @(negedge clk);
        request = 1'b1;
        test_one_cycle = 1'b1;

        @(negedge clk);
        request = 1'b0;
        test_one_cycle = 1'b0;
        acknowledge = 1'b1;

        @(negedge clk);
        acknowledge = 1'b0;

        // ---------------------------------------------
        // ##2 PASS
        // ---------------------------------------------

        @(negedge clk);
        request = 1'b1;
        test_two_cycle = 1'b1;

        @(negedge clk);
        request = 1'b0;
        test_two_cycle = 1'b0;

        @(negedge clk);
        acknowledge = 1'b1;

        @(negedge clk);
        acknowledge = 1'b0;

        #5;
        $finish;

    end

    always #5 clk = ~clk;

endmodule