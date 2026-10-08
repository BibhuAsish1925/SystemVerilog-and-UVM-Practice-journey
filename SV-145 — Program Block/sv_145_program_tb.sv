`timescale 1ns/1ps

module sv_145_program_dut (
    input  logic       clk,
    input  logic       reset,
    input  logic       enable,
    input  logic [7:0] data,
    output logic [7:0] result
);

    always_ff @(posedge clk) begin

        if (reset)
            result <= 8'h00;
        else if (enable)
            result <= data + 8'd1;

    end

endmodule


program sv_145_test_program (
    input  logic       clk,
    input  logic       reset,
    output logic       enable,
    output logic [7:0] data,
    input  logic [7:0] result
);

    initial begin

        enable = 1'b0;
        data   = 8'h00;

        @(negedge clk);

        enable = 1'b1;
        data   = 8'h10;

        @(negedge clk);

        enable = 1'b0;

        @(posedge clk);

        #1;

        $display("[%0t] Program: data=%h result=%h",
                 $time, data, result);

        @(negedge clk);

        enable = 1'b1;
        data   = 8'h20;

        @(negedge clk);

        enable = 1'b0;

        @(posedge clk);

        #1;

        $display("[%0t] Program: data=%h result=%h",
                 $time, data, result);

        $finish;

    end

endprogram


module sv_145_program_tb;

    logic       clk;
    logic       reset;
    logic       enable;
    logic [7:0] data;
    logic [7:0] result;

    sv_145_program_dut dut (
        .clk    (clk),
        .reset  (reset),
        .enable (enable),
        .data   (data),
        .result (result)
    );

    sv_145_test_program test_program (
        .clk    (clk),
        .reset  (reset),
        .enable (enable),
        .data   (data),
        .result (result)
    );

    initial begin

        clk   = 1'b0;
        reset = 1'b1;

        #12;

        reset = 1'b0;

    end

    always #5 clk = ~clk;

endmodule