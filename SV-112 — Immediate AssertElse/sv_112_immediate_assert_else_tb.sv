`timescale 1ns/1ps

module sv_112_immediate_assert_else_tb;

    logic [7:0] data;
    logic       valid;

    initial begin

        // Passing assertion
        data  = 8'hA5;
        valid = 1'b1;

        assert (valid == 1'b1)
            else $error("ERROR: valid is not 1");

        assert (data == 8'hA5)
            else $error("ERROR: data is not A5");

        $display("[%0t] PASS: Initial checks completed",
                 $time);

        // Failed assertion handled by $error
        valid = 1'b0;

        assert (valid == 1'b1)
            else $error("ERROR: valid is 0");

        $display("[%0t] Simulation continues after $error",
                 $time);

        // Failed assertion handled by $fatal
        data = 8'h00;

        assert (data == 8'hA5)
            else $fatal(1, "FATAL: data is not A5");

        // This line is not reached
        $display("[%0t] This message will not execute",
                 $time);

        $finish;

    end

endmodule