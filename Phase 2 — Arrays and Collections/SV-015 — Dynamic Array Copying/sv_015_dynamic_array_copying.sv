module sv_015_dynamic_array_copying;

    int source[];
    int copy[];

    initial begin
        // Create and initialize source array
        source = new[5];

        foreach (source[i])
            source[i] = (i + 1) * 10;

        $display("Source array:");
        foreach (source[i])
            $display("source[%0d] = %0d", i, source[i]);

        // Copy source into a larger dynamic array
        copy = new[8](source);

        $display("\nCopied array:");
        foreach (copy[i])
            $display("copy[%0d] = %0d", i, copy[i]);

        $display("\nSource size = %0d", source.size());
        $display("Copy size   = %0d", copy.size());
    end

endmodule