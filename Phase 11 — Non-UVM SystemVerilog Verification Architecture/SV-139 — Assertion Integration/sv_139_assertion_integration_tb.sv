`timescale 1ns/1ps

module sv_139_dut (
    input  logic clk,
    input  logic reset,
    input  logic valid,
    input  logic enable,
    output logic ready
);

    always_ff @(posedge clk) begin

        if (reset)
            ready <= 1'b0;
        else
            ready <= valid && enable;

    end

endmodule


module sv_139_assertion_integration_tb;

    logic clk;
    logic reset;
    logic valid;
    logic enable;
    logic ready;

    sv_139_dut dut (
        .clk    (clk),
        .reset  (reset),
        .valid  (valid),
        .enable (enable),
        .ready  (ready)
    );


    // When valid is high, ready must be high.
    ap_valid_ready:
        assert property (@(posedge clk)
                          disable iff (reset)
                          valid |-> ready)
        else $error("[%0t] ASSERTION FAILED: valid=1 but ready=0",
                    $time);


    initial begin

        clk    = 1'b0;
        reset  = 1'b1;
        valid  = 1'b0;
        enable = 1'b0;

        // Reset
        @(negedge clk);

        reset = 1'b1;

        @(negedge clk);

        // Valid transaction with enable
        reset  = 1'b0;
        enable = 1'b1;
        valid  = 1'b1;

        @(negedge clk);

        valid = 1'b0;

        // Intentional assertion failure
        // valid=1 while enable=0 causes ready=0.
        @(negedge clk);

        enable = 1'b0;
        valid  = 1'b1;

        @(negedge clk);

        valid = 1'b0;

        @(negedge clk);

        $finish;

    end


    always #5 clk = ~clk;

endmodule