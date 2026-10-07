`timescale 1ns/1ps

module sv_108_default_bins_tb;

    logic [1:0] opcode;

    covergroup opcode_cg;

        coverpoint opcode {

            bins add = {2'b00};
            bins sub = {2'b01};
            bins mul = {2'b10};

            // Collect all other values
            bins others = default;

        }

    endgroup

    opcode_cg cg;

    initial begin

        cg = new();

        // Explicit bins
        opcode = 2'b00;
        cg.sample();

        opcode = 2'b01;
        cg.sample();

        opcode = 2'b10;
        cg.sample();

        // Goes into the default bin
        opcode = 2'b11;
        cg.sample();

        $display("[%0t] Coverage = %0.2f%%",
                 $time,
                 cg.get_coverage());

        $finish;

    end

endmodule