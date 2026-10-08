`timescale 1ns/1ps

module sv_121_sva_system_functions_tb;

    logic       clk;
    logic       signal_a;
    logic [7:0] data;

    logic test_past;
    logic test_rose;
    logic test_fell;
    logic test_stable;
    logic test_changed;

    // ------------------------------------------------
    // $past
    // Current data must equal the previous data + 1.
    // ------------------------------------------------

    ap_past:
        assert property (@(posedge clk)
                          test_past |->
                          (data == $past(data) + 8'd1))
        else $error("[%0t] $past failed: data did not increment",
                    $time);

    // ------------------------------------------------
    // $rose
    // signal_a must have a rising edge.
    // ------------------------------------------------

    ap_rose:
        assert property (@(posedge clk)
                          test_rose |-> $rose(signal_a))
        else $error("[%0t] $rose failed: signal_a did not rise",
                    $time);

    // ------------------------------------------------
    // $fell
    // signal_a must have a falling edge.
    // ------------------------------------------------

    ap_fell:
        assert property (@(posedge clk)
                          test_fell |-> $fell(signal_a))
        else $error("[%0t] $fell failed: signal_a did not fall",
                    $time);

    // ------------------------------------------------
    // $stable
    // data must remain unchanged from the previous cycle.
    // ------------------------------------------------

    ap_stable:
        assert property (@(posedge clk)
                          test_stable |-> $stable(data))
        else $error("[%0t] $stable failed: data changed",
                    $time);

    // ------------------------------------------------
    // $changed
    // data must be different from the previous cycle.
    // ------------------------------------------------

    ap_changed:
        assert property (@(posedge clk)
                          test_changed |-> $changed(data))
        else $error("[%0t] $changed failed: data did not change",
                    $time);

    initial begin

        clk = 1'b0;
        signal_a = 1'b0;
        data = 8'd0;

        test_past    = 1'b0;
        test_rose    = 1'b0;
        test_fell    = 1'b0;
        test_stable  = 1'b0;
        test_changed = 1'b0;

        // =================================================
        // $past PASS
        // =================================================

        @(negedge clk);
        data = 8'd10;

        @(negedge clk);
        data = 8'd11;
        test_past = 1'b1;

        @(negedge clk);
        test_past = 1'b0;

        // =================================================
        // $rose PASS
        // =================================================

        @(negedge clk);
        signal_a = 1'b0;

        @(negedge clk);
        signal_a = 1'b1;
        test_rose = 1'b1;

        @(negedge clk);
        test_rose = 1'b0;

        // =================================================
        // $fell PASS
        // =================================================

        @(negedge clk);
        signal_a = 1'b1;

        @(negedge clk);
        signal_a = 1'b0;
        test_fell = 1'b1;

        @(negedge clk);
        test_fell = 1'b0;

        // =================================================
        // $stable PASS
        // =================================================

        @(negedge clk);
        data = 8'd20;

        @(negedge clk);
        data = 8'd20;
        test_stable = 1'b1;

        @(negedge clk);
        test_stable = 1'b0;

        // =================================================
        // $changed PASS
        // =================================================

        @(negedge clk);
        data = 8'd30;

        @(negedge clk);
        data = 8'd31;
        test_changed = 1'b1;

        @(negedge clk);
        test_changed = 1'b0;

        #5;
        $finish;

    end

    always #5 clk = ~clk;

endmodule