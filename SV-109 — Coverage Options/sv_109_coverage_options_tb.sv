`timescale 1ns/1ps

module sv_109_coverage_options_tb;

    logic [1:0] opcode;

    covergroup opcode_cg;

        // Coverage options
        option.goal = 100;
        option.name = "Opcode Coverage";
        option.per_instance = 1;

        coverpoint opcode {

            bins add = {2'b00};
            bins sub = {2'b01};

            // Each bin needs two hits
            bins mul = {2'b10} with (opcode == 2'b10);

        }

        // Bin hit requirement
        option.at_least = 2;

    endgroup

    opcode_cg cg;

    initial begin

        cg = new();

        // ADD: two hits
        opcode = 2'b00;
        cg.sample();

        opcode = 2'b00;
        cg.sample();

        // SUB: two hits
        opcode = 2'b01;
        cg.sample();

        opcode = 2'b01;
        cg.sample();

        // MUL: two hits
        opcode = 2'b10;
        cg.sample();

        opcode = 2'b10;
        cg.sample();

        $display("[%0t] %s = %0.2f%%",
                 $time,
                 cg.option.name,
                 cg.get_coverage());

        $finish;

    end

endmodule