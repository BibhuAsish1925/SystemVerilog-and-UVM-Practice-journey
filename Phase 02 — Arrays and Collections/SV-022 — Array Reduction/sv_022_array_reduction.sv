module sv_022_array_reduction;

    logic [3:0] data[3] = '{4'b1100, 4'b1010, 4'b0110};

    int sum_result;
    int product_result;
    logic [3:0] and_result;
    logic [3:0] or_result;
    logic [3:0] xor_result;

    initial begin
        $display("Array:");
        foreach (data[i])
            $display("data[%0d] = %b", i, data[i]);

        // Arithmetic reductions
        sum_result     = data.sum();
        product_result = data.product();

        // Bitwise reductions
        and_result = data.and();
        or_result  = data.or();
        xor_result = data.xor();

        $display("\nReduction Results:");
        $display("sum     = %0d", sum_result);
        $display("product = %0d", product_result);
        $display("and     = %b", and_result);
        $display("or      = %b", or_result);
        $display("xor     = %b", xor_result);
    end

endmodule