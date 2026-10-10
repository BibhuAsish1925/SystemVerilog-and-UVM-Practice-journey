module sv_025_functions;

    // Function declaration with two arguments and an integer return value
    function int add_numbers(input int a, input int b);
        return a + b;
    endfunction

    int result;

    initial begin
        result = add_numbers(10, 20);

        $display("10 + 20 = %0d", result);
        $display("5 + 15  = %0d", add_numbers(5, 15));
    end

endmodule