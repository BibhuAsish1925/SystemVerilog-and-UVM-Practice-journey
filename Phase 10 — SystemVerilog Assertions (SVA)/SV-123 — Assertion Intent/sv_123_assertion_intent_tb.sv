`timescale 1ns/1ps

module sv_123_assertion_intent_tb;

    logic clk;
    logic reset;
    logic valid;
    logic ready;

    // ------------------------------------------------------------
    // ASSERT
    // valid must imply ready on the same clock edge.
    // ------------------------------------------------------------
    ap_valid_ready:
        assert property (@(posedge clk)
                          disable iff (reset)
                          valid |-> ready)
        else $error("[%0t] ASSERT failed: valid=1 but ready=0",
                    $time);

    // ------------------------------------------------------------
    // ASSUME
    // In a formal environment, assume that valid is not asserted
    // while reset is active.
    // ------------------------------------------------------------
    ap_reset_environment:
        assume property (@(posedge clk)
                          reset |-> !valid);

    // ------------------------------------------------------------
    // COVER
    // Check whether a valid transaction followed by ready occurs.
    // ------------------------------------------------------------
    cp_valid_ready:
        cover property (@(posedge clk)
                         disable iff (reset)
                         valid ##1 ready);

    initial begin

        clk   = 1'b0;
        reset = 1'b1;
        valid = 1'b0;
        ready = 1'b0;

        // --------------------------------------------------------
        // Reset
        // --------------------------------------------------------
        @(negedge clk);
        reset = 1'b1;
        valid = 1'b0;
        ready = 1'b0;

        // --------------------------------------------------------
        // Valid transaction: ASSERT passes
        // --------------------------------------------------------
        @(negedge clk);
        reset = 1'b0;
        valid = 1'b1;
        ready = 1'b1;

        @(negedge clk);
        valid = 1'b0;
        ready = 1'b0;

        // --------------------------------------------------------
        // Cover scenario:
        // valid at one clock, ready at the next clock.
        // --------------------------------------------------------
        @(negedge clk);
        valid = 1'b1;
        ready = 1'b0;

        @(negedge clk);
        valid = 1'b0;
        ready = 1'b1;

        @(negedge clk);
        valid = 1'b0;
        ready = 1'b0;

        // --------------------------------------------------------
        // Intentional ASSERT failure
        // --------------------------------------------------------
        @(negedge clk);
        valid = 1'b1;
        ready = 1'b0;

        @(negedge clk);
        valid = 1'b0;
        ready = 1'b0;

        #5;
        $finish;

    end

    always #5 clk = ~clk;

endmodule