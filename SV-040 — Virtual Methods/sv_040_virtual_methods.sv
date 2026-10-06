module sv_040_virtual_methods;

    // Parent class
    class transaction;

        virtual function void display();
            $display("Parent transaction");
        endfunction

    endclass


    // Child class 1
    class write_transaction extends transaction;

        function void display();
            $display("Write transaction");
        endfunction

    endclass


    // Child class 2
    class read_transaction extends transaction;

        function void display();
            $display("Read transaction");
        endfunction

    endclass


    // Parent handle
    transaction trans;

    // Child handles
    write_transaction write_trans;
    read_transaction read_trans;

    initial begin

        // Create write object
        write_trans = new();

        // Parent handle refers to write object
        trans = write_trans;

        // Dynamic dispatch calls write version
        trans.display();


        // Create read object
        read_trans = new();

        // Parent handle refers to read object
        trans = read_trans;

        // Dynamic dispatch calls read version
        trans.display();

    end

endmodule