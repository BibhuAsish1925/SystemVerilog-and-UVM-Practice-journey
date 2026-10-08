`timescale 1ns/1ps

module sv_147_coverage_assertions_tb;

    logic clk;
    logic valid;
    logic ready;

    // Functional coverage
    covergroup protocol_cg @(posedge clk);

        cp_valid:
            coverpoint valid {
                bins valid_low  = {0};
                bins valid_high = {1};
            }

        cp_ready:
            coverpoint ready {
                bins ready_low  = {0};
                bins ready_high = {1};
            }

        cross_valid_ready:
            cross cp_valid, cp_ready;

    endgroup

    protocol_cg cg;

    // Assertion: a valid transfer must have ready high
    ap_valid_requires_ready:
        assert property (@(posedge clk)
                          valid |-> ready)
        else
            $error("[%0t] ASSERTION FAILED: valid=1 but ready=0",
                   $time);

    initial begin

        cg = new();

        clk   = 1'b0;
        valid = 1'b0;
        ready = 1'b0;

        // valid=0, ready=0
        @(negedge clk);

        // valid=1, ready=1 : PASS
        valid = 1'b1;
        ready = 1'b1;

        @(negedge clk);

        // valid=0, ready=1
        valid = 1'b0;
        ready = 1'b1;

        @(negedge clk);

        // valid=1, ready=0 : assertion FAIL
        valid = 1'b1;
        ready = 1'b0;

        @(negedge clk);

        // valid=0, ready=0
        valid = 1'b0;
        ready = 1'b0;

        @(negedge clk);

        $display("========================================");
        $display("Coverage + Assertion Verification");
        $display("========================================");

        $display("Functional Coverage = %0.2f%%",
                 cg.get_coverage());

        $finish;

    end

    always #5 clk = ~clk;

endmodule