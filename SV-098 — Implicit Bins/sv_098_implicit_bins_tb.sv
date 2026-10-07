`timescale 1ns/1ps

module sv_098_implicit_bins_tb;

    logic [1:0] opcode;

    // Functional coverage model
    covergroup opcode_cg;

        // No explicit bins are declared.
        // The simulator creates implicit value bins.
        coverpoint opcode;

    endgroup

    opcode_cg cg;

    initial begin

        // Create the coverage object
        cg = new();

        // Sample all possible 2-bit values
        opcode = 2'b00;
        cg.sample();

        opcode = 2'b01;
        cg.sample();

        opcode = 2'b10;
        cg.sample();

        opcode = 2'b11;
        cg.sample();

        $display("[%0t] Implicit-bin coverage = %0.2f%%",
                 $time,
                 cg.get_coverage());

        $finish;

    end

endmodule