module sv_016_queue;

    int queue[$];
    int value;

    initial begin
        // Add elements
        queue.push_back(20);
        queue.push_back(30);
        queue.push_front(10);

        $display("After push operations:");
        $display("queue = %p", queue);

        // Remove first element
        value = queue.pop_front();
        $display("\npop_front = %0d", value);
        $display("queue     = %p", queue);

        // Remove last element
        value = queue.pop_back();
        $display("\npop_back  = %0d", value);
        $display("queue     = %p", queue);

        // Add elements again
        queue.push_front(5);
        queue.push_back(40);

        $display("\nAfter adding again:");
        $display("queue = %p", queue);
        $display("size  = %0d", queue.size());
    end

endmodule