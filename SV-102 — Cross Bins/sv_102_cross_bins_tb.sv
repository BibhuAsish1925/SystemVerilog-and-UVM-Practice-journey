`timescale 1ns/1ps

module sv_102_cross_bins_tb;

    logic [1:0] opcode;
    logic       mode;

    covergroup operation_cg;

        cp_opcode : coverpoint opcode {
            bins add = {2'b00};
            bins sub = {2'b01};
        }

        cp_mode : coverpoint mode {
            bins normal = {1'b0};
            bins fast   = {1'b1};
        }

        // Cover only the specific ADD + FAST combination
        cross_opcode_mode : cross cp_opcode, cp_mode {
            bins add_fast = binsof(cp_opcode.add)
                          && binsof(cp_mode.fast);
        }

    endgroup

    operation_cg cg;

    initial begin

        cg = new();

        // ADD + NORMAL
        opcode = 2'b00;
        mode   = 1'b0;
        cg.sample();

        // ADD + FAST
        opcode = 2'b00;
        mode   = 1'b1;
        cg.sample();

        // SUB + NORMAL
        opcode = 2'b01;
        mode   = 1'b0;
        cg.sample();

        $display("[%0t] Cross coverage = %0.2f%%",
                 $time,
                 cg.get_coverage());

        $finish;

    end

endmodule