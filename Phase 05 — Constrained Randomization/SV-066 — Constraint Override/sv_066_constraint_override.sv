module sv_066_constraint_override;

    // Base class
    class transaction;

        rand int data;

        // Base constraint
        constraint base_range {
            data inside {[10:50]};
        }

        function void display(string label);
            $display("%s: data = %0d", label, data);
        endfunction

    endclass


    // Derived class
    class write_transaction extends transaction;

        // Derived constraint
        constraint write_range {
            data inside {[60:80]};
        }

        function void disable_base_constraint();
            base_range.constraint_mode(0);
        endfunction

    endclass


    transaction base_trans;
    write_transaction write_trans;

    initial begin

        // Base class uses its own constraint
        base_trans = new();

        if (base_trans.randomize())
            base_trans.display("Base transaction");
        else
            $display("Base randomization failed");


        // Derived class initially has both constraints
        write_trans = new();

        // Disable inherited constraint so the derived constraint
        // can replace its restriction for this example
        write_trans.disable_base_constraint();

        if (write_trans.randomize())
            write_trans.display("Write transaction");
        else
            $display("Write randomization failed");

    end

endmodule