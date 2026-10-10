module sv_029_void_functions;

    // Void function: performs an operation without returning a value
    function void print_sum(input int a, input int b);
        $display("Sum = %0d", a + b);
    endfunction

    // Normal function returning an integer
    function int multiply(input int a, input int b);
        return a * b;
    endfunction

    int result;

    initial begin
        print_sum(10, 20);

        result = multiply(5, 4);
        $display("Product = %0d", result);

        // Evaluate the function but intentionally discard its return value
        void'(multiply(7, 3));
        $display("Return value discarded using void'()");
    end

endmodule