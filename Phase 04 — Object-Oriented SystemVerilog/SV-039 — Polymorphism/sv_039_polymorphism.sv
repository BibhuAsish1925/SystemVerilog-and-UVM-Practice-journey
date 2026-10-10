module sv_039_polymorphism;

    // Parent class
    class transaction;

        virtual function void display();
            $display("Parent transaction");
        endfunction

    endclass


    // Child class
    class write_transaction extends transaction;

        function void display();
            $display("Write transaction");
        endfunction

    endclass


    // Another child class
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

        // Create write child object
        write_trans = new();

        // Parent handle refers to write child object
        trans = write_trans;

        // Calls write_transaction implementation
        trans.display();


        // Create read child object
        read_trans = new();

        // Parent handle now refers to read child object
        trans = read_trans;

        // Calls read_transaction implementation
        trans.display();

    end

endmodule