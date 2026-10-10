`timescale 1ns/1ps

module sv_104_illegal_bins_tb;

    logic [1:0] opcode;

    covergroup opcode_cg;

        coverpoint opcode {

            bins add = {2'b00};
            bins sub = {2'b01};
            bins mul = {2'b10};

            // Opcode 11 is illegal
            illegal_bins illegal_opcode = {2'b11};

        }

    endgroup

    opcode_cg cg;

    initial begin

        cg = new();

        opcode = 2'b00;
        cg.sample();

        opcode = 2'b01;
        cg.sample();

        opcode = 2'b10;
        cg.sample();

        // Intentionally demonstrate an illegal scenario
        opcode = 2'b11;
        cg.sample();

        $display("[%0t] Coverage = %0.2f%%",
                 $time,
                 cg.get_coverage());

        $finish;

    end

endmodule