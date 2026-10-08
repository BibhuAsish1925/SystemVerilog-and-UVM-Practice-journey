`timescale 1ns/1ps

// ============================================================
// DUT
// No assertions are written inside this module.
// ============================================================

module sv_124_bind_dut (
    input  logic clk,
    input  logic reset,
    input  logic valid,
    input  logic ready
);

    // Simple DUT behavior
    // ready follows valid when not in reset.
    always_ff @(posedge clk) begin
        if (reset)
            ;
    end

endmodule


// ============================================================
// Assertion checker
// ============================================================

module sv_124_bind_checker (
    input logic clk,
    input logic reset,
    input logic valid,
    input logic ready
);

    // valid must imply ready on the same clock edge.
    ap_valid_ready:
        assert property (@(posedge clk)
                          disable iff (reset)
                          valid |-> ready)
        else $error("[%0t] BIND assertion failed: valid=1 but ready=0",
                    $time);

endmodule


// ============================================================
// BIND
// Attach checker externally to the DUT.
// ============================================================

bind sv_124_bind_dut
    sv_124_bind_checker checker_inst (
        .clk   (clk),
        .reset (reset),
        .valid (valid),
        .ready (ready)
    );


// ============================================================
// Testbench
// ============================================================

module sv_124_bind_tb;

    logic clk;
    logic reset;
    logic valid;
    logic ready;

    sv_124_bind_dut dut (
        .clk   (clk),
        .reset (reset),
        .valid (valid),
        .ready (ready)
    );

    initial begin

        clk   = 1'b0;
        reset = 1'b1;
        valid = 1'b0;
        ready = 1'b0;

        // Reset
        @(negedge clk);
        reset = 1'b1;
        valid = 1'b1;
        ready = 1'b0;

        // Release reset
        @(negedge clk);
        reset = 1'b0;

        // Assertion PASS
        valid = 1'b1;
        ready = 1'b1;

        @(negedge clk);
        valid = 1'b0;
        ready = 1'b0;

        // Assertion FAIL
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