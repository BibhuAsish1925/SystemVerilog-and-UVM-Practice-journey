module sv_026_tasks;

    // Task with an input argument and timing control
    task automatic print_message(input string message);
        #10;
        $display("[%0t] %s", $time, message);
    endtask

    initial begin
        $display("[%0t] Start", $time);

        print_message("First task call");
        print_message("Second task call");

        $display("[%0t] End", $time);
    end

endmodule