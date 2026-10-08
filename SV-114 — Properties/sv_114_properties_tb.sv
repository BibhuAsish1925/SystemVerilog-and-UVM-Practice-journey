`timescale 1ns/1ps

module sv_114_properties_tb;

    logic clk;
    logic valid;
    logic ready;

    // Named property
    property valid_requires_ready;
        @(posedge clk) valid |-> ready;
    endproperty

    // Check the property
    ap_valid_requires_ready:
        assert property (valid_requires_ready)
        else $error("[%0t] Property failed: valid requires ready",
                    $time);

    initial begin

        clk   = 1'b0;
        valid = 1'b0;
        ready = 1'b0;

        #10;

        // Property passes
        valid = 1'b1;
        ready = 1'b1;

        #10;

        // Property fails
        valid = 1'b1;
        ready = 1'b0;

        #10;

        // Property is not violated because valid is 0
        valid = 1'b0;
        ready = 1'b0;

        #10;

        $finish;

    end

    always #5 clk = ~clk;

endmodule