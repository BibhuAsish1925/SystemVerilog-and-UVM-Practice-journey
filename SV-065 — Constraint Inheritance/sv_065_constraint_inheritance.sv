module sv_065_constraint_inheritance;

    // Base class
    class transaction;

        rand int data;

        // Base-class constraint
        constraint base_range {
            data inside {[10:50]};
        }

        function void display(string label);
            $display("%s: data = %0d", label, data);
        endfunction

    endclass


    // Derived class
    class write_transaction extends transaction;

        // Additional constraint inherited together with base_range
        constraint write_range {
            data inside {[30:40]};
        }

    endclass


    transaction base_trans;
    write_transaction write_trans;

    initial begin

        // Base-class object
        base_trans = new();

        if (base_trans.randomize())
            base_trans.display("Base transaction");
        else
            $display("Base randomization failed");


        // Derived-class object
        write_trans = new();

        if (write_trans.randomize())
            write_trans.display("Write transaction");
        else
            $display("Write randomization failed");

    end

endmodule