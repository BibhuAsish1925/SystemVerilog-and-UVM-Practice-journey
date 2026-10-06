module sv_035_inheritance;

    // Parent class
    class transaction;

        int data;

        function void display();
            $display("Parent: Data = %0d", data);
        endfunction

    endclass

    // Child class
    class extended_transaction extends transaction;

        string name;

        function void display_child();
            $display("Child: Name = %s | Data = %0d", name, data);
        endfunction

    endclass

    // Child object handle
    extended_transaction trans;

    initial begin

        // Create child object
        trans = new();

        // Inherited property
        trans.data = 100;

        // Child property
        trans.name = "Transaction-1";

        // Inherited method
        trans.display();

        // Child method
        trans.display_child();

    end

endmodule