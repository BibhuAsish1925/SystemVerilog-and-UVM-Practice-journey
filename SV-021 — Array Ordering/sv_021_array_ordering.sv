module sv_021_array_ordering;

    int data[6] = '{40, 10, 60, 20, 50, 30};

    initial begin
        $display("Original array:");
        $display("data = %p", data);

        // Sort in ascending order
        data.sort();

        $display("\nAfter sort():");
        $display("data = %p", data);

        // Sort in descending order
        data.rsort();

        $display("\nAfter rsort():");
        $display("data = %p", data);

        // Reverse current order
        data.reverse();

        $display("\nAfter reverse():");
        $display("data = %p", data);

        // Randomly shuffle elements
        data.shuffle();

        $display("\nAfter shuffle():");
        $display("data = %p", data);
    end

endmodule