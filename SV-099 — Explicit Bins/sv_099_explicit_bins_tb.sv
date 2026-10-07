`timescale 1ns/1ps

module sv_099_explicit_bins_tb;

    logic [7:0] opcode;

    // Functional coverage model
    covergroup opcode_cg;

        // User-defined functional bins
        coverpoint opcode {

            bins arithmetic = {8'h01, 8'h02, 8'h03};
            bins logical    = {8'h10, 8'h11};
            bins control    = {8'h20, 8'h21};

        }

    endgroup

    opcode_cg cg;

    initial begin

        // Create the coverage object
        cg = new();

        // Hit arithmetic bin
        opcode = 8'h01;
        cg.sample();

        // Hit logical bin
        opcode = 8'h10;
        cg.sample();

        // Hit control bin
        opcode = 8'h20;
        cg.sample();

        $display("[%0t] Explicit-bin coverage = %0.2f%%",
                 $time,
                 cg.get_coverage());

        $finish;

    end

endmodule