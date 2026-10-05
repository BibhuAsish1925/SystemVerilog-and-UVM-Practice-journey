module sv_013_fixed_arrays;

    // 1D fixed array
    int numbers [5];

    // 2D fixed array
    int matrix [2][3];

    initial begin
        // 1D array initialization
        numbers = '{10, 20, 30, 40, 50};

        $display("1D Fixed Array:");
        foreach (numbers[i])
            $display("numbers[%0d] = %0d", i, numbers[i]);

        // 2D array initialization
        matrix = '{
            '{1, 2, 3},
            '{4, 5, 6}
        };

        $display("\n2D Fixed Array:");
        foreach (matrix[i, j])
            $display("matrix[%0d][%0d] = %0d",
                     i, j, matrix[i][j]);

        // Array dimensions
        $display("\nArray Information:");
        $display("numbers size = %0d", $size(numbers));
        $display("matrix rows  = %0d", $size(matrix, 1));
        $display("matrix cols  = %0d", $size(matrix, 2));
    end

endmodule