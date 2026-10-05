module sv_018_associative_arrays;

    // Integer-indexed associative array
    int scores[int];

    // String-indexed associative array
    int marks[string];

    initial begin
        // Integer indexing
        scores[10] = 95;
        scores[25] = 88;
        scores[100] = 76;

        $display("Integer-indexed array:");
        $display("scores[10]  = %0d", scores[10]);
        $display("scores[25]  = %0d", scores[25]);
        $display("scores[100] = %0d", scores[100]);

        // String indexing
        marks["Math"]    = 95;
        marks["Physics"] = 88;
        marks["Verilog"] = 92;

        $display("\nString-indexed array:");
        $display("marks[Math]    = %0d", marks["Math"]);
        $display("marks[Physics] = %0d", marks["Physics"]);
        $display("marks[Verilog] = %0d", marks["Verilog"]);

        // Sparse storage
        $display("\nSparse storage:");
        $display("scores.size() = %0d", scores.size());
        $display("marks.size()  = %0d", marks.size());
    end

endmodule