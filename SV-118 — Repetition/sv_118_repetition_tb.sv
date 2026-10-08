`timescale 1ns/1ps

module sv_118_repetition_tb;

    logic clk;
    logic valid;
    logic done;

    logic test_consecutive;
    logic test_one_or_more;
    logic test_goto;

    // [*3] : valid must be high for 3 consecutive cycles
    ap_consecutive:
        assert property (@(posedge clk)
                          test_consecutive |-> valid[*3])
        else $error("[%0t] [*3] failed: valid was not high for 3 cycles",
                    $time);

    // [+] : valid must be high for one or more cycles
    ap_one_or_more:
        assert property (@(posedge clk)
                          test_one_or_more |-> valid[+])
        else $error("[%0t] [+] failed: valid was not high",
                    $time);

    // [->1] : done must occur at least once
    ap_goto:
        assert property (@(posedge clk)
                          test_goto |-> done[->1])
        else $error("[%0t] [->1] failed: done did not occur",
                    $time);

    initial begin

        clk = 1'b0;
        valid = 1'b0;
        done = 1'b0;

        test_consecutive = 1'b0;
        test_one_or_more = 1'b0;
        test_goto = 1'b0;

        // -------------------------
        // Test [*3]
        // -------------------------

        @(negedge clk);
        valid = 1'b1;
        test_consecutive = 1'b1;

        // Trigger is sampled here and valid stays high
        // for three consecutive assertion samples.

        @(negedge clk);
        test_consecutive = 1'b0;

        @(negedge clk);

        // Keep valid high through the third sample
        @(negedge clk);
        valid = 1'b0;

        // -------------------------
        // Test [+]
        // -------------------------

        @(negedge clk);
        valid = 1'b1;
        test_one_or_more = 1'b1;

        @(negedge clk);
        test_one_or_more = 1'b0;

        @(negedge clk);
        valid = 1'b0;

        // -------------------------
        // Test [->1]
        // -------------------------

        @(negedge clk);
        test_goto = 1'b1;
        done = 1'b0;

        @(negedge clk);
        test_goto = 1'b0;

        @(negedge clk);
        done = 1'b1;

        @(negedge clk);
        done = 1'b0;

        #5;
        $finish;

    end

    always #5 clk = ~clk;

endmodule