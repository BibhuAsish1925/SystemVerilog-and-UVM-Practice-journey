`timescale 1ns/1ps

module sv_101_cross_coverage_tb;

    logic [1:0] opcode;
    logic       mode;

    covergroup operation_cg;

        // Individual coverpoints
        cp_opcode : coverpoint opcode {
            bins add = {2'b00};
            bins sub = {2'b01};
        }

        cp_mode : coverpoint mode {
            bins normal = {1'b0};
            bins fast   = {1'b1};
        }

        // Cross coverage between opcode and mode
        opcode_mode_cross : cross cp_opcode, cp_mode;

    endgroup

    operation_cg cg;

    initial begin

        cg = new();

        // Test all opcode/mode combinations
        opcode = 2'b00;
        mode   = 1'b0;
        cg.sample();

        opcode = 2'b00;
        mode   = 1'b1;
        cg.sample();

        opcode = 2'b01;
        mode   = 1'b0;
        cg.sample();

        opcode = 2'b01;
        mode   = 1'b1;
        cg.sample();

        $display("[%0t] Cross coverage = %0.2f%%",
                 $time,
                 cg.get_coverage());

        $finish;

    end

endmodule