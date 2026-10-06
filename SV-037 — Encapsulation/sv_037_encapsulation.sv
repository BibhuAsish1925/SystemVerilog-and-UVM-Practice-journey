module sv_037_encapsulation;

    class transaction;

        // Public: accessible from outside the class
        int public_data;

        // Protected: accessible inside class and child classes
        protected int protected_data;

        // Local: accessible only inside this class
        local int local_data;

        function new();
            public_data    = 10;
            protected_data = 20;
            local_data     = 30;
        endfunction

        function void display();
            $display("Public    = %0d", public_data);
            $display("Protected = %0d", protected_data);
            $display("Local     = %0d", local_data);
        endfunction

    endclass


    class extended_transaction extends transaction;

        function void display_protected();
            $display("Child access to protected = %0d", protected_data);
        endfunction

    endclass


    transaction trans;
    extended_transaction child;

    initial begin

        trans = new();

        // Public member can be accessed directly
        trans.public_data = 100;

        trans.display();

        child = new();

        // Protected member can be accessed through a child method
        child.display_protected();

    end

endmodule