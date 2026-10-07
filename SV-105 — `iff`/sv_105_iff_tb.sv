`timescale 1ns/1ps

module sv_105_iff_tb;

    logic [1:0] data;
    logic       valid;

    covergroup data_cg;

        // Data is covered only when valid is 1
        cp_data : coverpoint data iff (valid) {
            bins value_0 = {2'b00};
            bins value_1 = {2'b01};
            bins value_2 = {2'b10};
            bins value_3 = {2'b11};
        }

    endgroup

    data_cg cg;

    initial begin

        cg = new();

        // valid = 0: these samples are ignored
        valid = 1'b0;
        data  = 2'b00;
        cg.sample();

        valid = 1'b0;
        data  = 2'b01;
        cg.sample();

        // valid = 1: these samples are counted
        valid = 1'b1;
        data  = 2'b00;
        cg.sample();

        valid = 1'b1;
        data  = 2'b01;
        cg.sample();

        valid = 1'b1;
        data  = 2'b10;
        cg.sample();

        valid = 1'b1;
        data  = 2'b11;
        cg.sample();

        $display("[%0t] Conditional coverage = %0.2f%%",
                 $time,
                 cg.get_coverage());

        $finish;

    end

endmodule