`timescale 1ns/1ps

module sv_097_coverpoint_tb;

    logic [7:0] opcode;

    // Functional coverage model
    covergroup opcode_cg;

        // Coverpoint measures the opcode value
        coverpoint opcode {
            bins add = {8'h01};
            bins sub = {8'h02};
            bins mul = {8'h03};
            bins div = {8'h04};
        }

    endgroup

    opcode_cg cg;

    initial begin

        // Create the coverage object
        cg = new();

        // Sample different opcode values
        opcode = 8'h01;
        cg.sample();

        opcode = 8'h02;
        cg.sample();

        opcode = 8'h03;
        cg.sample();

        opcode = 8'h04;
        cg.sample();

        $display("[%0t] Coverpoint coverage = %0.2f%%",
                 $time,
                 cg.get_coverage());

        $finish;

    end

endmodule