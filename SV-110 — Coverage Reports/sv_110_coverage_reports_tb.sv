`timescale 1ns/1ps

module sv_110_coverage_reports_tb;

    logic [1:0] opcode;

    covergroup opcode_cg;

        coverpoint opcode {
            bins add = {2'b00};
            bins sub = {2'b01};
            bins mul = {2'b10};
            bins div = {2'b11};
        }

    endgroup

    opcode_cg cg;

    initial begin

        cg = new();

        // Collect functional coverage
        opcode = 2'b00;
        cg.sample();

        opcode = 2'b01;
        cg.sample();

        opcode = 2'b10;
        cg.sample();

        opcode = 2'b11;
        cg.sample();

        // Coverage report
        $display("================================");
        $display("      FUNCTIONAL COVERAGE");
        $display("================================");
        $display("Covergroup : opcode_cg");
        $display("Coverage   : %0.2f%%", cg.get_coverage());
        $display("Instance   : %0.2f%%", cg.get_inst_coverage());
        $display("================================");

        $finish;

    end

endmodule