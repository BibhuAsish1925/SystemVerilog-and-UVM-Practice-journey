`timescale 1ns/1ps

module sv_144_checker_dut (
    input logic       clk,
    input logic       reset,
    input logic       valid,
    input logic       ready,
    input logic [7:0] data
);

    always_ff @(posedge clk) begin

        if (!reset && valid && ready)
            $display("[%0t] DUT: transfer accepted, data=%h",
                     $time, data);

    end

endmodule


// XSim-compatible checker module
module sv_144_protocol_checker (
    input logic clk,
    input logic reset,
    input logic valid,
    input logic ready
);

    ap_valid_ready:
        assert property (
            @(posedge clk)
            disable iff (reset)
            valid |-> ready
        )
        else
            $error("[%0t] CHECKER ASSERTION FAILED: valid=1 but ready=0",
                   $time);

endmodule


module sv_144_checker_tb;

    logic       clk;
    logic       reset;
    logic       valid;
    logic       ready;
    logic [7:0] data;

    sv_144_checker_dut dut (
        .clk   (clk),
        .reset (reset),
        .valid (valid),
        .ready (ready),
        .data  (data)
    );

    sv_144_protocol_checker protocol_checker (
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
        data  = 8'h00;

        repeat (2)
            @(negedge clk);

        reset = 1'b0;

        // Valid transfer: assertion passes
        @(negedge clk);
        valid = 1'b1;
        ready = 1'b1;
        data  = 8'hA5;

        @(negedge clk);
        valid = 1'b0;
        ready = 1'b0;

        // Intentional protocol violation
        @(negedge clk);
        valid = 1'b1;
        ready = 1'b0;
        data  = 8'h3C;

        @(negedge clk);
        valid = 1'b0;
        ready = 1'b1;

        #5;
        $finish;

    end

    always #5 clk = ~clk;

endmodule