module sv_023_array_iteration;

    int data[5] = '{10, 20, 30, 40, 50};
    int sum;

    initial begin
        $display("Array traversal:");

        // Iterator variable i represents the array index
        foreach (data[i]) begin
            $display("data[%0d] = %0d", i, data[i]);
        end

        // Use iterator to calculate the sum
        sum = 0;

        foreach (data[i]) begin
            sum += data[i];
        end

        $display("\nSum = %0d", sum);
    end

endmodule