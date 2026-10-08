`timescale 1ns/1ps

module sv_120_temporal_operators_tb;

    logic clk;

    logic busy;
    logic request;
    logic acknowledge;

    logic start;
    logic event_a;
    logic event_b;
    logic done;

    logic test_throughout;
    logic test_within;
    logic test_until;

    // ------------------------------------------------
    // throughout
    // busy must remain high throughout request -> acknowledge
    // ------------------------------------------------

    sequence request_ack;
        request ##1 acknowledge;
    endsequence

    ap_throughout:
        assert property (@(posedge clk)
                          test_throughout |->
                          (busy throughout request_ack))
        else $error("[%0t] throughout failed: busy was not high",
                    $time);

    // ------------------------------------------------
    // within
    // event_a -> event_b must occur completely
    // inside the start -> done operation window
    // ------------------------------------------------

    sequence event_sequence;
        event_a ##1 event_b;
    endsequence

    sequence operation_window;
        start ##1 done;
    endsequence

    ap_within:
        assert property (@(posedge clk)
                          test_within |->
                          (event_sequence within operation_window))
        else $error("[%0t] within failed: event sequence was outside window",
                    $time);

    // ------------------------------------------------
    // until
    // busy must remain high until done becomes high
    // ------------------------------------------------

    ap_until:
        assert property (@(posedge clk)
                          test_until |->
                          (busy until done))
        else $error("[%0t] until failed: busy ended before done",
                    $time);

    initial begin

        clk = 1'b0;

        busy        = 1'b0;
        request     = 1'b0;
        acknowledge = 1'b0;

        start   = 1'b0;
        event_a = 1'b0;
        event_b = 1'b0;
        done    = 1'b0;

        test_throughout = 1'b0;
        test_within     = 1'b0;
        test_until      = 1'b0;

        // =================================================
        // throughout PASS
        // =================================================

        @(negedge clk);

        busy = 1'b1;
        request = 1'b1;
        test_throughout = 1'b1;

        @(negedge clk);

        test_throughout = 1'b0;
        request = 1'b0;
        acknowledge = 1'b1;

        @(negedge clk);

        acknowledge = 1'b0;
        busy = 1'b0;

        // =================================================
        // within PASS
        // Both sequences start and finish together.
        // =================================================

        @(negedge clk);

        start = 1'b1;
        event_a = 1'b1;
        test_within = 1'b1;

        @(negedge clk);

        test_within = 1'b0;
        start = 1'b0;
        event_a = 1'b0;
        event_b = 1'b1;
        done = 1'b1;

        @(negedge clk);

        event_b = 1'b0;
        done = 1'b0;

        // =================================================
        // until PASS
        // busy remains high until done becomes high.
        // =================================================

        @(negedge clk);

        busy = 1'b1;
        done = 1'b0;
        test_until = 1'b1;

        @(negedge clk);

        test_until = 1'b0;
        busy = 1'b1;
        done = 1'b0;

        @(negedge clk);

        busy = 1'b1;
        done = 1'b1;

        @(negedge clk);

        busy = 1'b0;
        done = 1'b0;

        #5;
        $finish;

    end

    always #5 clk = ~clk;

endmodule