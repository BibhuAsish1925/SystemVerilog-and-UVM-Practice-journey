module sv_020_array_locator_methods;

    int data[6] = '{10, 25, 30, 45, 50, 65};

    int found[$];
    int indexes[$];
    int first_value[$];
    int last_value[$];

    initial begin
        $display("Array:");
        foreach (data[i])
            $display("data[%0d] = %0d", i, data[i]);

        // Find all matching elements
        found = data.find(x) with (x >= 30);

        $display("\nfind():");
        $display("Matching values = %p", found);

        // Find indexes of all matching elements
        indexes = data.find_index(x) with (x >= 30);

        $display("\nfind_index():");
        $display("Matching indexes = %p", indexes);

        // Find first matching element
        first_value = data.find_first(x) with (x >= 30);

        $display("\nfind_first():");
        $display("First matching value = %p", first_value);

        // Find last matching element
        last_value = data.find_last(x) with (x >= 30);

        $display("\nfind_last():");
        $display("Last matching value = %p", last_value);
    end

endmodule