module sv_036_super;

    // Parent class
    class transaction;

        int data;

        // Parent constructor
        function new(int data);
            this.data = data;
            $display("Parent constructor called");
        endfunction

        // Parent method
        function void display();
            $display("Parent method: Data = %0d", data);
        endfunction

    endclass


    // Child class
    class extended_transaction extends transaction;

        string name;

        // Child constructor
        function new(int data, string name);

            // Call parent constructor
            super.new(data);

            this.name = name;

            $display("Child constructor called");

        endfunction

        // Child method
        function void display_child();

            // Call parent method
            super.display();

            $display("Child method: Name = %s", name);

        endfunction

    endclass


    extended_transaction trans;

    initial begin

        // Create child object
        trans = new(100, "Transaction-1");

        // Call child method
        trans.display_child();

    end

endmodule