module sv_012_system_functions;

    logic [7:0] data;
    logic [15:4] range_data;
    int array [0:4];

    initial begin
        // $bits: number of bits in a data type/object
        $display("$bits(data)       = %0d", $bits(data));
        $display("$bits(range_data) = %0d", $bits(range_data));

        // $size: number of elements in an array
        $display("$size(array)      = %0d", $size(array));

        // $clog2: ceiling of log2
        $display("$clog2(10)        = %0d", $clog2(10));

        // Array/range boundary functions
        $display("$left(array)      = %0d", $left(array));
        $display("$right(array)     = %0d", $right(array));
        $display("$high(array)      = %0d", $high(array));
        $display("$low(array)       = %0d", $low(array));
    end

endmodule