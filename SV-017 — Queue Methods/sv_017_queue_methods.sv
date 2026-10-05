module sv_017_queue_methods;

    int queue[$];
    int value;

    initial begin
        // Initialize queue
        queue = '{10, 20, 30, 40};

        $display("Initial queue:");
        $display("queue = %p", queue);

        // Indexing
        $display("\nIndexing:");
        $display("queue[0] = %0d", queue[0]);
        $display("queue[2] = %0d", queue[2]);

        // Insert 25 at index 2
        queue.insert(2, 25);

        $display("\nAfter insert(2, 25):");
        $display("queue = %p", queue);

        // Delete element at index 3
        value = queue[3];
        queue.delete(3);

        $display("\nDeleted value = %0d", value);
        $display("After delete(3):");
        $display("queue = %p", queue);

        // Queue size
        $display("\nQueue size = %0d", queue.size());
    end

endmodule