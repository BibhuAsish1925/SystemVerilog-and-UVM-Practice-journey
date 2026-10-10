module sv_014_dynamic_arrays;

    int data[];

    initial begin
        // Allocate 5 elements
        data = new[5];

        // Initialize values
        foreach (data[i])
            data[i] = (i + 1) * 10;

        $display("Initial size = %0d", data.size());

        foreach (data[i])
            $display("data[%0d] = %0d", i, data[i]);

        // Resize to 8 elements and preserve old values
        data = new[8](data);

        $display("\nAfter resize = %0d", data.size());

        foreach (data[i])
            $display("data[%0d] = %0d", i, data[i]);

        // Delete the dynamic array
        data.delete();

        $display("\nAfter delete = %0d", data.size());
    end

endmodule