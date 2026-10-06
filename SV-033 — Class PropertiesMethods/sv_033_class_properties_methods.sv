module sv_033_class_properties_methods;

    class transaction;

        // Data members
        int data;
        string name;

        // Function method
        function void display();
            $display("Name = %s | Data = %0d", name, data);
        endfunction

        // Function method to modify data
        function void set_data(int new_data);
            data = new_data;
        endfunction

        // Task method
        task process_transaction();
            $display("Processing %s...", name);
            #10;
            $display("Process complete | Data = %0d", data);
        endtask

    endclass

    // Object handle
    transaction trans;

    initial begin

        // Create object
        trans = new();

        // Access data members
        trans.name = "Transaction-1";
        trans.data = 100;

        // Call function methods
        trans.display();

        trans.set_data(200);
        trans.display();

        // Call task method
        trans.process_transaction();

    end

endmodule