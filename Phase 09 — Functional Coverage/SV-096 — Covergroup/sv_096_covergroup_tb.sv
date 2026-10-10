`timescale 1ns/1ps

module sv_096_covergroup_tb;

    logic [7:0] data;

    // Functional coverage model
    covergroup data_cg;

        coverpoint data {
            bins low  = {[0:63]};
            bins mid  = {[64:191]};
            bins high = {[192:255]};
        }

    endgroup

    data_cg cg;

    initial begin

        // Create the covergroup object
        cg = new();

        // Sample 1: low range
        data = 8'd20;
        cg.sample();

        // Sample 2: middle range
        data = 8'd100;
        cg.sample();

        // Sample 3: high range
        data = 8'd220;
        cg.sample();

        // Display coverage result
        $display("[%0t] Data coverage = %0.2f%%",
                 $time,
                 cg.get_coverage());

        $finish;

    end

endmodule