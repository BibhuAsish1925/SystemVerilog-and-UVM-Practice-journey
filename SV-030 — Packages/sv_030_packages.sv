package common_pkg;

    parameter int DATA_WIDTH = 8;

    typedef logic [DATA_WIDTH-1:0] data_t;

    function automatic int add_numbers(input int a, input int b);
        return a + b;
    endfunction

endpackage


module sv_030_packages;

    // Import package members into this scope
    import common_pkg::*;

    data_t data;
    int result;

    initial begin
        data = 8'hA5;

        // Access imported members directly
        result = add_numbers(10, 20);

        $display("DATA_WIDTH = %0d", DATA_WIDTH);
        $display("data       = %h", data);
        $display("sum        = %0d", result);

        // Explicit package access using scope resolution
        $display("Package DATA_WIDTH = %0d", common_pkg::DATA_WIDTH);
    end

endmodule