module sv_041_cast_with_classes;

    // Parent class
    class transaction;

        virtual function void display();
            $display("Parent transaction");
        endfunction

    endclass


    // Child class
    class write_transaction extends transaction;

        int data;

        function void display();
            $display("Write transaction | Data = %0d", data);
        endfunction

        function void write_only();
            $display("Write-specific method");
        endfunction

    endclass


    // Another child class
    class read_transaction extends transaction;

        function void read_only();
            $display("Read-specific method");
        endfunction

    endclass


    transaction trans;
    write_transaction write_trans;
    read_transaction read_trans;

    initial begin

        // Create child object
        write_trans = new();
        write_trans.data = 100;

        // Upcasting: child handle -> parent handle
        trans = write_trans;

        $display("Upcasting:");
        trans.display();


        // Downcasting: parent handle -> child handle
        if ($cast(write_trans, trans)) begin
            $display("\nDowncasting: SUCCESS");
            write_trans.write_only();
        end
        else begin
            $display("\nDowncasting: FAILED");
        end


        // Create a different child object
        read_trans = new();
        trans = read_trans;

        // Safe cast to the wrong child type
        if ($cast(write_trans, trans)) begin
            $display("\nWrong cast: SUCCESS");
        end
        else begin
            $display("\nWrong cast: FAILED");
        end

    end

endmodule