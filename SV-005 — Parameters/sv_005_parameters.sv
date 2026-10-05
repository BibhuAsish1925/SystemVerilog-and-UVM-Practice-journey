module sv_005_parameters #(
    parameter int WIDTH = 8,       // Can be overridden
    parameter int DEPTH = 16
);

    localparam int ADDR_WIDTH = $clog2(DEPTH); // Cannot be overridden

    logic [WIDTH-1:0] data;
    logic [ADDR_WIDTH-1:0] address;

    initial begin
        data    = '1;
        address = '0;

        $display("WIDTH      = %0d", WIDTH);
        $display("DEPTH      = %0d", DEPTH);
        $display("ADDR_WIDTH = %0d", ADDR_WIDTH);
        $display("data width = %0d bits", $bits(data));
        $display("addr width = %0d bits", $bits(address));
    end

endmodule


module tb;

    // Override the parameterized values
    sv_005_parameters #(
        .WIDTH(16),
        .DEPTH(64)
    ) dut ();

endmodule