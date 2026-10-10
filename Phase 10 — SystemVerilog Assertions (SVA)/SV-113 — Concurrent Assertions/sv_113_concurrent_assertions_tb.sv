`timescale 1ns/1ps

module sv_113_concurrent_assertions_tb;

    logic clk;
    logic valid;
    logic ready;

    // Concurrent assertion:
    // Whenever valid is 1 at a rising edge,
    // ready must also be 1 at that edge.
    ap_valid_ready:
        assert property (@(posedge clk) valid |-> ready)
        else $error("[%0t] Assertion failed: valid=1 but ready=0",
                    $time);

    initial begin

        clk   = 1'b0;
        valid = 1'b0;
        ready = 1'b0;

        #10;

        // Assertion passes
        valid = 1'b1;
        ready = 1'b1;

        #10;

        // Assertion fails
        valid = 1'b1;
        ready = 1'b0;

        #10;

        // No failure because valid is 0
        valid = 1'b0;
        ready = 1'b0;

        #10;

        $finish;

    end

    always #5 clk = ~clk;

endmodule