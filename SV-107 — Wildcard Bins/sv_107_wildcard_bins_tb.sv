`timescale 1ns/1ps

module sv_107_wildcard_bins_tb;

    logic [3:0] opcode;

    covergroup opcode_cg;

        coverpoint opcode {

            // Bit positions marked with ? are don't-care
            wildcard bins group_0 = {4'b1??0};
            wildcard bins group_1 = {4'b0??1};

        }

    endgroup

    opcode_cg cg;

    initial begin

        cg = new();

        // Matches group_0: 1??0
        opcode = 4'b1000;
        cg.sample();

        opcode = 4'b1110;
        cg.sample();

        // Matches group_1: 0??1
        opcode = 4'b0001;
        cg.sample();

        opcode = 4'b0111;
        cg.sample();

        $display("[%0t] Wildcard coverage = %0.2f%%",
                 $time,
                 cg.get_coverage());

        $finish;

    end

endmodule