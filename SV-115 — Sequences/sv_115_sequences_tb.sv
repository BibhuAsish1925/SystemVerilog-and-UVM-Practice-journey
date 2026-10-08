`timescale 1ns/1ps

module sv_115_sequences_tb;

    logic clk;
    logic valid;
    logic ready;

    logic test_pass;
    logic test_fail;

    // Sequence:
    // valid must be followed by ready
    // on the next clock cycle.
    sequence valid_then_ready;
        valid ##1 ready;
    endsequence

    // Trigger the sequence intentionally.
    ap_valid_then_ready:
        assert property (@(posedge clk)
                          (test_pass || test_fail) |->
                          valid_then_ready)
        else $error("[%0t] Sequence failed: valid was not followed by ready",
                    $time);

    initial begin

        clk       = 1'b0;
        valid     = 1'b0;
        ready     = 1'b0;

        test_pass = 1'b0;
        test_fail = 1'b0;

        // ---------------------------------------------
        // Passing sequence
        // ---------------------------------------------

        @(negedge clk);

        valid     = 1'b1;
        ready     = 1'b0;
        test_pass = 1'b1;

        // valid is sampled here.
        // ready must be high at the next posedge.

        @(negedge clk);

        test_pass = 1'b0;
        valid     = 1'b0;
        ready     = 1'b1;

        // ready is sampled here -> PASS

        @(negedge clk);

        ready = 1'b0;

        // ---------------------------------------------
        // Failing sequence
        // ---------------------------------------------

        @(negedge clk);

        valid     = 1'b1;
        ready     = 1'b0;
        test_fail = 1'b1;

        // valid is sampled here.
        // ready should become high next cycle,
        // but intentionally remains low.

        @(negedge clk);

        test_fail = 1'b0;
        valid     = 1'b0;
        ready     = 1'b0;

        // ready is sampled here -> FAIL

        @(negedge clk);

        #5;
        $finish;

    end

    always #5 clk = ~clk;

endmodule