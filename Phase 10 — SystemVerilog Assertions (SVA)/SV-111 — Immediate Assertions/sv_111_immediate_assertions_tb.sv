`timescale 1ns/1ps

module sv_111_immediate_assertions_tb;

    logic [7:0] data;
    logic       valid;

    initial begin

        // Assertion passes
        data  = 8'hA5;
        valid = 1'b1;

        assert (valid == 1'b1)
            else $error("Assertion failed: valid is not 1");

        assert (data == 8'hA5)
            else $error("Assertion failed: data is not A5");

        $display("[%0t] First assertions passed",
                 $time);

        // Assertion intentionally fails
        valid = 1'b0;

        assert (valid == 1'b1)
            else $error("Assertion failed: valid is 0");

        $display("[%0t] Simulation continues after assertion",
                 $time);

        $finish;

    end

endmodule