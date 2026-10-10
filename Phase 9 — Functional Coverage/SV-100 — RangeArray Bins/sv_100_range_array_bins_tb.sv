`timescale 1ns/1ps

module sv_100_range_array_bins_tb;

    logic [7:0] data;

    covergroup data_cg;

        coverpoint data {

            // {} : selected individual values
            bins selected_values = {8'd10, 8'd20, 8'd30};

            // [] : continuous value range
            bins range_values = {[8'd40:8'd60]};

            // bins[] : automatic array of bins
            bins value_bins[4] = {[8'd100:8'd199]};

        }

    endgroup

    data_cg cg;

    initial begin

        cg = new();

        // Hit the selected_values bin
        data = 8'd10;
        cg.sample();

        // Hit the range_values bin
        data = 8'd50;
        cg.sample();

        // Hit one of the value_bins
        data = 8'd125;
        cg.sample();

        // Hit another value_bins bin
        data = 8'd175;
        cg.sample();

        $display("[%0t] Coverage = %0.2f%%",
                 $time,
                 cg.get_coverage());

        $finish;

    end

endmodule