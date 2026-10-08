`timescale 1ns/1ps

module sv_122_disable_iff_tb;

    logic clk;
    logic reset;
    logic valid;
    logic ready;

    logic test_reset;
    logic test_active;

    // ------------------------------------------------
    // Assertion is disabled whenever reset is high.
    // When reset is low:
    // valid must be followed by ready on the same cycle.
    // ------------------------------------------------

    ap_valid_ready:
        assert property (@(posedge clk)
                          disable iff (reset)
                          (test_reset || test_active) |->
                          (valid && ready))
        else $error("[%0t] Assertion failed: valid requires ready",
                    $time);

    initial begin

        clk = 1'b0;
        reset = 1'b1;
        valid = 1'b0;
        ready = 1'b0;

        test_reset  = 1'b0;
        test_active = 1'b0;

        // =================================================
        // Assertion disabled during reset
        // =================================================

        @(negedge clk);

        reset = 1'b1;
        valid = 1'b1;
        ready = 1'b0;
        test_reset = 1'b1;

        @(negedge clk);

        test_reset = 1'b0;
        valid = 1'b0;

        // =================================================
        // Reset released
        // Assertion becomes active.
        // =================================================

        @(negedge clk);

        reset = 1'b0;
        valid = 1'b1;
        ready = 1'b1;
        test_active = 1'b1;

        // Assertion passes because valid && ready.
        @(negedge clk);

        test_active = 1'b0;
        valid = 1'b0;
        ready = 1'b0;

        // =================================================
        // Assertion active and intentionally failing
        // =================================================

        @(negedge clk);

        valid = 1'b1;
        ready = 1'b0;
        test_active = 1'b1;

        @(negedge clk);

        test_active = 1'b0;
        valid = 1'b0;

        // =================================================
        // Assert reset again.
        // Assertion is disabled again.
        // =================================================

        @(negedge clk);

        reset = 1'b1;
        valid = 1'b1;
        ready = 1'b0;
        test_reset = 1'b1;

        @(negedge clk);

        test_reset = 1'b0;
        valid = 1'b0;
        ready = 1'b0;

        #5;
        $finish;

    end

    always #5 clk = ~clk;

endmodule