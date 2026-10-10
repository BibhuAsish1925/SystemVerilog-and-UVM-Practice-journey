module sv_019_associative_array_methods;

    int data[int];
    int index;

    initial begin
        // Create sparse associative array
        data[10] = 100;
        data[20] = 200;
        data[50] = 500;
        data[80] = 800;

        $display("Initial number of elements = %0d", data.num());

        // first() and last() update the index variable
        data.first(index);
        $display("First index = %0d", index);

        data.last(index);
        $display("Last index  = %0d", index);

        // Check whether an index exists
        $display("\nExists:");
        $display("data[20] exists = %0d", data.exists(20));
        $display("data[30] exists = %0d", data.exists(30));

        // Traverse using first() and next()
        $display("\nForward traversal:");

        data.first(index);

        while (1) begin
            $display("data[%0d] = %0d", index, data[index]);

            if (!data.next(index))
                break;
        end

        // Previous index
        index = 50;

        if (data.prev(index))
            $display("\nPrevious index before 50 = %0d", index);

        // Delete one entry
        data.delete(50);

        $display("\nAfter delete(50):");
        $display("Number of elements = %0d", data.num());
        $display("Exists(50) = %0d", data.exists(50));
    end

endmodule