`timescale 1ns/1ps

module sv_116_implication_tb;

    logic clk;
    logic valid;
    logic ready;

    logic test_overlapped;
    logic test_non_overlapped;

    // |-> : valid and ready must be true on the same clock edge
    ap_overlapped:
        assert property (@(posedge clk)
                          test_overlapped |-> (valid && ready))
        else $error("[%0t] |-> failed: valid and ready were not both high",
                    $time);

    // |=> : ready must be true on the next clock edge
    ap_non_overlapped:
        assert property (@(posedge clk)
                          test_non_overlapped |=> ready)
        else $error("[%0t] |=> failed: ready was not high next cycle",
                    $time);

    initial begin

        clk = 1'b0;
        valid = 1'b0;
        ready = 1'b0;

        test_overlapped    = 1'b0;
        test_non_overlapped = 1'b0;

        // ------------------------------------------------
        // |-> PASS: valid and ready are high together
        // ------------------------------------------------
        @(negedge clk);
        valid = 1'b1;
        ready = 1'b1;
        test_overlapped = 1'b1;

        @(negedge clk);
        test_overlapped = 1'b0;
        valid = 1'b0;
        ready = 1'b0;

        // ------------------------------------------------
        // |=> PASS: ready becomes high on next cycle
        // ------------------------------------------------
        @(negedge clk);
        valid = 1'b1;
        ready = 1'b0;
        test_non_overlapped = 1'b1;

        @(negedge clk);
        test_non_overlapped = 1'b0;
        valid = 1'b0;
        ready = 1'b1;

        @(negedge clk);
        ready = 1'b0;

        // ------------------------------------------------
        // |-> FAIL: valid is high but ready is low
        // ------------------------------------------------
        @(negedge clk);
        valid = 1'b1;
        ready = 1'b0;
        test_overlapped = 1'b1;

        @(negedge clk);
        test_overlapped = 1'b0;
        valid = 1'b0;

        // ------------------------------------------------
        // |=> FAIL: ready is not high on next cycle
        // ------------------------------------------------
        @(negedge clk);
        valid = 1'b1;
        ready = 1'b0;
        test_non_overlapped = 1'b1;

        @(negedge clk);
        test_non_overlapped = 1'b0;
        valid = 1'b0;
        ready = 1'b0;

        @(negedge clk);

        #5;
        $finish;

    end

    always #5 clk = ~clk;

endmodule