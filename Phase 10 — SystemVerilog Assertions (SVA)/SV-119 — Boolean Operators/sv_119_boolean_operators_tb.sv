`timescale 1ns/1ps

module sv_119_boolean_operators_tb;

    logic clk;
    logic a;
    logic b;
    logic c;

    logic test_and;
    logic test_or;
    logic test_intersect;

    // One-cycle sequences
    sequence seq_a;
        a;
    endsequence

    sequence seq_b;
        b;
    endsequence

    // AND: both sequences must match
    ap_and:
        assert property (@(posedge clk)
                          test_and |-> (seq_a and seq_b))
        else $error("[%0t] AND failed",
                    $time);

    // OR: at least one sequence must match
    ap_or:
        assert property (@(posedge clk)
                          test_or |-> (seq_a or seq_b))
        else $error("[%0t] OR failed",
                    $time);

    // Two-cycle sequences for INTERSECT
    sequence seq_a_then_b;
        a ##1 b;
    endsequence

    sequence seq_c_then_b;
        c ##1 b;
    endsequence

    // INTERSECT: both sequences must end together
    ap_intersect:
        assert property (@(posedge clk)
                          test_intersect |->
                          (seq_a_then_b intersect seq_c_then_b))
        else $error("[%0t] INTERSECT failed",
                    $time);

    initial begin

        clk = 1'b0;
        a   = 1'b0;
        b   = 1'b0;
        c   = 1'b0;

        test_and       = 1'b0;
        test_or        = 1'b0;
        test_intersect = 1'b0;

        // -------------------------
        // Test AND
        // -------------------------

        @(negedge clk);
        a = 1'b1;
        b = 1'b1;
        test_and = 1'b1;

        @(negedge clk);
        test_and = 1'b0;
        a = 1'b0;
        b = 1'b0;

        // -------------------------
        // Test OR
        // -------------------------

        @(negedge clk);
        a = 1'b1;
        b = 1'b0;
        test_or = 1'b1;

        @(negedge clk);
        test_or = 1'b0;
        a = 1'b0;

        // -------------------------
        // Test INTERSECT
        // -------------------------

        @(negedge clk);
        a = 1'b1;
        c = 1'b1;
        b = 1'b0;
        test_intersect = 1'b1;

        @(negedge clk);
        test_intersect = 1'b0;
        b = 1'b1;

        @(negedge clk);
        a = 1'b0;
        b = 1'b0;
        c = 1'b0;

        #5;
        $finish;

    end

    always #5 clk = ~clk;

endmodule